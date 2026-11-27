// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get attachment_audio_failed =>
      'Não foi possível reproduzir este áudio. O formato ou codec pode não ser compatível, ou o limite de tamanho da pré-visualização foi excedido. Tente novamente, guarde ou partilhe o ficheiro original.';

  @override
  String get attachment_audio_seek => 'Posição do áudio';

  @override
  String get workspace_workers => 'Subagentes ativos';

  @override
  String get workers_unattached =>
      'Apenas contagens. Para orientar um subagente, escolha Subagentes ativos na conversa principal ligada.';

  @override
  String get slash_local_arguments =>
      'Este atalho não aceita argumentos aqui. Use os controlos da aplicação; o rascunho foi mantido.';

  @override
  String get fallback_title => 'Modelos de recurso';

  @override
  String get fallback_notice =>
      'São tentados por ordem quando o modelo principal está indisponível. As alterações aplicam-se apenas a este perfil; guarde explicitamente a lista completa.';

  @override
  String get fallback_unavailable =>
      'As definições de recurso estão indisponíveis ou são inválidas. Verifique a ligação, o perfil selecionado e a versão do servidor e tente novamente.';

  @override
  String get fallback_discovery_unavailable =>
      'Não foi possível obter os fornecedores. As entradas existentes são preservadas; tente novamente para escolher fornecedores e modelos.';

  @override
  String get fallback_empty => 'Não há entradas nesta lista de recurso.';

  @override
  String get fallback_incomplete =>
      'Escolha um fornecedor e um modelo para cada entrada ou remova as entradas incompletas antes de guardar.';

  @override
  String get fallback_add => 'Adicionar recurso';

  @override
  String get fallback_save => 'Guardar lista de recurso';

  @override
  String get fallback_save_failed =>
      'Não foi possível verificar a lista guardada. O rascunho foi preservado. Guarde novamente ou atualize para carregar as definições do servidor.';

  @override
  String get fallback_saved => 'Lista de recurso guardada e verificada.';

  @override
  String get fallback_legacy_title => 'Recursos antigos (só de leitura)';

  @override
  String get fallback_legacy_notice =>
      'O servidor também usa fallback_model após esta lista, ignorando rotas duplicadas. Estas entradas antigas são preservadas mesmo com a lista acima vazia. Edite-as no servidor.';

  @override
  String fallback_priority(String position) {
    return 'Prioridade $position';
  }

  @override
  String get fallback_move_up => 'Mover para cima';

  @override
  String get fallback_move_down => 'Mover para baixo';

  @override
  String get fallback_routing_read_only =>
      'Os detalhes de encaminhamento ou um fornecedor não listado são preservados. Edite este fornecedor/modelo no servidor; pode reordenar ou remover a entrada aqui.';

  @override
  String get cron_model_default => 'Seguir predefinição';

  @override
  String get cron_model_notice =>
      'Aplica-se apenas a esta tarefa cron. Sem modelo fixo, o Hermes usa a predefinição cron e depois o modelo principal. Gira modelos personalizados no servidor.';

  @override
  String get model_management_unavailable =>
      'Não foi possível carregar ou guardar as definições do modelo. Atualize e tente novamente.';

  @override
  String get model_management_subtitle =>
      'Modelos principal, de recurso e auxiliares deste perfil';

  @override
  String get usage => 'Utilização';

  @override
  String get nous_portal => 'Nous Portal';

  @override
  String get portal_menu_subtitle => 'Estado do gateway e utilização registada';

  @override
  String get portal_read_only =>
      'Dados do gateway só de leitura. Gira a autenticação Nous no anfitrião Hermes. Estes endpoints não fornecem saldos de subscrição nem créditos.';

  @override
  String get portal_status => 'Estado do Portal no gateway';

  @override
  String get portal_free_tier =>
      'Acesso gratuito (sem conta com sessão iniciada)';

  @override
  String get portal_signed_in => 'Sessão iniciada';

  @override
  String get portal_signed_out => 'Sessão não iniciada';

  @override
  String get portal_account_tier => 'Nível da conta';

  @override
  String get portal_recorded_usage => 'Utilização registada';

  @override
  String get portal_all_providers =>
      'Todos os fornecedores do perfil de gateway selecionado. Um custo registado de zero não significa que o modelo seja gratuito.';

  @override
  String portal_period(String days) {
    return 'Últimos $days dias';
  }

  @override
  String get portal_sessions => 'Sessões';

  @override
  String get portal_input => 'Tokens de entrada';

  @override
  String get portal_output => 'Tokens de saída';

  @override
  String get portal_estimated => 'Custo estimado registado';

  @override
  String get portal_actual => 'Custo real registado';

  @override
  String get portal_recorded_models => 'Modelos registados';

  @override
  String get portal_no_models => 'Sem modelos registados.';

  @override
  String get portal_unavailable =>
      'Indisponível. Verifique a ligação, o perfil selecionado e a versão do gateway e tente novamente.';

  @override
  String get paste_attachment_failed_text_kept =>
      'Não foi possível anexar o texto colado. O texto foi mantido na mensagem.';

  @override
  String get background_task_report => 'Tarefa em segundo plano';

  @override
  String get background_process_report => 'Processo em segundo plano';

  @override
  String get background_report_issues =>
      'Foram comunicados problemas — expanda para ver os detalhes.';

  @override
  String get background_report_expand => 'Expandir relatório';

  @override
  String get background_report_collapse => 'Recolher relatório';

  @override
  String get ng_brand_open_chat => 'Abrir uma conversa';

  @override
  String get ng_brand_recent => 'Recentes';

  @override
  String get ng_brand_sidebar_hint =>
      'ou escolha uma conversa na barra lateral';

  @override
  String get copy_session_id => 'Copiar ID da sessão';

  @override
  String get copy_session_id_failed =>
      'Não foi possível copiar o ID da sessão.';

  @override
  String get setup_interface_title => 'Escolha a sua interface';

  @override
  String get setup_interface_classic => 'Classic';

  @override
  String get setup_interface_nextgen => 'NextGen';

  @override
  String get setup_interface_classic_description =>
      'A área de trabalho original do Ares, com todos os controlos de ligação e definições Classic.';

  @override
  String get setup_interface_nextgen_description =>
      'Um aspeto novo com uma única sessão no painel, planos em direto, subagentes e notificações.';

  @override
  String get setup_interface_switch_later =>
      'Pode mudar a qualquer momento nas Definições.';

  @override
  String get ng_confirm_model_switch => 'Mudar de modelo?';

  @override
  String get ng_switch => 'Mudar';

  @override
  String get ng_model_confirmation_required =>
      'Este modelo precisa de confirmação antes de ser selecionado.';

  @override
  String ng_model_switches_next_turn(String model) {
    return 'Muda para $model no próximo turno.';
  }

  @override
  String get ng_model_switch_not_connected =>
      'A conversa não está pronta para mudar de modelo. Volte a abri-la e tente novamente.';

  @override
  String ng_gateway_kept_default_model(String model) {
    return 'O gateway manteve $model nesta conversa. Escolha novamente o modelo antes de enviar.';
  }

  @override
  String get hands_free_title => 'Mãos livres';

  @override
  String get hands_free_start => 'Iniciar mãos livres';

  @override
  String get hands_free_stop => 'Parar mãos livres';

  @override
  String get hands_free_preparing => 'A preparar voz — aguarde';

  @override
  String get hands_free_listening => 'Diga Hey Hermes';

  @override
  String get hands_free_recording => 'Pronto — fale agora';

  @override
  String get hands_free_waiting => 'A aguardar Hermes';

  @override
  String get hands_free_speaking => 'A falar — microfone desligado';

  @override
  String hands_free_followup(int seconds) {
    return 'Ouvir até $seconds segundos';
  }

  @override
  String get hands_free_error => 'Mãos livres parado';

  @override
  String get hands_free_setup => 'Configurar mãos livres';

  @override
  String hands_free_preview(String transcript) {
    return 'Pré-visualização: $transcript';
  }

  @override
  String get hands_free_short_disclosure =>
      'Apenas com este chat aberto em primeiro plano. Ativação offline; a voz pode usar redes. Consome bateria.';

  @override
  String get hands_free_error_action =>
      'Verifique microfone, serviço de voz, voz da resposta e ligação. Prima Parar e Iniciar. Nada é reenviado.';

  @override
  String get hands_free_disclosure =>
      'A ativação funciona offline na CPU. O reconhecimento Android, a voz escolhida e o gateway podem usar redes. A escuta consome bateria e pode ativar por engano. Para ao cobrir ou fechar o chat ou sair do primeiro plano, sem reinício automático. O ditado manual continua como rascunho editável.';

  @override
  String get hands_free_ready_cue =>
      'Diga «Hey Hermes», espere por «Pronto» e fale. Sem captura na mesma frase nem áudio anterior. Se a autorização sair da aplicação, prima Iniciar novamente após a conceder.';

  @override
  String get hands_free_settings_title => 'Voz mãos-livres';

  @override
  String get hands_free_settings_subtitle =>
      'Mostra o controlo de início «Hey Hermes» nos chats. Desligar interrompe qualquer sessão mãos-livres em curso.';

  @override
  String get hands_free_timing_limit =>
      'A janela de seguimento é um máximo, não um mínimo. O Android pode parar mais cedo. O silêncio volta à ativação local sem reinícios repetidos do reconhecimento.';

  @override
  String get hands_free_followup_off =>
      'Seguimento desligado — diga Hey Hermes para cada mensagem';

  @override
  String get hands_free_start_blocked =>
      'Requer rascunho vazio, sem anexos, chat ligado e inativo e respostas faladas ativas. Termine primeiro as ações de voz manuais.';

  @override
  String get hands_free_setup_complete =>
      'Configuração do microfone concluída. Prima Iniciar novamente.';

  @override
  String message_time_recorded(String time) {
    return 'Registado pelo servidor: $time (hora local)';
  }

  @override
  String message_time_sent(String time) {
    return 'Envio observado neste dispositivo: $time (hora local)';
  }

  @override
  String message_time_received(String time) {
    return 'Primeira receção neste dispositivo: $time (hora local)';
  }

  @override
  String get stop_and_send => 'Parar e enviar';

  @override
  String get message_queued_for_running_turn =>
      'Mensagem em fila para a execução atual.';

  @override
  String get running_message_not_accepted =>
      'O Hermes não conseguiu aceitar esta mensagem. O rascunho foi guardado; pare a resposta ou aguarde e volte a enviar.';

  @override
  String get running_message_delivery_unknown =>
      'Não foi possível confirmar a entrega. O rascunho foi guardado. Verifique a conversa antes de tentar novamente.';

  @override
  String get attachment_tap_to_preview => 'Toque para pré-visualizar';

  @override
  String get attachment_save => 'Guardar';

  @override
  String get attachment_share => 'Partilhar';

  @override
  String get attachment_saved => 'Ficheiro guardado';

  @override
  String get attachment_save_cancelled => 'Gravação cancelada';

  @override
  String get attachment_save_failed =>
      'Não foi possível guardar este ficheiro. Tente novamente.';

  @override
  String get attachment_share_failed =>
      'Não foi possível partilhar este ficheiro. Tente novamente.';

  @override
  String get attachment_download_failed =>
      'Não foi possível carregar este ficheiro. Verifique a ligação e tente novamente.';

  @override
  String get attachment_no_inline_preview =>
      'Não existe pré-visualização para este tipo de ficheiro. Guarde ou partilhe o ficheiro original para o abrir noutra aplicação.';

  @override
  String get attachment_image_failed =>
      'Não foi possível descodificar esta imagem. Pode guardar ou partilhar o ficheiro original.';

  @override
  String get attachment_text_truncated =>
      'Pré-visualização abreviada. Guarde ou partilhe o ficheiro para o ler na íntegra.';

  @override
  String get attachment_text_unavailable =>
      'Não foi possível apresentar este ficheiro como texto. Guarde ou partilhe o ficheiro original.';

  @override
  String get attachment_pdf_failed =>
      'Não foi possível pré-visualizar este PDF. Guarde ou partilhe o ficheiro original.';

  @override
  String get attachment_pdf_unavailable =>
      'A pré-visualização de PDF está disponível no Android. Pode guardar ou partilhar este ficheiro.';

  @override
  String attachment_pdf_page(int page, int total) {
    return 'Página $page de $total';
  }

  @override
  String get attachment_previous_page => 'Página anterior';

  @override
  String get attachment_next_page => 'Página seguinte';

  @override
  String get attachment_loading => 'A carregar pré-visualização…';

  @override
  String get attachment_document_text_notice =>
      'Pré-visualização de texto. A disposição, as imagens e a formatação podem diferir do original.';

  @override
  String get attachment_document_failed =>
      'Não foi possível pré-visualizar este documento. Guarde ou partilhe o ficheiro original.';

  @override
  String get attachment_document_empty =>
      'Não foi encontrado texto legível neste documento.';

  @override
  String get attachment_video_failed =>
      'Não foi possível reproduzir este vídeo. O formato ou codec pode não ser suportado. Guarde ou partilhe o ficheiro original.';

  @override
  String get attachment_video_play => 'Reproduzir';

  @override
  String get attachment_video_pause => 'Pausa';

  @override
  String get attachment_video_mute => 'Silenciar';

  @override
  String get attachment_video_unmute => 'Ativar som';

  @override
  String get attachment_video_seek => 'Posição do vídeo';

  @override
  String get attachment_close => 'Fechar pré-visualização';

  @override
  String get attachment_retry => 'Tentar novamente';

  @override
  String get saved_history_heading => 'Histórico guardado';

  @override
  String get received_output_heading =>
      'Resultado recebido — correspondência com o histórico guardado por confirmar';

  @override
  String get received_output_details => 'Sobre o resultado recebido';

  @override
  String get received_output_explanation =>
      'Isto também pode aparecer no histórico guardado. A aplicação não consegue confirmar a correspondência.';

  @override
  String get local_prompt_context => 'Contexto local do prompt';

  @override
  String get received_output_badge =>
      'Recebido · correspondência por confirmar';

  @override
  String get received_output_lifetime =>
      'O resultado recebido é guardado temporariamente nesta sessão da aplicação e pode ser encurtado ou removido ao atingir os limites. Pode deixar de estar disponível após fechar a aplicação ou a ligação.';

  @override
  String get theme_palette => 'Tema de cor';

  @override
  String get theme_palette_gold => 'Dourado';

  @override
  String get theme_palette_purple => 'Roxo';

  @override
  String get theme_palette_orange => 'Laranja';

  @override
  String get theme_palette_green => 'Verde';

  @override
  String get theme_palette_blue => 'Azul';

  @override
  String get theme_palette_red => 'Vermelho';

  @override
  String get theme_palette_teal => 'Verde-petróleo';

  @override
  String get theme_palette_pink => 'Rosa';

  @override
  String get theme_palette_indigo => 'Índigo';

  @override
  String get theme_palette_cyan => 'Ciano';

  @override
  String get assets_recent_subtitle =>
      'Encontre arquivos compartilhados pelo Hermes em chats salvos';

  @override
  String get assets_scope_notice =>
      'Arquivos gerados e compartilhados explicitamente pelo Hermes em respostas salvas. Esta é uma visão parcial do histórico de chats, não um catálogo completo de arquivos ou anexos. Os arquivos referenciados podem não existir mais.';

  @override
  String get assets_download_limit =>
      'Os arquivos só são carregados ao tocar neles. Pré-visualizações e downloads têm limite de 25 MiB por arquivo; use o painel para arquivos maiores.';

  @override
  String get assets_search_hint =>
      'Buscar nos arquivos encontrados ou nos chats de origem';

  @override
  String get assets_all => 'Todos';

  @override
  String get assets_images => 'Imagens';

  @override
  String get assets_audio => 'Áudio';

  @override
  String get assets_video => 'Vídeo';

  @override
  String get assets_documents => 'Documentos e outros arquivos';

  @override
  String get assets_empty =>
      'Nenhum recurso encontrado nas mensagens examinadas';

  @override
  String get assets_empty_detail =>
      'Examine mais chats ou mensagens mais antigas para consultar um período anterior. Anexos comuns e arquivos sem links não são indexados aqui.';

  @override
  String get assets_no_matches => 'Nenhum recurso correspondente';

  @override
  String get assets_load_more_chats => 'Examinar mais chats';

  @override
  String get assets_load_older_messages => 'Examinar mensagens mais antigas';

  @override
  String get assets_load_failed =>
      'Algumas partes do histórico não puderam ser lidas. Os resultados estão incompletos. Verifique a conexão com o painel e tente novamente.';

  @override
  String get assets_retry_failed => 'Tentar novamente as leituras que falharam';

  @override
  String get assets_partial =>
      'O servidor informou que o histórico está incompleto. Verifique o painel e atualize em seguida.';

  @override
  String assets_scan_summary(int files, int chats) {
    return 'Referências a arquivos encontradas: $files · Chats examinados: $chats';
  }

  @override
  String assets_open_chat(String title) {
    return 'Abrir chat: $title';
  }

  @override
  String get assets_file_too_large =>
      'Este arquivo excede o limite de download. Abra o painel para baixá-lo.';

  @override
  String get a_one_off_question_archives_itself_after_72_hours_anything =>
      'Uma pergunta pontual. É arquivada automaticamente após 72 horas; o que valer a pena guardar continua na memória.';

  @override
  String get archive_chat => 'Arquivar chat';

  @override
  String get unarchive_chat => 'Desarquivar chat';

  @override
  String get chat_archived => 'Chat arquivado';

  @override
  String get chat_unarchived => 'Chat desarquivado';

  @override
  String could_not_update_chat_archive(Object error) {
    return 'Não foi possível alterar o arquivo do chat: $error';
  }

  @override
  String get quick_chat_description => 'Uma pergunta pontual.';

  @override
  String get ai_full_text => 'IA + texto completo';

  @override
  String get ai_search_model => 'Modelo de busca com IA';

  @override
  String ai_searched_for(Object aiRewrittenQuery) {
    return 'A IA buscou: $aiRewrittenQuery';
  }

  @override
  String get ai_assisted_filing => 'Arquivamento assistido por IA';

  @override
  String get api_key => 'Chave de API';

  @override
  String get api_server_key_from_hermes_env =>
      'API_SERVER_KEY de ~/.hermes/.env';

  @override
  String get active => 'Ativo';

  @override
  String get activity => 'Atividade';

  @override
  String get activity_reads_the_durable_turn_journal_to_know_what_hermes =>
      'A atividade lê o diário de turnos durável para saber o que o Hermes está fazendo. Verifique se o Gateway está acessível e tente novamente.';

  @override
  String get add => 'Adicionar';

  @override
  String get add_connection => 'Adicionar conexão';

  @override
  String get add_cron_job => 'Adicionar tarefa Cron';

  @override
  String get add_gateway_connection => 'Adicionar conexão de Gateway';

  @override
  String get add_and_update_connections_from_the_backup_keep_the_rest =>
      'Adicionar e atualizar conexões do backup; manter as demais.';

  @override
  String get add_attachment => 'Adicionar anexo';

  @override
  String get add_new_cron_job => 'Adicionar nova tarefa Cron';

  @override
  String get add_to_chat => 'Adicionar ao chat';

  @override
  String get all_chats => 'Todos os chats';

  @override
  String get all_stored_message_content =>
      'Todo o conteúdo de mensagens armazenado';

  @override
  String get allow_for_this_session => 'Permitir nesta sessão';

  @override
  String get allow_matching_commands_until_this_hermes_session_ends =>
      'Permitir comandos correspondentes até esta sessão do Hermes terminar.';

  @override
  String get allow_folder_until_sandbox_off =>
      'Permitir esta pasta até a sandbox ser desativada.';

  @override
  String get allow_once => 'Permitir uma vez';

  @override
  String get allow_website_until_sandbox_off =>
      'Permitir este site até a sandbox ser desativada.';

  @override
  String get always_allow => 'Permitir sempre';

  @override
  String get apply_to_this_chat => 'Aplicar a este chat';

  @override
  String get approval_needed => 'Aprovação necessária';

  @override
  String get approval_needed_description =>
      'Um comando aguarda sua aprovação ou recusa.';

  @override
  String get approve => 'Aprovar';

  @override
  String get archive => 'Arquivar';

  @override
  String get archive_project => 'Arquivar projeto';

  @override
  String archive_2(Object projectName) {
    return 'Arquivar $projectName?';
  }

  @override
  String archive_3(Object name) {
    return 'Arquivar $name?';
  }

  @override
  String get archived => 'Arquivado';

  @override
  String get archived_conversations_appear_here =>
      'Só as conversas arquivadas aparecem aqui. Os chats antigos continuam em Todos os chats.';

  @override
  String get archived_quick_chats => 'Chats rápidos arquivados';

  @override
  String get artifacts_attachments_and_generated_media =>
      'Artefatos, anexos e mídia gerada';

  @override
  String get ask_ai_to_find_a_conversation =>
      'Pedir à IA para encontrar uma conversa';

  @override
  String get assets => 'Recursos';

  @override
  String get assets_need_a_server_authoritative_assets_index_in_the_hermes =>
      'Os recursos precisam de um índice autoritativo do servidor no Gateway do Hermes antes de serem exibidos por projeto.';

  @override
  String get assets_unavailable => 'Recursos indisponíveis';

  @override
  String get attach_image_or_file => 'Anexar imagem ou arquivo';

  @override
  String get attachment_drafts => 'Rascunhos de anexos';

  @override
  String get recover_text_draft => 'Recuperar um rascunho de texto';

  @override
  String get undo_draft_recovery => 'Desfazer';

  @override
  String get draft_session_exists =>
      'Esta conversa ainda existe. Abra-a para continuar o rascunho.';

  @override
  String get draft_recovery_unavailable =>
      'Não foi possível verificar o rascunho. Nada foi alterado.';

  @override
  String attachment_of(Object index, Object total) {
    return 'Anexo $index de $total';
  }

  @override
  String get auto_device_default => 'Automático (padrão do dispositivo)';

  @override
  String get agent => 'Agente';

  @override
  String get autonomous_agents => 'Agentes autônomos';

  @override
  String get background_recovery_unavailable_legacy_transport =>
      'Recuperação em segundo plano indisponível — transporte legado';

  @override
  String get background_task_completed => 'Tarefa em segundo plano concluída';

  @override
  String get background_task_completed_description =>
      'Um comando de terminal em segundo plano foi concluído.';

  @override
  String get backup_restore => 'Backup e restauração';

  @override
  String backup_exported(Object destination) {
    return 'Backup exportado — $destination';
  }

  @override
  String get base_url => 'URL base';

  @override
  String get binary_preview_is_unavailable_download_the_file_to_open_it =>
      'A pré-visualização de binários não está disponível. Baixe o arquivo para abri-lo.';

  @override
  String get branch => 'Ramificação';

  @override
  String get branch_chat => 'Criar ramificação do chat';

  @override
  String get branch_created_in_hermes_history =>
      'Ramificação criada no histórico do Hermes.';

  @override
  String get browse_and_manage_your_hermes_agent_sessions_from_your_phone =>
      'Navegue e gerencie suas sessões do Hermes Agent pelo celular. Conecta-se a um painel do Hermes em execução na sua rede local.';

  @override
  String get browse_server_files => 'Navegar pelos arquivos do servidor';

  @override
  String get browse_the_miniserver_folders_behind_your_projects =>
      'Navegue pelas pastas do miniserver por trás dos seus projetos';

  @override
  String get cancel => 'Cancelar';

  @override
  String get cancel_voice_input => 'Cancelar entrada de voz';

  @override
  String cannot_reach(Object host, Object port) {
    return 'Não é possível alcançar $host:$port.';
  }

  @override
  String cannot_reach_check_the_host_and_port(Object host, Object port) {
    return 'Não é possível alcançar $host:$port. Verifique o host e a porta.';
  }

  @override
  String get change_ai_search_model => 'Alterar modelo de busca com IA';

  @override
  String changes_the_default_for_use_the_selector_in_a_chat(Object label) {
    return 'Altera o padrão de $label. Use o seletor em um chat para substituir apenas aquela conversa.';
  }

  @override
  String get chat_actions => 'Ações do chat';

  @override
  String get chats => 'Chats';

  @override
  String get chats_from_this_gateway_are_not_grouped_yet_grouping_stays =>
      'Os chats deste Gateway ainda não são agrupados. O agrupamento fica neste celular até que o Gateway possa hospedar projetos.';

  @override
  String get chats_in_this_project_will_show_their_state_and_last =>
      'Os chats deste projeto mostrarão aqui seu estado e última atividade.';

  @override
  String get chats_that_are_not_assigned_to_a_project =>
      'Chats que não estão atribuídos a um projeto';

  @override
  String get chats_you_start_in_this_project_will_appear_here_on =>
      'Os chats que você iniciar neste projeto aparecerão aqui, em todos os dispositivos conectados a este Hermes.';

  @override
  String get check_that_the_gateway_is_running_and_reachable_then_try =>
      'Verifique se o Gateway está em execução e acessível e tente novamente.';

  @override
  String get check_the_dashboard_connection_and_try_again =>
      'Verifique a conexão do painel e tente novamente.';

  @override
  String get check_the_connection_and_try_again =>
      'Verifique a conexão e tente novamente.';

  @override
  String get choose_a_small_model_to_rewrite_queries =>
      'Escolha um modelo pequeno para reescrever consultas';

  @override
  String get choose_an_ai_search_model_before_using_ai_search =>
      'Escolha um modelo de busca com IA antes de usar a busca com IA.';

  @override
  String get choose_an_active_project_next =>
      'Escolha um projeto ativo em seguida';

  @override
  String get choose_chat_model => 'Escolher modelo do chat';

  @override
  String get choose_files => 'Escolher arquivos';

  @override
  String get choose_image => 'Escolher imagem';

  @override
  String get choose_images => 'Escolher imagens';

  @override
  String get choose_its_destination_space => 'Escolha o espaço de destino';

  @override
  String get clear_search => 'Limpar busca';

  @override
  String get close => 'Fechar';

  @override
  String get code_copied => 'Código copiado';

  @override
  String get code_format => 'Código';

  @override
  String get coming_next => 'Em breve';

  @override
  String get command => 'Comando';

  @override
  String get command_palette => 'Paleta de comandos';

  @override
  String get command_palette_hint => 'Escreva um comando';

  @override
  String get command_palette_no_results => 'Não foram encontrados comandos';

  @override
  String get command_palette_new_chat => 'Nova conversa';

  @override
  String get command_palette_search_chats => 'Pesquisar conversas';

  @override
  String get command_palette_toggle_theme => 'Alternar tema';

  @override
  String get command_palette_copy_last_code => 'Copiar último bloco de código';

  @override
  String get command_line_chats => 'Chats de linha de comando';

  @override
  String get compatibility_mode => 'Modo de compatibilidade';

  @override
  String get configure_a_valid_desktop_gateway_url_before_attaching_files =>
      'Configure uma URL válida do Desktop Gateway antes de anexar arquivos.';

  @override
  String get confirm_always_allow => 'Confirmar permitir sempre';

  @override
  String get confirm_passphrase => 'Confirmar frase secreta';

  @override
  String connecting_to(Object baseUrl) {
    return 'Conectando a $baseUrl...';
  }

  @override
  String get connection_issue => 'Problema de conexão';

  @override
  String
  get connection_switched_the_running_reply_continues_on_the_server_and =>
      'Conexão alterada — a resposta em andamento continua no servidor e será reconectada automaticamente.';

  @override
  String get connection_appearance_and_device_preferences =>
      'Conexão, aparência e preferências do dispositivo';

  @override
  String context_tokens(Object effectiveContextLength) {
    return 'Contexto: $effectiveContextLength tokens';
  }

  @override
  String get continue_label => 'Continuar';

  @override
  String get continue_working => 'Continuar trabalhando';

  @override
  String get conversations_in_this_project => 'Conversas neste projeto';

  @override
  String get copy_code => 'Copiar código';

  @override
  String get copy_message => 'Copiar mensagem';

  @override
  String could_not_branch_chat(Object error) {
    return 'Não foi possível criar ramificação do chat: $error';
  }

  @override
  String could_not_delete_session(Object error) {
    return 'Não foi possível excluir a sessão: $error';
  }

  @override
  String could_not_deny_the_command(Object error) {
    return 'Não foi possível negar o comando: $error';
  }

  @override
  String could_not_load_ai_search_models(Object error) {
    return 'Não foi possível carregar os modelos de busca com IA: $error';
  }

  @override
  String get could_not_load_conversations =>
      'Não foi possível carregar as conversas';

  @override
  String get could_not_load_files => 'Não foi possível carregar os arquivos';

  @override
  String could_not_load_models_for_this_profile(Object error) {
    return 'Não foi possível carregar os modelos deste perfil: $error';
  }

  @override
  String could_not_load_more_chats(Object error) {
    return 'Não foi possível carregar mais chats: $error';
  }

  @override
  String get could_not_open_link => 'Não foi possível abrir este link.';

  @override
  String get could_not_open_the_hermes_dashboard =>
      'Não foi possível abrir o painel do Hermes.';

  @override
  String get could_not_open_this_project =>
      'Não foi possível abrir este projeto';

  @override
  String get could_not_preview_file =>
      'Não foi possível pré-visualizar o arquivo';

  @override
  String get could_not_reach_hermes => 'Não foi possível alcançar o Hermes';

  @override
  String could_not_reach_authenticate_the_dashboard_at_check_the_port(
    Object dashboardPort,
    Object host,
  ) {
    return 'Não foi possível alcançar/autenticar o painel em $host:$dashboardPort. Verifique a porta e as credenciais.';
  }

  @override
  String get could_not_read_activity => 'Não foi possível ler a atividade';

  @override
  String could_not_rename_chat(Object error) {
    return 'Não foi possível renomear o chat: $error';
  }

  @override
  String could_not_send_the_approval(Object error) {
    return 'Não foi possível enviar a aprovação: $error';
  }

  @override
  String get could_not_skip_the_hermes_question =>
      'Não foi possível pular a pergunta do Hermes.';

  @override
  String could_not_the_project(Object action, Object error) {
    return 'Não foi possível $action o projeto: $error';
  }

  @override
  String get couldn_t_delete_project => 'Não foi possível excluir o projeto';

  @override
  String couldn_t_load_runs(Object error) {
    return 'Não foi possível carregar as execuções: $error';
  }

  @override
  String get couldn_t_move_conversation => 'Não foi possível mover a conversa';

  @override
  String couldn_t_move_to(Object label, Object reason) {
    return 'Não foi possível mover para $label: $reason';
  }

  @override
  String get couldn_t_prepare_the_shared_files =>
      'Não foi possível preparar os arquivos compartilhados.';

  @override
  String get couldn_t_promote_conversation =>
      'Não foi possível promover a conversa';

  @override
  String couldn_t_project(Object action) {
    return 'Não foi possível $action o projeto';
  }

  @override
  String get create => 'Criar';

  @override
  String get create_a_project => 'Criar um projeto';

  @override
  String get create_a_project_first_then_chats_can_live_inside_it =>
      'Crie um projeto primeiro; depois os chats poderão viver dentro dele.';

  @override
  String get create_a_space_to_separate_related_conversations =>
      'Crie um espaço para separar conversas relacionadas.';

  @override
  String get create_branch => 'Criar ramificação';

  @override
  String get credit_notifications => 'Notificações de crédito';

  @override
  String get credit_notifications_description =>
      'O uso de crédito foi interrompido ou restaurado.';

  @override
  String get cron => 'Cron';

  @override
  String get crons => 'Crons';

  @override
  String get cron_conversations_empty =>
      'As conversas de tarefas agendadas aparecem aqui, incluindo execuções anteriores.';

  @override
  String get search_cron_conversations => 'Pesquisar conversas cron';

  @override
  String get cron_jobs => 'Tarefas Cron';

  @override
  String cron_schedule_timezone(Object zone) {
    return 'Fuso horário do agendamento: $zone';
  }

  @override
  String get crons_upcoming => 'Próximas';

  @override
  String get crons_history => 'Histórico';

  @override
  String cron_time_with_zone(Object time, Object zone) {
    return '$time ($zone)';
  }

  @override
  String cron_time_zone_unknown(Object time) {
    return '$time (fuso horário desconhecido)';
  }

  @override
  String get cron_no_next_run => 'Sem próxima execução agendada';

  @override
  String get cron_status_scheduled => 'Agendada';

  @override
  String get cron_status_paused => 'Em pausa';

  @override
  String cron_delivers_to(Object target) {
    return 'Entrega em $target';
  }

  @override
  String get cron_upcoming_empty_title => 'Sem tarefas agendadas';

  @override
  String get cron_upcoming_empty_message =>
      'Não há nada agendado para executar. Crie uma tarefa em Tarefas Cron ou peça ao agente para agendar uma.';

  @override
  String get cron_upcoming_unavailable => 'Tarefas agendadas indisponíveis';

  @override
  String get cron_upcoming_needs_dashboard =>
      'As tarefas agendadas necessitam de uma ligação ao painel. Este endereço não disponibiliza o agendamento Cron. Verifique o endereço do painel e o suporte do anfitrião.';

  @override
  String get cron_upcoming_needs_dashboard_auth =>
      'As tarefas agendadas necessitam de autenticação no painel. Adicione o utilizador e a palavra-passe do painel a esta ligação ou ative o modo com proxy.';

  @override
  String get cron_upcoming_dashboard_unreachable =>
      'Não foi possível alcançar o painel. Verifique o anfitrião, a porta do painel e a rede e tente novamente.';

  @override
  String get cron_upcoming_load_failed =>
      'Não foi possível ler as tarefas agendadas. Verifique a ligação ao painel e tente novamente.';

  @override
  String get cron_upcoming_refresh_failed =>
      'Não foi possível atualizar o agendamento. É apresentada a última leitura bem-sucedida.';

  @override
  String get cron_job_added => 'Tarefa Cron adicionada';

  @override
  String get cron_job_updated => 'Tarefa Cron atualizada';

  @override
  String get cron_run => 'Execução do Cron';

  @override
  String get cross_device_ordering_and_reversible_bulk_organization =>
      'Ordenação entre dispositivos e organização em massa reversível';

  @override
  String get current_profile_default => 'Padrão do perfil atual';

  @override
  String get custom_proxy_and_dashboard_details =>
      'Detalhes personalizados de proxy e painel';

  @override
  String get dark => 'Escuro';

  @override
  String get dashboard_proxy_settings => 'Configurações do painel / proxy';

  @override
  String get dashboard_password_optional => 'Senha do painel (opcional)';

  @override
  String get dashboard_port => 'Porta do painel';

  @override
  String get dashboard_username_optional =>
      'Nome de usuário do painel (opcional)';

  @override
  String get dashboard_behind_proxy => 'Painel atrás de proxy';

  @override
  String get dashboard_path_prefix => 'Prefixo de caminho do painel';

  @override
  String delegated_task(Object goal) {
    return 'Tarefa delegada: $goal';
  }

  @override
  String get delete => 'Excluir';

  @override
  String delete_2(Object name) {
    return 'Excluir “$name”?';
  }

  @override
  String delete_from_the_remote_hermes_history_this_cannot_be_undone(
    Object title,
  ) {
    return 'Excluir “$title” do histórico remoto do Hermes? Esta ação não pode ser desfeita.';
  }

  @override
  String get delete_cron_job => 'Excluir tarefa Cron';

  @override
  String get delete_connections_that_are_not_in_the_backup =>
      'Excluir conexões que não estão no backup.';

  @override
  String delete_failed(Object error) {
    return 'Falha ao excluir: $error';
  }

  @override
  String get delete_project => 'Excluir projeto';

  @override
  String get delete_session => 'Excluir sessão?';

  @override
  String delete_3(Object projectName) {
    return 'Excluir $projectName?';
  }

  @override
  String deleted(Object name) {
    return '“$name” excluído';
  }

  @override
  String get delivery_is_uncertain_recovering_without_resending =>
      'A entrega é incerta; recuperando sem reenviar…';

  @override
  String get desktop_gateway_url_optional =>
      'URL do Desktop Gateway (opcional)';

  @override
  String get desktop_gateway_is_not_configured_for_this_connection =>
      'O Desktop Gateway não está configurado para esta conexão.';

  @override
  String get desktop_app => 'Aplicativo para desktop';

  @override
  String get developer_tool_calls => 'Chamadas de ferramentas do desenvolvedor';

  @override
  String get discord_chats => 'Chats do Discord';

  @override
  String get dismiss => 'Descartar';

  @override
  String get do_not_run_this_command => 'Não execute este comando.';

  @override
  String get documents_archives_audio_video_or_data =>
      'Documentos, arquivos compactados, áudio, vídeo ou dados';

  @override
  String get download => 'Baixar';

  @override
  String download_failed(Object error) {
    return 'Falha no download: $error';
  }

  @override
  String get durable_facts_hermes_keeps_about_you =>
      'Fatos duráveis que o Hermes guarda sobre você';

  @override
  String get durable_work_inside_one_of_your_projects_shared_with_desktop =>
      'Trabalho durável dentro de um dos seus projetos, compartilhado com o Desktop.';

  @override
  String get edit => 'Editar';

  @override
  String get edit_connection => 'Editar conexão';

  @override
  String get edit_cron_job => 'Editar tarefa Cron';

  @override
  String get edit_gateway_connection => 'Editar conexão de Gateway';

  @override
  String get edit_and_resend => 'Editar e reenviar';

  @override
  String get enable_notifications => 'Ativar notificações';

  @override
  String get enable_notifications_description =>
      'Desativar isto desativa todas as notificações abaixo.';

  @override
  String get enables_file_attachments_through_the_desktop_remote_gateway =>
      'Permite anexos de arquivos pelo Gateway remoto do Desktop.';

  @override
  String get enter_a_name => 'Digite um nome';

  @override
  String get enter_a_passphrase => 'Digite uma frase secreta.';

  @override
  String get enter_the_passphrase_for_this_backup =>
      'Digite a frase secreta deste backup.';

  @override
  String get every_conversation_is_already_assigned_to_a_project =>
      'Todas as conversas já estão atribuídas a um projeto.';

  @override
  String get everything_not_yet_native_in_the_authenticated_web_dashboard =>
      'Tudo que ainda não é nativo, no painel web autenticado';

  @override
  String get explain_the_attached_content_clearly =>
      'Explique claramente o conteúdo anexado.';

  @override
  String explain_this_content_clearly(Object text) {
    return 'Explique claramente este conteúdo:\n\n$text';
  }

  @override
  String
  get explicit_choices_adjust_android_accessibility_text_size_system_leaves_it =>
      'Escolhas explícitas ajustam o tamanho do texto de acessibilidade do Android; “Sistema” o mantém inalterado.';

  @override
  String get export_label => 'Exportar';

  @override
  String get export_share => 'Exportar / compartilhar';

  @override
  String get external_api_clients => 'Clientes de API externos';

  @override
  String get extra_high => 'Muito alto';

  @override
  String get extract_tasks => 'Extrair tarefas';

  @override
  String
  get extract_the_decisions_deadlines_owners_and_actionable_action_items_from =>
      'Extraia do conteúdo anexado as decisões, prazos, responsáveis e itens de ação executáveis.';

  @override
  String
  extract_the_decisions_deadlines_owners_and_actionable_action_items_from_2(
    Object text,
  ) {
    return 'Extraia deste conteúdo as decisões, prazos, responsáveis e itens de ação executáveis:\n\n$text';
  }

  @override
  String failed_to_add_job(Object error) {
    return 'Falha ao adicionar tarefa: $error';
  }

  @override
  String get failed_to_load_cron_jobs => 'Falha ao carregar as tarefas Cron';

  @override
  String get failed_to_load_memory => 'Falha ao carregar a memória';

  @override
  String get failed_to_load_messages => 'Falha ao carregar as mensagens';

  @override
  String get failed_to_load_settings => 'Falha ao carregar as configurações';

  @override
  String get failed_to_load_skills => 'Falha ao carregar as habilidades';

  @override
  String failed_to_update_job(Object error) {
    return 'Falha ao atualizar tarefa: $error';
  }

  @override
  String failed(Object error) {
    return 'Falha: $error';
  }

  @override
  String get file_attached_document_catalog_registration_is_pending =>
      'Arquivo anexado; o registro no catálogo de documentos está pendente.';

  @override
  String get file_reference_added_to_chat =>
      'Referência de arquivo adicionada ao chat';

  @override
  String get files => 'Arquivos';

  @override
  String get fill_from_document => 'Preencher a partir do documento';

  @override
  String get folder_is_empty => 'A pasta está vazia';

  @override
  String get folders => 'Pastas';

  @override
  String get full_text => 'Texto completo';

  @override
  String get gateway_api_access => 'Acesso à API do Gateway';

  @override
  String get gateway_connected_but_the_dashboard_could_not_be_reached_or =>
      'Gateway conectado, mas o painel não pôde ser alcançado ou autenticado. Verifique os detalhes do painel ou limpe-os para pular.';

  @override
  String get gateway_path_prefix => 'Prefixo de caminho do Gateway';

  @override
  String get go_to_end => 'Ir para o fim';

  @override
  String get hermes_agent => 'Ares - formerly Hermes Android';

  @override
  String get hermes_agent_for_android => 'Ares - formerly Hermes Android';

  @override
  String get hermes_could_not_accept_the_answer_please_try_again =>
      'O Hermes não pôde aceitar a resposta. Tente novamente.';

  @override
  String get hermes_could_not_load_your_saved_connections =>
      'O Hermes não pôde carregar suas conexões salvas';

  @override
  String get hermes_did_not_accept_the_response_please_try_again =>
      'O Hermes não aceitou a resposta. Tente novamente.';

  @override
  String get hermes_is_responding => 'O Hermes está respondendo…';

  @override
  String get hermes_is_waiting_for_input =>
      'O Hermes está aguardando sua entrada…';

  @override
  String get hermes_keeps_android_accessibility_text_scaling_active =>
      'O Ares mantém a escala de texto de acessibilidade do Android ativa.';

  @override
  String get hermes_needs_your_input => 'O Hermes precisa da sua entrada';

  @override
  String get hermes_profile_optional => 'Perfil do Hermes (opcional)';

  @override
  String get hermes_profile_must_be_a_plain_profile_name_such_as =>
      'O perfil do Hermes deve ser um nome simples de perfil, como “sol”, e não um caminho.';

  @override
  String get hermes_reasoning_details => 'Detalhes de raciocínio do Hermes';

  @override
  String hermes_recovery_is_unavailable(Object error) {
    return 'A recuperação do Hermes está indisponível: $error';
  }

  @override
  String get hermes_stopped_recovery_safely_no_prompt_was_resent =>
      'O Hermes interrompeu a recuperação com segurança. Nenhum prompt foi reenviado.';

  @override
  String get hide_passphrase => 'Ocultar frase secreta';

  @override
  String get home_needs_your_recent_chats_to_know_what_deserves_your =>
      'O início precisa dos seus chats recentes para saber o que merece sua atenção. Verifique se o Gateway está acessível e tente novamente.';

  @override
  String get host => 'Host';

  @override
  String get image_selection_was_interrupted_try_again =>
      'A seleção de imagem foi interrompida. Tente novamente.';

  @override
  String get import_label => 'Importar';

  @override
  String get inbox => 'Caixa de entrada';

  @override
  String get inbox_is_clear => 'Caixa de entrada vazia';

  @override
  String get input_needed => 'Entrada necessária';

  @override
  String get input_needed_description =>
      'O Hermes fez uma pergunta ou precisa de uma senha ou segredo.';

  @override
  String get insert_a_remote_file_reference =>
      'Inserir uma referência remota a @file';

  @override
  String get invalid_port_number => 'Número de porta inválido.';

  @override
  String get job_paused => 'Tarefa pausada';

  @override
  String get job_resumed => 'Tarefa retomada';

  @override
  String get job_triggered => 'Tarefa acionada';

  @override
  String get label => 'Rótulo';

  @override
  String last_activity(Object day, Object month, Object year) {
    return 'Última atividade $day/$month/$year';
  }

  @override
  String last(Object lastRun) {
    return 'Última: $lastRun';
  }

  @override
  String get leave_blank_for_default_8642_443_with_https =>
      'Deixe em branco para o padrão (8642; 443 com https)';

  @override
  String get leave_blank_for_default_9119 =>
      'Deixe em branco para o padrão (9119)';

  @override
  String get light => 'Claro';

  @override
  String listening(Object elapsed) {
    return 'Ouvindo • $elapsed';
  }

  @override
  String listening_elapsed(Object elapsed) {
    return 'Ouvindo, decorrido: $elapsed';
  }

  @override
  String get load_more => 'Carregar mais…';

  @override
  String get loading => 'Carregando';

  @override
  String get location => 'Localização';

  @override
  String get make_sure_the_gateway_api_server_is_running_hermes_gateway =>
      'Certifique-se de que o servidor de API do Gateway esteja em execução\n(hermes gateway status)';

  @override
  String matches(Object assigned, Object name) {
    return 'Corresponde a $name · $assigned';
  }

  @override
  String get memory => 'Memória';

  @override
  String get memory_about_you => 'Sobre si';

  @override
  String get memory_agent_notes => 'Notas do agente';

  @override
  String get memory_builtin_scope =>
      'Factos guardados em USER.md e MEMORY.md deste perfil. Os fornecedores de memória externos (incluindo MemPalace) não são apresentados aqui.';

  @override
  String get memory_read_only =>
      'Só de leitura. Peça ao Hermes no chat para corrigir ou esquecer um facto.';

  @override
  String get memory_unavailable =>
      'Este gateway ou perfil não pode fornecer os factos guardados. Verifique o perfil selecionado e atualize o Hermes, se necessário.';

  @override
  String get memory_load_error =>
      'Verifique a ligação e a autenticação do painel e tente novamente.';

  @override
  String get memory_read_full_fact => 'Ler o facto completo';

  @override
  String get memory_full_fact_requires_update =>
      'Os factos completos requerem um gateway Hermes mais recente. Atualize o Hermes e a lista.';

  @override
  String get memory_fact_detail_error =>
      'Não foi possível carregar o facto completo. Pode ter sido alterado; atualize a lista e tente novamente.';

  @override
  String get memory_entries_are_cross_session_facts_the_agent_remembers_they =>
      'Os factos guardados aparecerão aqui quando o Hermes os memorizar.';

  @override
  String get merge => 'Mesclar';

  @override
  String get message => 'Mensagem';

  @override
  String get message_hermes => 'Enviar mensagem ao Hermes…';

  @override
  String get message_actions => 'Ações da mensagem';

  @override
  String get message_copied => 'Mensagem copiada';

  @override
  String get migrating => 'Migrando…';

  @override
  String get migration_complete => 'Migração concluída';

  @override
  String get migration_failed_local_spaces_were_kept_unchanged =>
      'A migração falhou. Os espaços locais foram mantidos inalterados.';

  @override
  String get migration_incomplete => 'Migração incompleta';

  @override
  String get migration_preview => 'Pré-visualização da migração';

  @override
  String get model => 'Modelo';

  @override
  String get model_and_thinking_for_this_chat =>
      'Modelo e raciocínio para este chat';

  @override
  String model_was_not_changed(Object error) {
    return 'O modelo não foi alterado: $error';
  }

  @override
  String get move_attachment_next => 'Mover anexo para frente';

  @override
  String get move_attachment_previous => 'Mover anexo para trás';

  @override
  String get move_chat => 'Mover chat';

  @override
  String get move_conversation => 'Mover conversa';

  @override
  String get move_to_project => 'Mover para projeto';

  @override
  String get move_to_space => 'Mover para espaço';

  @override
  String get moved_to_a_project => 'Movido para um projeto';

  @override
  String moved_to(Object label) {
    return 'Movido para $label';
  }

  @override
  String get name => 'Nome';

  @override
  String get name_prompt_and_schedule_are_required =>
      'Nome, prompt e agendamento são obrigatórios';

  @override
  String get nav_activity => 'Atividade';

  @override
  String get nav_projects => 'Projetos';

  @override
  String get needs_a_correction_aware_filing_contract_in_the_hermes_gateway =>
      'Requer um contrato de arquivamento com correção no Gateway do Hermes.';

  @override
  String get needs_a_reachable_hermes_dashboard_check_the_host_port_and =>
      'Requer um painel do Hermes acessível. Verifique o host, a porta e as credenciais desta conexão.';

  @override
  String get needs_a_server_authoritative_assets_index_in_the_hermes_gateway =>
      'Requer um índice de recursos autoritativo do servidor no Gateway do Hermes.';

  @override
  String get needs_durable_pin_ordering_batch_mutation_and_undo_contracts_in =>
      'Requer contratos de ordenação de fixados, mutação em lote e desfazer no Gateway do Hermes.';

  @override
  String get needs_you => 'Precisa de você';

  @override
  String get new_label => 'Novo';

  @override
  String get new_chat => 'Novo chat';

  @override
  String get new_chat_2 => 'Novo chat';

  @override
  String new_chat_3(Object projectName) {
    return 'Novo chat · $projectName';
  }

  @override
  String get new_project => 'Novo projeto';

  @override
  String get new_space => 'Novo espaço';

  @override
  String next(Object nextRun) {
    return 'Próxima: $nextRun';
  }

  @override
  String get nginx_injects_auth_app_sends_clean_requests =>
      'O Nginx injeta a autenticação — o app envia requisições limpas';

  @override
  String get no_tts_voices_found_ninstall_google_text_to_speech_and =>
      'Nenhuma voz de TTS encontrada.\nInstale o Google Text-to-Speech e baixe os dados de voz.';

  @override
  String get no_active_projects_on_this_gateway =>
      'Nenhum projeto ativo neste Gateway';

  @override
  String get no_activity_yet => 'Nenhuma atividade ainda';

  @override
  String get no_chat_is_blocked_running_or_waiting_to_be_resumed =>
      'Nenhum chat está bloqueado, em execução ou aguardando retomada. Inicie um novo quando quiser.';

  @override
  String no_chats_in_this_project_match(Object searchQuery) {
    return 'Nenhum chat deste projeto corresponde a “$searchQuery”.';
  }

  @override
  String get no_chats_in_this_space_yet_tap_to_start_one =>
      'Ainda não há chats neste espaço. Toque em + para iniciar um.';

  @override
  String get no_chats_yet => 'Ainda não há chats';

  @override
  String get no_connections => 'Sem conexões';

  @override
  String get no_conversation_matches_this_view =>
      'Nenhuma conversa corresponde a esta visualização.';

  @override
  String get no_cron_jobs => 'Sem tarefas Cron';

  @override
  String get no_folders_yet => 'Ainda não há pastas';

  @override
  String get no_local_spaces_were_found_for_this_connection_so_projects =>
      'Nenhum espaço local foi encontrado para esta conexão, então os projetos já são a única forma de organização em uso aqui.';

  @override
  String get no_matches => 'Sem correspondências';

  @override
  String get no_memory_entries => 'Sem entradas de memória';

  @override
  String get no_message_content_matches =>
      'Nenhuma correspondência no conteúdo das mensagens';

  @override
  String get no_new_messages => 'Sem mensagens novas';

  @override
  String get no_projects_yet => 'Ainda não há projetos';

  @override
  String get no_runs_yet => 'Ainda não há execuções.';

  @override
  String no_server_project_matches_this_name(Object assigned) {
    return 'Nenhum projeto do servidor corresponde a este nome · $assigned';
  }

  @override
  String get no_sessions_yet => 'Ainda não há sessões';

  @override
  String get no_skills_found => 'Nenhuma habilidade encontrada';

  @override
  String get no_spaces_on_this_device => 'Nenhum espaço neste dispositivo';

  @override
  String get no_text_shared => 'Nenhum texto compartilhado';

  @override
  String get no_turn_is_blocked_in_flight_or_recently_finished_work =>
      'Nenhum turno está bloqueado, em andamento ou recém-concluído. O trabalho que você iniciar aparecerá aqui.';

  @override
  String get no_turn_needs_your_input_or_has_failed =>
      'Nenhum turno precisa da sua entrada ou falhou.';

  @override
  String get no_unassigned_chats => 'Nenhum chat não atribuído.';

  @override
  String get nothing_changed_in_the_last_seven_days =>
      'Nada mudou nos últimos sete dias.';

  @override
  String get nothing_has_moved_yet_this_is_only_what_a_migration =>
      'Nada foi movido ainda — isto é apenas o que uma migração faria.';

  @override
  String get nothing_here => 'Nada aqui';

  @override
  String get nothing_is_running => 'Nada em execução';

  @override
  String get nothing_needs_you => 'Nada precisa de você';

  @override
  String get nothing_to_migrate => 'Nada para migrar';

  @override
  String get notifications => 'Notificações';

  @override
  String get windows_notifications_blocked =>
      'As notificações estão indisponíveis. Use a aplicação Ares instalada e verifique Definições → Sistema → Notificações no Windows.';

  @override
  String get windows_notification_diagnostics =>
      'O que o Ares enviou ao Windows';

  @override
  String get chat_activity_share => 'Partilhar atividade da conversa';

  @override
  String get chat_activity_share_hint =>
      'Informe um gateway compatível ligado quando está a usar esta conversa, para que o seu plug-in de notificações do telemóvel possa evitar alertas duplicados. Não são enviadas chaves nem texto de mensagens.';

  @override
  String get completion_sound => 'Som de conclusão';

  @override
  String get completion_sound_system => 'Predefinição do sistema';

  @override
  String get completion_sound_mail => 'Correio';

  @override
  String get completion_sound_reminder => 'Lembrete';

  @override
  String get completion_sound_silent => 'Silencioso';

  @override
  String get completion_sound_scope =>
      'Toca nas respostas concluídas, na notificação de teste e dentro da aplicação. As aprovações e os outros alertas mantêm o som habitual.';

  @override
  String get completion_sound_scope_android =>
      'Toca nas respostas concluídas, na notificação de teste e dentro da aplicação. As aprovações, os outros alertas, as notificações em segundo plano do servidor e as mensagens do Android Auto mantêm o som habitual.';

  @override
  String get notification_open_action => 'Abrir';

  @override
  String get app_sounds_mute => 'Silenciar sons da aplicação';

  @override
  String get app_sounds_mute_hint =>
      'Desativa o som de conclusão que o Ares reproduz enquanto está aberto. As notificações mantêm o seu próprio som.';

  @override
  String get notifications_permission_denied =>
      'As notificações estão bloqueadas pelo sistema. Ative-as para este app nas configurações do Android.';

  @override
  String get off_no_thinking => 'Desativado (sem raciocínio)';

  @override
  String get offline_showing_the_last_known_activity =>
      'Offline — mostrando a última atividade conhecida.';

  @override
  String get offline_showing_the_last_known_chats =>
      'Offline — mostrando os últimos chats conhecidos';

  @override
  String get offline_showing_the_last_known_projects =>
      'Offline — mostrando os últimos projetos conhecidos.';

  @override
  String get on_this_device => 'Neste dispositivo';

  @override
  String get on_device => 'No dispositivo';

  @override
  String get open_inbox => 'Abrir caixa de entrada';

  @override
  String open_inbox_2(Object count) {
    return 'Abrir caixa de entrada ($count)';
  }

  @override
  String get open_the_hermes_dashboard => 'Abrir o painel do Hermes';

  @override
  String get optional_for_the_memory_cron_skills_settings_tabs_leave_blank =>
      'Opcional. Para as abas Memória/Cron/Habilidades/Configurações. Deixe em branco para usar a porta padrão do painel (9119) sem login.';

  @override
  String get organization => 'Organização';

  @override
  String get other_answer => 'Outra resposta';

  @override
  String get overview => 'Visão geral';

  @override
  String get passphrase => 'Frase secreta';

  @override
  String get password_optional => 'Senha (opcional)';

  @override
  String get phone_or_tablet => 'Telefone ou tablet';

  @override
  String get pin_batch_and_undo => 'Fixar, em lote e desfazer';

  @override
  String get plugin_notifications => 'Notificações de plugins';

  @override
  String get plugin_notifications_description =>
      'O gateway enviou um aviso enquanto o app estava em segundo plano.';

  @override
  String get port => 'Porta';

  @override
  String get preparing_attachments => 'Preparando anexos…';

  @override
  String get preview_truncated => 'Pré-visualização truncada';

  @override
  String get preview_unavailable => 'Pré-visualização indisponível';

  @override
  String get profile => 'Perfil';

  @override
  String get profile_default_model => 'Modelo padrão do perfil';

  @override
  String profile_default_set_to_chats_with_their_own_model_keep(
    Object selectedModel,
  ) {
    return 'Padrão do perfil definido como $selectedModel. Chats com modelo próprio mantêm essa substituição.';
  }

  @override
  String
  get profile_this_connection_chats_as_when_the_dashboard_serves_several =>
      'Perfil com que esta conexão conversa quando o painel serve vários perfis. Deixe em branco para um painel isolado por perfil.';

  @override
  String get project => 'Projeto';

  @override
  String get project_actions => 'Ações do projeto';

  @override
  String get project_chat => 'Chat do projeto';

  @override
  String get project_chats_unavailable => 'Chats do projeto indisponíveis';

  @override
  String get projects => 'Projetos';

  @override
  String get projects_group_related_chats_files_and_activity_and_stay_in =>
      'Os projetos agrupam chats, arquivos e atividades relacionados e ficam sincronizados com o Hermes no seu computador.';

  @override
  String
  get projects_need_a_desktop_gateway_connection_add_the_desktop_gateway =>
      'Os projetos precisam de uma conexão com o Desktop Gateway. Adicione a URL do Desktop Gateway a esta conexão para organizar chats entre dispositivos.';

  @override
  String get projects_unavailable => 'Projetos indisponíveis';

  @override
  String get projects_activity_new_navigation =>
      'Projetos, Atividade — nova navegação';

  @override
  String get promote_to_project => 'Promover a projeto';

  @override
  String get prompt => 'Prompt';

  @override
  String get protect_this_backup => 'Proteger este backup';

  @override
  String get provider => 'Provedor';

  @override
  String get proxy_injects_auth_app_sends_clean_requests =>
      'O proxy injeta a autenticação; o app envia requisições limpas';

  @override
  String get quick_chat => 'Chat rápido';

  @override
  String get quick_chats_appear_here_after_their_retention_period =>
      'Chats rápidos aparecem aqui após o período de retenção.';

  @override
  String get read_aloud => 'Ler em voz alta';

  @override
  String get read_aloud_is_unavailable_on_this_device =>
      'A leitura em voz alta não está disponível neste dispositivo';

  @override
  String get reading_response_aloud => 'Lendo a resposta em voz alta';

  @override
  String get ready_to_upload => 'Pronto para enviar';

  @override
  String get reasoning => 'Raciocínio';

  @override
  String get recently_completed => 'Concluído recentemente';

  @override
  String get recently_active => 'Ativo recentemente';

  @override
  String get recovering_hermes => 'Recuperando o Hermes…';

  @override
  String get refresh => 'Atualizar';

  @override
  String get regenerate_response => 'Regenerar resposta';

  @override
  String get remove_attachment => 'Remover anexo';

  @override
  String get rename => 'Renomear';

  @override
  String get rename_chat => 'Renomear chat';

  @override
  String get rename_project => 'Renomear projeto';

  @override
  String get rename_space => 'Renomear espaço';

  @override
  String rename_2(Object projectName) {
    return 'Renomear $projectName';
  }

  @override
  String rename_3(Object name) {
    return 'Renomear $name';
  }

  @override
  String get replace => 'Substituir';

  @override
  String get repositories => 'Repositórios';

  @override
  String
  get research_the_attached_content_verify_the_important_claims_and_cite =>
      'Pesquise o conteúdo anexado, verifique as afirmações importantes e cite as fontes.';

  @override
  String research_this_content_verify_the_important_claims_and_cite_sources(
    Object text,
  ) {
    return 'Pesquise este conteúdo, verifique as afirmações importantes e cite as fontes:\n\n$text';
  }

  @override
  String reset_failed_the_secure_storage_may_need_reinstall(Object retryError) {
    return 'Falha na redefinição: $retryError. O armazenamento seguro pode precisar ser reinstalado.';
  }

  @override
  String get reset_saved_connections => 'Redefinir conexões salvas';

  @override
  String get responding => 'Respondendo…';

  @override
  String response_closed_locally_gateway_stop_failed(Object error) {
    return 'Resposta fechada localmente; falha ao parar o Gateway: $error';
  }

  @override
  String get response_closed_locally_no_active_gateway_turn_was_found =>
      'Resposta fechada localmente; nenhum turno ativo do Gateway foi encontrado.';

  @override
  String get response_complete => 'Resposta concluída';

  @override
  String get response_complete_description =>
      'Um turno foi concluído enquanto o app estava em segundo plano.';

  @override
  String get response_ready => 'Resposta pronta';

  @override
  String get response_stopped => 'Resposta interrompida.';

  @override
  String get restore => 'Restaurar';

  @override
  String get restore_configuration => 'Restaurar configuração';

  @override
  String get restore_project => 'Restaurar projeto';

  @override
  String get retry => 'Tentar novamente';

  @override
  String retry_failed_for_the_draft_and_prompt_were_kept(Object name) {
    return 'Falha ao tentar novamente para $name. O rascunho e o prompt foram mantidos.';
  }

  @override
  String get retry_upload => 'Tentar enviar novamente';

  @override
  String retrying(Object name) {
    return 'Tentando novamente $name…';
  }

  @override
  String get review_local_spaces => 'Revisar espaços locais';

  @override
  String get review_or_promote_quick_chats_past_their_retention_period =>
      'Revisar ou promover chats rápidos além do período de retenção';

  @override
  String get review_the_attached_content => 'Revise o conteúdo anexado.';

  @override
  String get run_only_this_command => 'Execute apenas este comando.';

  @override
  String get running_now => 'Em execução';

  @override
  String get save => 'Salvar';

  @override
  String get save_changes => 'Salvar alterações';

  @override
  String get save_a_permanent_rule_in_the_hermes_configuration =>
      'Salve uma regra permanente na configuração do Hermes.';

  @override
  String get save_the_durable_facts_from_the_attached_content_to_memory =>
      'Salve os fatos duráveis do conteúdo anexado na memória e confirme o que foi retido.';

  @override
  String save_the_durable_facts_from_this_content_to_memory_then(Object text) {
    return 'Salve os fatos duráveis deste conteúdo na memória e confirme o que foi retido:\n\n$text';
  }

  @override
  String get save_your_connections_and_settings_to_an_encrypted_file_then =>
      'Salve suas conexões e configurações em um arquivo criptografado e restaure-as após reinstalar ou em outro dispositivo.';

  @override
  String save_2(Object filename) {
    return 'Salvar $filename';
  }

  @override
  String get schedule => 'Agendamento';

  @override
  String get scheduled_jobs_and_their_last_runs =>
      'Tarefas agendadas e suas últimas execuções';

  @override
  String get scheduled_tasks => 'Tarefas agendadas';

  @override
  String get script_only_no_agent => 'Somente script (sem agente)';

  @override
  String get scroll_horizontally => 'Rolar horizontalmente';

  @override
  String get search_all_chats => 'Pesquisar todos os chats';

  @override
  String get search_all_message_content =>
      'Pesquisar todo o conteúdo das mensagens';

  @override
  String get search_chats => 'Pesquisar chats';

  @override
  String get search_conversations => 'Pesquisar conversas';

  @override
  String get search_loaded_chats => 'Pesquisar chats carregados';

  @override
  String get search_mode => 'Modo de busca';

  @override
  String get select_one_option_or_enter_another_answer =>
      'Selecione uma opção ou digite outra resposta.';

  @override
  String get select_one_or_more_options_then_continue =>
      'Selecione uma ou mais opções e continue.';

  @override
  String get select_text => 'Selecionar texto';

  @override
  String get send => 'Enviar';

  @override
  String send_failed(Object error) {
    return 'Falha no envio: $error';
  }

  @override
  String send_failed_api_only_permission_denied(Object error) {
    return 'Falha no envio: $error. O servidor recusou esta escrita para o principal da chave de API. Se esta conversa pertencer ao Dashboard, adicionar o nome de utilizador e a palavra-passe do Dashboard desta ligação pode permitir o envio; o servidor também pode estar a recusar deliberadamente.';
  }

  @override
  String get send_message => 'Enviar mensagem';

  @override
  String get send_test_notification => 'Enviar notificação de teste';

  @override
  String get session_sources => 'Fontes de sessões';

  @override
  String get session_deleted_from_remote_hermes =>
      'Sessão excluída do Hermes remoto.';

  @override
  String session_search_failed(Object error) {
    return 'Falha na busca de sessões: $error';
  }

  @override
  String get set_profile_default => 'Definir como padrão do perfil';

  @override
  String get settings => 'Configurações';

  @override
  String get share_to_hermes => 'Compartilhar com o Hermes';

  @override
  String get show_passphrase => 'Mostrar frase secreta';

  @override
  String get show_tool_calls_thinking_and_message_metadata =>
      'Mostrar chamadas de ferramentas, raciocínio e metadados de mensagens';

  @override
  String get signal_messages => 'Mensagens do Signal';

  @override
  String get skills => 'Habilidades';

  @override
  String skills_2(Object count) {
    return 'Habilidades ($count)';
  }

  @override
  String get skills_and_tools => 'Habilidades e ferramentas';

  @override
  String get skip => 'Pular';

  @override
  String get slack_chats => 'Chats do Slack';

  @override
  String source(Object source) {
    return 'Origem: $source';
  }

  @override
  String get space_actions => 'Ações do espaço';

  @override
  String get spaces => 'Espaços';

  @override
  String get speak_to_hermes => 'Fale com o Hermes';

  @override
  String get speech_recognition_is_unavailable =>
      'O reconhecimento de fala não está disponível';

  @override
  String get spoken_replies => 'Respostas faladas';

  @override
  String get spoken_replies_off => 'Respostas faladas desativadas';

  @override
  String get spoken_replies_on => 'Respostas faladas ativadas';

  @override
  String get stalled_no_update_from_hermes =>
      'Travado — sem atualizações do Hermes';

  @override
  String get start_something_new => 'Começar algo novo';

  @override
  String get start_voice_input => 'Iniciar entrada de voz';

  @override
  String get starting_hermes => 'Iniciando o Hermes…';

  @override
  String get media_card_download => 'Transferir ficheiro';

  @override
  String get media_card_tap_to_download => 'Toque para transferir';

  @override
  String get still_loading_your_projects => 'Ainda carregando seus projetos.';

  @override
  String get stop => 'Parar';

  @override
  String get stop_response => 'Parar resposta';

  @override
  String get stop_voice_input => 'Parar entrada de voz';

  @override
  String get submitted_waiting_for_hermes => 'Enviado, aguardando o Hermes';

  @override
  String get suggest_projects_and_learn_from_your_corrections =>
      'Sugerir projetos e aprender com suas correções';

  @override
  String get summarize_the_attached_content => 'Resuma o conteúdo anexado.';

  @override
  String summarize_this_content(Object text) {
    return 'Resuma este conteúdo:\n\n$text';
  }

  @override
  String get switch_profile => 'Trocar de perfil';

  @override
  String get system => 'Sistema';

  @override
  String get take_photo => 'Tirar foto';

  @override
  String get tap_to_add_a_remote_hermes_gateway_api_server_port =>
      'Toque em + para adicionar um Gateway do Hermes remoto\n(servidor de API, porta 8642)';

  @override
  String get tap_the_button_to_start_a_new_chat =>
      'Toque no botão + para iniciar um novo chat';

  @override
  String get telegram_messages => 'Mensagens do Telegram';

  @override
  String get terminal_sessions => 'Sessões de terminal';

  @override
  String get test_notification_body =>
      'Se você está vendo isto, as notificações estão funcionando.';

  @override
  String get test_notification_sent => 'Notificação de teste enviada.';

  @override
  String get test_notification_title => 'Teste de notificação do Hermes';

  @override
  String get test_notification_unsupported =>
      'Não foi possível enviar a notificação — verifique se o sistema permite notificações.';

  @override
  String get text_size => 'Tamanho do texto';

  @override
  String get text_size_preview => 'Pré-visualização do tamanho do texto';

  @override
  String text_size_2(Object label) {
    return 'Tamanho do texto: $label';
  }

  @override
  String get the_api_key_could_not_be_stored_securely =>
      'A chave de API não pôde ser armazenada com segurança.';

  @override
  String get the_project_will_move_to_archived_its_chats_and_files =>
      'O projeto será movido para “Arquivado”. Seus chats e arquivos permanecem intactos, e você pode restaurá-lo a qualquer momento.';

  @override
  String get the_project_will_move_to_archived_its_chats_and_files_2 =>
      'O projeto será movido para “Arquivado”. Seus chats e arquivos permanecem intactos, e você pode restaurá-lo depois.';

  @override
  String get the_active_profile_did_not_return_any_selectable_models =>
      'O perfil ativo não retornou nenhum modelo selecionável.';

  @override
  String get the_backup_could_not_be_exported =>
      'O backup não pôde ser exportado.';

  @override
  String get the_backup_could_not_be_restored =>
      'O backup não pôde ser restaurado.';

  @override
  String get the_connection_could_not_be_deleted_safely =>
      'A conexão não pôde ser excluída com segurança.';

  @override
  String get the_connection_could_not_be_stored_securely =>
      'A conexão não pôde ser armazenada com segurança.';

  @override
  String get the_dashboard_credentials_could_not_be_stored_securely =>
      'As credenciais do painel não puderam ser armazenadas com segurança.';

  @override
  String get the_detached_reply_failed => 'A resposta desacoplada falhou.';

  @override
  String the_detached_reply_failed_2(Object error) {
    return 'A resposta desacoplada falhou: $error';
  }

  @override
  String get the_file_contains_your_api_keys_and_dashboard_password_so =>
      'O arquivo contém suas chaves de API e a senha do painel, por isso é criptografado. Sem esta frase secreta, o backup não pode ser restaurado.';

  @override
  String get the_last_turn_failed => 'O último turno falhou';

  @override
  String the_local_connection_store_looks_damaged_you_can_reset_the(
    Object errorType,
  ) {
    return 'O armazenamento local de conexões parece danificado ($errorType). Você pode redefinir as conexões salvas e começar do zero. Os chats no seu Gateway não são afetados.';
  }

  @override
  String get the_model_only_rewrites_your_question_into_a_short_full =>
      'O modelo apenas reescreve sua pergunta como uma consulta curta de texto completo. O Hermes usa as credenciais do provedor já configuradas no host.';

  @override
  String get the_server_has_not_reported_folders_for_this_project_yet =>
      'O servidor ainda não informou pastas para este projeto. Arquivos globais continua disponível em Mais.';

  @override
  String get the_turn_failed => 'O turno falhou';

  @override
  String get the_two_passphrases_do_not_match =>
      'As duas frases secretas não coincidem.';

  @override
  String get the_value_is_sent_directly_to_the_active_hermes_gateway =>
      'O valor é enviado diretamente ao Gateway do Hermes ativo e não é salvo por este app Android.';

  @override
  String get there_are_no_visible_files_in_this_server_folder =>
      'Não há arquivos visíveis nesta pasta do servidor.';

  @override
  String get thinking_effort => 'Esforço de raciocínio';

  @override
  String get this_hermes_gateway_does_not_support_opening_a_project_yet =>
      'Este Gateway do Hermes ainda não oferece suporte a abrir um projeto. Atualize o Hermes no servidor para navegar por um projeto pelo celular.';

  @override
  String get this_hermes_gateway_is_older_than_server_side_projects_so =>
      'Este Gateway do Hermes é mais antigo que os projetos do servidor, então os chats ficam agrupados apenas neste dispositivo. Atualize o Hermes para compartilhar os mesmos projetos entre seus dispositivos.';

  @override
  String get this_project_has_no_folder_to_open_the_chat_in =>
      'Este projeto precisa de uma pasta antes de iniciar um chat nele. Adicione uma pasta e tente novamente.';

  @override
  String get this_chat_has_no_messages_available_in_the_desktop_session =>
      'Este chat ainda não tem mensagens disponíveis na sessão do Desktop.';

  @override
  String get this_creates_a_permanent_rule_in_hermes_review_the_full =>
      'Isto cria uma regra permanente no Hermes. Revise o comando completo antes de confirmar.';

  @override
  String get this_gateway_does_not_host_projects_yet_update_the_gateway =>
      'Este Gateway ainda não hospeda projetos. Atualize o Gateway para organizar chats entre dispositivos.';

  @override
  String get this_permanently_deletes_the_project_chats_will_not_be_deleted =>
      'Isto exclui o projeto permanentemente. Os chats não serão excluídos; voltarão para “Não atribuído”.';

  @override
  String get this_server_doesn_t_offer_background_recovery_chats_run_live =>
      'Este servidor não oferece recuperação em segundo plano — os chats rodam ao vivo';

  @override
  String get this_week => 'Esta semana';

  @override
  String get titles_previews_and_models =>
      'Títulos, pré-visualizações e modelos';

  @override
  String get tool_activity => 'Atividade de ferramentas';

  @override
  String get trigger_now => 'Acionar agora';

  @override
  String get received_outcome_unknown =>
      'Turno encerrado — resultado não confirmado';

  @override
  String get turn_completed => 'Turno concluído';

  @override
  String get turn_failed => 'Turno falhou';

  @override
  String get turn_failed_description =>
      'Um turno em segundo plano terminou com erro.';

  @override
  String get turn_recovery_failed => 'Falha na recuperação do turno';

  @override
  String get unable_to_prepare_this_file_try_another_one =>
      'Não foi possível preparar este arquivo. Tente outro.';

  @override
  String get unable_to_prepare_this_image_try_another_one =>
      'Não foi possível preparar esta imagem. Tente outra.';

  @override
  String unable_to_prepare(Object name) {
    return 'Não foi possível preparar $name.';
  }

  @override
  String get unable_to_read_the_selected_image_the_selection_was_kept =>
      'Não foi possível ler a imagem selecionada. A seleção foi mantida.';

  @override
  String get unassigned => 'Não atribuído';

  @override
  String get unassigned_chats => 'Chats não atribuídos';

  @override
  String get untitled_chat => 'Chat sem título';

  @override
  String get untitled_session => 'Sessão sem título';

  @override
  String get update_api_key => 'Atualizar chave de API';

  @override
  String get upload_failed => 'Falha no envio';

  @override
  String get upload_failed_tap_retry =>
      'Falha no envio • toque para tentar novamente';

  @override
  String uploading(Object index, Object name, Object total) {
    return 'Enviando $index/$total: $name';
  }

  @override
  String get use_as_is => 'Usar como está';

  @override
  String get use_at_least_8_characters => 'Use pelo menos 8 caracteres.';

  @override
  String get use_for_cron_jobs_backed_by_scripts =>
      'Use para tarefas Cron baseadas em scripts.';

  @override
  String get use_on_device => 'Usar no dispositivo';

  @override
  String get use_the_attached_content_to_identify_and_fill_the_relevant =>
      'Use o conteúdo anexado para identificar e preencher os campos relevantes do documento ou formulário. Pergunte antes de enviar qualquer coisa.';

  @override
  String use_this_content_to_identify_and_fill_the_relevant_document(
    Object text,
  ) {
    return 'Use este conteúdo para identificar e preencher os campos relevantes do documento ou formulário. Pergunte antes de enviar qualquer coisa:\n\n$text';
  }

  @override
  String get used_for_hosted_path_prefixes_and_for_the_settings_memory =>
      'Usado para prefixos de caminho hospedados e para as abas Configurações, Memória, Habilidades e Cron. Deixe usuário/senha em branco para um painel aberto, ou ative o modo proxy quando seu proxy reverso injetar a autenticação do painel.';

  @override
  String get username_optional => 'Nome de usuário (opcional)';

  @override
  String using(Object displayName) {
    return 'Usando $displayName…';
  }

  @override
  String get verbose_mode => 'Modo detalhado';

  @override
  String get message_metadata => 'Detalhes da mensagem';

  @override
  String get voice => 'Voz';

  @override
  String voice_setup_failed(Object error) {
    return 'Falha na configuração de voz: $error';
  }

  @override
  String get waiting_for_your_input => 'Aguardando sua entrada';

  @override
  String get what_hermes_knows_how_to_do => 'O que o Hermes sabe fazer';

  @override
  String get what_should_the_agent_do => 'O que o agente deve fazer?';

  @override
  String get whatsapp_messages => 'Mensagens do WhatsApp';

  @override
  String get which_project => 'Qual projeto?';

  @override
  String get workspace => 'Área de trabalho';

  @override
  String get wrap_lines => 'Quebrar linhas';

  @override
  String you_can_attach_up_to_items(Object maxRemoteAttachmentDrafts) {
    return 'Você pode anexar até $maxRemoteAttachmentDrafts itens.';
  }

  @override
  String get your_answer => 'Sua resposta';

  @override
  String get e_g_dashboard => 'ex.: /dashboard';

  @override
  String get e_g_dashboard_proxy_path_before_api =>
      'ex.: /dashboard (caminho do proxy antes de /api/)';

  @override
  String get e_g_profile_peter => 'ex.: /profile/peter';

  @override
  String get e_g_sol => 'ex.: sol';

  @override
  String get e_g_0_9_or_every_2h => 'ex.: 0 9 * * * ou every 2h';

  @override
  String get e_g_daily_backup => 'ex.: Backup diário';

  @override
  String downloaded(Object filename) {
    return '$filename baixado';
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
      '192.168.1.50, 100.x.y.z ou hermes-machine.tailnet.ts.net';

  @override
  String get example_profile_prefix_hint_full =>
      'ex.: /profile/peter (caminho do proxy antes de /api/ e /v1/)';

  @override
  String and_more(Object count) {
    return 'e mais $count';
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
    return '$chats · somente neste dispositivo';
  }

  @override
  String spaces_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count espaços',
      one: '$count espaço',
    );
    return '$_temp0';
  }

  @override
  String get no_new_projects_needed => 'nenhum projeto novo necessário';

  @override
  String projects_to_create(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count projetos a criar',
      one: '$count projeto a criar',
    );
    return '$_temp0';
  }

  @override
  String chats_migrated_projects_created(
    Object createdProjects,
    Object linkedSessions,
  ) {
    return '$linkedSessions chats migrados · $createdProjects projetos criados';
  }

  @override
  String chats_stayed_in_local_spaces(Object unlinkedSessions) {
    return '$unlinkedSessions chats permaneceram em espaços locais e podem ser tentados novamente com segurança.';
  }

  @override
  String model_recommended(Object provider) {
    return '$provider • Recomendado: pequeno e econômico';
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
  String get this_chat => 'este chat';

  @override
  String get profile_default => 'padrão do perfil';

  @override
  String minutes_ago(Object count) {
    return 'há $count min';
  }

  @override
  String hours_ago(Object count) {
    return 'há $count h';
  }

  @override
  String days_ago(Object count) {
    return 'há $count d';
  }

  @override
  String get now_label => 'agora';

  @override
  String get latest_label => 'Mais recente';

  @override
  String new_count_indicator(Object count) {
    return '$count novos';
  }

  @override
  String new_messages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count novas mensagens',
      one: '$count nova mensagem',
    );
    return '$_temp0';
  }

  @override
  String activity_failed_summary(Object failures, Object total) {
    return '$failures com falha • $total no total';
  }

  @override
  String activity_completed_summary(Object count) {
    return '$count concluídos';
  }

  @override
  String tool_start_observed(Object time) {
    return 'Início observado às $time (hora local)';
  }

  @override
  String tool_last_observed(Object time) {
    return 'Última observação às $time (hora local)';
  }

  @override
  String tool_result_recorded(Object time) {
    return 'Resultado registado às $time (hora local)';
  }

  @override
  String get tool_time_unavailable => 'Hora indisponível';

  @override
  String get hermes_is_using_a_tool => 'O Hermes está usando uma ferramenta';

  @override
  String hermes_is_using_tools(Object count) {
    return 'O Hermes está usando $count ferramentas';
  }

  @override
  String delegated_tasks_completed(Object count) {
    return '$count tarefa(s) delegada(s) concluída(s)';
  }

  @override
  String delegated_tasks_active(Object count) {
    return '$count tarefa(s) delegada(s) ativa(s)';
  }

  @override
  String branch_main(Object label) {
    return '$label · main';
  }

  @override
  String get you_heading => '## Você';

  @override
  String get hermes_heading => '## Hermes';

  @override
  String get action_label => 'Ação';

  @override
  String get destination_label => 'Destino';

  @override
  String get markdown_source => 'Código-fonte';

  @override
  String get preview_label => 'Pré-visualização';

  @override
  String get share_action_summarize => 'Resumir';

  @override
  String get share_action_explain => 'Explicar';

  @override
  String get share_action_research => 'Pesquisar';

  @override
  String get share_action_remember => 'Lembrar';

  @override
  String get text_size_small => 'Pequeno';

  @override
  String get text_size_default => 'Padrão';

  @override
  String get text_size_large => 'Grande';

  @override
  String get text_size_extra_large => 'Muito grande';

  @override
  String get text_size_use_system_description =>
      'Usar exatamente o tamanho de texto de acessibilidade do Android.';

  @override
  String text_size_percent_description(Object percent) {
    return '$percent% do tamanho de texto do Android.';
  }

  @override
  String text_size_label_description(Object description, Object label) {
    return '$label — $description';
  }

  @override
  String files_skipped(Object count) {
    return '$count arquivo(s) ignorado(s): limite, tamanho, ilegível ou nome de arquivo sensível.';
  }

  @override
  String model_scope_applied(Object effort, Object model) {
    return '$model • $effort agora se aplicam somente a este chat.';
  }

  @override
  String get reasoning_minimal => 'Mínimo';

  @override
  String get reasoning_low => 'Baixo';

  @override
  String get reasoning_medium => 'Médio';

  @override
  String get reasoning_high => 'Alto';

  @override
  String get reasoning_max => 'Máximo';

  @override
  String get reasoning_ultra => 'Ultra';

  @override
  String get status_running => 'Em execução';

  @override
  String get status_failed => 'Falhou';

  @override
  String get status_done => 'Concluído';

  @override
  String get status_idle => 'Inativo';

  @override
  String get upload_status_uploading => 'Enviando';

  @override
  String get upload_status_uploaded => 'Enviado';

  @override
  String attachment_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anexos',
      one: '$count anexo',
    );
    return '$_temp0';
  }

  @override
  String get action_create => 'criar';

  @override
  String get action_rename => 'renomear';

  @override
  String get action_archive => 'arquivar';

  @override
  String get action_restore => 'restaurar';

  @override
  String get action_delete => 'excluir';

  @override
  String get migrate => 'Migrar';

  @override
  String assigned_chats(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chats atribuídos',
      one: '$count chat atribuído',
    );
    return '$_temp0';
  }

  @override
  String get date_today => 'Hoje';

  @override
  String get date_yesterday => 'Ontem';

  @override
  String get date_earlier => 'Anterior';

  @override
  String get nav_home => 'Início';

  @override
  String get nav_more => 'Mais';

  @override
  String get status_completed => 'Concluído';

  @override
  String get filter_all => 'Todos';

  @override
  String get filter_recent => 'Recentes';

  @override
  String connection_address_key(Object address, Object status) {
    return '$address  •  Chave: $status';
  }

  @override
  String model_via_provider(Object model, Object provider) {
    return '$model  \nvia `$provider`';
  }

  @override
  String get deny => 'Negar';

  @override
  String get connect => 'Conectar';

  @override
  String get appearance => 'Aparência';

  @override
  String get connection_section => 'Conexão';

  @override
  String get about => 'Sobre';

  @override
  String version_label(Object version) {
    return 'Versão $version';
  }

  @override
  String get matched => 'Correspondência';

  @override
  String get search => 'Pesquisar';

  @override
  String get on => 'Ativado';

  @override
  String get off => 'Desativado';

  @override
  String get reasoning_off => 'Desativado';

  @override
  String get hermes_response_ready => 'Resposta do Hermes pronta';

  @override
  String get admin_password_needed => 'Senha de administrador necessária';

  @override
  String get hermes_needs_a_sudo_password_for_the_pending_terminal_command =>
      'O Hermes precisa de uma senha sudo para o comando de terminal pendente.';

  @override
  String get sudo_password => 'Senha do sudo';

  @override
  String get secret_needed => 'Segredo necessário';

  @override
  String get hermes_needs_a_secret_for_the_pending_skill =>
      'O Hermes precisa de um segredo para a habilidade pendente.';

  @override
  String get secret_value => 'Valor do segredo';

  @override
  String get attached_file => 'Arquivo anexado';

  @override
  String get pin_chat => 'Fixar chat';

  @override
  String get unpin_chat => 'Desafixar chat';

  @override
  String get pinned_chats => 'Fixados';

  @override
  String could_not_update_chat_pin(Object error) {
    return 'Não foi possível alterar a fixação do chat: $error';
  }

  @override
  String get could_not_save_chat_spaces =>
      'Não foi possível guardar os espaços de conversa neste dispositivo';

  @override
  String get chat_density => 'Densidade do chat';

  @override
  String chat_density_2(Object label) {
    return 'Densidade do chat: $label';
  }

  @override
  String get chat_density_comfortable => 'Confortável';

  @override
  String get chat_density_compact => 'Compacta';

  @override
  String get chat_density_comfortable_description =>
      'Balões mais amplos com um rótulo de remetente acima de cada mensagem.';

  @override
  String get chat_density_compact_description =>
      'Balões mais justos e sem rótulo para caberem mais mensagens no ecrã.';

  @override
  String chat_density_label_description(Object description, Object label) {
    return '$label — $description';
  }

  @override
  String
  get compact_removes_the_you_and_hermes_labels_and_trims_bubble_padding_spacing_and_side_margins =>
      'O modo compacto remove os rótulos You e Hermes e reduz as margens internas, o espaçamento e as margens laterais dos balões.';

  @override
  String get client_certificate_mtls => 'Certificado de cliente (mTLS)';

  @override
  String get client_certificate_mtls_description =>
      'Apresentar um certificado quando um proxy HTTPS exige TLS mútuo.';

  @override
  String get client_certificate_https_only =>
      'Os certificados de cliente só são usados em ligações HTTPS.';

  @override
  String get choose_certificate => 'Escolher certificado';

  @override
  String get certificate_password => 'Palavra-passe do certificado';

  @override
  String get this_certificate_is_password_protected =>
      'Este certificado está protegido por palavra-passe. Abre à medida que escreve.';

  @override
  String get enter_the_certificate_password_to_finish_loading_it =>
      'Introduza a palavra-passe do certificado para terminar de carregar o certificado escolhido.';

  @override
  String get client_certificate_required =>
      'Carregue um certificado de cliente ou desative a opção de certificado de cliente.';

  @override
  String client_certificate_loaded(String label) {
    return 'Carregado: $label';
  }

  @override
  String get remove_certificate => 'Remover certificado';

  @override
  String get certificate_import_failed =>
      'Não foi possível carregar esse certificado.';

  @override
  String get background_work => 'Trabalho em segundo plano';

  @override
  String get keep_chats_active_in_background =>
      'Manter conversas ativas em segundo plano';

  @override
  String get background_work_description =>
      'Mantém conectadas as conversas iniciadas por você enquanto o app está em segundo plano. Conexões ociosas podem ser desconectadas. Consome mais bateria e dados. Desativar não interrompe o trabalho no servidor.';

  @override
  String get background_work_limits =>
      'O Android ainda pode suspender conexões no modo Doze ou encerrar o processo do app. Notificações após o encerramento do processo exigem uma configuração de push separada. A parada forçada não é suportada.';

  @override
  String get background_work_disclosure =>
      'Uma notificação obrigatória do serviço permanece visível enquanto a proteção em segundo plano está ativa, mesmo com as notificações opcionais de conversa desativadas.';

  @override
  String get battery_optimisation_settings =>
      'Configurações de otimização da bateria';

  @override
  String get battery_optimisation_description =>
      'Abre as configurações do Android para revisar as restrições de bateria. Nenhuma exceção é solicitada automaticamente e alterar as configurações não garante a entrega.';

  @override
  String get battery_settings_unavailable =>
      'Não foi possível abrir as configurações de bateria neste dispositivo.';

  @override
  String get background_work_save_failed =>
      'Não foi possível salvar a configuração de trabalho em segundo plano.';

  @override
  String get ongoing_chat_channel_name => 'Conversas ativas';

  @override
  String get ongoing_chat_channel_description =>
      'Atualizações silenciosas de conversas iniciadas por você ainda não concluídas';

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
  String get activity_status_unconfirmed => 'Estado não confirmado';

  @override
  String get activity_recently_updated => 'Atualizado recentemente';

  @override
  String get activity_reconnecting =>
      'A restabelecer ligação — a verificar o estado do turno';

  @override
  String get activity_outcome_unknown =>
      'Não foi possível confirmar o resultado do turno. Abra o chat para verificar.';

  @override
  String get activity_chat_updated_detail =>
      'Atividade do chat registada pelo Gateway; o estado do turno em tempo real não está disponível.';

  @override
  String get activity_updated => 'Atualizado';

  @override
  String get activity_empty_title => 'Sem atividade recente';

  @override
  String get activity_empty_detail =>
      'Aqui aparecem os turnos iniciados nesta app e os chats do Gateway atualizados nos últimos 7 dias.';

  @override
  String get activity_read_error =>
      'A Atividade não conseguiu ler os registos dos turnos ou os chats do Gateway. Verifique a ligação e tente novamente.';

  @override
  String get activity_chat_unavailable =>
      'Este chat já não está disponível ou não foi possível contactar o Gateway.';

  @override
  String get activity_partial_title => 'Atividade parcialmente carregada';

  @override
  String get activity_partial_detail =>
      'É apresentado um intervalo limitado da atividade do gateway. Podem existir mais conversas; puxe para atualizar.';

  @override
  String get provider_usage => 'Utilização registada';

  @override
  String get provider_usage_notice =>
      'Utilização do Hermes nos últimos 30 dias, não saldo ou preços. Configure as credenciais no servidor Hermes; esta aplicação não guarda chaves API dos fornecedores.';

  @override
  String get provider_usage_failed => 'Não foi possível carregar a utilização.';

  @override
  String get provider_usage_empty =>
      'Sem utilização registada para este fornecedor.';

  @override
  String provider_usage_counts(String sessions, String input, String output) {
    return '$sessions sessões · Entrada: $input · Saída: $output';
  }

  @override
  String provider_usage_costs(String estimated, String actual) {
    return 'Estimado: $estimated · Reportado: $actual';
  }

  @override
  String get provider_quota_codex => 'Subscrição do OpenAI Codex';

  @override
  String get provider_quota_claude => 'Subscrição do Claude';

  @override
  String get provider_quota_openai_api => 'Utilização registada da API OpenAI';

  @override
  String get provider_quota_notice =>
      'Períodos da subscrição comunicados pelo fornecedor, separados da utilização registada pelo Hermes e da faturação da API. As contas são apresentadas separadamente; os limites de um modelo não significam que toda a quota da conta esteja esgotada.';

  @override
  String get provider_quota_windows_notice =>
      'As subscrições do Codex e do Claude têm limites por sessão de cinco horas e por semana. Apenas são apresentados os períodos comunicados pelo fornecedor; os limites e as horas de reposição não comunicados continuam indisponíveis. Os limites semanais podem aplicar-se à conta ou a modelos específicos.';

  @override
  String get provider_quota_five_hour_session => 'Sessão de 5 horas';

  @override
  String get provider_quota_unavailable => 'Quota da subscrição indisponível.';

  @override
  String get provider_quota_failed =>
      'Não foi possível atualizar a quota da subscrição. Os valores mantidos são da consulta anterior.';

  @override
  String get provider_quota_account => 'Conta';

  @override
  String get provider_quota_unknown => 'desconhecido';

  @override
  String provider_quota_state(String state) {
    return 'Estado da conta: $state';
  }

  @override
  String provider_quota_scope(String scope) {
    return 'Âmbito: $scope';
  }

  @override
  String provider_quota_percent(String used, String remaining) {
    return '$used% utilizado · $remaining% restante';
  }

  @override
  String provider_quota_reset(String reset) {
    return 'Reposição: $reset';
  }

  @override
  String get provider_quota_reset_unknown => 'Hora de reposição indisponível.';

  @override
  String get auxiliary_models => 'Modelos auxiliares';

  @override
  String get auxiliary_notice =>
      'Escolha modelos por tarefa. Os endpoints personalizados são geridos no servidor. Auto segue as regras de herança da tarefa.';

  @override
  String get auxiliary_inherit => 'Auto (herdar)';

  @override
  String get auxiliary_unavailable =>
      'As definições auxiliares estão indisponíveis.';

  @override
  String get provider_oauth_title => 'Início de sessão no fornecedor';

  @override
  String get provider_oauth_more_subtitle =>
      'Gerir o início de sessão nos fornecedores no seu servidor Hermes';

  @override
  String get provider_oauth_settings_subtitle =>
      'Inicie sessão no seu servidor Hermes; os tokens do fornecedor não ficam neste dispositivo';

  @override
  String get provider_oauth_intro =>
      'Inicie sessão no fornecedor num navegador externo. Os tokens são guardados apenas no seu servidor Hermes, não neste dispositivo. O início de sessão não seleciona um modelo de conversa nesta aplicação.';

  @override
  String get provider_oauth_defaults_notice =>
      'Alguns processos do servidor, incluindo a substituição de contas gratuitas Nous, podem alterar as predefinições do servidor. Reveja as definições do servidor após iniciar sessão.';

  @override
  String get provider_oauth_transport_init_failed =>
      'Não foi possível inicializar a ligação segura ao painel selecionado. Verifique a identidade TLS e as definições de ligação.';

  @override
  String get provider_oauth_https_required =>
      'O início de sessão no fornecedor requer uma ligação HTTPS ao painel Hermes.';

  @override
  String get provider_oauth_auth_required =>
      'Configure a autenticação por palavra-passe do painel ou um proxy de confiança antes de iniciar sessão.';

  @override
  String get provider_oauth_catalog_failed =>
      'O início de sessão nos fornecedores não está disponível neste servidor. Verifique a autenticação do painel e atualize o servidor se não suportar OAuth de fornecedores.';

  @override
  String get provider_oauth_expired =>
      'O início de sessão expirou. Comece novamente.';

  @override
  String get provider_oauth_start_failed =>
      'Não foi possível iniciar a sessão segura no fornecedor. Tente novamente.';

  @override
  String get provider_oauth_denied =>
      'O início de sessão foi recusado. Comece novamente.';

  @override
  String get provider_oauth_cancelled => 'Início de sessão cancelado.';

  @override
  String get provider_oauth_host_failed =>
      'O servidor não conseguiu concluir o início de sessão. Comece novamente.';

  @override
  String get provider_oauth_poll_failed =>
      'Não foi possível verificar o estado do início de sessão. Comece novamente.';

  @override
  String provider_oauth_cancellation_unconfirmed(String message) {
    return '$message Não foi possível confirmar o cancelamento; a sessão do servidor pode continuar até expirar.';
  }

  @override
  String get provider_oauth_browser_failed =>
      'Não foi possível abrir o navegador externo. Tente novamente ou cancele o início de sessão.';

  @override
  String get provider_oauth_retry => 'Tentar novamente';

  @override
  String provider_oauth_complete(String provider) {
    return 'Concluir o início de sessão em $provider';
  }

  @override
  String get provider_oauth_code_instruction =>
      'Introduza este código temporário na página do fornecedor:';

  @override
  String get provider_oauth_waiting =>
      'A aguardar aprovação. Esta sessão expira automaticamente.';

  @override
  String get provider_oauth_open_browser => 'Abrir fornecedor no navegador';

  @override
  String get provider_oauth_cancel => 'Cancelar início de sessão';

  @override
  String get provider_oauth_signed_out => 'Sem sessão iniciada no servidor';

  @override
  String get provider_oauth_sign_in_again => 'Iniciar sessão novamente';

  @override
  String get provider_oauth_sign_in => 'Iniciar sessão';

  @override
  String get provider_oauth_cli_required =>
      'Inicie sessão com a CLI do fornecedor no seu servidor Hermes. Este servidor não disponibiliza início de sessão na aplicação para este fornecedor.';

  @override
  String get provider_oauth_checking_account =>
      'Aprovação recebida. A verificar a conta no servidor…';

  @override
  String get provider_oauth_verification_unavailable =>
      'Aprovação recebida; verificação da conta indisponível. Abra Utilização para atualizar a utilização da conta.';

  @override
  String provider_oauth_verified_account(String email) {
    return 'Sessão iniciada no servidor Hermes como $email. Abra Utilização para atualizar a utilização da conta.';
  }

  @override
  String get provider_oauth_credentials_unverified =>
      'O servidor indica credenciais disponíveis; a identidade da conta não foi verificada.';

  @override
  String get provider_oauth_account_status_unknown =>
      'Estado da conta no servidor indisponível.';

  @override
  String get app_language => 'Idioma da aplicação';

  @override
  String get app_language_system => 'O mesmo do telemóvel';

  @override
  String get auto_archives_after_72_hours =>
      'Arquivada automaticamente após 72 horas';

  @override
  String get automation => 'Automatização';

  @override
  String get voice_recording_start => 'Gravar mensagem de voz';

  @override
  String get voice_recording_pause => 'Pausar gravação';

  @override
  String get voice_recording_preview => 'Reproduzir gravação';

  @override
  String get voice_recording_resume => 'Continuar gravação';

  @override
  String get voice_recording_send => 'Enviar mensagem de voz';

  @override
  String get voice_recording_discard => 'Descartar gravação';

  @override
  String get voice_recording_processing => 'A preparar mensagem de voz…';

  @override
  String voice_recording_elapsed(String time) {
    return 'A gravar $time';
  }

  @override
  String voice_recording_draft(String time) {
    return 'Mensagem de voz $time';
  }

  @override
  String get voice_recording_permission =>
      'Permita o acesso ao microfone para gravar uma mensagem de voz.';

  @override
  String get voice_recording_limit =>
      'Esta gravação atingiu o limite de dez minutos.';

  @override
  String get voice_recording_empty => 'Não foi gravado áudio. Tente novamente.';

  @override
  String get voice_recording_failed =>
      'Não foi possível processar a gravação. Os fragmentos guardados foram mantidos.';

  @override
  String get voice_recording_unconfirmed =>
      'A entrega não foi confirmada. A sua gravação está guardada. Verifique a conversa antes de tentar novamente.';

  @override
  String get voice_recording_submit_failed =>
      'Não foi possível enviar a mensagem de voz. A sua gravação está guardada. Verifique a ligação, o acesso ao painel e as definições de transcrição do servidor.';

  @override
  String get voice_recording_pause_playback => 'Pausar reprodução';

  @override
  String get projects_root_title => 'Pasta de Projetos no servidor';

  @override
  String get projects_root_more_subtitle =>
      'Onde as novas pastas de Projeto são criadas no servidor';

  @override
  String get projects_root_description =>
      'Os Projetos criados neste telefone recebem a pasta aqui. Aponte para a pasta que o próprio Hermes usa, para que telefone e servidor compartilhem os mesmos Projetos.';

  @override
  String get projects_root_label => 'Caminho raiz dos Projetos';

  @override
  String projects_root_default_hint(String path) {
    return 'Padrão do servidor: $path';
  }

  @override
  String get projects_root_locked_title => 'Definido pelo servidor';

  @override
  String get projects_root_locked_explanation =>
      'Este servidor restringe o acesso a arquivos a uma única raiz, portanto a pasta de Projetos não pode ser alterada pelo aplicativo.';

  @override
  String get projects_root_saved => 'Pasta de Projetos salva.';

  @override
  String get projects_root_reset => 'Usar o padrão do servidor';

  @override
  String get projects_root_invalid_empty => 'Informe um caminho de pasta.';

  @override
  String get projects_root_invalid_absolute =>
      'Informe um caminho absoluto que comece com uma barra.';

  @override
  String get projects_root_invalid_segments =>
      'Remova os segmentos com pontos e os caracteres de controle do caminho.';

  @override
  String get projects_root_unsupported =>
      'Não compatível nesta conexão. É necessária uma conexão Desktop Gateway com acesso ao Painel para ler ou alterar a pasta de Projetos do servidor.';

  @override
  String get projects_root_unavailable =>
      'Não foi possível ler a pasta de Projetos do servidor. Verifique a conexão com o Painel e tente novamente.';

  @override
  String get adopt_folder_action => 'Adicionar uma pasta existente';

  @override
  String adopt_folder_description(String root) {
    return 'Pastas em $root que ainda não estão registradas como Projeto.';
  }

  @override
  String adopt_folder_registered(String name) {
    return 'Já é um Projeto: $name';
  }

  @override
  String get adopt_folder_none =>
      'Todas as pastas neste caminho já são Projetos.';

  @override
  String get adopt_folder_unsupported =>
      'Esta conexão não consegue listar as pastas do servidor. Informe o caminho absoluto de uma pasta existente.';

  @override
  String adopt_folder_failed(String error) {
    return 'Não foi possível listar as pastas do servidor: $error';
  }

  @override
  String get adopt_folder_manual_label => 'Caminho da pasta existente';

  @override
  String get adopt_folder_name_label => 'Nome do Projeto';

  @override
  String get adopt_folder_add => 'Adicionar como Projeto';

  @override
  String adopt_folder_added(String name, String path) {
    return '$name agora usa $path';
  }

  @override
  String adopt_folder_error(String error) {
    return 'Não foi possível adicionar a pasta: $error';
  }

  @override
  String adopt_folder_folderless(String name) {
    return '$name foi criado, mas a pasta não foi anexada. Anexe-a pelo Hermes no servidor.';
  }

  @override
  String get slash_commands => 'Slash commands';

  @override
  String get slash_commands_loading => 'Loading commands…';

  @override
  String get slash_commands_empty => 'No matching commands';

  @override
  String slash_command_info_alias(String alias, String command) {
    return '$alias é um alias de $command';
  }

  @override
  String get slash_command_info_no_description => 'Sem descrição disponível.';

  @override
  String get slash_command_info_arguments_options =>
      'Aceita uma opção de uma lista fixa.';

  @override
  String get slash_command_info_arguments_text =>
      'Aceita texto depois do comando.';

  @override
  String get slash_command_info_arguments_mixed =>
      'Aceita uma opção ou texto depois do comando.';

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
      'Este comando não está disponível neste servidor.';

  @override
  String get slash_sessions_inline =>
      'Abra a lista de sessões para escolher uma conversa. O rascunho foi mantido.';

  @override
  String get composer_snippets => 'Excertos de prompts';

  @override
  String get composer_snippets_description =>
      'Escolha um prompt inicial para inserir no editor.';

  @override
  String get composer_snippet_review => 'Revisão de código';

  @override
  String get composer_snippet_review_body =>
      'Reveja a alteração atual para detetar regressões, casos limite esquecidos e testes em falta.';

  @override
  String get composer_snippet_review_text =>
      'Reveja isto para detetar erros, regressões e testes em falta.';

  @override
  String get composer_snippet_plan => 'Plano de implementação';

  @override
  String get composer_snippet_plan_body =>
      'Defina uma abordagem antes de alterar o código para manter as alterações focadas no objetivo.';

  @override
  String get composer_snippet_plan_text =>
      'Faça um plano de implementação conciso antes de alterar o código.';

  @override
  String get composer_snippet_explain => 'Explicar isto';

  @override
  String get composer_snippet_explain_body =>
      'Explique como funciona o código selecionado e indique os ficheiros principais.';

  @override
  String get composer_snippet_explain_text =>
      'Explique como isto funciona e indique-me os ficheiros principais.';

  @override
  String get composer_status => 'Estado';

  @override
  String get composer_status_context => 'Contexto';

  @override
  String get composer_status_cache => 'Acerto na cache';

  @override
  String get composer_status_throughput => 'Tokens de saída/s';

  @override
  String get composer_status_running => 'Em execução';

  @override
  String get composer_status_session => 'Sessão';

  @override
  String get composer_status_not_reported => 'Não comunicado';

  @override
  String get composer_status_empty =>
      'Não foi fornecida uma discriminação do contexto.';

  @override
  String get composer_status_loading => 'A carregar discriminação do contexto';

  @override
  String get composer_status_reset => 'Repor barra de estado';

  @override
  String get composer_resume_title => 'Retomar uma conversa';

  @override
  String get composer_resume_search => 'Pesquisar títulos e IDs';

  @override
  String get composer_resume_empty => 'Nenhuma conversa corresponde.';

  @override
  String get composer_resume_unavailable =>
      'Este painel não tem uma lista de conversas para pesquisar.';

  @override
  String get composer_failure_retry => 'Tentar novamente';

  @override
  String composer_failure_retry_at(String time) {
    return 'Tentar novamente às $time';
  }

  @override
  String get composer_failure_compress => 'Comprimir';

  @override
  String get composer_failure_switch_model => 'Mudar de modelo';

  @override
  String composer_failure_switch_to(String model) {
    return 'Mudar para $model';
  }

  @override
  String get composer_failure_new_chat => 'Nova conversa';

  @override
  String get composer_failure_edit => 'Editar mensagem';

  @override
  String get composer_failure_details => 'Detalhes';

  @override
  String get composer_failure_hide_details => 'Ocultar detalhes';

  @override
  String get composer_failure_copy => 'Copiar diagnóstico';

  @override
  String get composer_failure_account =>
      'A outra correção é na conta do gateway. Não pode ser feita nesta conversa.';

  @override
  String get composer_failure_account_only =>
      'Isto tem de ser corrigido na conta do gateway. Não pode ser feito nesta conversa.';

  @override
  String get composer_failure_confirm_compress =>
      'Comprimir esta conversa? O gateway irá encurtar a transcrição.';

  @override
  String composer_failure_confirm_model(String model) {
    return 'Mudar esta conversa para $model?';
  }

  @override
  String get composer_drop_attach => 'Largue para anexar';

  @override
  String get composer_drop_folder_unsupported =>
      'Não é possível anexar pastas. Largue os ficheiros em vez disso.';

  @override
  String get composer_drop_reference => 'Largue para referenciar';

  @override
  String get composer_reference_copy => 'Copiar referência';

  @override
  String get composer_reference_remove => 'Remover referência';

  @override
  String get composer_btw_usage =>
      'Utilização: /btw <question> — resposta a partir de um instantâneo desta conversa sem a interromper.';

  @override
  String get composer_background_usage =>
      'Utilização: /background <prompt> — a tarefa é executada em separado e o resultado volta aqui.';

  @override
  String get composer_handoff_usage =>
      'Utilização: /handoff <platform> — transferir esta conversa para essa plataforma de mensagens.';

  @override
  String get composer_command_needs_session =>
      'Este comando precisa de uma conversa aberta.';

  @override
  String get composer_retry_not_found =>
      'Este turno não está no histórico guardado, pelo que Tentar novamente não o pode substituir. Nada foi reenviado. Edite a mensagem e envie-a para tentar de novo.';

  @override
  String get composer_retry_unavailable =>
      'Tentar novamente não pode substituir um turno nesta ligação, pelo que nada foi reenviado. Edite a mensagem e envie-a para tentar de novo.';

  @override
  String get composer_failure_switch_no_retry =>
      'Mudar altera apenas o modelo: esta ligação não consegue voltar a executar o turno que falhou. Envie-o novamente depois de mudar.';

  @override
  String get composer_command_needs_gateway_session =>
      'Esta conversa ainda não tem uma sessão no gateway. Envie primeiro uma mensagem e volte a executar o comando.';

  @override
  String get composer_side_question =>
      'btw — a responder a partir de um instantâneo da conversa';

  @override
  String composer_side_question_id(String id) {
    return 'btw $id — a responder a partir de um instantâneo da conversa';
  }

  @override
  String get composer_background_started =>
      'Tarefa em segundo plano iniciada. Pode continuar a conversar. O resultado aparecerá aqui.';

  @override
  String composer_background_started_id(String id) {
    return 'Tarefa em segundo plano $id iniciada. Pode continuar a conversar. O resultado aparecerá aqui.';
  }

  @override
  String composer_handoff_requested(String platform) {
    return 'Transferência para $platform solicitada.';
  }

  @override
  String composer_handoff_done(String platform) {
    return 'Esta conversa foi transferida para $platform.';
  }

  @override
  String get composer_handoff_failed => 'A transferência falhou.';

  @override
  String get composer_handoff_timeout =>
      'A transferência não terminou. Pode ainda estar em curso no gateway.';

  @override
  String get composer_compress_done => 'Esta conversa foi comprimida.';

  @override
  String get composer_file_missing =>
      'Esse ficheiro não está neste dispositivo.';

  @override
  String get composer_attach_busy =>
      'Pode adicionar anexos quando esta resposta terminar.';

  @override
  String get nextgen_toggle => 'Interface NextGen';

  @override
  String get nextgen_toggle_subtitle =>
      'Um novo design com um único início de sessão, conversas em direto e descoberta na rede. Os seus gateways e conversas são partilhados com esta interface.';

  @override
  String get nextgen_single_login => 'Entrar com um único início de sessão';

  @override
  String get nextgen_single_login_subtitle =>
      'Adicione um gateway apenas com o endereço do painel e um início de sessão.';

  @override
  String get ng_allow_this_command => 'Permitir este comando?';

  @override
  String ng_hermes_wants_to_run_this_with(Object tool) {
    return 'O Hermes quer executar isto com $tool.';
  }

  @override
  String get ng_hermes_wants_to_run_this => 'O Hermes quer executar isto.';

  @override
  String get ng_hermes_has_a_question => 'O Hermes tem uma pergunta';

  @override
  String get ng_hermes_has_questions => 'O Hermes tem perguntas';

  @override
  String get ng_password_for_sudo => 'Palavra-passe do sudo';

  @override
  String get ng_hermes_needs_your_sudo_password_to =>
      'O Hermes precisa da sua palavra-passe do sudo para executar este comando.';

  @override
  String get ng_a_secret_value => 'Um valor secreto';

  @override
  String ng_value_for(Object variable) {
    return 'Valor de $variable';
  }

  @override
  String get ng_your_password_manager => 'o seu gestor de palavras-passe';

  @override
  String ng_unlock(Object name) {
    return 'Desbloquear $name';
  }

  @override
  String ng_hermes_needs_unlocked_to_sign_in(Object name) {
    return 'O Hermes precisa que $name esteja desbloqueado para iniciar sessão por si.';
  }

  @override
  String get ng_sign_in_code => 'Código de início de sessão';

  @override
  String get ng_enter_the_sign_in_code =>
      'Introduza o código de início de sessão.';

  @override
  String ng_enter_the_sign_in_code_for(Object site) {
    return 'Introduza o código de início de sessão para $site.';
  }

  @override
  String get ng_save_a_login => 'Guardar um início de sessão?';

  @override
  String ng_save_your_login(Object site) {
    return 'Guardar o seu início de sessão de $site?';
  }

  @override
  String ng_couldn_t_load_this_chat(Object error) {
    return 'Não foi possível carregar esta conversa: $error';
  }

  @override
  String ng_live_updates_are_unavailable(Object error) {
    return 'As atualizações em tempo real estão indisponíveis: $error';
  }

  @override
  String ng_preparing(Object name) {
    return 'a preparar $name…';
  }

  @override
  String get ng_the_turn_failed => 'A execução falhou.';

  @override
  String get ng_turn_changed =>
      'essa execução já terminou ou começou uma mais recente';

  @override
  String get ng_steer_rejected => 'a execução em curso não o aceitou';

  @override
  String get ng_turn_not_known_yet =>
      'a execução em curso ainda não é conhecida; tente novamente daqui a pouco';

  @override
  String ng_couldn_t_stop(Object error) {
    return 'Não foi possível parar: $error';
  }

  @override
  String get ng_server_access => 'Acesso ao servidor';

  @override
  String get ng_sign_in => 'Início de sessão';

  @override
  String get ng_live_connection => 'Ligação em tempo real';

  @override
  String get ng_check_that_tailscale_is_on_on =>
      'Confirme que o Tailscale está ativo neste telemóvel e no servidor.';

  @override
  String get ng_check_the_address_and_that_the =>
      'Verifique o endereço e confirme que o proxy encaminha os pedidos para o painel.';

  @override
  String get ng_use_the_same_network_as_the =>
      'Use a mesma rede que o servidor e inicie o painel com --host 0.0.0.0 para que outros dispositivos lhe possam aceder.';

  @override
  String get ng_check_the_address_vpn_or_tailscale =>
      'Verifique o endereço e a ligação VPN ou Tailscale.';

  @override
  String get ng_not_checked_yet => 'Ainda não verificado.';

  @override
  String get ng_checking => 'A verificar…';

  @override
  String ng_hermes_answers_at(Object version, Object address) {
    return 'O Hermes $version responde em $address.';
  }

  @override
  String get ng_something_answered_but_not_a_hermes =>
      'Houve uma resposta, mas não é um painel Hermes.';

  @override
  String ng_something_answered_http_but_not_a(Object status) {
    return 'Houve uma resposta (HTTP $status), mas não é um painel Hermes.';
  }

  @override
  String get ng_use_the_dashboard_s_address_and =>
      'Use o endereço e a porta do painel (9119 por predefinição), não os do servidor da API.';

  @override
  String get ng_cloudflare_access_turned_the_service_token =>
      'O Cloudflare Access rejeitou o token de serviço.';

  @override
  String get ng_cloudflare_access_is_in_front_of =>
      'O Cloudflare Access está à frente deste endereço.';

  @override
  String get ng_check_the_service_token_and_its =>
      'Verifique o token de serviço e a respetiva política Service Auth.';

  @override
  String get ng_add_a_cloudflare_access_service_token =>
      'Adicione um token de serviço do Cloudflare Access para este endereço.';

  @override
  String get ng_the_server_asks_for_a_client =>
      'O servidor pede um certificado de cliente.';

  @override
  String get ng_pick_the_client_certificate_for_this =>
      'Selecione o certificado de cliente deste gateway e teste novamente.';

  @override
  String get ng_needs_server_access_first =>
      'É necessário configurar primeiro o acesso ao servidor.';

  @override
  String get ng_needs_a_sign_in_first =>
      'É necessário iniciar sessão primeiro.';

  @override
  String ng_signed_in_as(Object name) {
    return 'Sessão iniciada como $name.';
  }

  @override
  String get ng_this_dashboard_doesn_t_need_a =>
      'Este painel não requer início de sessão.';

  @override
  String get ng_the_saved_sign_in_has_expired => 'A sessão guardada expirou.';

  @override
  String get ng_sign_in_again => 'Inicie sessão novamente.';

  @override
  String get ng_too_many_sign_in_attempts =>
      'Demasiadas tentativas de início de sessão.';

  @override
  String get ng_wait_a_minute_then_check_again =>
      'Aguarde um minuto e volte a verificar.';

  @override
  String ng_the_gateway_answered(Object message) {
    return 'O gateway respondeu: $message.';
  }

  @override
  String get ng_sign_in_again_or_update_hermes =>
      'Inicie sessão novamente ou atualize o Hermes.';

  @override
  String ng_couldn_t_check_the_sign_in(Object error) {
    return 'Não foi possível verificar o início de sessão: $error';
  }

  @override
  String ng_the_gateway_wouldn_t_issue_a(Object message) {
    return 'O gateway não emitiu um bilhete de chat ($message).';
  }

  @override
  String get ng_the_chat_connection_opened_and_the =>
      'A ligação de chat foi aberta e o gateway indicou que está pronta.';

  @override
  String get ng_the_gateway_never_said_it_was =>
      'O gateway nunca indicou que estava pronto.';

  @override
  String get ng_check_that_the_agent_is_running =>
      'Confirme que o agente está em execução no servidor.';

  @override
  String get ng_the_gateway_refused_the_chat_connection =>
      'O gateway recusou a ligação de chat (HTTP 403).';

  @override
  String get ng_this_dashboard_has_no_chat_endpoint =>
      'Este painel não tem um endpoint de chat (/api/ws).';

  @override
  String ng_the_chat_connection_failed(Object detail) {
    return 'A ligação de chat falhou: $detail';
  }

  @override
  String get ng_use_the_exact_address_the_dashboard =>
      'Use o endereço exato configurado para o painel.';

  @override
  String get ng_update_hermes => 'Atualize o Hermes.';

  @override
  String get ng_make_sure_the_proxy_allows_websocket =>
      'Certifique-se de que o proxy permite a atualização para WebSocket em /api/ws.';

  @override
  String get ng_offline => 'Offline';

  @override
  String get ng_connecting => 'A ligar…';

  @override
  String get ng_connected => 'Ligado';

  @override
  String get ng_reconnecting => 'A restabelecer ligação…';

  @override
  String get ng_signed_out => 'Sessão terminada';

  @override
  String get ng_connection_failed => 'Falha na ligação';

  @override
  String get ng_rate_limited_by_gateway =>
      'Limite de pedidos imposto pelo gateway';

  @override
  String ng_couldn_t_open_the_chat_connection(Object message) {
    return 'Não foi possível abrir a ligação de chat: $message';
  }

  @override
  String get ng_the_gateway_returned_no_websocket_ticket =>
      'O gateway não devolveu um ticket WebSocket.';

  @override
  String get ng_connection_lost => 'Ligação perdida';

  @override
  String get ng_this_dashboard_has_no_chat_endpoint_2 =>
      'Este painel não tem um endpoint de chat (/api/ws). Atualize o Hermes.';

  @override
  String get ng_the_gateway_refused_the_chat_connection_2 =>
      'O gateway recusou a ligação de chat. Verifique se o endereço corresponde ao anfitrião configurado no painel e se o chat incorporado está ativado.';

  @override
  String ng_the_gateway_refused(Object method) {
    return 'O gateway recusou $method.';
  }

  @override
  String ng_couldn_t_read_your_saved_gateways(Object error) {
    return 'Não foi possível ler os gateways guardados: $error';
  }

  @override
  String get ng_applies_to_new_chats => 'Aplica-se a novas conversas';

  @override
  String ng_couldn_t_change(Object label, Object error) {
    return 'Não foi possível alterar $label: $error';
  }

  @override
  String get ng_capabilities => 'Capacidades';

  @override
  String get ng_skills => 'Competências';

  @override
  String get ng_toolsets => 'Conjuntos de ferramentas';

  @override
  String get ng_search => 'Pesquisar';

  @override
  String get ng_couldn_t_load => 'Não foi possível carregar';

  @override
  String get ng_try_again => 'Tentar novamente';

  @override
  String get ng_no_skills => 'Sem competências';

  @override
  String get ng_no_toolsets => 'Sem conjuntos de ferramentas';

  @override
  String get ng_no_mcp_servers => 'Sem servidores MCP';

  @override
  String get ng_that_file_is_too_large_to =>
      'Esse ficheiro é demasiado grande para ser um certificado.';

  @override
  String ng_the_certificate_couldn_t_be_imported(Object error) {
    return 'Não foi possível importar o certificado: $error';
  }

  @override
  String get ng_now_pick_its_private_key =>
      'Selecione agora a respetiva chave privada.';

  @override
  String get ng_now_pick_its_certificate =>
      'Selecione agora o respetivo certificado.';

  @override
  String get ng_that_file_isn_t_a_certificate =>
      'Esse ficheiro não é um certificado nem uma chave privada.';

  @override
  String get ng_if_a_proxy_in_front_of =>
      'Se um proxy à frente deste endereço pedir um certificado de cliente, selecione-o aqui para que o teste, o início de sessão e o chat o apresentem.';

  @override
  String get ng_client_certificates_are_only_used_with =>
      'Os certificados de cliente só são utilizados com endereços https://.';

  @override
  String get ng_remove => 'Remover';

  @override
  String get ng_certificate_password => 'Palavra-passe do certificado';

  @override
  String get ng_importing => 'A importar…';

  @override
  String get ng_pick_certificate => 'Selecionar certificado';

  @override
  String get ng_pick_a_different_certificate => 'Selecionar outro certificado';

  @override
  String get ng_accepts_p12_pfx_or_pem_certificate =>
      'Aceita ficheiros .p12/.pfx ou ficheiros PEM de certificado e chave. A chave fica no armazenamento privado desta aplicação.';

  @override
  String get ng_photos => 'Fotografias';

  @override
  String get ng_camera => 'Câmara';

  @override
  String get ng_files => 'Ficheiros';

  @override
  String ng_you_can_attach_up_to_files(Object count) {
    return 'Pode anexar até $count ficheiros.';
  }

  @override
  String ng_couldn_t_read(Object name) {
    return 'Não foi possível ler $name.';
  }

  @override
  String ng_couldn_t_prepare_that_file(Object error) {
    return 'Não foi possível preparar esse ficheiro: $error';
  }

  @override
  String get ng_hermes_is_still_working => 'O Hermes ainda está a trabalhar';

  @override
  String get ng_steer => 'Orientar';

  @override
  String get ng_adds_this_to_the_running_turn =>
      'Adiciona isto ao turno em curso no passo seguinte';

  @override
  String get ng_queue => 'Fila';

  @override
  String get ng_sends_it_when_the_turn_finishes =>
      'Envia quando o turno terminar';

  @override
  String get ng_stop_and_send => 'Parar e enviar';

  @override
  String get ng_stops_the_turn_then_sends_this =>
      'Para o turno e depois envia isto';

  @override
  String ng_dictation_stopped(Object message) {
    return 'Ditado parado: $message';
  }

  @override
  String get ng_speech_recognition_isn_t_available =>
      'O reconhecimento de voz não está disponível.';

  @override
  String get ng_working => 'A trabalhar';

  @override
  String get ng_ready => 'Pronto';

  @override
  String get ng_chats => 'Conversas';

  @override
  String get ng_new_chat => 'Nova conversa';

  @override
  String get ng_usage => 'Utilização';

  @override
  String get ng_rename_chat => 'Mudar o nome da conversa';

  @override
  String ng_couldn_t_rename(Object error) {
    return 'Não foi possível mudar o nome: $error';
  }

  @override
  String get ng_this_chat => 'Esta conversa';

  @override
  String get ng_input_tokens => 'Tokens de entrada';

  @override
  String get ng_output_tokens => 'Tokens de saída';

  @override
  String get ng_reasoning_tokens => 'Tokens de raciocínio';

  @override
  String get ng_cache_reads => 'Leituras da cache';

  @override
  String get ng_api_calls => 'Chamadas à API';

  @override
  String get ng_cost => 'Custo';

  @override
  String get ng_context => 'Contexto';

  @override
  String get ng_your_sign_in_expired => 'A sua sessão expirou.';

  @override
  String get ng_sign_in_2 => 'Iniciar sessão';

  @override
  String get ng_retry => 'Tentar novamente';

  @override
  String get ng_project_home => 'Início';

  @override
  String get ng_choose_project => 'Escolher um projeto';

  @override
  String ng_project_cwd_fallback(String path) {
    return 'A pasta do projeto não estava disponível, por isso esta conversa é executada em $path.';
  }

  @override
  String get ng_project_create_uncertain =>
      'O gateway pode ter criado esta conversa, mas não a confirmou. Verifique as conversas antes de iniciar outra; este pedido não será repetido automaticamente.';

  @override
  String get ng_what_should_we_work_on => 'Em que vamos trabalhar?';

  @override
  String get ng_ask_hermes_anything_it_can_run =>
      'Pergunte o que quiser ao Hermes. Pode usar ferramentas, navegar na Web e trabalhar nos seus ficheiros no servidor.';

  @override
  String ng_working_2(Object frame) {
    return 'A trabalhar · $frame';
  }

  @override
  String get ng_default_model => 'Modelo predefinido';

  @override
  String get ng_listening => 'A ouvir…';

  @override
  String get ng_steer_or_queue_a_message =>
      'Oriente ou ponha uma mensagem na fila';

  @override
  String get ng_message_hermes => 'Enviar mensagem ao Hermes';

  @override
  String get ng_attach => 'Anexar';

  @override
  String get ng_stop_dictation => 'Parar ditado';

  @override
  String get ng_dictate => 'Ditado';

  @override
  String get ng_stop => 'Parar';

  @override
  String get ng_send => 'Enviar';

  @override
  String ng_slash_command_alias(String alias, String command) {
    return '$alias é um alias de $command';
  }

  @override
  String get ng_slash_command_no_description => 'Sem descrição disponível.';

  @override
  String get ng_slash_command_arguments_options =>
      'Aceita uma opção de uma lista fixa.';

  @override
  String get ng_slash_command_arguments_text =>
      'Aceita texto depois do comando.';

  @override
  String get ng_slash_command_arguments_mixed =>
      'Aceita uma opção ou texto depois do comando.';

  @override
  String get ng_slash_command_sent_as_message =>
      'O NextGen envia isto ao Hermes como uma mensagem normal; o comando em si não é executado.';

  @override
  String get ng_slash_command_output => 'Saída do comando';

  @override
  String get ng_slash_command_running => 'A executar o comando…';

  @override
  String get ng_slash_command_done => 'Concluído.';

  @override
  String ng_slash_command_failed(Object error) {
    return 'Não foi possível executar o comando: $error';
  }

  @override
  String get ng_slash_command_refused =>
      'O Hermes não consegue executar este comando aqui.';

  @override
  String get ng_slash_command_delivery_unknown =>
      'O comando foi enviado, mas não chegou resposta. Pode ainda estar a ser executado no gateway, por isso não foi enviado de novo e o rascunho foi mantido.';

  @override
  String get ng_slash_command_nothing_running => 'Nada está em execução.';

  @override
  String get ng_steered => 'Orientado';

  @override
  String get ng_copied => 'Copiado';

  @override
  String ng_not_sent(Object reason) {
    return 'Não enviado: $reason';
  }

  @override
  String get ng_thinking => 'A pensar…';

  @override
  String get ng_thought => 'Pensamento';

  @override
  String ng_used(Object name) {
    return 'Usou $name';
  }

  @override
  String ng_used_tools(Object count) {
    return 'Usou $count ferramentas';
  }

  @override
  String get ng_copy => 'Copiar';

  @override
  String get ng_read_aloud => 'Ler em voz alta';

  @override
  String get ng_the_gateway_connection_dropped_try_again =>
      'A ligação ao gateway foi interrompida. Tente novamente.';

  @override
  String get ng_allow_once => 'Permitir uma vez';

  @override
  String get ng_allow_until_sandbox_off => 'Até a sandbox ser desativada';

  @override
  String get ng_folder_access => 'Acesso à pasta';

  @override
  String get ng_folder_access_unspecified =>
      'O gateway não indicou se é só de leitura ou de leitura e escrita.';

  @override
  String get ng_folder_read_only => 'Só de leitura';

  @override
  String get ng_folder_read_write => 'Leitura e escrita';

  @override
  String get ng_website_access => 'Acesso ao site';

  @override
  String get ng_allow_for_this_chat => 'Permitir nesta conversa';

  @override
  String get ng_always_allow => 'Permitir sempre';

  @override
  String get ng_deny => 'Recusar';

  @override
  String get ng_your_answer => 'A sua resposta';

  @override
  String get ng_or_type_an_answer => 'Ou escreva uma resposta';

  @override
  String get ng_skip => 'Ignorar';

  @override
  String get ng_answer => 'Responder';

  @override
  String get ng_cancel => 'Cancelar';

  @override
  String get ng_username_or_email => 'Nome de utilizador ou e-mail';

  @override
  String get ng_password => 'Palavra-passe';

  @override
  String get ng_not_now => 'Agora não';

  @override
  String get ng_save => 'Guardar';

  @override
  String get ng_enter_both_the_client_id_and =>
      'Introduza o ID de cliente e o segredo de cliente, ou nenhum dos dois.';

  @override
  String get ng_enter_your_username_and_password =>
      'Introduza o seu nome de utilizador e a palavra-passe.';

  @override
  String ng_couldn_t_save_the_sign_in(Object error) {
    return 'Não foi possível guardar os dados de início de sessão: $error';
  }

  @override
  String get ng_wrong_username_or_password =>
      'Nome de utilizador ou palavra-passe incorretos.';

  @override
  String get ng_too_many_attempts_wait_a_moment =>
      'Demasiadas tentativas. Aguarde um momento e tente novamente.';

  @override
  String get ng_welcome_to_hermes => 'Bem-vindo ao Ares';

  @override
  String get ng_add_a_gateway => 'Adicionar um gateway';

  @override
  String get ng_connect_to_your_hermes_agent_dashboard =>
      'Ligue-se ao painel do Hermes Agent. Um endereço e uma sessão dão-lhe acesso às suas conversas, ferramentas e definições. Nada é enviado até iniciar sessão.';

  @override
  String get ng_connect_to_another_hermes_agent_dashboard =>
      'Ligue-se a outro painel do Hermes Agent. Continua com a sessão iniciada nos painéis que guardou.';

  @override
  String get ng_dashboard_address => 'Endereço do painel';

  @override
  String get ng_testing => 'A testar…';

  @override
  String get ng_test => 'Testar';

  @override
  String get ng_where_your_hermes_dashboard_runs_lan =>
      'Onde está alojado o seu painel do Hermes: na rede local, através de Tailscale ou por HTTPS.';

  @override
  String get ng_find_on_my_network => 'Procurar na minha rede';

  @override
  String get ng_which_address_do_i_use => 'Que endereço devo usar?';

  @override
  String get ng_behind_cloudflare_access => 'Protegido pelo Cloudflare Access?';

  @override
  String get ng_need_a_client_certificate =>
      'Precisa de um certificado de cliente?';

  @override
  String get ng_this_address_isn_t_private_and =>
      'Este endereço não é privado e não usa https://, por isso a sua palavra-passe e as suas conversas seriam transmitidas pela Internet sem encriptação. Use https://, Tailscale ou a sua própria rede.';

  @override
  String get ng_continue_to_sign_in => 'Continuar para iniciar sessão';

  @override
  String get ng_use_the_classic_interface_instead =>
      'Usar a interface clássica';

  @override
  String get ng_if_cloudflare_access_protects_this_address =>
      'Se o Cloudflare Access proteger este endereço, crie um token de serviço no Cloudflare Zero Trust (Access, Service credentials) e adicione uma política Service Auth à aplicação Access.';

  @override
  String get ng_a_service_token_is_saved_for =>
      'Está guardado um token de serviço para este endereço';

  @override
  String get ng_forget => 'Esquecer';

  @override
  String get ng_client_id => 'ID de cliente';

  @override
  String get ng_client_secret => 'Segredo de cliente';

  @override
  String get ng_stored_encrypted_on_this_phone_and =>
      'Guardado de forma encriptada neste telemóvel e enviado apenas para este endereço.';

  @override
  String get ng_hermes_is_reachable => 'O Hermes está acessível';

  @override
  String ng_hermes_is_reachable_2(Object version) {
    return 'O Hermes $version está acessível';
  }

  @override
  String get ng_sign_in_is_tested_next_then =>
      'A seguir, testa-se o início de sessão e depois o chat';

  @override
  String get ng_agent_gateway => 'Gateway do agente';

  @override
  String get ng_running => 'Em execução';

  @override
  String get ng_stopped => 'Parado';

  @override
  String get ng_username_password => 'Nome de utilizador e palavra-passe';

  @override
  String get ng_browser => 'Browser';

  @override
  String get ng_in_the_browser_sso => 'No browser (SSO)';

  @override
  String get ng_profiles => 'Perfis';

  @override
  String get ng_this_dashboard_offers_neither_a_username =>
      'Este dashboard não disponibiliza um fornecedor de nome de utilizador e palavra-passe nem início de sessão pelo browser. Atualize o Hermes ou configure o fornecedor de nome de utilizador e palavra-passe no servidor.';

  @override
  String get ng_the_auth_gate_is_off_on =>
      'A autenticação está desativada neste dashboard. Qualquer pessoa que consiga aceder-lhe pode usar o seu agente.';

  @override
  String get ng_couldn_t_reach_the_dashboard =>
      'Não foi possível aceder ao dashboard';

  @override
  String ng_check_the_address_and_port_9119(Object reason) {
    return '$reason\n\nVerifique o endereço e a porta (9119 por predefinição). Se o dashboard ainda não estiver em execução, execute este comando no servidor:\nhermes dashboard --host 0.0.0.0';
  }

  @override
  String get ng_that_isn_t_a_hermes_dashboard =>
      'Isto não é um dashboard Hermes';

  @override
  String get ng_something_answered_but_not_a_hermes_2 =>
      'Houve uma resposta, mas não de um dashboard Hermes. Use o endereço do dashboard, não o do servidor da API (porta 8642).';

  @override
  String ng_something_answered_http_but_not_a_2(Object status) {
    return 'Houve uma resposta (HTTP $status), mas não de um dashboard Hermes. Use o endereço do dashboard, não o do servidor da API (porta 8642).';
  }

  @override
  String get ng_cloudflare_access_stopped_the_request =>
      'O Cloudflare Access bloqueou o pedido';

  @override
  String ng_cloudflare_access_turned_down_the_service(Object status) {
    return 'O Cloudflare Access rejeitou o token de serviço (HTTP $status). Verifique o Client ID, o Secret e a política Service Auth.';
  }

  @override
  String get ng_add_a_cloudflare_access_service_token_2 =>
      'Adicione abaixo um token de serviço do Cloudflare Access e teste novamente.';

  @override
  String get ng_a_client_certificate_is_needed =>
      'É necessário um certificado de cliente';

  @override
  String get ng_this_server_asks_for_a_client =>
      'Este servidor pede um certificado de cliente antes de comunicar. Selecione abaixo o certificado que lhe foi fornecido e teste novamente.';

  @override
  String get ng_this_dashboard_doesn_t_ask_for =>
      'Este dashboard não pede início de sessão.';

  @override
  String ng_use_the_dashboard_username_and_password(Object address) {
    return 'Use o nome de utilizador e a palavra-passe do dashboard configurados em $address, ou inicie sessão no browser.';
  }

  @override
  String ng_use_the_dashboard_username_and_password_2(Object address) {
    return 'Use o nome de utilizador e a palavra-passe do dashboard configurados em $address.';
  }

  @override
  String ng_sign_in_to_in_your_browser(Object address) {
    return 'Inicie sessão em $address no browser, com a conta usada pelo dashboard.';
  }

  @override
  String ng_gateway(Object address) {
    return 'Gateway $address';
  }

  @override
  String get ng_profile => 'Perfil';

  @override
  String get ng_server_default => 'Predefinição do servidor';

  @override
  String get ng_continue => 'Continuar';

  @override
  String get ng_username => 'Nome de utilizador';

  @override
  String get ng_signing_in => 'A iniciar sessão…';

  @override
  String get ng_waiting_for_the_browser => 'À espera do browser…';

  @override
  String get ng_sign_in_with_browser => 'Iniciar sessão com o browser';

  @override
  String get ng_finish_signing_in_on_the_page =>
      'Conclua o início de sessão na página que abriu. O Hermes regressa automaticamente quando terminar.';

  @override
  String get ng_use_a_different_gateway => 'Usar outro gateway';

  @override
  String get ng_same_wi_fi_or_local_network => 'Mesma rede Wi-Fi ou rede local';

  @override
  String get ng_use_the_server_s_local_address =>
      'Use o endereço local e a porta do servidor, por exemplo, 192.168.1.20:9119. Inicie o dashboard com --host 0.0.0.0 para que outros dispositivos lhe possam aceder.';

  @override
  String get ng_tailscale => 'Tailscale';

  @override
  String get ng_turn_on_tailscale_on_this_phone =>
      'Ative o Tailscale neste telemóvel e use o endereço Tailscale do servidor, por exemplo, 100.64.0.1:9119 ou o respetivo nome .ts.net. Também funciona fora de casa.';

  @override
  String get ng_use_your_https_address_when_the =>
      'Use o endereço https:// quando o dashboard estiver atrás de um proxy com certificado. O proxy também tem de permitir atualizações WebSocket em /api/ws.';

  @override
  String get ng_start_the_dashboard_on_the_server =>
      'Inicie o dashboard no servidor:';

  @override
  String get ng_enter_a_port_from_1_to =>
      'Introduza uma porta entre 1 e 65535.';

  @override
  String get ng_looks_for_hermes_dashboards_on_port =>
      'Procura dashboards Hermes na porta 9119 nesta rede Wi-Fi e verifica os computadores que já guardou.';

  @override
  String ng_looks_for_hermes_dashboards_on_ports(Object port) {
    return 'Procura dashboards Hermes nas portas 9119 e $port nesta rede Wi-Fi e verifica os computadores que já guardou.';
  }

  @override
  String get ng_other_port_optional => 'Outra porta (opcional)';

  @override
  String get ng_no_dashboards_answered_start_one_with =>
      'Nenhum dashboard respondeu. Inicie um com hermes dashboard --host 0.0.0.0 ou introduza o respetivo endereço.';

  @override
  String get ng_using_tailscale_or_a_vpn_those =>
      'Está a usar o Tailscale ou uma VPN? Não é possível procurar nessas redes. Introduza o endereço 100.x do computador ou o respetivo nome .ts.net.';

  @override
  String get ng_search_again => 'Pesquisar novamente';

  @override
  String get ng_insights => 'Informações';

  @override
  String get ng_couldn_t_load_insights =>
      'Não foi possível carregar as informações';

  @override
  String get ng_sessions => 'Sessões';

  @override
  String get ng_tokens => 'Tokens';

  @override
  String get ng_est_cost => 'Custo estimado';

  @override
  String get ng_daily_tokens => 'Tokens diários';

  @override
  String get ng_models => 'Modelos';

  @override
  String get ng_tools => 'Ferramentas';

  @override
  String get ng_hermes_is_waiting_for_you => 'O Hermes está à sua espera.';

  @override
  String get ng_hermes_replied => 'O Hermes respondeu';

  @override
  String get ng_the_turn_finished => 'A resposta terminou.';

  @override
  String get ng_off => 'Desativado';

  @override
  String get ng_minimal => 'Mínimo';

  @override
  String get ng_low => 'Baixo';

  @override
  String get ng_medium => 'Médio';

  @override
  String get ng_high => 'Alto';

  @override
  String get ng_extra_high => 'Muito alto';

  @override
  String get ng_max => 'Máximo';

  @override
  String get ng_ultra => 'Ultra';

  @override
  String get ng_default => 'Predefinição';

  @override
  String ng_couldn_t_switch_model(Object error) {
    return 'Não foi possível mudar de modelo: $error';
  }

  @override
  String get ng_model => 'Modelo';

  @override
  String get ng_thinking_2 => 'A pensar';

  @override
  String get ng_search_models => 'Pesquisar modelos';

  @override
  String get ng_no_models_match => 'Nenhum modelo corresponde a estes filtros.';

  @override
  String get privacy_policy => 'Política de privacidade';

  @override
  String get report_ai_output => 'Relatar resposta de IA';

  @override
  String ng_couldn_t_load_models(Object error) {
    return 'Não foi possível carregar os modelos: $error';
  }

  @override
  String get ng_no_providers_are_set_up_on =>
      'Ainda não há fornecedores configurados neste gateway.';

  @override
  String get ng_starred => 'Favoritos';

  @override
  String get ng_recent => 'Recentes';

  @override
  String get ng_more => 'Mais';

  @override
  String get ng_archived_chats => 'Conversas arquivadas';

  @override
  String get ng_projects => 'Projetos';

  @override
  String get ng_chats_grouped_by_project_and_workspace =>
      'Conversas agrupadas por projeto e espaço de trabalho';

  @override
  String get ng_agent => 'Agente';

  @override
  String get ng_memory => 'Memória';

  @override
  String get ng_what_hermes_remembers_about_you =>
      'O que o Hermes se lembra sobre si';

  @override
  String get ng_skills_library => 'Biblioteca de competências';

  @override
  String get ng_browse_and_read_installed_skills =>
      'Explore e leia as competências instaladas';

  @override
  String get ng_cron_editor => 'Editor de cron';

  @override
  String get ng_edit_schedules_prompts_and_delivery =>
      'Edite horários, instruções e entrega';

  @override
  String get ng_config_file => 'Ficheiro de configuração';

  @override
  String get ng_edit_config_yaml_on_the_gateway =>
      'Edite config.yaml no gateway';

  @override
  String get ng_models_and_providers => 'Modelos e fornecedores';

  @override
  String get ng_model_management => 'Gestão de modelos';

  @override
  String get ng_default_fallback_and_auxiliary_models =>
      'Modelos predefinidos, alternativos e auxiliares';

  @override
  String get ng_provider_sign_in => 'Início de sessão do fornecedor';

  @override
  String get ng_connect_provider_accounts_with_oauth =>
      'Ligue contas de fornecedores com OAuth';

  @override
  String get ng_nous_portal => 'Nous Portal';

  @override
  String get ng_subscription_credits_and_usage =>
      'Subscrição, créditos e utilização';

  @override
  String get ng_interface => 'Interface';

  @override
  String get ng_switch_to_the_classic_interface =>
      'Mudar para a interface clássica';

  @override
  String get ng_turns_nextgen_off_you_can_turn =>
      'Desativa o NextGen. Pode voltar a ativá-lo nas Definições.';

  @override
  String get ng_restored => 'Restaurada';

  @override
  String get ng_archived => 'Arquivada';

  @override
  String get ng_couldn_t_load_archived_chats =>
      'Não foi possível carregar as conversas arquivadas';

  @override
  String get ng_nothing_archived => 'Não há conversas arquivadas';

  @override
  String get ng_restore => 'Restaurar';

  @override
  String get ng_saved_new_chats_use_it =>
      'Guardado. As novas conversas vão usá-lo.';

  @override
  String ng_couldn_t_save(Object error) {
    return 'Não foi possível guardar: $error';
  }

  @override
  String get ng_saving => 'A guardar…';

  @override
  String ng_today(Object time) {
    return 'Hoje $time';
  }

  @override
  String get ng_mon => 'seg';

  @override
  String get ng_tue => 'ter';

  @override
  String get ng_wed => 'qua';

  @override
  String get ng_thu => 'qui';

  @override
  String get ng_fri => 'sex';

  @override
  String get ng_sat => 'sáb';

  @override
  String get ng_sun => 'dom';

  @override
  String get ng_scheduled => 'Agendado';

  @override
  String get ng_new_job => 'Novo trabalho';

  @override
  String get ng_couldn_t_load_scheduled_jobs =>
      'Não foi possível carregar os trabalhos agendados';

  @override
  String get ng_nothing_scheduled => 'Nada agendado';

  @override
  String get ng_ask_hermes_to_do_something_on =>
      'Peça ao Hermes para fazer algo de forma agendada ou adicione aqui um trabalho.';

  @override
  String get ng_active => 'Ativo';

  @override
  String get ng_paused => 'Em pausa';

  @override
  String ng_next(Object when) {
    return 'A seguir $when';
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
    return 'Trabalho $id';
  }

  @override
  String get ng_delete => 'Eliminar';

  @override
  String get ng_delete_this_job => 'Eliminar este trabalho?';

  @override
  String get ng_it_stops_running_past_runs_stay =>
      'Deixará de ser executado. As execuções anteriores continuam nas conversas.';

  @override
  String ng_next_run(Object when) {
    return 'Próxima execução $when';
  }

  @override
  String ng_delivers_to(Object target) {
    return 'Envia para $target';
  }

  @override
  String get ng_run_now => 'Executar agora';

  @override
  String get ng_started => 'Iniciado';

  @override
  String get ng_pause => 'Pausar';

  @override
  String get ng_resume => 'Retomar';

  @override
  String get ng_resumed => 'Retomado';

  @override
  String get ng_prompt => 'Instrução';

  @override
  String get ng_runs => 'Execuções';

  @override
  String get ng_no_runs_yet => 'Ainda sem execuções.';

  @override
  String get ng_enter_a_schedule_and_a_prompt =>
      'Introduza um agendamento e uma instrução.';

  @override
  String get ng_name_optional => 'Nome (opcional)';

  @override
  String get ng_schedule => 'Agendamento';

  @override
  String get ng_every_1h_0_9_or_30m => 'every 1h, 0 9 * * *, or 30m';

  @override
  String get ng_create => 'Criar';

  @override
  String get ng_unpin => 'Desafixar';

  @override
  String get ng_pin => 'Fixar';

  @override
  String get ng_rename => 'Mudar o nome';

  @override
  String get ng_archive => 'Arquivar';

  @override
  String get ng_delete_this_chat => 'Eliminar esta conversa?';

  @override
  String get ng_it_is_removed_from_the_gateway =>
      'É removida do gateway em todos os dispositivos.';

  @override
  String get ng_search_chats => 'Pesquisar conversas';

  @override
  String get ng_pinned => 'Fixadas';

  @override
  String get ng_no_chats_match => 'Nenhuma conversa corresponde à pesquisa.';

  @override
  String get ng_no_chats_yet => 'Ainda não há conversas.';

  @override
  String get ng_nothing_is_running => 'Nada está em execução.';

  @override
  String get ng_nothing_is_waiting_on_you => 'Nada aguarda a sua atenção.';

  @override
  String get ng_settings => 'Definições';

  @override
  String get ng_all => 'Todas';

  @override
  String ng_needs_you(Object count) {
    return 'Precisa de si · $count';
  }

  @override
  String get ng_needs_you_2 => 'Precisa de si';

  @override
  String get ng_gateways => 'Gateways';

  @override
  String ng_classic_connection(Object address) {
    return '$address · ligação clássica';
  }

  @override
  String get ng_gateway_2 => 'Gateway';

  @override
  String get ng_signed_in => 'Sessão iniciada';

  @override
  String get ng_classic_connection_2 => 'Ligação clássica';

  @override
  String get ng_in_the_browser => 'No navegador';

  @override
  String ng_in_the_browser_as(Object name) {
    return 'No navegador como $name';
  }

  @override
  String get ng_not_required => 'Não necessário';

  @override
  String get ng_test_connection => 'Testar ligação';

  @override
  String get ng_sign_in_again_2 => 'Iniciar sessão novamente';

  @override
  String get ng_sign_out => 'Terminar sessão';

  @override
  String get ng_saved_gateways => 'Gateways guardados';

  @override
  String get ng_in_use => 'Em uso';

  @override
  String get ng_appearance => 'Aspeto';

  @override
  String get ng_theme => 'Tema';

  @override
  String get ng_system => 'Sistema';

  @override
  String get ng_light => 'Claro';

  @override
  String get ng_dark => 'Escuro';

  @override
  String get ng_accent => 'Cor de destaque';

  @override
  String get ng_pure_black => 'Preto puro';

  @override
  String get ng_dark_theme_uses_true_black_oled =>
      'O tema escuro usa preto verdadeiro (OLED)';

  @override
  String get ng_glow => 'Brilho';

  @override
  String get ng_soft_accent_light_behind_each_screen =>
      'Uma luz suave da cor de destaque por trás de cada ecrã';

  @override
  String get ng_the_new_interface_turn_off_to =>
      'A nova interface. Desative para voltar à interface clássica; os gateways e as conversas são partilhados.';

  @override
  String get ng_more_settings => 'Mais definições';

  @override
  String get ng_voice_notifications_language_backups_and_the =>
      'Voz, notificações, idioma, cópias de segurança e configuração do gateway';

  @override
  String get ng_licences => 'Licenças';

  @override
  String ng_sign_out_of(Object name) {
    return 'Terminar sessão de $name?';
  }

  @override
  String get ng_this_gateway_and_its_saved_sign =>
      'Este gateway e os dados de início de sessão guardados serão removidos deste telemóvel, em ambas as interfaces. As suas conversas permanecem no gateway.';

  @override
  String get ng_password_or_browser => 'Palavra-passe ou navegador';

  @override
  String get ng_unsupported => 'Não suportado';

  @override
  String get ng_background_task_finished => 'Tarefa em segundo plano concluída';

  @override
  String get ng_background_process_finished =>
      'Processo em segundo plano concluído';

  @override
  String get ng_system_message => 'Mensagem do sistema';

  @override
  String get ng_summary => 'Resumo';

  @override
  String get classic_interface_only => 'Apenas interface clássica';

  @override
  String get classic_only_settings_hint =>
      'As secções assinaladas como «Apenas interface clássica» alteram o aspeto clássico e o chat, não o NextGen. O NextGen tem as suas próprias opções de aparência nas Definições.';

  @override
  String get attachment_preview_too_large =>
      'Demasiado grande para pré-visualizar aqui. Guardar ou Partilhar transfere-o para o telemóvel (até 1 GB).';

  @override
  String get attachment_over_phone_limit =>
      'Este ficheiro tem mais de 1 GB e excede o limite de transferência. Abra o painel para o transferir.';

  @override
  String attachment_downloading_percent(int percent) {
    return 'A transferir… $percent%';
  }

  @override
  String attachment_downloading_mb(int megabytes) {
    return 'A transferir… $megabytes MB';
  }

  @override
  String ng_attachment_too_large_for_gateway(String name) {
    return '$name tem mais de 12 MB, o tamanho máximo aceite por este gateway. Atualize o Hermes para enviar ficheiros até 100 MB.';
  }

  @override
  String ng_couldn_t_upload(String name) {
    return 'Não foi possível carregar $name.';
  }

  @override
  String ng_uploading_percent(int percent) {
    return 'A carregar… $percent%';
  }

  @override
  String get ng_show_tasks => 'Mostrar tarefas';

  @override
  String get ng_hide_tasks => 'Ocultar tarefas';

  @override
  String get ng_goal => 'Objetivo';

  @override
  String get ng_loop => 'Ciclo';

  @override
  String get ng_heartbeat => 'Pulso';

  @override
  String get ng_goal_working => 'Em curso';

  @override
  String get ng_goal_waiting => 'À espera';

  @override
  String get ng_goal_blocked => 'Bloqueado';

  @override
  String get ng_goal_done => 'Concluído';

  @override
  String ng_goal_turns_of(int used, int max) {
    return '$used de $max turnos';
  }

  @override
  String ng_goal_turn(int used) {
    return 'turno $used';
  }

  @override
  String get ng_loop_held => 'Em espera pelo objetivo';

  @override
  String get ng_loop_finished => 'Concluído';

  @override
  String get ng_loop_running => 'Em execução';

  @override
  String ng_loop_runs_of(int fired, int times) {
    return '$fired de $times execuções';
  }

  @override
  String ng_loop_runs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count execuções',
      one: '1 execução',
    );
    return '$_temp0';
  }

  @override
  String ng_loop_next(String time) {
    return 'seguinte: $time';
  }

  @override
  String get ng_loop_due_now => 'agendado para agora';

  @override
  String ng_every_seconds(int seconds) {
    return 'a cada $seconds s';
  }

  @override
  String ng_every_minutes(int minutes) {
    return 'a cada $minutes min';
  }

  @override
  String ng_every_hours(int hours) {
    return 'a cada $hours h';
  }

  @override
  String ng_every_hours_minutes(int hours, int minutes) {
    return 'a cada $hours h $minutes min';
  }

  @override
  String ng_heartbeat_fired(int count) {
    return '$count ativações';
  }

  @override
  String ng_heartbeat_last_fired(String time) {
    return 'Última ativação: $time';
  }

  @override
  String ng_wait_until(String time) {
    return 'À espera até $time';
  }

  @override
  String get ng_wait_resume => 'À espera para retomar';

  @override
  String get ng_wait_other_chat => 'À espera de outra conversa';

  @override
  String ng_wait_process(String pid) {
    return 'À espera do processo $pid';
  }

  @override
  String get ng_control_open => 'Abrir objetivo e automatização';

  @override
  String get ng_control_title => 'Objetivo e automatização';

  @override
  String get ng_control_subtitle =>
      'O que esta conversa pretende alcançar e o que é executado automaticamente.';

  @override
  String get ng_contract_outcome => 'Resultado';

  @override
  String get ng_contract_verification => 'Verificação';

  @override
  String get ng_contract_constraints => 'Restrições';

  @override
  String get ng_contract_boundaries => 'Limites';

  @override
  String get ng_contract_stop_when => 'Parar quando';

  @override
  String get ng_subgoals => 'Subobjetivos';

  @override
  String get ng_subgoal_add_placeholder => 'Adicionar um subobjetivo';

  @override
  String get ng_add => 'Adicionar';

  @override
  String get ng_subgoal_remove => 'Remover subobjetivo';

  @override
  String get ng_goal_checks => 'Verificações';

  @override
  String get ng_gate_not_run => 'Ainda não executado';

  @override
  String ng_gate_attempts(int attempts, int tries) {
    return '$attempts de $tries tentativas';
  }

  @override
  String ng_gate_exit(int code) {
    return 'código de saída $code';
  }

  @override
  String get ng_resume_now => 'Retomar agora';

  @override
  String get ng_goal_clear => 'Limpar objetivo';

  @override
  String get ng_goal_clear_title => 'Limpar este objetivo?';

  @override
  String get ng_goal_clear_message =>
      'O agente deixará de trabalhar para o alcançar. Os subobjetivos e as verificações também serão removidos.';

  @override
  String get ng_subgoal_remove_title => 'Remover este subobjetivo?';

  @override
  String ng_subgoal_remove_message(String text) {
    return '\"$text\" deixará de fazer parte do objetivo.';
  }

  @override
  String get ng_subgoals_clear_title => 'Limpar todos os subobjetivos?';

  @override
  String get ng_subgoals_clear_message =>
      'O objetivo mantém o título, mas ficará sem subobjetivos.';

  @override
  String get ng_clear_all => 'Limpar tudo';

  @override
  String get ng_clear => 'Limpar';

  @override
  String get ng_dismiss => 'Fechar';

  @override
  String get ng_loop_stop_title => 'Parar este ciclo?';

  @override
  String get ng_heartbeat_clear_title => 'Limpar este pulso?';

  @override
  String get ng_wont_fire_again => 'Não será ativado novamente.';

  @override
  String get ng_loop_self_paced => 'Ao seu próprio ritmo';

  @override
  String ng_loop_until(String condition) {
    return 'Até: $condition';
  }

  @override
  String get ng_loop_waits_for_goal =>
      'Aguarda enquanto o objetivo está em curso.';

  @override
  String get ng_loop_awaiting_reply => 'À espera da resposta do agente.';

  @override
  String ng_loop_stopped_reason(String reason) {
    return 'Parado: $reason';
  }

  @override
  String get ng_hide_subagents => 'Ocultar subagentes';

  @override
  String get ng_show_subagents => 'Mostrar subagentes';

  @override
  String get ng_subagent => 'Subagente';

  @override
  String get ng_subagent_queued => 'Na fila';

  @override
  String get ng_subagent_starting => 'A iniciar…';

  @override
  String get ng_subagent_running => 'Em execução';

  @override
  String get ng_subagent_done => 'Concluído';

  @override
  String get ng_subagent_failed => 'Falhou';

  @override
  String get ng_subagent_stopped => 'Parado';

  @override
  String get ng_subagent_stop => 'Parar subagente';

  @override
  String ng_subagent_tools(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ferramentas',
      one: '1 ferramenta',
    );
    return '$_temp0';
  }

  @override
  String get ng_mark_as_read => 'Marcar como lida';

  @override
  String get ng_mark_as_unread => 'Marcar como não lida';

  @override
  String ng_chats_unread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Conversas, $count não lidas',
      one: 'Conversas, 1 não lida',
    );
    return '$_temp0';
  }

  @override
  String get ng_unread_finished => 'Concluído, resposta por ler';

  @override
  String get ng_unread_updates => 'Em execução, atualizações por ler';

  @override
  String get ng_notifications => 'Notificações';

  @override
  String get ng_notifications_hint =>
      'Respostas e pedidos enquanto o Ares está em segundo plano';

  @override
  String get ng_notify_replies => 'Respostas';

  @override
  String get ng_notify_replies_hint =>
      'Quando uma resposta termina ou falha no chat aberto';

  @override
  String get ng_notify_requests => 'Aprovações e perguntas';

  @override
  String get ng_notify_requests_hint =>
      'Um aviso quando o agente aguarda uma resposta sua, com as opções Permitir uma vez e Recusar';

  @override
  String get ng_keep_running =>
      'Manter a ligação ativa enquanto decorre uma resposta';

  @override
  String get ng_keep_running_hint =>
      'Mantém a ligação aberta em segundo plano até a resposta terminar, com uma notificação discreta';

  @override
  String get ng_battery_settings => 'Otimização da bateria';

  @override
  String get ng_battery_settings_hint =>
      'Permita que o Ares funcione em segundo plano para receber notificações atempadamente';

  @override
  String get ng_send_test_notification => 'Enviar uma notificação de teste';

  @override
  String get ng_test_notification_title =>
      'As notificações do Ares estão a funcionar';

  @override
  String get ng_test_notification_body =>
      'As respostas e os pedidos serão apresentados desta forma.';

  @override
  String get ng_test_notification_sent => 'Notificação de teste enviada';

  @override
  String get ng_notifications_blocked =>
      'As notificações estão bloqueadas. Ative-as nas definições do Android.';

  @override
  String get ng_notifications_off_hint =>
      'As notificações estão desativadas, por isso não será apresentada nenhuma enquanto o Ares estiver em segundo plano.';

  @override
  String get ng_insights_building =>
      'A criar o relatório. Na primeira vez, um período longo pode demorar até um minuto.';

  @override
  String get ng_insights_timed_out =>
      'O gateway demorou demasiado tempo a criar este relatório. Tente novamente ou selecione um período mais curto.';

  @override
  String get ng_dock_goal_active => 'Objetivo ativo';

  @override
  String get ng_dock_goal_paused => 'Objetivo em pausa';

  @override
  String get ng_dock_goal_waiting => 'Objetivo a aguardar';

  @override
  String get ng_dock_goal_blocked => 'Objetivo bloqueado';

  @override
  String get ng_dock_goal_done => 'Objetivo concluído';

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
    return '$count concluídos';
  }

  @override
  String ng_dock_tasks(int done, int total) {
    return 'Tarefas $done/$total';
  }

  @override
  String ng_dock_previous_tasks(int done, int total) {
    return 'Tarefas anteriores $done/$total';
  }

  @override
  String get ng_dock_manage => 'Gerir';

  @override
  String get ng_recent_notifications => 'Notificações recentes';

  @override
  String get ng_recent_notifications_hint =>
      'O que o Ares tentou publicar e se o Android apresentou a notificação';

  @override
  String get ng_recent_notifications_empty =>
      'Ainda não há nada. As tentativas aparecem aqui quando uma resposta, pergunta ou falha geraria uma notificação.';

  @override
  String get ng_notify_permission_granted => 'Permissão concedida';

  @override
  String get ng_notify_permission_denied => 'Permissão negada';

  @override
  String get ng_notify_master_on => 'Notificações ativadas';

  @override
  String get ng_notify_master_off => 'Notificações desativadas';

  @override
  String get ng_models_default => 'Modelo predefinido';

  @override
  String get ng_models_change => 'Alterar';

  @override
  String get ng_models_custom_endpoint =>
      'Usa um endpoint personalizado. Altere-o no gateway.';

  @override
  String get ng_models_context_window => 'Janela de contexto';

  @override
  String ng_models_token_count(String count) {
    return '$count tokens';
  }

  @override
  String ng_models_context_override(String count) {
    return 'Definido no gateway. Detetado automaticamente: $count tokens.';
  }

  @override
  String get ng_models_max_output => 'Saída máxima';

  @override
  String get ng_models_input_price => 'Preço de entrada';

  @override
  String get ng_models_output_price => 'Preço de saída';

  @override
  String get ng_models_cache_price => 'Preço de entrada em cache';

  @override
  String ng_models_per_million(String price) {
    return '$price por 1 M de tokens';
  }

  @override
  String ng_models_price_pair(String input, String output) {
    return '$input entrada · $output saída por 1 M de tokens';
  }

  @override
  String get ng_models_free => 'Gratuito';

  @override
  String get ng_models_vision => 'Visão';

  @override
  String get ng_models_reasoning => 'Raciocínio';

  @override
  String get ng_models_fast => 'Modo rápido';

  @override
  String get ng_models_in_use => 'Em uso';

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
  String get ng_models_rate_limited => 'Limite atingido';

  @override
  String get ng_models_plan_locked => 'Não incluído no seu plano';

  @override
  String get ng_models_unsaved => 'Alterações por guardar';

  @override
  String get ng_models_discard => 'Rejeitar';

  @override
  String get ng_models_aux_hint =>
      'As tarefas auxiliares usam o modelo predefinido, a menos que lhes atribua um próprio.';

  @override
  String get ng_models_uses_default => 'Usa o modelo predefinido';

  @override
  String get ng_models_thinking_level => 'Nível de raciocínio';

  @override
  String get ng_models_providers => 'Fornecedores';

  @override
  String get ng_models_saved => 'Guardado';

  @override
  String get ng_aux_vision => 'Visão';

  @override
  String get ng_aux_vision_hint => 'Lê imagens e capturas de ecrã';

  @override
  String get ng_aux_compression => 'Compressão';

  @override
  String get ng_aux_compression_hint =>
      'Resume uma conversa longa para caber na janela de contexto';

  @override
  String get ng_aux_approval => 'Aprovação';

  @override
  String get ng_aux_approval_hint =>
      'Decide se um comando pode ser executado sem perguntar';

  @override
  String get ng_aux_mcp => 'MCP';

  @override
  String get ng_aux_mcp_hint => 'Escolhe as ferramentas MCP a usar';

  @override
  String get ng_aux_title_generation => 'Títulos das conversas';

  @override
  String get ng_aux_title_generation_hint => 'Dá nome às novas conversas';

  @override
  String get ng_aux_review => 'Revisão';

  @override
  String get ng_aux_review_hint => 'Revê o trabalho quando executa /review';

  @override
  String get ng_aux_voice_chat => 'Conversa por voz';

  @override
  String get ng_aux_voice_chat_hint => 'Responde no modo de voz';

  @override
  String get ng_aux_triage_specifier => 'Triagem';

  @override
  String get ng_aux_triage_specifier_hint =>
      'Transforma um cartão Kanban de uma linha numa especificação';

  @override
  String get ng_aux_kanban_decomposer => 'Decomposição Kanban';

  @override
  String get ng_aux_kanban_decomposer_hint =>
      'Divide um cartão Kanban em tarefas mais pequenas';

  @override
  String get ng_aux_profile_describer => 'Descrições de perfil';

  @override
  String get ng_aux_profile_describer_hint =>
      'Escreve a descrição curta de cada perfil';

  @override
  String get ng_aux_curator => 'Curador';

  @override
  String get ng_aux_curator_hint => 'Analisa a utilização das competências';

  @override
  String get appearance_save_failed =>
      'Não foi possível guardar esta alteração.';

  @override
  String get appearance_keep_which_theme => 'Que tema pretende manter?';

  @override
  String get appearance_tour_back => 'Anterior';

  @override
  String get appearance_tour_finish => 'Concluir';

  @override
  String get appearance_tour_next => 'Seguinte';

  @override
  String get appearance_tour_close => 'Fechar visita guiada';

  @override
  String get appearance_dismiss_tip => 'Dispensar dica';

  @override
  String get appearance_search_settings => 'Pesquisar definições';

  @override
  String get appearance_search_show => 'Mostrar';

  @override
  String get appearance_no_matching_setting => 'Nenhuma definição corresponde.';

  @override
  String get appearance_replay_tour => 'Repetir visita guiada';

  @override
  String get appearance_show_tips_again => 'Voltar a mostrar dicas';

  @override
  String get appearance_window_translucency_unavailable =>
      'A translucidez da janela não está disponível neste computador. O Linux não a suporta e os executáveis Apple e Windows desenham uma vista opaca do Flutter.';

  @override
  String get appearance_imported_themes => 'Temas importados';

  @override
  String get appearance_import_theme_file => 'Importar ficheiro de tema';

  @override
  String get appearance_remove_theme => 'Remover tema';

  @override
  String get appearance_chat_font => 'Tipo de letra das conversas';

  @override
  String get appearance_terminal_font => 'Tipo de letra do terminal';

  @override
  String get appearance_font_platform => 'Plataforma';

  @override
  String get appearance_automatic => 'Automático';

  @override
  String get appearance_force_left_to_right =>
      'Forçar da esquerda para a direita';

  @override
  String get appearance_force_right_to_left =>
      'Forçar da direita para a esquerda';

  @override
  String get appearance_user_bubble_opacity =>
      'Opacidade do balão do utilizador';

  @override
  String get appearance_inline_embeds => 'Conteúdo incorporado';

  @override
  String get appearance_inline_embeds_hint =>
      'As pré-visualizações enriquecidas são carregadas de sites de terceiros (YouTube, X, …). Perguntar mostra um marcador de posição até permitir cada uma; Sempre carrega-as automaticamente; Desativado mantém ligações simples.';

  @override
  String get appearance_embeds_ask => 'Perguntar';

  @override
  String get appearance_embeds_always => 'Sempre';

  @override
  String get appearance_embeds_off => 'Desativado';

  @override
  String appearance_embeds_reset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Repor $count serviços permitidos',
      one: 'Repor 1 serviço permitido',
    );
    return '$_temp0';
  }

  @override
  String get appearance_embed_load => 'Carregar';

  @override
  String appearance_embed_always_allow(String service) {
    return 'Permitir sempre $service';
  }

  @override
  String get appearance_embed_loading => 'A carregar pré-visualização…';

  @override
  String appearance_embed_image_failed(String host) {
    return 'Não foi possível carregar a imagem de $host. Toque para a abrir.';
  }

  @override
  String get appearance_embed_preview_unavailable =>
      'Pré-visualização indisponível';

  @override
  String get appearance_emoji_reactions => 'Reações com emojis';

  @override
  String get appearance_celebration_hearts => 'Corações de celebração';

  @override
  String get appearance_celebration_hearts_hint =>
      'É animado um coração quando chega uma resposta enquanto está ausente.';

  @override
  String get appearance_pop_out_companion => 'Destacar companheiro';

  @override
  String get appearance_mosskip => 'Mosskip';

  @override
  String get appearance_emberbun => 'Emberbun';

  @override
  String get appearance_tideling => 'Tideling';

  @override
  String get appearance_my_hatchling => 'A minha cria';

  @override
  String get appearance_at_rest => 'Em repouso';

  @override
  String get appearance_working => 'A trabalhar';

  @override
  String get appearance_thinking => 'A pensar';

  @override
  String get appearance_waiting_for_you => 'À sua espera';

  @override
  String get appearance_reply_ready => 'Resposta pronta';

  @override
  String get appearance_turn_failed => 'Turno falhado';

  @override
  String get appearance_small => 'Pequeno';

  @override
  String get appearance_medium => 'Médio';

  @override
  String get appearance_large => 'Grande';

  @override
  String get appearance_hello => 'Olá!';

  @override
  String get appearance_unread_reply => 'Resposta por ler';

  @override
  String get appearance_compose => 'Escrever';

  @override
  String get appearance_say_hello => 'Cumprimentar';

  @override
  String get appearance_pet_image_failed =>
      'Não foi possível abrir essa imagem. Escolha um PNG ou JPEG mais pequeno.';

  @override
  String get appearance_pet_companion => 'Animal de companhia';

  @override
  String get appearance_pet_companion_hint =>
      'Mostre um companheiro enquanto conversa.';

  @override
  String get appearance_adopt_a_companion => 'Adotar um companheiro';

  @override
  String get appearance_roam_when_idle => 'Passear quando inativo';

  @override
  String get appearance_pet_size => 'Tamanho do animal';

  @override
  String get appearance_hatch_from_a_local_picture =>
      'Fazer nascer de uma imagem local';

  @override
  String get appearance_pet_image_limits =>
      'Escolha um PNG ou JPEG (até 4 MiB, 4096 px por lado e 8 MP). Pré-visualize primeiro. Ao fazer nascer a cria, é guardado um retrato de 24 × 24 píxeis que substitui a cria anterior.';

  @override
  String get appearance_choose_picture => 'Escolher imagem';

  @override
  String get appearance_hatchling_preview => 'Pré-visualização da cria';

  @override
  String get appearance_hatch_and_adopt => 'Fazer nascer e adotar';

  @override
  String get appearance_discard_draft => 'Descartar rascunho';

  @override
  String get appearance_forget_saved_hatchling => 'Esquecer cria guardada';

  @override
  String get appearance_radio => 'Rádio';

  @override
  String appearance_radio_hint(String stations) {
    return 'As emissões vêm diretamente de $stations e só começam quando prime Reproduzir. A pesquisa de estações fica neste dispositivo.';
  }

  @override
  String get appearance_radio_save_failed =>
      'Não foi possível guardar as definições da rádio.';

  @override
  String get appearance_choose_a_station => 'Escolher uma estação';

  @override
  String get appearance_pause_radio => 'Pausar rádio';

  @override
  String get appearance_play_radio => 'Reproduzir rádio';

  @override
  String get appearance_next_station => 'Estação seguinte';

  @override
  String get appearance_radio_trace_semantics =>
      'Atividade da emissão. Os níveis de áudio estão indisponíveis, pelo que esta linha permanece plana.';

  @override
  String get appearance_radio_is_off => 'A rádio está desligada';

  @override
  String get appearance_paused => 'Em pausa';

  @override
  String get appearance_connecting => 'A ligar…';

  @override
  String get appearance_live => 'Em direto';

  @override
  String get appearance_stream_unavailable => 'Emissão indisponível';

  @override
  String appearance_now_playing(String credit) {
    return 'A reproduzir: $credit';
  }

  @override
  String get appearance_audio_only_waveform_unavailable =>
      'Só áudio · forma de onda indisponível';

  @override
  String get appearance_volume => 'Volume';

  @override
  String get appearance_search_presets => 'Pesquisar estações predefinidas';

  @override
  String get appearance_no_stations_found => 'Não foram encontradas estações';

  @override
  String appearance_unpin_station(String station) {
    return 'Desafixar estação: $station';
  }

  @override
  String appearance_pin_station(String station) {
    return 'Fixar estação: $station';
  }

  @override
  String get appearance_radio_picker_metadata_notice =>
      'Enquanto este seletor estiver aberto, as estações em reprodução podem partilhar detalhes das faixas diretamente a partir da emissora.';

  @override
  String get appearance_message_from_your_companion =>
      'Mensagem do seu companheiro';

  @override
  String get appearance_send_to_the_open_chat =>
      'Enviar para a conversa aberta';

  @override
  String get appearance_tour_theme_body =>
      'Importe um tema de cores do VS Code a partir de um ficheiro neste dispositivo e escolha a variante a manter.';

  @override
  String get appearance_tour_fonts_title => 'Tipos de letra de leitura';

  @override
  String get appearance_tour_fonts_body =>
      'O texto das conversas e o código do terminal usam tipos de letra distintos incluídos no Ares.';

  @override
  String get appearance_tour_direction_title => 'Direção da transcrição';

  @override
  String get appearance_tour_direction_body =>
      'Deixe em automático ou force a transcrição da esquerda para a direita ou da direita para a esquerda.';

  @override
  String get appearance_tour_pet_title => 'Companheiro';

  @override
  String get appearance_tour_pet_body =>
      'O companheiro está desativado até adotar um. A janela destacada inclui um pequeno editor.';

  @override
  String get appearance_tour_radio_body =>
      'A rádio fica desligada até a ativar. É ao premir Reproduzir que se abre uma emissão.';

  @override
  String get appearance_tip_theme =>
      'Os temas importados substituem a paleta integrada até limpar a seleção. Só as cores são mantidas.';

  @override
  String get appearance_tip_pet =>
      'O companheiro guarda um pequeno retrato neste dispositivo. Não envia a imagem usada para fazer nascer a cria.';

  @override
  String get appearance_theme_import_failed =>
      'Não foi possível importar esse tema. Escolha um tema de cores do VS Code guardado como ficheiro .vsix, .json ou .jsonc.';

  @override
  String get render_widget_file_truncated =>
      'Só o início deste ficheiro foi lido, por isso o widget pode estar incompleto.';

  @override
  String get setup_beat_title => 'Configuração';

  @override
  String setup_beat_use_name(String name) {
    return 'Usar $name';
  }

  @override
  String get setup_beat_name_hint => 'Como é que o Hermes deve chamar-lhe?';

  @override
  String get setup_beat_on_computer =>
      'Este passo faz-se no Hermes, no computador onde corre. Continuar mantém o que já está configurado lá.';

  @override
  String get setup_beat_not_waiting =>
      'Este cartão de configuração já não está à espera de resposta.';

  @override
  String get catalog_kind_plugin => 'Plugin';

  @override
  String get catalog_kind_skill => 'Competência';

  @override
  String get catalog_tier_official => 'Oficial';

  @override
  String get catalog_tier_verified => 'Verificado';

  @override
  String get catalog_tier_community => 'Comunidade';

  @override
  String get catalog_install => 'Instalar';

  @override
  String get catalog_waiting => 'À espera da sua escolha';

  @override
  String get catalog_installed => 'Instalado';

  @override
  String get catalog_installed_off => 'Instalado, não ativado';

  @override
  String get catalog_skipped => 'Ignorado';

  @override
  String get catalog_not_installed => 'Não instalado';

  @override
  String catalog_target_profile(String profile) {
    return 'É instalado no perfil $profile';
  }

  @override
  String catalog_source(String repo, String sha) {
    return '$repo em $sha';
  }

  @override
  String catalog_scan(String status, String summary) {
    return 'Análise de segurança: $status. $summary';
  }

  @override
  String catalog_requires_hermes(String range) {
    return 'Requer Hermes $range';
  }

  @override
  String catalog_skill_ready(String name) {
    return 'A competência $name está pronta';
  }

  @override
  String catalog_missing_env(String names) {
    return 'Ainda precisa de: $names';
  }

  @override
  String catalog_server_error(String name, String error) {
    return '$name não ligou: $error';
  }

  @override
  String get catalog_send_failed =>
      'A sua escolha não foi enviada. Tente novamente.';

  @override
  String get attachment_video_speed => 'Velocidade de reprodução';

  @override
  String get catalog_installing => 'A instalar…';

  @override
  String get catalog_phase_downloading => 'A transferir…';

  @override
  String get catalog_phase_python_packages => 'A instalar pacotes Python…';

  @override
  String get catalog_phase_loading_tools => 'A carregar as ferramentas…';

  @override
  String get setup_beat_send_failed =>
      'A sua resposta não foi enviada. Tente novamente.';

  @override
  String catalog_tool_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ferramentas',
      one: '1 ferramenta',
    );
    return '$_temp0';
  }

  @override
  String get render_svg_not_drawn => 'Este SVG não foi desenhado.';

  @override
  String get render_notes_directive => 'Diretiva de notas';

  @override
  String get render_maths_source => 'Fonte da fórmula';

  @override
  String get render_inline_maths_source => 'Fonte da fórmula em linha';

  @override
  String get render_sequence_outline => 'Esquema da sequência';

  @override
  String get render_diagram_outline => 'Esquema do diagrama';

  @override
  String render_revision_of(int index, int count) {
    return 'Revisão $index de $count';
  }

  @override
  String get render_previous_revision => 'Revisão anterior';

  @override
  String get render_next_revision => 'Revisão seguinte';

  @override
  String get render_show_rendered => 'Renderizado';

  @override
  String get render_show_source => 'Código-fonte';

  @override
  String render_copied_file(String name) {
    return '$name copiado';
  }

  @override
  String render_copy_file(String name) {
    return 'Copiar $name';
  }

  @override
  String get render_artifact_too_long =>
      'Este artefacto é demasiado longo para ser mostrado aqui como página.';

  @override
  String get render_active_content_removed =>
      'Os scripts, frames e endereços externos foram removidos.';

  @override
  String render_widget_file(String file) {
    return 'Ficheiro de widget $file';
  }

  @override
  String get render_widget_runs_as_text =>
      'É executado como texto nesta conversa. Os scripts e frames externos são removidos.';

  @override
  String get render_load_widget => 'Carregar widget';

  @override
  String get render_not_html_widget => 'Este ficheiro não é um widget HTML.';

  @override
  String get render_widget_sent => 'Enviado para esta conversa';

  @override
  String get render_widget_not_sent => 'Não enviado para esta conversa';

  @override
  String get render_widget_throttled =>
      'Aguarde um momento antes de enviar novamente';

  @override
  String get render_widget_too_long =>
      'Este pedido é demasiado longo para ser enviado';

  @override
  String get render_widget_no_gesture =>
      'Toque num controlo do widget para enviar';

  @override
  String get render_widget_invalid => 'Não foi possível enviar este pedido';

  @override
  String get render_inspected_image => 'Imagem inspecionada';

  @override
  String get render_contributions => 'Contribuições';

  @override
  String get render_contributions_intro =>
      'Só as contribuições compiladas no Ares podem acrescentar algo a uma resposta. O texto da conversa não pode registar nenhuma, e uma autorização aplica-se apenas a esta ligação.';

  @override
  String render_grant_plugin(String name) {
    return 'Permitir $name';
  }

  @override
  String render_revoke_plugin(String name) {
    return 'Revogar $name';
  }

  @override
  String render_plugin_slots(String directive) {
    return 'cartões de resposta para ::$directive';
  }

  @override
  String get render_plugin_notes => 'Notas';

  @override
  String get catalog_scan_passed => 'aprovado';

  @override
  String get catalog_scan_warnings => 'encontrou avisos';

  @override
  String get catalog_scan_failed => 'falhou';

  @override
  String get deployment_token_label => 'Token de implementação (opcional)';

  @override
  String get deployment_token_helper =>
      'Para tokens de sessão do Hermes Dashboard enviados como X-Hermes-Session-Token. Não é guardado em texto simples nas preferências.';

  @override
  String get deployment_token_hint => 'Token de sessão do painel';

  @override
  String get custom_headers_label => 'Cabeçalhos personalizados (opcional)';

  @override
  String get custom_headers_helper =>
      'Um por linha, p. ex. X-Custom: valor. Os cabeçalhos proibidos são rejeitados.';

  @override
  String get custom_headers_hint => 'p. ex. X-Custom-Header: valor';

  @override
  String get desktop_tray_open => 'Abrir o Ares';

  @override
  String get desktop_tray_new_chat => 'Novo chat';

  @override
  String get desktop_tray_quick_entry => 'Entrada rápida…';

  @override
  String get desktop_tray_pause_notifications => 'Pausar notificações';

  @override
  String get desktop_tray_quit => 'Sair do Ares';

  @override
  String get desktop_integration_title => 'Integração com a área de trabalho';

  @override
  String get desktop_tray_setting =>
      'Mostrar o Ares na bandeja do sistema ou na barra de menus';

  @override
  String get desktop_tray_setting_help =>
      'No ícone, abra o Ares, inicie um chat, abra a entrada rápida, pause as notificações ou saia.';

  @override
  String get desktop_close_to_tray_setting =>
      'Continuar em execução na bandeja ao fechar a janela';

  @override
  String get desktop_tray_unsupported =>
      'Esta área de trabalho não tem uma bandeja do sistema que o Ares possa usar.';

  @override
  String get quick_entry_title => 'Entrada rápida';

  @override
  String get quick_entry_hint => 'Digite um prompt para o Ares…';

  @override
  String get quick_entry_submit => 'Colocar no editor';

  @override
  String get quick_entry_never_sends =>
      'Enter coloca o texto no editor do chat. Nada é enviado até você clicar em Enviar.';

  @override
  String get quick_entry_unavailable =>
      'Não foi possível abrir a entrada rápida. Tente novamente.';

  @override
  String get desktop_hotkey_setting => 'Atalho da entrada rápida';

  @override
  String desktop_hotkey_help(String shortcut) {
    return 'Pressione $shortcut em qualquer lugar para abrir a entrada rápida.';
  }

  @override
  String desktop_hotkey_conflict(String shortcut) {
    return 'Outro app já usa $shortcut. Escolha um atalho diferente.';
  }

  @override
  String get desktop_hotkey_unsupported =>
      'Esta área de trabalho não permite que apps registrem um atalho global (por exemplo, no Wayland).';

  @override
  String get desktop_hotkey_no_modifier => 'Inclua Cmd, Ctrl ou Alt.';

  @override
  String get desktop_hotkey_super_key =>
      'A tecla Windows ou Super é reservada ao sistema.';

  @override
  String get desktop_hotkey_reserved => 'O sistema já usa este atalho.';

  @override
  String desktop_hotkey_in_app(String action) {
    return 'O Ares já usa este atalho para $action.';
  }

  @override
  String get desktop_hotkey_change => 'Alterar';

  @override
  String get desktop_hotkey_reset => 'Usar padrão';

  @override
  String get capture_screen_action => 'Capturar tela';

  @override
  String get capture_screen_help =>
      'Adiciona uma captura de tela à mensagem como rascunho. Nada é enviado até você clicar em Enviar.';

  @override
  String get capture_screen_unavailable =>
      'A captura de tela não está disponível nesta área de trabalho.';

  @override
  String get capture_screen_failed =>
      'Não foi possível capturar a tela. Tente novamente.';

  @override
  String get capture_permission_title => 'Permitir gravação de tela';

  @override
  String get capture_permission_body =>
      'Para capturar uma janela, o Ares precisa da permissão de gravação de tela. Ative o Ares em Ajustes do Sistema > Privacidade e Segurança > Gravação de Tela e tente novamente.';

  @override
  String get capture_open_settings => 'Abrir Ajustes do Sistema';

  @override
  String get keep_awake_title => 'Manter o computador ativo';

  @override
  String get keep_awake_title_mobile => 'Manter o ecrã ligado';

  @override
  String get keep_awake_mode_off => 'Desligado';

  @override
  String get keep_awake_mode_while_working => 'Durante o trabalho';

  @override
  String get keep_awake_mode_always => 'Sempre';

  @override
  String get keep_awake_off_help =>
      'Nunca impedir a suspensão do sistema (predefinição).';

  @override
  String get keep_awake_while_working_help =>
      'Impedir a suspensão por inatividade apenas enquanto um turno do agente estiver em curso.';

  @override
  String get keep_awake_always_help =>
      'Impedir a suspensão por inatividade enquanto o Ares estiver aberto neste dispositivo.';

  @override
  String get keep_awake_off_help_mobile =>
      'Deixar o ecrã desligar-se como habitualmente (predefinição).';

  @override
  String get keep_awake_while_working_help_mobile =>
      'Manter o ecrã ligado enquanto um turno do agente estiver em curso e o Ares estiver aberto.';

  @override
  String get keep_awake_always_help_mobile =>
      'Manter o ecrã ligado enquanto o Ares estiver aberto.';

  @override
  String get ng_token_gateway_has_no_sign_in =>
      'Este gateway não tem início de sessão, por isso não consegue verificar um token de implementação. Ative a autenticação do painel no anfitrião (ou atualize o Hermes) e tente novamente.';

  @override
  String get palette_open => 'Paleta de comandos da app';

  @override
  String get palette_no_matches => 'Nenhuma ação correspondente';

  @override
  String get palette_filter_hint => 'Escreva para filtrar ações…';

  @override
  String get palette_keys_move => '↑↓ para mover';

  @override
  String get palette_keys_run => 'Enter para executar';

  @override
  String get palette_keys_close => 'Esc para fechar';

  @override
  String get palette_search_sessions => 'Pesquisar sessões';

  @override
  String get palette_scheduled_crons => 'Agendadas / Crons';

  @override
  String get palette_capabilities_skills => 'Capacidades e competências';

  @override
  String get palette_insights_usage => 'Estatísticas e utilização';

  @override
  String get palette_more_projects => 'Mais e projetos';

  @override
  String get deeplink_chat_not_found =>
      'Conversa não encontrada na lista. Pode ainda não ter sido carregada.';

  @override
  String get keyboard_shortcuts_title => 'Atalhos de teclado';

  @override
  String get shortcuts_reset_all => 'Repor tudo';

  @override
  String get shortcuts_reset_to_default => 'Repor predefinição';

  @override
  String get shortcut_action_command_palette => 'Paleta de comandos';

  @override
  String get shortcut_action_new_chat => 'Nova conversa';

  @override
  String get shortcut_action_search => 'Pesquisar';

  @override
  String get shortcut_action_settings => 'Definições';

  @override
  String shortcut_action_go_to_tab(int number) {
    return 'Ir para o separador $number';
  }

  @override
  String shortcuts_conflict(String first, String second, String chord) {
    return 'Conflito: \"$first\" e \"$second\" usam ambos $chord. O atalho personalizado mantém a predefinição até alterar um deles.';
  }

  @override
  String shortcuts_editor_title(String action) {
    return 'Atalho: $action';
  }

  @override
  String get shortcuts_editor_help =>
      'Prima uma combinação de teclas ou escolha modificadores e uma tecla abaixo:';

  @override
  String get shortcuts_editor_needs_modifier =>
      'Escolha pelo menos Cmd/Meta, Ctrl ou Alt para não afetar a escrita no campo de mensagem.';

  @override
  String shortcuts_text_editing_warning(String chord) {
    return '$chord é um atalho de edição de texto (copiar, colar, cortar, anular, refazer ou selecionar tudo). Atribuí-lo aqui retira-o aos campos de texto.';
  }

  @override
  String shortcuts_text_editing_in_use(String action, String chord) {
    return '\"$action\" usa $chord, um atalho de edição de texto. Os campos de texto perdem-no enquanto estiver atribuído aqui.';
  }

  @override
  String custom_headers_problem_format(int line) {
    return 'Linha $line: esperado \"Nome: Valor\"';
  }

  @override
  String custom_headers_problem_missing_name(int line) {
    return 'Linha $line: falta o nome do cabeçalho';
  }

  @override
  String custom_headers_problem_invalid_name(int line, String name) {
    return 'Linha $line: nome de cabeçalho inválido \"$name\"';
  }

  @override
  String custom_headers_problem_reserved(int line, String name) {
    return 'Linha $line: \"$name\" está reservado e não pode ser reencaminhado';
  }

  @override
  String custom_headers_problem_empty_value(int line) {
    return 'Linha $line: valor do cabeçalho vazio';
  }

  @override
  String get ng_enter_a_deployment_token =>
      'Introduza um token de sessão de implementação.';

  @override
  String get ng_custom_headers => 'Cabeçalhos personalizados';

  @override
  String get ng_custom_headers_help =>
      'Cabeçalhos HTTP adicionais para este gateway (Nome: Valor, um por linha), enviados nas suas chamadas REST e WebSocket. Ficam no armazenamento seguro de credenciais. Os cabeçalhos de autenticação e hop-by-hop são rejeitados.';

  @override
  String get ng_use_a_deployment_token =>
      'Usar um token de sessão de implementação';

  @override
  String get ng_sign_in_with_deployment_token =>
      'Iniciar sessão com token de implementação';

  @override
  String get ng_signed_in_with_deployment_token =>
      'Sessão iniciada com o token de implementação.';

  @override
  String get auto_speak_replies_title => 'Ler respostas em voz alta';

  @override
  String get auto_speak_replies_subtitle =>
      'Lê cada nova resposta em voz alta ao concluir um turno. Desativado por padrão; o controle de respostas faladas do chat continua valendo.';

  @override
  String get ng_auto_read_replies_title => 'Ler respostas automaticamente';

  @override
  String get ng_auto_read_replies_subtitle =>
      'Lê cada nova resposta em voz alta ao concluir um turno. Desativado por padrão.';

  @override
  String get barge_in_title => 'Interromper a leitura';

  @override
  String get barge_in_subtitle =>
      'Fale por cima de uma resposta para a interromper. O microfone fica ligado enquanto as respostas são lidas em voz alta.';

  @override
  String get barge_in_mic_live =>
      'Microfone ligado: fale para interromper a resposta';

  @override
  String get ng_barge_in_title => 'Interromper a leitura';

  @override
  String get ng_barge_in_subtitle =>
      'Fale por cima de uma resposta para a interromper. O microfone fica ligado enquanto as respostas são lidas em voz alta.';

  @override
  String get ng_barge_in_mic_live =>
      'Microfone ligado: fale para interromper a resposta';

  @override
  String get wake_word_title => 'Palavra de ativação';

  @override
  String get wake_word_subtitle =>
      'Deteção mãos-livres no gateway. Desativada por predefinição; transmite áudio apenas quando a captura no dispositivo está ativa.';

  @override
  String wake_word_listening(String phrase) {
    return 'À escuta da palavra de ativação \"$phrase\"';
  }

  @override
  String wake_word_paused(String phrase) {
    return 'Palavra de ativação \"$phrase\" — em pausa';
  }

  @override
  String wake_word_off(String phrase) {
    return 'Palavra de ativação \"$phrase\" — desligada';
  }

  @override
  String get wake_word_arming => 'A ativar palavra de ativação…';

  @override
  String get wake_word_stop => 'Parar palavra de ativação';

  @override
  String get wake_word_rearm => 'Reativar';

  @override
  String get wake_word_capture_mode => 'Modo de captura';

  @override
  String get wake_word_capture_auto => 'Automático';

  @override
  String get wake_word_capture_client => 'Microfone deste dispositivo';

  @override
  String get wake_word_capture_local => 'Microfone do anfitrião do gateway';

  @override
  String get wake_word_capture_unavailable =>
      'Este gateway não permite que as aplicações alterem o modo de captura. Defina wake_word.capture na configuração do Hermes no anfitrião do gateway.';

  @override
  String get wake_word_input_device => 'Microfone de entrada';

  @override
  String get wake_word_default_device => 'Predefinição do sistema';

  @override
  String get ng_wake_word_title => 'Palavra de ativação';

  @override
  String get ng_wake_word_subtitle =>
      'Deteção mãos-livres no gateway. Desativada por predefinição.';

  @override
  String get voice_engine_title => 'Motor de conversa por voz';

  @override
  String get voice_engine_subtitle =>
      'Escolha como as conversas de voz mãos-livres funcionam neste perfil do gateway.';

  @override
  String get voice_engine_chained =>
      'Encadeado (voz para texto → Hermes → voz)';

  @override
  String get voice_engine_chained_short => 'Encadeado';

  @override
  String get voice_engine_live => 'GPT-Live (voz em tempo real)';

  @override
  String get voice_engine_live_short => 'GPT-Live';

  @override
  String get voice_engine_live_needs_key =>
      'Configure uma chave da API da OpenAI no anfitrião do gateway para ativar o GPT-Live.';

  @override
  String voice_engine_fallback_chained(String reason) {
    return 'GPT-Live indisponível ($reason) — a usar a voz encadeada.';
  }

  @override
  String get voice_live_start => 'Iniciar conversa de voz';

  @override
  String get voice_live_stop => 'Terminar conversa de voz';

  @override
  String get voice_live_mute => 'Desativar microfone';

  @override
  String get voice_live_unmute => 'Ativar microfone';

  @override
  String get voice_live_interrupt => 'Interromper ou responder agora';

  @override
  String get voice_live_listening => 'A ouvir';

  @override
  String get voice_live_speaking => 'A falar';

  @override
  String get voice_live_thinking => 'A pensar';

  @override
  String get voice_live_muted => 'Sem som';

  @override
  String get voice_live_ended_connection_lost =>
      'A sessão de voz em direto perdeu a ligação.';

  @override
  String get voice_live_ended_closed =>
      'A sessão de voz em direto foi encerrada pelo serviço.';

  @override
  String wake_word_other_profile(String profile) {
    return 'Essa palavra de ativação pertence ao perfil «$profile». Abra uma ligação a esse perfil para responder.';
  }

  @override
  String get wake_word_reason_disabled => 'Desligada — toque para ativar';

  @override
  String get wake_word_reason_surface =>
      'Limitada a outra superfície (configuração wake_word.surface)';

  @override
  String get wake_word_reason_owned =>
      'Outra superfície controla a escuta da palavra de ativação';

  @override
  String wake_word_reason_owned_by(String surface) {
    return 'Outra superfície ($surface) controla a escuta da palavra de ativação';
  }

  @override
  String get wake_word_reason_unavailable =>
      'Palavra de ativação indisponível neste gateway';

  @override
  String get wake_word_reason_permission_denied =>
      'Permissão do microfone negada';

  @override
  String get wake_word_reason_permission_required =>
      'Permissão do microfone necessária — toque para ativar';

  @override
  String get voice_live_not_enabled =>
      'O GPT-Live não está ativado para este perfil.';

  @override
  String get voice_live_not_available => 'O GPT-Live não está disponível';

  @override
  String voice_live_start_failed(String error) {
    return 'Não foi possível iniciar o GPT-Live: $error';
  }

  @override
  String voice_direct_stt_timeout(String seconds, String provider) {
    return 'A transcrição excedeu o tempo limite após $seconds s ($provider não respondeu)';
  }

  @override
  String voice_direct_stt_error(String provider, String status) {
    return 'Erro de STT de $provider (HTTP $status)';
  }

  @override
  String voice_direct_tts_failed(String provider) {
    return 'O pedido de TTS a $provider falhou';
  }

  @override
  String voice_direct_tts_error(String provider, String status) {
    return 'Erro de TTS de $provider (HTTP $status)';
  }

  @override
  String ng_wake_status_listening(String phrase) {
    return 'A ouvir (\"$phrase\")';
  }

  @override
  String ng_wake_status_off(String phrase) {
    return 'Desligada (\"$phrase\")';
  }

  @override
  String ng_wire_setting_unavailable(Object setting) {
    return 'Alterar $setting ainda não está disponível no gateway partilhado';
  }

  @override
  String ng_wire_method_unavailable(Object method) {
    return '$method ainda não está disponível no gateway partilhado';
  }

  @override
  String ng_wire_session_options_unsupported(Object options) {
    return 'O gateway canónico não suporta estas opções de sessão explícitas: $options';
  }

  @override
  String get ng_wire_prompt_stale =>
      'O pedido está desatualizado ou indisponível; volte a ligar antes de responder';

  @override
  String get ng_wire_revision_unavailable =>
      'A revisão da sessão não está disponível; reabra a sessão antes de editar os metadados';

  @override
  String get ng_wire_generation_unavailable =>
      'A identidade de execução da sessão não está disponível; volte a ligar antes de usar este comando';

  @override
  String get ng_wire_message_not_saved =>
      'Esta mensagem ainda não foi guardada; aguarde que fique concluída e volte a ramificar a partir dela';

  @override
  String get ng_wire_not_available =>
      'Ainda não disponível no gateway partilhado';

  @override
  String get edit_turn_title => 'Editar este pedido?';

  @override
  String get edit_turn_body =>
      'O pedido será executado novamente a partir daqui. Os turnos seguintes são arquivados.';

  @override
  String get edit_turn_send => 'Enviar';

  @override
  String get restore_turn_title => 'Restaurar para este ponto de restauro?';

  @override
  String get restore_turn_body =>
      'Tudo após este pedido é removido da conversa e o pedido volta a ser executado a partir daqui.';

  @override
  String get restore_turn_confirm => 'Restaurar e repetir';

  @override
  String get edit_turn_later_turns_body =>
      'Isto irá arquivar os turnos seguintes da conversa. Continuar?';

  @override
  String get session_history => 'Histórico da sessão';

  @override
  String get import_claude_or_codex => 'Importar Claude ou Codex';

  @override
  String get ng_session_history => 'Histórico da sessão';

  @override
  String get ng_import_claude_or_codex => 'Importar Claude ou Codex';

  @override
  String get ng_edit_and_resend => 'Editar e reenviar';

  @override
  String get ng_restore_turn_confirm => 'Restaurar e repetir';

  @override
  String get rewind_target_unsaved =>
      'Esta mensagem ainda não foi guardada. Aguarde que termine e edite-a novamente.';

  @override
  String get rewind_turn_busy =>
      'A resposta atual ainda não parou, por isso nada foi enviado. Tente novamente dentro de momentos.';

  @override
  String get rewind_session_changed =>
      'Esta conversa mudou desde que foi aberta aqui, por isso nada foi removido nem enviado. Reabra-a e tente novamente.';

  @override
  String get history_lineage => 'Conversas relacionadas';

  @override
  String get history_lineage_none =>
      'Esta conversa não tem ramificações nem ramos irmãos.';

  @override
  String get history_lineage_unavailable =>
      'Não foi possível ler as conversas relacionadas neste gateway.';

  @override
  String get history_lineage_parent => 'Origem';

  @override
  String get history_lineage_sibling => 'Irmão';

  @override
  String get history_lineage_fork => 'Ramificação';

  @override
  String get history_messages => 'Mensagens';

  @override
  String get history_messages_hint =>
      'Selecione uma mensagem guardada para ramificar ou recuar até aí.';

  @override
  String get history_messages_none => 'Ainda não há mensagens guardadas.';

  @override
  String get history_messages_unavailable =>
      'Não foi possível ler as mensagens guardadas. Abra esta conversa e atualize.';

  @override
  String get history_role_user => 'Você';

  @override
  String get history_role_assistant => 'Hermes';

  @override
  String get history_branch_here => 'Ramificar a partir daqui';

  @override
  String get history_rewind_here => 'Recuar até aqui';

  @override
  String get history_branch_title => 'Ramificar a partir desta mensagem';

  @override
  String get history_branch_body =>
      'Isto cria uma nova conversa com o histórico até à mensagem selecionada. A conversa atual fica como está.';

  @override
  String get history_rewind_title => 'Recuar até esta mensagem';

  @override
  String get history_rewind_body =>
      'As mensagens a partir da selecionada são removidas desta conversa. Os ficheiros no computador não são alterados. Restaurá-los é uma ação à parte, por ponto de controlo.';

  @override
  String history_branched(String id) {
    return 'Ramificado como $id';
  }

  @override
  String get history_open_chat => 'Abrir conversa';

  @override
  String get history_mutate_unsupported =>
      'Ramificar e recuar requerem Hermes 0.23 ou mais recente neste gateway.';

  @override
  String get history_checkpoints => 'Pontos de controlo';

  @override
  String get history_checkpoints_none =>
      'Esta sessão não tem pontos de controlo de ficheiros.';

  @override
  String get history_checkpoints_unavailable =>
      'Os pontos de controlo não estão disponíveis neste gateway.';

  @override
  String get history_diff_none => 'Sem diferenças.';

  @override
  String get history_diff_loading => 'A carregar as alterações…';

  @override
  String get history_diff_failed =>
      'Não foi possível carregar as alterações, por isso este ponto de controlo ainda não pode ser restaurado.';

  @override
  String get history_restore_checkpoint => 'Restaurar ponto de controlo';

  @override
  String get history_restore_title => 'Restaurar este ponto de controlo';

  @override
  String get history_restore_body =>
      'Os ficheiros que o agente alterou desde este ponto de controlo voltam a como estavam. As suas próprias alterações são mantidas. Mensagens posteriores da conversa também podem ser removidas. A conversa não é ramificada.';

  @override
  String get history_restore_body_all =>
      'Todos os ficheiros da pasta da sessão voltam a este ponto de controlo, incluindo as suas próprias alterações. Mensagens posteriores da conversa também podem ser removidas. A conversa não é ramificada.';

  @override
  String get history_restore_own_edits =>
      'Reverter também as minhas alterações';

  @override
  String get history_restored => 'Ponto de controlo restaurado.';

  @override
  String history_restored_removed(int count) {
    return 'Ponto de controlo restaurado. Foram removidas $count mensagens da conversa.';
  }

  @override
  String get history_export => 'Exportar';

  @override
  String get history_export_redact => 'Ocultar tokens';

  @override
  String get history_export_action => 'Exportar transcrição';

  @override
  String get history_export_saved => 'Transcrição guardada.';

  @override
  String get history_export_unsupported =>
      'Exportar requer Hermes 0.23 ou mais recente neste gateway.';

  @override
  String get history_import_unsupported =>
      'Este gateway não suporta a importação do Claude e do Codex.';

  @override
  String history_import_destination(String profile) {
    return 'Perfil de destino: $profile.';
  }

  @override
  String history_import_reading(String host, String profile, int count) {
    return 'A ler de $host · Perfil de destino: $profile. Não foi possível ler $count registos.';
  }

  @override
  String get history_import_all => 'Todos';

  @override
  String history_import_scan_failed(String reason) {
    return 'Não foi possível procurar as sessões do anfitrião: $reason';
  }

  @override
  String get history_import_none =>
      'Não foram encontradas sessões do Claude Code ou do Codex neste anfitrião.';

  @override
  String get history_import_no_match =>
      'Nenhuma sessão do anfitrião corresponde.';

  @override
  String history_import_preview_failed(String reason) {
    return 'Não foi possível pré-visualizar a sessão: $reason';
  }

  @override
  String get history_import_open => 'Abrir sessão importada';

  @override
  String get history_import_action => 'Importar sessão selecionada';

  @override
  String get history_import_title => 'Importar esta sessão';

  @override
  String history_import_body(String profile) {
    return 'Copiar esta sessão do Claude ou do Codex para o perfil \"$profile\" neste gateway.';
  }

  @override
  String history_import_body_existing(String profile) {
    return 'Esta sessão já foi importada para \"$profile\". Continue com a cópia existente.';
  }

  @override
  String history_imported(String id) {
    return 'Importado como $id';
  }

  @override
  String history_imported_already(String id) {
    return 'Já importado como $id';
  }

  @override
  String history_import_directory(String path) {
    return 'Diretório: $path';
  }

  @override
  String history_import_preview_partial(int shown, int total) {
    return 'A pré-visualização mostra $shown de $total.';
  }

  @override
  String history_failed(String reason) {
    return 'Não foi possível concluir: $reason';
  }

  @override
  String get history_error_unavailable =>
      'O gateway não conseguiu fazer isto agora. Tente novamente.';

  @override
  String get history_error_unsupported => 'Este gateway não suporta isto.';

  @override
  String get history_error_denied => 'Este gateway recusou o pedido.';

  @override
  String get history_error_changed =>
      'Esta conversa mudou enquanto esta página estava aberta. Atualize e tente novamente.';

  @override
  String get history_error_unbound =>
      'Esta conversa não está aberta no gateway. Abra-a e tente novamente.';

  @override
  String get history_error_invalid =>
      'O gateway enviou uma resposta que esta aplicação não conseguiu ler.';

  @override
  String ng_dock_kanban(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cartões Kanban',
      one: '1 cartão Kanban',
    );
    return '$_temp0';
  }

  @override
  String ng_dock_kanban_done(int count) {
    return '$count concluídos';
  }

  @override
  String get ng_show_kanban => 'Mostrar cartões Kanban';

  @override
  String get ng_hide_kanban => 'Ocultar cartões Kanban';

  @override
  String get ng_kanban_status_triage => 'Triagem';

  @override
  String get ng_kanban_status_todo => 'Por fazer';

  @override
  String get ng_kanban_status_scheduled => 'Agendado';

  @override
  String get ng_kanban_status_ready => 'Pronto';

  @override
  String get ng_kanban_status_running => 'Em execução';

  @override
  String get ng_kanban_status_blocked => 'Bloqueado';

  @override
  String get ng_kanban_status_review => 'Em revisão';

  @override
  String get ng_kanban_status_done => 'Concluído';

  @override
  String get ng_kanban_status_archived => 'Arquivado';

  @override
  String ng_kanban_open_card(String title) {
    return 'Abrir $title no Kanban';
  }

  @override
  String ng_kanban_show_all(int count) {
    return 'Mostrar todos os $count';
  }

  @override
  String ng_kanban_this_chat(int count) {
    return 'Esta conversa ($count)';
  }

  @override
  String get ng_kanban_close => 'Fechar o Kanban';

  @override
  String get ng_kanban_block_no_dashboard =>
      'Esta ligação não tem acesso ao painel, por isso o estado dos cartões não é em direto e o quadro não pode ser aberto.';

  @override
  String get ng_kanban_block_unsupported =>
      'O Kanban não está ativado neste gateway. Ative o plugin kanban para ver o estado em direto e abrir o quadro.';

  @override
  String get ng_kanban_block_denied =>
      'Inicie sessão no painel para ver o estado em direto dos cartões e abrir o quadro.';

  @override
  String get ng_kanban_block_insecure =>
      'O Kanban precisa de HTTPS ou de uma ligação local, por isso o estado dos cartões não é em direto e o quadro não pode ser aberto.';

  @override
  String get ng_kanban_block_unreachable =>
      'Não foi possível contactar o Kanban neste gateway. O estado dos cartões pode estar desatualizado.';

  @override
  String get ng_kanban_block_stale =>
      'A ligação mudou. Reabra esta conversa para ver o estado em direto dos cartões.';

  @override
  String get ng_bots_tab_roster => 'Equipa';

  @override
  String get ng_bots_tab_rooms => 'Salas';

  @override
  String get ng_bots_tab_screen => 'Ecrã';

  @override
  String get ng_bots_tab_routines => 'Rotinas';

  @override
  String ng_bots_rooms_load_failed(String error) {
    return 'Não foi possível carregar as salas: $error';
  }

  @override
  String ng_bots_routines_load_failed(String error) {
    return 'Não foi possível carregar as rotinas: $error';
  }

  @override
  String ng_bots_desktop_failed(String error) {
    return 'Bot Desktop: $error';
  }

  @override
  String get ng_bots_install_not_started =>
      'O gateway não iniciou a instalação.';

  @override
  String ng_bots_install_failed_error(String error) {
    return 'A instalação falhou: $error';
  }

  @override
  String get ng_bots_install_cancelled => 'A instalação foi cancelada.';

  @override
  String get ng_bots_install_no_sudo =>
      'O sudo não está disponível no anfitrião do gateway. Execute lá o comando acima e depois atualize.';

  @override
  String ng_bots_install_exit_code(String code) {
    return 'A instalação falhou (código de saída $code).';
  }

  @override
  String ng_bots_install_done(String bot) {
    return 'Bot Desktop instalado para $bot';
  }

  @override
  String get ng_bots_start_failed => 'Falha ao iniciar';

  @override
  String ng_bots_stop_title(String bot) {
    return 'Parar o Bot Desktop de $bot?';
  }

  @override
  String get ng_bots_stop_human_held =>
      'Alguém está a controlar este ecrã. Pará-lo termina a sessão dessa pessoa e fecha tudo o que estiver aberto nele.';

  @override
  String get ng_bots_stop_body =>
      'Tudo o que estiver aberto no ecrã do bot será fechado.';

  @override
  String get ng_bots_stop_refused => 'Paragem recusada';

  @override
  String get ng_bots_take_over_reason => 'Controlo assumido a partir do Ares';

  @override
  String ng_bots_take_over_failed(String error) {
    return 'Não foi possível assumir o controlo: $error';
  }

  @override
  String ng_bots_force_hand_back_title(String bot) {
    return 'Devolver o ecrã de $bot ao bot?';
  }

  @override
  String get ng_bots_force_hand_back_body =>
      'Uma pessoa está a controlar este ecrã. Se ainda o estiver a utilizar, perderá o controlo.';

  @override
  String get ng_bots_hand_back => 'Devolver controlo';

  @override
  String get ng_bots_hand_back_failed => 'Falha ao devolver o controlo';

  @override
  String get ng_bots_adopt_title => 'Adotar a nova imagem de sandbox?';

  @override
  String ng_bots_adopt_body(String bot, String current, String target) {
    return '$bot passa de $current para $target. O contentor é recriado na próxima chamada de terminal; tudo o que existir apenas no contentor atual será perdido.';
  }

  @override
  String get ng_bots_adopt_image => 'Adotar imagem';

  @override
  String get ng_bots_image_switch_failed => 'Falha ao mudar de imagem';

  @override
  String get ng_bots_keep_refused => 'Pedido para manter a imagem recusado';

  @override
  String ng_bots_chat_open_failed(String error) {
    return 'Não foi possível abrir o Bot Chat: $error';
  }

  @override
  String ng_bots_title(String connection) {
    return 'Bots · $connection';
  }

  @override
  String get ng_bots_protocol_tooltip =>
      'O gateway injeta ele próprio o protocolo de mensagens entre colegas — não é enviado nenhum protocolo SOUL.md adicional.';

  @override
  String ng_bots_unavailable(String reason) {
    return 'Bots indisponíveis ($reason)';
  }

  @override
  String get ng_bots_account_changed =>
      'A conta mudou. Volte a ligar ou atualize.';

  @override
  String get ng_bots_try_refresh =>
      'Experimente atualizar. Se persistir, o gateway pode não suportar bots.';

  @override
  String get ng_bots_search => 'Pesquisar bots';

  @override
  String get ng_bots_none_found => 'Nenhum bot encontrado.';

  @override
  String get ng_bots_no_model => 'sem modelo';

  @override
  String ng_bots_skill_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count competências',
      one: '1 competência',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_bot_chat => 'Bot Chat';

  @override
  String ng_bots_install_id(String id, String protocol) {
    return 'O gateway indica o ID de instalação $id · bot_mode_protocol: $protocol';
  }

  @override
  String get ng_bots_protocol_note =>
      'O gateway injeta o protocolo de mensagens entre colegas quando bot_mode_protocol está definido. Identificador: default→hermes; caso contrário, o nome do perfil.';

  @override
  String get ng_bots_no_rooms =>
      'Ainda não há salas. Crie uma a partir da sua equipa.';

  @override
  String ng_bots_member_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membros',
      one: '1 membro',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_room_disbanded => 'dissolvida';

  @override
  String get ng_bots_room_adopted => 'adotada';

  @override
  String get ng_bots_rooms_gateway => 'Salas do gateway';

  @override
  String get ng_bots_rooms_desktop => 'Salas geridas pelo Desktop';

  @override
  String ng_bots_rooms_gateway_body(String methods) {
    return 'As salas pertencem ao gateway. Métodos: $methods.';
  }

  @override
  String get ng_bots_rooms_no_seat =>
      'Este gateway pode não conseguir alojar salas (é necessário um processo persistente).';

  @override
  String get ng_bots_rooms_fallback =>
      'Alternativa clássica: o Desktop conduz as rondas do grupo (não são criadas aqui).';

  @override
  String get ng_bots_create_room => 'Criar sala';

  @override
  String get ng_bots_refresh_rooms => 'Atualizar salas';

  @override
  String get ng_bots_room_created => 'Sala criada';

  @override
  String ng_bots_room_refused(String reason) {
    return 'Criação da sala recusada ($reason)';
  }

  @override
  String ng_bots_room_failed(String error) {
    return 'Falha ao criar a sala: $error';
  }

  @override
  String get ng_bots_bot => 'Bot';

  @override
  String get ng_bots_screen_unavailable => 'Estado do ecrã indisponível';

  @override
  String get ng_bots_screen_unavailable_body =>
      'Inicie o ecrã do bot para ver a miniatura ou assuma o controlo para o utilizar.';

  @override
  String get ng_bots_take_over_note =>
      'Assumir o controlo abre o ecrã em direto e dá-lhe o controlo do mesmo. O controlo volta para o bot quando fechar o ecrã em direto, sair desta página ou colocar a aplicação em segundo plano.';

  @override
  String get ng_bots_not_installed => 'Não instalado';

  @override
  String get ng_bots_unsupported_host => 'Anfitrião não suportado';

  @override
  String ng_bots_pid(String pid) {
    return 'pid $pid';
  }

  @override
  String ng_bots_missing(String items) {
    return 'em falta: $items';
  }

  @override
  String ng_bots_blocked(String reason) {
    return 'bloqueado: $reason';
  }

  @override
  String get ng_bots_no_switch =>
      'Não há nenhuma mudança de imagem de sandbox pendente.';

  @override
  String ng_bots_switch_image(String current, String target) {
    return 'mudar imagem: $current → $target';
  }

  @override
  String get ng_bots_bot_in_control => 'o bot tem o controlo';

  @override
  String get ng_bots_person_in_control => 'uma pessoa tem o controlo';

  @override
  String get ng_bots_installing =>
      'A instalar o Bot Desktop no anfitrião do gateway…';

  @override
  String get ng_bots_install_unfinished => 'A instalação não terminou';

  @override
  String get ng_bots_install => 'Instalar';

  @override
  String get ng_bots_start => 'Iniciar';

  @override
  String get ng_bots_take_over => 'Assumir controlo';

  @override
  String get ng_bots_keep_image => 'Manter imagem atual';

  @override
  String ng_bots_missing_pieces(String items) {
    return 'O gateway indicou componentes em falta: $items';
  }

  @override
  String get ng_bots_install_missing => 'Instalar componentes em falta';

  @override
  String get ng_bots_thumbnail_unavailable => 'Miniatura indisponível';

  @override
  String get ng_bots_thumbnail_title => 'Miniatura do ecrã (em direto)';

  @override
  String get ng_bots_thumbnail_suppressed =>
      'Miniatura oculta enquanto uma pessoa controla o ecrã.';

  @override
  String get ng_bots_thumbnail_pending =>
      'A miniatura ainda não está disponível.';

  @override
  String ng_bots_routines_of(String bot) {
    return '$bot · rotinas';
  }

  @override
  String get ng_bots_add_routine => 'Adicionar rotina';

  @override
  String get ng_bots_no_routines => 'Este bot não tem rotinas.';

  @override
  String get ng_bots_routines_note =>
      'As rotinas são tarefas com a etiqueta [bot:<name>] que pertencem ao armazenamento do perfil do bot. As rotinas delegadas antigas são colocadas em pausa forçada ao carregar.';

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
    return 'erro: $error';
  }

  @override
  String ng_bots_remove_routine_title(String routine) {
    return 'Remover a rotina $routine?';
  }

  @override
  String ng_bots_remove_routine_body(String bot) {
    return 'A rotina será eliminada da agenda de $bot. Esta ação não pode ser anulada.';
  }

  @override
  String ng_bots_routine_action_failed(String action, String error) {
    return 'Falha em «$action»: $error';
  }

  @override
  String get ng_bots_not_connected => 'Sem ligação.';

  @override
  String ng_bots_add_failed(String error) {
    return 'Falha ao adicionar: $error';
  }

  @override
  String get ng_bots_routine_added => 'Rotina adicionada';

  @override
  String get ng_bots_routine_enabled => 'ativa';

  @override
  String get ng_bots_routine_paused => 'em pausa';

  @override
  String ng_bots_path(String path) {
    return 'Caminho: $path';
  }

  @override
  String get ng_bots_chat_present => 'Bot Chat presente';

  @override
  String get ng_bots_chat_missing => 'Bot Chat em falta';

  @override
  String ng_bots_last_session(String preview) {
    return 'Última sessão: $preview';
  }

  @override
  String get ng_bots_open_chat => 'Abrir Bot Chat';

  @override
  String get ng_bots_desktop => 'Bot Desktop';

  @override
  String get ng_bots_room_name => 'Nome da sala';

  @override
  String get ng_bots_select_member => 'Selecione pelo menos um membro.';

  @override
  String get ng_bots_sudo_title => 'Palavra-passe de administrador';

  @override
  String ng_bots_sudo_body(String bot) {
    return 'A instalação do Bot Desktop para $bot requer sudo no anfitrião do gateway. A palavra-passe é enviada apenas para esse gateway, para esta instalação, e não é guardada.';
  }

  @override
  String get ng_bots_sudo_password => 'Palavra-passe do sudo';

  @override
  String get ng_bots_new_routine => 'Nova rotina';

  @override
  String get ng_bots_routine_title => 'Título';

  @override
  String get ng_bots_routine_instruction => 'Instrução';

  @override
  String get ng_bots_cron => 'Expressão cron';

  @override
  String get ng_bots_interval => 'Intervalo';

  @override
  String get ng_bots_cron_help => '0 9 * * * executa todos os dias às 09:00';

  @override
  String get ng_bots_every => 'A cada';

  @override
  String get ng_bots_unit_minutes => 'minutos';

  @override
  String get ng_bots_unit_hours => 'horas';

  @override
  String get ng_bots_unit_days => 'dias';

  @override
  String get ng_bots_stop_after => 'Parar após (execuções)';

  @override
  String get ng_bots_stop_after_help =>
      'Deixe em branco para continuar a executar';

  @override
  String get ng_bots_send_results => 'Enviar resultados para';

  @override
  String get ng_bots_run_history => 'Apenas histórico de execuções';

  @override
  String get ng_bots_continuity => 'Continuar a partir da execução anterior';

  @override
  String get ng_bots_account_changed_refresh =>
      'A conta mudou. Atualize antes de continuar.';

  @override
  String ng_bots_room_load_failed(String error) {
    return 'Não foi possível carregar a sala: $error';
  }

  @override
  String ng_bots_send_failed(String error) {
    return 'Falha ao enviar: $error';
  }

  @override
  String ng_bots_stop_failed(String error) {
    return 'Falha ao parar: $error';
  }

  @override
  String get ng_bots_stop_room => 'Parar sala';

  @override
  String get ng_bots_send_message => 'Enviar uma mensagem';

  @override
  String get ng_bots_room_hint =>
      'Escreva para a sala (mencione membros com @handle)';

  @override
  String get ng_bots_history => 'Histórico';

  @override
  String ng_bots_revision(String revision) {
    return 'revisão $revision';
  }

  @override
  String ng_bots_last_error(String error) {
    return 'último erro: $error';
  }

  @override
  String get ng_bots_members => 'Membros';

  @override
  String get ng_bots_room_context => 'Contexto da sala';

  @override
  String ng_bots_purpose(String purpose) {
    return 'Objetivo: $purpose';
  }

  @override
  String ng_bots_notes(String notes) {
    return 'Notas: $notes';
  }

  @override
  String ng_bots_routing(String routing) {
    return 'Encaminhamento: $routing';
  }

  @override
  String ng_bots_lead(String member) {
    return 'líder $member';
  }

  @override
  String get ng_bots_viewer_you_control =>
      'Está a controlar este ecrã. O bot aguarda até lhe devolver o controlo.';

  @override
  String get ng_bots_viewer_handed_back => 'O controlo voltou para o bot.';

  @override
  String get ng_bots_viewer_background =>
      'O controlo voltou para o bot porque a aplicação deixou de estar em primeiro plano.';

  @override
  String get ng_bots_viewer_taken =>
      'Outra pessoa assumiu o controlo deste ecrã.';

  @override
  String get ng_bots_viewer_lost =>
      'A visualização em direto foi perdida, por isso o controlo voltou para o bot.';

  @override
  String ng_bots_viewer_title(String bot) {
    return 'Bot Desktop · $bot';
  }

  @override
  String get ng_bots_viewer_type_hint => 'Escrever no ecrã do bot';

  @override
  String get ng_bots_viewer_type => 'Escrever';

  @override
  String get ng_bots_viewer_enter => 'Enter';

  @override
  String get ng_bots_viewer_backspace => 'Backspace';

  @override
  String get ng_more_kanban => 'Kanban';

  @override
  String get ng_more_kanban_subtitle =>
      'Quadros, dependências de tarefas, atribuição de executores e registos';

  @override
  String get ng_more_bots => 'Bots';

  @override
  String get ng_more_bots_subtitle => 'Equipa, salas, rotinas e Bot Desktop';

  @override
  String get ng_slash_kanban => 'Abrir o quadro Kanban';

  @override
  String get ng_slash_bots => 'Abrir os seus bots';

  @override
  String ng_board_card_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cartões',
      one: '1 cartão',
    );
    return '$_temp0';
  }

  @override
  String ng_board_event_toast(String task, String event) {
    return 'Kanban $task: $event';
  }

  @override
  String get ng_board_task => 'tarefa';

  @override
  String ng_board_refused_http(String status) {
    return 'Ação recusada (HTTP $status).';
  }

  @override
  String get ng_board_err_unsupported =>
      'O plugin Kanban não está ativado neste gateway.';

  @override
  String get ng_board_err_denied =>
      'É necessário iniciar sessão ou ter permissão neste gateway.';

  @override
  String get ng_board_err_stale =>
      'O proprietário do gateway mudou. Atualize antes de continuar.';

  @override
  String get ng_board_err_insecure =>
      'É necessário HTTPS (ou loopback) para operações no espaço de trabalho Kanban.';

  @override
  String get ng_board_err_unreachable =>
      'Não foi possível contactar o serviço Kanban neste gateway.';

  @override
  String get ng_board_err_failed =>
      'A operação falhou. Atualize e tente novamente.';

  @override
  String ng_board_block_title(String task) {
    return 'Bloquear $task';
  }

  @override
  String get ng_board_block_reason => 'Motivo do bloqueio';

  @override
  String get ng_board_block_hint => 'O que está a bloquear este cartão?';

  @override
  String ng_board_review_title(String task) {
    return 'Pedir revisão de $task';
  }

  @override
  String get ng_board_review_summary => 'Resumo para revisão';

  @override
  String get ng_board_review_hint => 'O que foi implementado e verificado?';

  @override
  String ng_board_move_title(String cards, String column) {
    return 'Mover $cards para $column?';
  }

  @override
  String ng_board_move_body(String board) {
    return 'Todos os cartões selecionados em $board mudam de coluna. Um cartão em execução deixa de ser executado.';
  }

  @override
  String get ng_board_move => 'Mover';

  @override
  String ng_board_moved(String column) {
    return 'Cartões movidos para $column';
  }

  @override
  String ng_board_unassign_title(String cards) {
    return 'Remover a atribuição de $cards?';
  }

  @override
  String ng_board_assign_title(String cards, String profile) {
    return 'Atribuir $cards a @$profile?';
  }

  @override
  String get ng_board_assign_body =>
      'Os cartões em execução são recuperados primeiro: os respetivos executores são parados.';

  @override
  String get ng_board_unassign => 'Remover atribuição';

  @override
  String get ng_board_assign => 'Atribuir';

  @override
  String get ng_board_unassigned_done =>
      'Atribuição removida dos cartões selecionados';

  @override
  String ng_board_assigned_done(String profile) {
    return '@$profile atribuído';
  }

  @override
  String ng_board_archive_title(String cards) {
    return 'Arquivar $cards?';
  }

  @override
  String ng_board_archive_body(String board) {
    return 'Os cartões arquivados saem de $board. Ative Arquivados para voltar a vê-los.';
  }

  @override
  String get ng_board_archived_done => 'Cartões selecionados arquivados';

  @override
  String ng_board_delete_title(String cards) {
    return 'Eliminar $cards?';
  }

  @override
  String ng_board_delete_body(String board) {
    return 'Esta ação elimina permanentemente os cartões selecionados de $board.';
  }

  @override
  String ng_board_deleted(String cards) {
    return 'Eliminação concluída: $cards.';
  }

  @override
  String ng_board_partial_failure(String failed, String total, String reason) {
    return '$failed de $total falharam: $reason';
  }

  @override
  String get ng_board_refused => 'recusado';

  @override
  String ng_board_dispatched(
    String spawned,
    String promoted,
    String reclaimed,
  ) {
    return 'Despachado: $spawned iniciados, $promoted promovidos, $reclaimed recuperados.';
  }

  @override
  String ng_board_board_archived(String board) {
    return 'Quadro $board arquivado';
  }

  @override
  String ng_board_board_archived_to(String path) {
    return 'Arquivado em $path';
  }

  @override
  String ng_board_exported(String board, String archive) {
    return '$board exportado para $archive';
  }

  @override
  String ng_board_imported(String board, String warnings) {
    return 'Quadro $board importado$warnings';
  }

  @override
  String ng_board_created(String task) {
    return 'Tarefa $task criada';
  }

  @override
  String get ng_board_orchestration_saved => 'Orquestração Kanban guardada';

  @override
  String get ng_board_auto_describe_unavailable =>
      'Descrição automática indisponível';

  @override
  String ng_board_description_updated(String profile) {
    return 'Descrição de @$profile atualizada';
  }

  @override
  String ng_board_title(String board) {
    return 'Kanban · $board';
  }

  @override
  String ng_board_active(String count) {
    return '$count em curso';
  }

  @override
  String get ng_board_dispatch => 'Despachar agora as tarefas prontas';

  @override
  String get ng_board_orchestration => 'Orquestração e executores';

  @override
  String get ng_board_new_task => 'Nova tarefa';

  @override
  String get ng_board_enable_plugin =>
      'Ative o plugin «kanban» incluído em Capacidades → Plugins neste gateway para ativar o respetivo router de quadros.';

  @override
  String get ng_board_filter => 'Filtrar tarefas…';

  @override
  String get ng_board_all_assignees => 'Todos os responsáveis';

  @override
  String get ng_board_unassigned => 'Sem responsável';

  @override
  String get ng_board_running_by_profile => 'Em execução por perfil';

  @override
  String get ng_board_select => 'Selecionar';

  @override
  String ng_board_selected_chip(String count) {
    return 'Selecionados ($count)';
  }

  @override
  String get ng_board_locked_column =>
      'Coluna gerida — arrastar e largar desativado';

  @override
  String ng_board_add_to(String column) {
    return 'Adicionar a $column';
  }

  @override
  String ng_board_collapse(String column) {
    return 'Recolher $column';
  }

  @override
  String ng_board_column_empty(String column) {
    return 'Sem tarefas em $column';
  }

  @override
  String get ng_board_drop_here => 'Largue aqui ou + tarefa';

  @override
  String get ng_board_card_actions => 'Ações do cartão';

  @override
  String get ng_board_open_details => 'Abrir detalhes';

  @override
  String get ng_board_select_card => 'Selecionar cartão';

  @override
  String ng_board_move_to(String column) {
    return 'Mover para $column';
  }

  @override
  String get ng_board_parked => 'Em espera';

  @override
  String ng_board_blocked_by(String count) {
    return 'Bloqueado por $count';
  }

  @override
  String get ng_board_goal_loop => 'Ciclo de objetivo';

  @override
  String ng_board_selected(String count) {
    return 'Selecionados: $count';
  }

  @override
  String get ng_board_move_menu => 'Mover…';

  @override
  String get ng_board_assign_menu => 'Atribuir…';

  @override
  String get ng_board_new_board_title => 'Novo quadro Kanban';

  @override
  String get ng_board_slug => 'Slug (minúsculas, p. ex. release-v5)';

  @override
  String get ng_board_display_name => 'Nome a apresentar';

  @override
  String get ng_board_linked_project => 'Projeto associado (opcional)';

  @override
  String get ng_board_none => 'Nenhum';

  @override
  String get ng_board_default_workdir =>
      'Diretório de trabalho predefinido no anfitrião (opcional)';

  @override
  String get ng_board_import_title => 'Importar arquivo de quadro';

  @override
  String get ng_board_import_path => 'Caminho do arquivo .tar.gz no anfitrião';

  @override
  String get ng_board_import => 'Importar';

  @override
  String ng_board_edit_board(String board) {
    return 'Editar $board';
  }

  @override
  String get ng_board_name => 'Nome';

  @override
  String get ng_board_description => 'Descrição';

  @override
  String get ng_board_workdir_clear =>
      'Diretório de trabalho predefinido (vazio para limpar)';

  @override
  String get ng_board_boards => 'Quadros Kanban';

  @override
  String get ng_board_new_board => 'Novo quadro';

  @override
  String get ng_board_search_boards => 'Pesquisar quadros…';

  @override
  String get ng_board_unpin => 'Desafixar separador';

  @override
  String get ng_board_pin => 'Afixar separador';

  @override
  String ng_board_archive_board_title(String board) {
    return 'Arquivar o quadro $board?';
  }

  @override
  String ng_board_archive_board_body(String cards) {
    return 'O quadro e os seus cartões ($cards) saem da lista de quadros. O gateway mantém um arquivo no respetivo anfitrião.';
  }

  @override
  String get ng_board_edit_metadata => 'Editar metadados';

  @override
  String get ng_board_export => 'Exportar .tar.gz no anfitrião';

  @override
  String get ng_board_move_pin_left =>
      'Mover separador afixado para a esquerda';

  @override
  String get ng_board_archive_board => 'Arquivar quadro';

  @override
  String get ng_board_new_task_title => 'Nova tarefa Kanban';

  @override
  String get ng_board_title_required => 'Título *';

  @override
  String get ng_board_spec => 'Especificação e critérios de aceitação';

  @override
  String get ng_board_estimate => 'Estimar';

  @override
  String ng_board_estimate_draft(String complexity, String tokens) {
    return 'Complexidade $complexity (~$tokens tok — apenas estimativa de tokens, não de custo em dólares)';
  }

  @override
  String get ng_board_estimate_unavailable => 'Estimativa indisponível';

  @override
  String get ng_board_initial_column => 'Coluna inicial';

  @override
  String get ng_board_worker_assignee => 'Executor atribuído';

  @override
  String get ng_board_parked_unassigned => 'Em espera (sem responsável)';

  @override
  String get ng_board_priority => 'Prioridade';

  @override
  String get ng_board_workspace => 'Espaço de trabalho';

  @override
  String get ng_board_scratch => 'Temporário';

  @override
  String get ng_board_worktree => 'Git worktree';

  @override
  String get ng_board_shared_dir => 'Diretório partilhado';

  @override
  String get ng_board_workspace_path =>
      'Caminho do espaço de trabalho no anfitrião';

  @override
  String get ng_board_parent => 'Dependência-mãe (opcional)';

  @override
  String get ng_board_skills =>
      'Competências fixas (separadas por vírgulas, opcional)';

  @override
  String get ng_board_provider_override => 'Substituição do fornecedor';

  @override
  String get ng_board_model_override => 'Substituição do modelo';

  @override
  String get ng_board_reasoning => 'Esforço de raciocínio';

  @override
  String get ng_board_profile_default => 'Predefinição do perfil';

  @override
  String get ng_board_xhigh => 'Muito alto';

  @override
  String get ng_board_goal_mode => 'Modo de ciclo de objetivo';

  @override
  String get ng_board_goal_turns =>
      'Máximo de turnos do objetivo (vazio = predefinição)';

  @override
  String get ng_board_create_task => 'Criar tarefa';

  @override
  String get ng_board_orchestration_title =>
      'Orquestração e perfis de executores';

  @override
  String ng_board_orchestrator(String profile) {
    return 'Perfil do orquestrador (efetivo: $profile)';
  }

  @override
  String get ng_board_inherit_default => 'Herdar a predefinição ativa';

  @override
  String ng_board_default_assignee(String profile) {
    return 'Responsável predefinido (efetivo: $profile)';
  }

  @override
  String get ng_board_auto_decompose =>
      'Decompor automaticamente cartões de triagem';

  @override
  String get ng_board_auto_decompose_help =>
      'Usa o modelo kanban_decomposer configurado nas tarefas de triagem';

  @override
  String get ng_board_save_orchestration => 'Guardar orquestração';

  @override
  String get ng_board_worker_descriptions =>
      'Descrições da especialização dos executores';

  @override
  String ng_board_worker_label(String profile, String model, String skills) {
    return '@$profile ($model · $skills)';
  }

  @override
  String get ng_board_default_model => 'modelo predefinido';

  @override
  String get ng_board_save_description => 'Guardar descrição';

  @override
  String get ng_board_auto_describe =>
      'Descrever automaticamente a partir das competências e da persona';

  @override
  String get ng_board_manual_block => 'Bloqueio manual do operador';

  @override
  String get ng_board_requested_review => 'Revisão pedida';

  @override
  String ng_board_requeue_title(String task) {
    return 'Recolocar $task na fila?';
  }

  @override
  String get ng_board_requeue_body =>
      'O executor que está a processar este cartão é parado e o cartão volta para a fila.';

  @override
  String get ng_board_requeue => 'Recolocar na fila';

  @override
  String ng_board_reassign_title(String task, String profile) {
    return 'Reatribuir $task a @$profile?';
  }

  @override
  String get ng_board_reassign_body =>
      'Este cartão está em execução: o respetivo executor é parado primeiro.';

  @override
  String get ng_board_reassign => 'Reatribuir';

  @override
  String ng_board_saved_task(String task) {
    return 'Tarefa $task guardada';
  }

  @override
  String get ng_board_commented_requeued =>
      'Comentário publicado e tarefa recolocada na fila';

  @override
  String get ng_board_commented => 'Comentário publicado';

  @override
  String ng_board_requeued(String task) {
    return 'Tarefa $task recolocada na fila';
  }

  @override
  String get ng_board_decompose_failed => 'A decomposição falhou.';

  @override
  String ng_board_decompose_failed_reason(String reason) {
    return 'A decomposição falhou: $reason';
  }

  @override
  String ng_board_decomposed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Decomposta em $count tarefas-filhas',
      one: 'Decomposta em 1 tarefa-filha',
    );
    return '$_temp0';
  }

  @override
  String get ng_board_no_children => 'Não foram criadas tarefas-filhas.';

  @override
  String ng_board_no_children_reason(String reason) {
    return 'Não foram criadas tarefas-filhas: $reason';
  }

  @override
  String ng_board_uploaded(String file) {
    return '$file carregado';
  }

  @override
  String ng_board_linked_parent(String task) {
    return 'Tarefa-mãe $task associada';
  }

  @override
  String ng_board_unlinked_parent(String task) {
    return 'Ligação à tarefa-mãe $task removida';
  }

  @override
  String get ng_board_task_load_failed => 'Não foi possível carregar a tarefa';

  @override
  String get ng_board_refresh_task => 'Atualizar tarefa';

  @override
  String get ng_board_tab_overview => 'Visão geral';

  @override
  String get ng_board_tab_comments => 'Comentários e ligações';

  @override
  String get ng_board_tab_runs => 'Execuções e registo';

  @override
  String get ng_board_tab_events => 'Eventos';

  @override
  String get ng_board_decompose => 'Decompor';

  @override
  String get ng_board_attach => 'Anexar ficheiro';

  @override
  String ng_board_estimate_task(
    String complexity,
    String tokens,
    String rationale,
  ) {
    return 'Estimativa: $complexity · ~$tokens tokens ($rationale) — não é uma estimativa de custo em dólares.';
  }

  @override
  String get ng_board_no_rationale => 'sem justificação';

  @override
  String get ng_board_status => 'Estado';

  @override
  String get ng_board_assignee => 'Responsável';

  @override
  String get ng_board_title_label => 'Título';

  @override
  String get ng_board_body => 'Corpo / especificação';

  @override
  String get ng_board_save_changes => 'Guardar alterações';

  @override
  String get ng_board_clear_model => 'Limpar substituição do modelo';

  @override
  String ng_board_blocked_reason(String reason) {
    return 'Motivo do bloqueio: $reason';
  }

  @override
  String ng_board_result(String result) {
    return 'Resultado: $result';
  }

  @override
  String ng_board_parents(String count) {
    return 'Bloqueado por (tarefas-mãe · $count)';
  }

  @override
  String get ng_board_add_parent => '+ Adicionar tarefa-mãe';

  @override
  String ng_board_children(String count) {
    return 'Bloqueia (tarefas-filhas · $count)';
  }

  @override
  String ng_board_attachments(String count) {
    return 'Anexos ($count)';
  }

  @override
  String get ng_board_worker => 'executor';

  @override
  String ng_board_comments(String count) {
    return 'Comentários ($count)';
  }

  @override
  String get ng_board_comment_hint =>
      'Adicionar comentário / orientação para o executor';

  @override
  String get ng_board_post_comment => 'Publicar comentário';

  @override
  String get ng_board_comment_requeue => 'Comentar e recolocar na fila';

  @override
  String ng_board_runs(String count) {
    return 'Execuções ($count)';
  }

  @override
  String get ng_board_no_runs =>
      'Ainda não foram registadas execuções do executor.';

  @override
  String ng_board_run_error(String error) {
    return 'Erro: $error';
  }

  @override
  String ng_board_log_tail_truncated(String bytes) {
    return 'Final do registo do executor ($bytes B, truncado)';
  }

  @override
  String ng_board_log_tail(String bytes) {
    return 'Final do registo do executor ($bytes B)';
  }

  @override
  String get ng_board_refresh_log => 'Atualizar registo';

  @override
  String get ng_board_no_log => 'Sem saída no registo do executor.';

  @override
  String get ng_board_no_events => 'Não há eventos registados.';

  @override
  String get ng_bots_room_unknown => 'desconhecido';

  @override
  String get ng_bots_room_blocked => 'bloqueado';

  @override
  String get ng_bots_room_working => 'a trabalhar';

  @override
  String get ng_bots_room_running => 'em execução';

  @override
  String get ng_bots_room_idle => 'inativo';

  @override
  String ng_board_run_title(String id, String profile, String outcome) {
    return 'Execução n.º $id · @$profile · $outcome';
  }

  @override
  String get ng_bots_new_bot => 'Novo bot';

  @override
  String get ng_bots_new_bot_hint =>
      'Um colega com nome, com memória, habilidades e chat próprios. Pode enviar mensagens aos seus outros agentes.';

  @override
  String get ng_bots_field_name => 'Nome';

  @override
  String get ng_bots_field_title => 'Título';

  @override
  String get ng_bots_field_description => 'Descrição';

  @override
  String get ng_bots_description_hint => 'Com o que este bot deve ajudar?';

  @override
  String get ng_bots_name_invalid =>
      'Use letras minúsculas, números, hífens ou sublinhados, começando por uma letra ou um número (no máximo 64 caracteres).';

  @override
  String ng_bots_name_taken(String name) {
    return 'Já existe um agente chamado “$name”.';
  }

  @override
  String ng_bots_profile_id(String id) {
    return 'ID do perfil: $id';
  }

  @override
  String get ng_bots_advanced =>
      'Avançado — modelo, habilidades, conjuntos de ferramentas, SOUL.md';

  @override
  String get ng_bots_clone_from => 'Clonar do perfil';

  @override
  String get ng_bots_clone_main => 'Perfil principal (default)';

  @override
  String get ng_bots_fresh_profile => 'Perfil novo (habilidades incluídas)';

  @override
  String get ng_bots_create_empty =>
      'Criar vazio (sem as habilidades incluídas)';

  @override
  String get ng_bots_share_keys =>
      'Compartilhar chaves e contas com o perfil principal';

  @override
  String get ng_bots_provider => 'Provedor';

  @override
  String get ng_bots_model => 'Modelo';

  @override
  String get ng_bots_model_pair => 'Informe um provedor e um modelo.';

  @override
  String get ng_bots_soul => 'SOUL.md (opcional — substitui a persona gerada)';

  @override
  String get ng_bots_soul_edit => 'SOUL.md';

  @override
  String get ng_bots_creating => 'Criando…';

  @override
  String get ng_bots_create_bot => 'Criar bot';

  @override
  String ng_bots_created(String name) {
    return 'Bot “$name” criado';
  }

  @override
  String get ng_bots_look_failed =>
      'A aparência não foi salva no gateway; defina-a em Editar perfil.';

  @override
  String ng_bots_request_failed(String reason) {
    return 'O gateway não aceitou ($reason).';
  }

  @override
  String get ng_bots_avatar_shape => 'Forma';

  @override
  String ng_bots_avatar_shape_n(int n) {
    return 'Forma $n';
  }

  @override
  String get ng_bots_avatar_colour => 'Cor';

  @override
  String ng_bots_avatar_colour_n(int n) {
    return 'Cor $n';
  }

  @override
  String get ng_bots_avatar_match_name => 'Conforme o nome';

  @override
  String get ng_bots_avatar_upload => 'Escolher uma imagem…';

  @override
  String get ng_bots_avatar_remove => 'Remover imagem — usar forma';

  @override
  String get ng_bots_avatar_too_large => 'Imagem grande demais (máx. 15 MB).';

  @override
  String get ng_bots_avatar_unreadable => 'Não foi possível ler essa imagem.';

  @override
  String get ng_bots_edit_profile => 'Editar perfil';

  @override
  String ng_bots_edit_description(String name, String profile) {
    return 'Aparência e função de $name ($profile).';
  }

  @override
  String ng_bots_advanced_failed(String reason) {
    return 'Não foi possível carregar as configurações do perfil ($reason).';
  }

  @override
  String get ng_bots_skills => 'Habilidades';

  @override
  String get ng_bots_toolsets => 'Conjuntos de ferramentas';

  @override
  String get ng_bots_toolsets_hint =>
      'Deixar todos (ou nenhum) marcados mantém o comportamento padrão.';

  @override
  String get ng_bots_mcp_servers => 'Servidores MCP';

  @override
  String get ng_bots_saving => 'Salvando…';

  @override
  String get ng_bots_confirm_changes_title => 'Salvar estas alterações?';

  @override
  String get ng_bots_change_remove_image => 'Remover a imagem do bot';

  @override
  String get ng_bots_change_soul => 'Substituir o SOUL.md';

  @override
  String ng_bots_change_turn_off(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Desativar $count habilidades, conjuntos ou servidores MCP',
      one: 'Desativar 1 habilidade, conjunto ou servidor MCP',
    );
    return '$_temp0';
  }

  @override
  String ng_bots_updated(String name) {
    return '$name atualizado';
  }

  @override
  String ng_bots_sections_failed(String sections) {
    return 'Algumas seções falharam: $sections';
  }

  @override
  String get ng_bots_model_confirm_title => 'Trocar o modelo?';

  @override
  String get ng_bots_model_confirm_ok => 'Trocar';

  @override
  String get ng_bots_model_not_switched => 'O modelo não foi trocado.';

  @override
  String get ng_bots_section_new => 'Nova seção';

  @override
  String get ng_bots_section_new_ellipsis => 'Nova seção…';

  @override
  String get ng_bots_section_name => 'Nome da seção';

  @override
  String get ng_bots_section_name_hint => 'ex.: Clientes';

  @override
  String get ng_bots_section_create => 'Criar';

  @override
  String get ng_bots_section_rename => 'Renomear seção';

  @override
  String get ng_bots_section_delete => 'Excluir seção';

  @override
  String get ng_bots_section_move_up => 'Mover para cima';

  @override
  String get ng_bots_section_move_down => 'Mover para baixo';

  @override
  String get ng_bots_section_unassigned => 'Sem seção';

  @override
  String ng_bots_section_options(String name) {
    return 'Opções da seção $name';
  }

  @override
  String get ng_bots_section_empty =>
      'Ainda não há bots aqui. Use Mover para seção em um bot.';

  @override
  String get ng_bots_section_move_to => 'Mover para seção';

  @override
  String get ng_bots_section_remove => 'Remover da seção';

  @override
  String ng_bots_section_deleted(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '“$name” excluída — $count bots movidos para Sem seção',
      one: '“$name” excluída — 1 bot movido para Sem seção',
      zero: '“$name” excluída',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_undo => 'Desfazer';

  @override
  String ng_bots_section_move_failed(String reason) {
    return 'Não foi possível mover o bot ($reason).';
  }

  @override
  String ng_bots_bot_actions(String name) {
    return 'Ações de $name';
  }

  @override
  String ng_bots_section_toggle(String name) {
    return 'Mostrar ou ocultar $name';
  }

  @override
  String
  get release_core_transcript_reader_this_passage_is_no_longer_in_the_loaded =>
      'Esta passagem já não está na janela carregada.';

  @override
  String get release_core_transcript_reader_loaded_prompts =>
      'Instruções carregadas';

  @override
  String get release_core_transcript_reader_jump_to_latest =>
      'Ir para o mais recente';

  @override
  String get release_core_transcript_reader_no_prompts_loaded =>
      'Nenhuma instrução carregada';

  @override
  String get release_core_transcript_reader_find_in_loaded_messages =>
      'Pesquisar nas mensagens carregadas';

  @override
  String get release_core_transcript_reader_previous_match =>
      'Correspondência anterior';

  @override
  String get release_core_transcript_reader_next_match =>
      'Correspondência seguinte';

  @override
  String get release_core_transcript_reader_prompt_timeline =>
      'Cronologia de instruções';

  @override
  String get release_core_transcript_reader_close_find => 'Fechar pesquisa';

  @override
  String get release_core_session_organisation_organise_chats =>
      'Organizar conversas';

  @override
  String get release_core_session_organisation_show_model_and_usage =>
      'Mostrar modelo e utilização';

  @override
  String
  get release_core_session_files_view_connection_changed_reopen_files_on_the_new_connection =>
      'A ligação mudou. Volte a abrir os ficheiros na nova ligação.';

  @override
  String
  get release_core_session_files_view_the_connection_or_session_changed_reopen_this_pane =>
      'A ligação ou a sessão mudou. Volte a abrir este painel.';

  @override
  String
  get release_core_session_files_view_no_verified_host_working_directory_for_this_session =>
      'Não há um diretório de trabalho verificado no anfitrião para esta sessão.';

  @override
  String
  get release_core_session_files_view_the_gateway_denied_this_operation =>
      'O gateway recusou esta operação.';

  @override
  String
  get release_core_session_files_view_this_gateway_does_not_support_this_operation =>
      'Este gateway não suporta esta operação.';

  @override
  String
  get release_core_session_files_view_the_file_owner_or_working_directory_changed_reload =>
      'O ficheiro, o proprietário ou o diretório de trabalho mudou. Volte a carregar e reveja.';

  @override
  String
  get release_core_session_files_view_the_gateway_returned_an_unsafe_path_or_invalid =>
      'O gateway devolveu um caminho inseguro ou uma resposta de ficheiro inválida.';

  @override
  String
  get release_core_session_files_view_workspace_access_requires_a_secure_gateway_connection =>
      'O acesso ao espaço de trabalho requer uma ligação segura ao gateway.';

  @override
  String
  get release_core_session_files_view_gateway_unavailable_refresh_to_check_the_current_state =>
      'Gateway indisponível. Atualize para verificar o estado atual.';

  @override
  String
  get release_core_session_files_view_gateway_operation_could_not_be_confirmed =>
      'Não foi possível confirmar a operação do gateway.';

  @override
  String get release_core_session_files_view_git_status_unavailable =>
      'Estado do Git indisponível.';

  @override
  String
  get release_core_session_files_view_change_this_chat_s_working_directory =>
      'Alterar o diretório de trabalho desta conversa?';

  @override
  String get release_core_session_files_view_absolute_gateway_directory =>
      'Caminho absoluto do diretório no gateway';

  @override
  String get release_core_session_files_view_change_directory =>
      'Alterar diretório';

  @override
  String get release_core_session_files_view_replace_gateway_file =>
      'Substituir o ficheiro do gateway?';

  @override
  String
  release_core_session_files_view_only_if_the_file_still_matches_the_version(
    String path,
  ) {
    return '$path\n\nApenas se o ficheiro ainda corresponder à versão que reviu. Um anfitrião compatível conserva o ficheiro substituído para permitir a sua recuperação.';
  }

  @override
  String get release_core_session_files_view_save_changes =>
      'Guardar alterações';

  @override
  String
  get release_core_session_files_view_saved_and_verified_on_the_gateway =>
      'Guardado e verificado no gateway.';

  @override
  String
  get release_core_session_files_view_guarded_saving_is_unavailable_on_this_gateway_your =>
      'A gravação protegida não está disponível neste gateway. O seu rascunho continua aqui.';

  @override
  String
  release_core_session_files_view_save_was_not_confirmed_your_draft_is_still(
    String reason,
  ) {
    return '$reason A gravação não foi confirmada. O seu rascunho continua aqui.';
  }

  @override
  String get release_core_session_files_view_review_current_gateway_version =>
      'Rever a versão atual do gateway';

  @override
  String get release_core_session_files_view_discard_draft_and_reload =>
      'Descartar rascunho e voltar a carregar';

  @override
  String get release_core_session_files_view_keep_draft_against_this_version =>
      'Manter o rascunho com base nesta versão';

  @override
  String get release_core_session_files_view_discard_unsaved_edits =>
      'Descartar alterações não guardadas?';

  @override
  String get release_core_session_files_view_keep_editing =>
      'Continuar a editar';

  @override
  String get release_core_session_files_view_discard_edits =>
      'Descartar alterações';

  @override
  String get release_core_session_files_view_remote_working_directory =>
      'Diretório de trabalho remoto';

  @override
  String get release_core_session_files_view_change_working_directory =>
      'Alterar diretório de trabalho';

  @override
  String get release_core_session_files_view_show_ignored_files =>
      'Mostrar ficheiros ignorados';

  @override
  String
  get release_core_session_files_view_gateway_does_not_report_ignored_status =>
      'O gateway não indica quais os ficheiros ignorados.';

  @override
  String get release_core_session_files_view_no_visible_entries =>
      'Sem entradas visíveis';

  @override
  String get release_core_session_files_view_changed => 'Alterado';

  @override
  String get release_core_session_files_view_ignored => 'Ignorado';

  @override
  String release_core_session_files_view_actions_for(String name) {
    return 'Ações para $name';
  }

  @override
  String get release_core_session_files_view_copy_relative_path =>
      'Copiar caminho relativo';

  @override
  String get release_core_session_files_view_copy_gateway_path =>
      'Copiar caminho do gateway';

  @override
  String get release_core_session_files_view_attach_folder_reference =>
      'Anexar referência à pasta';

  @override
  String get release_core_session_files_view_attach_file_reference =>
      'Anexar referência ao ficheiro';

  @override
  String
  get release_core_session_files_view_preview_truncated_editing_disabled =>
      'Pré-visualização truncada — edição desativada.';

  @override
  String get release_core_session_files_view_select_lines =>
      'Selecionar linhas';

  @override
  String get release_core_session_files_view_review_gateway_version =>
      'Rever versão do gateway';

  @override
  String get release_core_session_files_view_attach_selected_lines =>
      'Anexar linhas selecionadas';

  @override
  String get release_core_session_files_view_binary_file_no_text_preview =>
      'Ficheiro binário — sem pré-visualização de texto.';

  @override
  String get release_core_session_files_view_file_source =>
      'Origem do ficheiro';

  @override
  String get release_core_session_files_view_close_session_files =>
      'Fechar ficheiros da sessão';

  @override
  String get release_core_session_files_view_back_to_tree => 'Voltar à árvore';

  @override
  String get release_core_session_files_view_session_files =>
      'Ficheiros da sessão';

  @override
  String get release_core_session_files_view_git_review => 'Revisão do Git';

  @override
  String get release_core_session_files_view_refresh_tree => 'Atualizar árvore';

  @override
  String
  get release_core_gateway_queue_screen_this_connection_changed_reopen_its_chat =>
      'Esta ligação mudou. Volte a abrir a respetiva conversa.';

  @override
  String
  get release_core_gateway_queue_screen_disconnected_reconnect_the_chat_then_refresh =>
      'Sem ligação. Volte a ligar a conversa e depois atualize.';

  @override
  String release_core_gateway_queue_screen_gateway_queue_unavailable(
    String reason,
  ) {
    return 'Fila do gateway indisponível: $reason.';
  }

  @override
  String release_core_gateway_queue_screen_not_confirmed_nothing_was_resent(
    String reason,
  ) {
    return 'Não confirmado ($reason). Nada foi reenviado.';
  }

  @override
  String get release_core_gateway_queue_screen_gateway_confirmed_admission =>
      'O gateway confirmou a admissão.';

  @override
  String
  get release_core_gateway_queue_screen_edited_entry_admitted_at_the_end_of_the =>
      'A entrada editada foi admitida no fim da fila.';

  @override
  String get release_core_gateway_queue_screen_discard_unknown_outcome =>
      'Descartar o resultado desconhecido?';

  @override
  String get release_core_gateway_queue_screen_remove_this_entry =>
      'Remover esta entrada?';

  @override
  String
  get release_core_gateway_queue_screen_the_lost_turn_will_not_be_retried_waiting =>
      'O turno perdido não será repetido. Os turnos em espera já podem ser executados.';

  @override
  String
  get release_core_gateway_queue_screen_if_the_gateway_has_just_started_this_entry =>
      'Se o gateway acabou de iniciar esta entrada, removê-la pode parar esse turno.';

  @override
  String get release_core_gateway_queue_screen_keep => 'Manter';

  @override
  String get release_core_gateway_queue_screen_discard_and_resume =>
      'Descartar e retomar';

  @override
  String get release_core_gateway_queue_screen_remove_entry =>
      'Remover entrada';

  @override
  String
  get release_core_gateway_queue_screen_lost_admission_resolved_it_was_not_resent =>
      'A admissão perdida foi resolvida; não foi reenviada.';

  @override
  String get release_core_gateway_queue_screen_gateway_acknowledged_removal =>
      'O gateway confirmou a remoção.';

  @override
  String get release_core_gateway_queue_screen_gateway_queue =>
      'Fila do gateway';

  @override
  String get release_core_gateway_queue_screen_refresh_queue =>
      'Atualizar fila';

  @override
  String get release_core_gateway_queue_screen_queue_paused_unknown_outcome =>
      'Fila em pausa: resultado desconhecido';

  @override
  String
  get release_core_gateway_queue_screen_review_the_lost_admission_before_resuming_nothing_is =>
      'Reveja a admissão perdida antes de retomar. Nada é enviado novamente.';

  @override
  String get release_core_gateway_queue_screen_no_pending_admissions =>
      'Sem admissões pendentes';

  @override
  String get release_core_gateway_queue_screen_discard => 'Descartar…';

  @override
  String
  get release_core_gateway_queue_screen_gateway_acknowledged_the_steering_request =>
      'O gateway confirmou a receção do pedido de reorientação.';

  @override
  String get release_core_gateway_queue_screen_steer_running_turn =>
      'Reorientar o turno em curso';

  @override
  String get release_core_gateway_queue_screen_remove => 'Remover…';

  @override
  String get release_core_gateway_queue_screen_next_prompt =>
      'Instrução seguinte';

  @override
  String get release_core_gateway_queue_screen_edit_queued_prompt =>
      'Editar instrução em fila';

  @override
  String get release_core_gateway_queue_screen_submit_to_gateway_queue =>
      'Enviar para a fila do gateway';

  @override
  String get release_core_gateway_queue_screen_save_at_queue_end =>
      'Guardar no fim da fila';

  @override
  String get release_core_gateway_queue_screen_cancel_edit => 'Cancelar edição';

  @override
  String get release_core_git_review_pane_the_git_operation_did_not_complete =>
      'A operação do Git não foi concluída.';

  @override
  String get release_core_git_review_pane_close_git_review =>
      'Fechar revisão do Git';

  @override
  String get release_core_git_review_pane_pin_lane => 'Fixar faixa';

  @override
  String get release_core_git_review_pane_refresh_git_review =>
      'Atualizar revisão do Git';

  @override
  String get release_core_git_review_pane_uncommitted => 'Por submeter';

  @override
  String get release_core_git_review_pane_last_turn => 'Último turno';

  @override
  String
  get release_core_git_review_pane_branch_and_last_turn_views_are_read_only =>
      'As vistas do ramo e do último turno são apenas de leitura.';

  @override
  String get release_core_git_review_pane_mark_head_as_the_turn_baseline =>
      'Marcar HEAD como referência inicial do turno';

  @override
  String get release_core_git_review_pane_stage_all => 'Preparar tudo';

  @override
  String get release_core_git_review_pane_discard_every_uncommitted_change =>
      'Descartar todas as alterações por submeter?';

  @override
  String
  get release_core_git_review_pane_tracked_files_return_to_head_and_untracked_files =>
      'Os ficheiros controlados regressam a HEAD e os ficheiros não controlados neste diretório de sessão são removidos.';

  @override
  String get release_core_git_review_pane_discard => 'Descartar';

  @override
  String get release_core_git_review_pane_discard_all => 'Descartar tudo';

  @override
  String get release_core_git_review_pane_unstage =>
      'Retirar da área de preparação';

  @override
  String get release_core_git_review_pane_stage => 'Preparar';

  @override
  String get release_core_git_review_pane_discard_file => 'Descartar ficheiro';

  @override
  String release_core_git_review_pane_discard_2(String path) {
    return 'Descartar $path?';
  }

  @override
  String
  get release_core_git_review_pane_this_restores_the_committed_copy_or_removes_the =>
      'Isto restaura a cópia submetida ou remove o ficheiro não controlado.';

  @override
  String get release_core_git_review_pane_commit_message =>
      'Mensagem do commit';

  @override
  String get release_core_git_review_pane_nothing_in_the_diff_to_summarise =>
      'Não há nada no diff para resumir.';

  @override
  String get release_core_git_review_pane_generate_message => 'Gerar mensagem';

  @override
  String get release_core_git_review_pane_commit => 'Criar commit';

  @override
  String get release_core_git_review_pane_commit_and_push =>
      'Criar commit e enviar';

  @override
  String get release_core_git_review_pane_push => 'Enviar alterações';

  @override
  String get release_core_git_review_pane_create_pull_request =>
      'Criar pedido de integração';

  @override
  String get release_core_git_review_pane_pull_request_ready =>
      'Pedido de integração pronto';

  @override
  String get release_core_git_review_pane_ask_hermes_to_ship =>
      'Pedir ao Hermes para publicar as alterações';

  @override
  String get release_core_git_review_pane_gh_is_authenticated_on_this_gateway =>
      'O gh está autenticado neste gateway.';

  @override
  String
  get release_core_git_review_pane_install_the_github_cli_gh_and_sign_in =>
      'Instale a CLI do GitHub (gh) e inicie sessão para abrir pedidos de integração';

  @override
  String get release_core_git_review_pane_worktrees => 'Árvores de trabalho';

  @override
  String get release_core_git_review_pane_main => 'Principal';

  @override
  String release_core_git_review_pane_follow(String branch) {
    return 'Seguir $branch?';
  }

  @override
  String
  get release_core_git_review_pane_the_session_working_directory_becomes_this_worktree_unless =>
      'O diretório de trabalho da sessão passa a ser esta árvore de trabalho, a menos que a faixa esteja fixa.';

  @override
  String get release_core_git_review_pane_follow_2 => 'Seguir';

  @override
  String release_core_git_review_pane_remove(String branch) {
    return 'Remover $branch?';
  }

  @override
  String get release_core_git_review_pane_the_worktree_directory_is_removed =>
      'O diretório da árvore de trabalho é removido.';

  @override
  String get release_core_git_review_pane_remove_2 => 'Remover';

  @override
  String get release_core_git_review_pane_new_worktree_name =>
      'Nome da nova árvore de trabalho';

  @override
  String get release_core_git_review_pane_new_branch => 'Novo ramo';

  @override
  String get release_core_git_review_pane_base_branch => 'Ramo base';

  @override
  String get release_core_git_review_pane_create_worktree =>
      'Criar árvore de trabalho';

  @override
  String get release_core_git_review_pane_existing_branch => 'Ramo existente';

  @override
  String get release_core_git_review_pane_convert_branch_to_worktree =>
      'Converter ramo em árvore de trabalho';

  @override
  String get release_core_git_review_pane_switch_branch => 'Mudar de ramo';

  @override
  String
  get release_core_git_review_pane_this_gateway_does_not_support_that_git_operation =>
      'Este gateway não suporta essa operação do Git.';

  @override
  String
  get release_core_git_review_pane_git_needs_the_session_directory_on_the_local =>
      'O Git precisa do diretório da sessão no backend de terminal local.';

  @override
  String
  get release_core_git_review_pane_the_gateway_refused_the_git_operation =>
      'O gateway recusou a operação do Git.';

  @override
  String
  get release_core_git_review_pane_the_session_changed_refresh_and_try_again =>
      'A sessão mudou. Atualize e tente novamente.';

  @override
  String
  get release_core_git_review_pane_this_review_is_no_longer_the_selected_session =>
      'Esta revisão já não corresponde à sessão selecionada.';

  @override
  String
  get release_core_git_review_pane_the_gateway_returned_an_unexpected_git_result =>
      'O gateway devolveu um resultado inesperado do Git.';

  @override
  String
  get release_core_git_review_pane_git_review_requires_the_gateway_transport =>
      'A revisão do Git requer o transporte do gateway.';

  @override
  String get release_core_client_held_queue_bar_resume => 'Retomar';

  @override
  String get release_core_client_held_queue_bar_send_queued_prompt =>
      'Enviar instrução em fila';

  @override
  String get release_core_client_held_queue_bar_edit_unsent_prompt =>
      'Editar instrução não enviada';

  @override
  String get release_core_client_held_queue_bar_remove_unsent_prompt =>
      'Remover instrução não enviada';

  @override
  String get release_core_workspace_discovery_view_repository_discovery =>
      'Descoberta de repositórios';

  @override
  String get release_core_workspace_discovery_view_refresh_results =>
      'Atualizar resultados';

  @override
  String release_core_workspace_discovery_view_hide(String path) {
    return 'Ocultar $path';
  }

  @override
  String
  get release_core_workspace_discovery_view_invalid_path_or_discovery_data_use_absolute_server =>
      'Caminho ou dados de descoberta inválidos. Utilize caminhos absolutos do servidor sem componentes «.» ou «..».';

  @override
  String
  get release_core_workspace_discovery_view_this_gateway_does_not_support_repository_discovery =>
      'Este gateway não suporta a descoberta de repositórios.';

  @override
  String
  get release_core_workspace_discovery_view_the_gateway_denied_access_to_repository_discovery =>
      'O gateway recusou o acesso à descoberta de repositórios.';

  @override
  String
  get release_core_workspace_discovery_view_the_connection_changed_reopen_discovery_on_the_current =>
      'A ligação mudou. Volte a abrir a descoberta no gateway atual.';

  @override
  String
  get release_core_workspace_discovery_view_the_displayed_settings_have_changed_refresh_before_trying =>
      'As definições apresentadas mudaram. Atualize antes de tentar novamente.';

  @override
  String
  get release_core_workspace_discovery_view_could_not_load_or_verify_discovery_settings_refresh =>
      'Não foi possível carregar ou verificar as definições de descoberta. Atualize para tentar novamente.';

  @override
  String release_core_workspace_discovery_view_repositories_shown_of(
    int visible,
    int total,
  ) {
    return 'Repositórios apresentados: $visible de $total';
  }

  @override
  String
  get release_core_workspace_discovery_view_the_gateway_returned_no_repositories =>
      'O gateway não devolveu nenhum repositório.';

  @override
  String
  get release_core_workspace_discovery_view_no_repositories_match_your_device_filters =>
      'Nenhum repositório corresponde aos filtros do dispositivo.';

  @override
  String get release_core_workspace_discovery_view_gateway_scan_policy =>
      'Política de pesquisa do gateway';

  @override
  String
  get release_core_workspace_discovery_view_this_gateway_did_not_report_a_scan_policy =>
      'Este gateway não indicou uma política de pesquisa.';

  @override
  String
  get release_core_workspace_discovery_view_to_scan_folders_configure_repository_scanning_in_the =>
      'Para pesquisar pastas, configure a pesquisa de repositórios nas definições do Desktop do perfil do gateway.';

  @override
  String
  get release_core_workspace_discovery_view_results_can_include_cached_repositories_and_repositories_with =>
      'Os resultados podem incluir repositórios em cache e repositórios com sessões. Uma pesquisa não garante que todas as pastas tenham sido alcançadas.';

  @override
  String get release_core_workspace_discovery_view_scan_gateway_roots =>
      'Pesquisar nas raízes do gateway';

  @override
  String
  get release_core_workspace_discovery_view_filter_results_on_this_device =>
      'Filtrar resultados neste dispositivo';

  @override
  String
  get release_core_workspace_discovery_view_only_this_discovery_list_changes_not_the_gateway =>
      'Apenas esta lista de descoberta muda, não a pesquisa do gateway.';

  @override
  String get release_core_workspace_discovery_view_include_subtrees_empty_all =>
      'Incluir subárvores (vazio = todas)';

  @override
  String get release_core_workspace_discovery_view_exclude_subtrees =>
      'Excluir subárvores';

  @override
  String get release_core_workspace_discovery_view_apply_filters =>
      'Aplicar filtros';

  @override
  String release_core_workspace_discovery_view_hidden_repositories(int count) {
    return 'Repositórios ocultos ($count)';
  }

  @override
  String get release_core_workspace_discovery_view_undo_hide =>
      'Anular ocultação';

  @override
  String
  get release_core_workspace_discovery_view_one_absolute_server_path_per_line =>
      'Um caminho absoluto do servidor por linha';

  @override
  String get release_core_project_settings_view_project_settings =>
      'Definições do projeto';

  @override
  String
  get release_core_project_settings_view_the_gateway_did_not_confirm_the_selected_project =>
      'O gateway não confirmou o projeto selecionado ou a alteração. Reveja as definições antes de tentar novamente.';

  @override
  String
  get release_core_project_settings_view_could_not_verify_these_settings_use_one_absolute =>
      'Não foi possível verificar estas definições. Utilize um caminho absoluto de pasta do servidor por linha, sem componentes «.» ou «..».';

  @override
  String get release_core_project_settings_view_set_active => 'Ativar';

  @override
  String get release_core_project_settings_view_icon => 'Ícone';

  @override
  String get release_core_project_settings_view_folder => 'Pasta';

  @override
  String get release_core_project_settings_view_repository => 'Repositório';

  @override
  String get release_core_project_settings_view_rocket => 'Foguetão';

  @override
  String get release_core_project_settings_view_star => 'Estrela';

  @override
  String get release_core_project_settings_view_book => 'Livro';

  @override
  String get release_core_project_settings_view_terminal => 'Terminal';

  @override
  String get release_core_project_settings_view_colour => 'Cor';

  @override
  String get release_core_project_settings_view_primary_folder =>
      'Pasta principal';

  @override
  String get release_core_project_settings_view_server_folder_paths =>
      'Caminhos de pastas do servidor';

  @override
  String
  get release_core_project_settings_view_one_absolute_path_per_line_existing_folders_are =>
      'Um caminho absoluto por linha. As pastas existentes são mantidas.';

  @override
  String get release_core_project_settings_view_add_folders =>
      'Adicionar pastas';

  @override
  String release_core_project_settings_view_choose(String label) {
    return 'Escolher $label';
  }

  @override
  String
  get release_core_prepared_image_recovery_wait_for_an_empty_draft_before_restoring =>
      'Aguarde que o rascunho esteja vazio antes de restaurar.';

  @override
  String
  get release_core_prepared_image_recovery_no_unacknowledged_image_drafts_in_this_chat =>
      'Não há rascunhos de imagens sem confirmação de receção nesta conversa.';

  @override
  String get release_core_prepared_image_recovery_unacknowledged_image_drafts =>
      'Rascunhos de imagens sem confirmação de receção';

  @override
  String
  get release_core_prepared_image_recovery_the_gateway_may_already_have_received_these_restore =>
      'O gateway pode já tê-los recebido. Restaure para rever; nada é enviado.';

  @override
  String get release_core_prepared_image_recovery_image_draft =>
      'Rascunho de imagem';

  @override
  String get release_core_prepared_image_recovery_discard_local_copy =>
      'Descartar cópia local';

  @override
  String
  get release_core_prepared_image_recovery_discard_this_local_image_draft =>
      'Descartar este rascunho de imagem local?';

  @override
  String
  get release_core_prepared_image_recovery_image_draft_recovery_is_unavailable =>
      'A recuperação de rascunhos de imagens está indisponível.';

  @override
  String get release_core_prepared_image_recovery_recover_image_draft =>
      'Recuperar rascunho de imagem…';

  @override
  String get release_core_session_search_mode_menu_could_not_save_search_mode =>
      'Não foi possível guardar o modo de pesquisa.';

  @override
  String get release_core_projects_pane_discover_repositories =>
      'Descobrir repositórios';

  @override
  String
  get release_core_projects_pane_project_created_but_the_gateway_did_not_confirm =>
      'O projeto foi criado, mas o gateway não confirmou a respetiva ideia.';

  @override
  String get release_core_projects_pane_project_idea_optional =>
      'Ideia do projeto (opcional)';

  @override
  String
  get release_core_projects_pane_saved_in_the_project_description_not_a_file =>
      'Guardada na descrição do projeto, não num ficheiro.';

  @override
  String get release_core_project_detail_screen_new_chat_in_this_lane =>
      'Nova conversa nesta faixa';

  @override
  String get release_core_project_detail_screen_review_git => 'Rever Git';

  @override
  String get release_core_more_pane_gateway_fleet => 'Frota de gateways';

  @override
  String
  get release_core_more_pane_connected_sessions_hermes_cloud_and_desktop_webapp =>
      'Sessões ligadas, Hermes Cloud e aplicação Web do Desktop';

  @override
  String get release_core_more_pane_use_dashboard_sign_in_for_a_named_profile =>
      'Utilize o início de sessão do painel para um perfil com nome. Esta API antiga não consegue confirmar a que perfil pertence o histórico da conversa.';

  @override
  String get release_core_more_pane_capabilities => 'Capacidades';

  @override
  String
  get release_core_more_pane_install_and_govern_skills_plugins_connectors_and_tool =>
      'Instale e administre competências, plugins, conectores e backends de ferramentas';

  @override
  String get release_core_more_pane_browser_vault => 'Cofre do navegador';

  @override
  String
  get release_core_more_pane_site_logins_addresses_cards_and_credential_sources =>
      'Inícios de sessão em sites, moradas, cartões e fontes de credenciais';

  @override
  String get release_core_more_pane_agent_policy => 'Política do agente';

  @override
  String
  get release_core_more_pane_approvals_checkpoints_browser_access_and_shared_metrics =>
      'Aprovações, pontos de controlo, acesso ao navegador e métricas partilhadas';

  @override
  String get release_core_more_pane_remote_logs_health_maintenance_and_update =>
      'Registos remotos, estado, manutenção e atualização';

  @override
  String get release_core_more_pane_schedules => 'Agendamentos';

  @override
  String get release_core_more_pane_all_profiles_blueprints_catch_up_and_stop =>
      'Todos os perfis, modelos, recuperação de execuções em falta e paragem';

  @override
  String get release_core_more_pane_memory_graph => 'Grafo de memória';

  @override
  String get release_core_more_pane_timeline_edits_and_memory_providers =>
      'Cronologia, edições e fornecedores de memória';

  @override
  String get release_core_more_pane_providers_and_routes =>
      'Fornecedores e rotas';

  @override
  String get release_core_more_pane_keys_endpoints_delegation_and_mixtures =>
      'Chaves, endpoints, delegação e misturas';

  @override
  String get release_core_more_pane_credits_and_plans => 'Créditos e planos';

  @override
  String
  get release_core_more_pane_consented_nous_billing_when_the_account_allows_it =>
      'Faturação da Nous com consentimento quando a conta o permite';

  @override
  String
  get release_core_fleet_screen_this_gateway_does_not_offer_this_service =>
      'Este gateway não disponibiliza este serviço.';

  @override
  String
  get release_core_fleet_screen_sign_in_or_permission_required_on_this_gateway =>
      'Este gateway requer início de sessão ou permissão.';

  @override
  String get release_core_fleet_screen_a_secure_gateway_address_is_required =>
      'É necessário um endereço seguro do gateway.';

  @override
  String
  get release_core_fleet_screen_the_owner_changed_refresh_before_continuing =>
      'O proprietário mudou. Atualize antes de continuar.';

  @override
  String
  get release_core_fleet_screen_could_not_verify_the_operation_check_the_gateway =>
      'Não foi possível verificar a operação. Verifique o gateway e atualize.';

  @override
  String get release_core_fleet_screen_verified_ssh => 'SSH verificado';

  @override
  String
  get release_core_fleet_screen_confirm_a_host_key_inspect_a_remote_service =>
      'Confirme uma chave de anfitrião, inspecione um serviço remoto ou abra a respetiva shell';

  @override
  String get release_core_fleet_screen_cloud_and_desktop_webapp =>
      'Cloud e aplicação Web do Desktop';

  @override
  String get release_core_fleet_screen_register_an_existing_gateway_or_webapp =>
      'Registar um gateway ou uma aplicação Web existente';

  @override
  String
  get release_core_fleet_screen_sign_in_to_its_address_nothing_is_hosted =>
      'Inicie sessão no respetivo endereço. Nada é alojado neste dispositivo.';

  @override
  String get release_core_fleet_screen_fleet_updates => 'Atualizações da frota';

  @override
  String get release_core_fleet_screen_refresh_roster =>
      'Atualizar lista de gateways';

  @override
  String release_core_fleet_screen_disconnect(String gateway) {
    return 'Desligar $gateway';
  }

  @override
  String get release_core_fleet_screen_open_this_gateway_on_launch =>
      'Abrir este gateway ao iniciar';

  @override
  String
  get release_core_fleet_screen_primary_for_ares_does_not_change_the_last =>
      'Principal para o Ares; não altera o último gateway utilizado.';

  @override
  String get release_core_fleet_screen_reconnect_in_fleet_on_launch =>
      'Voltar a ligar na frota ao iniciar';

  @override
  String get release_core_fleet_screen_no_sessions_for_this_profile =>
      'Sem sessões para este perfil.';

  @override
  String get release_core_fleet_screen_more_sessions => 'Mais sessões';

  @override
  String get release_core_fleet_screen_this_gateway_was_disconnected =>
      'Este gateway foi desligado.';

  @override
  String
  get release_core_fleet_screen_some_conversation_data_could_not_be_loaded =>
      'Não foi possível carregar alguns dados da conversa.';

  @override
  String get release_core_fleet_screen_message_this_session =>
      'Enviar uma mensagem para esta sessão';

  @override
  String get release_core_fleet_screen_send_to_this_session =>
      'Enviar para esta sessão';

  @override
  String get release_core_fleet_updates_screen_update_these_remote_gateways =>
      'Atualizar estes gateways remotos?';

  @override
  String
  release_core_fleet_updates_screen_this_can_restart_the_backend_and_interrupt_other(
    String gateways,
  ) {
    return 'Isto pode reiniciar o backend e interromper outros utilizadores. Não irá atualizar o Ares.\n\n$gateways';
  }

  @override
  String get release_core_fleet_updates_screen_update_listed_gateways =>
      'Atualizar os gateways da lista';

  @override
  String
  get release_core_fleet_updates_screen_checks_connected_gateways_cloud_is_platform_managed_entries =>
      'Verifica os gateways ligados. O Cloud é gerido pela plataforma; as entradas sem proveniência de registo são excluídas.';

  @override
  String get release_core_fleet_updates_screen_check_connected_gateways =>
      'Verificar gateways ligados';

  @override
  String get release_core_fleet_updates_screen_read_update_receipt =>
      'Consultar comprovativo da atualização';

  @override
  String get release_core_fleet_updates_screen_review_eligible_updates =>
      'Rever atualizações elegíveis';

  @override
  String
  get release_core_fleet_webapp_screen_account_changed_reopen_this_page =>
      'A conta mudou. Volte a abrir esta página.';

  @override
  String
  get release_core_fleet_webapp_screen_set_the_webapp_s_primary_gateway =>
      'Definir o gateway principal da aplicação Web?';

  @override
  String
  release_core_fleet_webapp_screen_this_changes_the_shared_registry_not_the_last(
    String webapp,
    String gateway,
    String id,
  ) {
    return '$webapp → $gateway ($id)\nIsto altera o registo partilhado, não o último gateway utilizado.';
  }

  @override
  String get release_core_fleet_webapp_screen_set_primary =>
      'Definir como principal';

  @override
  String get release_core_fleet_webapp_screen_serving_profile =>
      'Perfil que serve a aplicação';

  @override
  String get release_core_fleet_webapp_screen_hermes_cloud => 'Hermes Cloud';

  @override
  String get release_core_fleet_webapp_screen_discover_signed_in_agents =>
      'Descobrir agentes com sessão iniciada';

  @override
  String release_core_fleet_webapp_screen_organisation(String organisation) {
    return 'Organização: $organisation';
  }

  @override
  String get release_core_fleet_webapp_screen_no_agents_available =>
      'Sem agentes disponíveis.';

  @override
  String get release_core_fleet_webapp_screen_existing_desktop_webapp =>
      'Aplicação Web do Desktop existente';

  @override
  String
  get release_core_fleet_webapp_screen_check_gateway_and_web_access_status =>
      'Verificar o estado do gateway e do acesso Web';

  @override
  String
  get release_core_fleet_webapp_screen_these_settings_belong_to_the_machine_serving_this =>
      'Estas definições pertencem à máquina que serve esta aplicação Web. A publicação e os reinícios não são ações remotas.';

  @override
  String get release_core_fleet_webapp_screen_read_webapp_gateway_registry =>
      'Consultar o registo de gateways da aplicação Web';

  @override
  String get release_core_fleet_webapp_screen_last_used => 'Último utilizado';

  @override
  String get release_core_fleet_webapp_screen_primary => 'Principal';

  @override
  String release_core_fleet_webapp_screen_set_primary_2(String gateway) {
    return 'Definir como principal: $gateway';
  }

  @override
  String get release_core_fleet_webapp_screen_read_shared_display_preferences =>
      'Consultar preferências de apresentação partilhadas';

  @override
  String
  get release_core_fleet_webapp_screen_chat_text_direction_on_this_webapp_and_desktop =>
      'Direção do texto da conversa nesta aplicação Web e no Desktop';

  @override
  String release_core_schedule_desk_screen_created_on(
    String job,
    String profile,
  ) {
    return '$job criado em $profile.';
  }

  @override
  String
  get release_core_schedule_desk_screen_the_list_covers_every_profile_on_this_gateway =>
      'A lista abrange todos os perfis deste gateway. As ações de parar, pausar, recuperar execuções em falta, entrega e modelos são enviadas para o perfil ao qual pertence a tarefa.';

  @override
  String get release_core_schedule_desk_screen_a_run_is_in_progress =>
      'Há uma execução em curso';

  @override
  String get release_core_schedule_desk_screen_no_current_run =>
      'Sem execução em curso';

  @override
  String release_core_schedule_desk_screen_stop_requested_for(String job) {
    return 'Foi pedida a paragem de $job.';
  }

  @override
  String release_core_schedule_desk_screen_no_run_was_in_flight_for(
    String job,
  ) {
    return 'Não havia nenhuma execução em curso para $job.';
  }

  @override
  String get release_core_schedule_desk_screen_stop_current_run =>
      'Parar execução atual';

  @override
  String get release_core_schedule_desk_screen_pause_future_runs =>
      'Pausar execuções futuras';

  @override
  String get release_core_schedule_desk_screen_resume_future_runs =>
      'Retomar execuções futuras';

  @override
  String get release_core_schedule_desk_screen_catch_up_default =>
      'Recuperação predefinida de execuções em falta';

  @override
  String get release_core_schedule_desk_screen_run_one_missed =>
      'Executar uma em falta';

  @override
  String get release_core_schedule_desk_screen_skip_missed =>
      'Ignorar execuções em falta';

  @override
  String get release_core_schedule_desk_screen_blueprint_recipes =>
      'Receitas de modelos';

  @override
  String get release_core_schedule_desk_screen_profile_for_the_new_job =>
      'Perfil para a nova tarefa';

  @override
  String release_core_schedule_desk_screen_create(String blueprint) {
    return 'Criar $blueprint';
  }

  @override
  String get release_core_schedule_desk_screen_loading_delivery_targets =>
      'A carregar destinos de entrega';

  @override
  String release_core_schedule_desk_screen_no_home_channel(String target) {
    return '$target (sem canal principal)';
  }

  @override
  String release_core_memory_graph_screen_edit(String label) {
    return 'Editar $label';
  }

  @override
  String get release_core_memory_graph_screen_content => 'Conteúdo';

  @override
  String get release_core_memory_graph_screen_archive_skill =>
      'Arquivar competência';

  @override
  String get release_core_memory_graph_screen_delete_memory =>
      'Eliminar memória';

  @override
  String release_core_memory_graph_screen_archive_on_it_can_be_restored_on_the(
    String label,
    String profile,
  ) {
    return 'Arquivar $label em $profile? Pode ser restaurado no anfitrião com o Curator.';
  }

  @override
  String release_core_memory_graph_screen_delete_from_this_removes_that_memory(
    String label,
    String profile,
  ) {
    return 'Eliminar $label de $profile? Isto remove essa memória.';
  }

  @override
  String get release_core_memory_graph_screen_filter => 'Filtrar';

  @override
  String get release_core_memory_graph_screen_timeline => 'Cronologia';

  @override
  String get release_core_memory_graph_screen_play_timeline =>
      'Reproduzir cronologia';

  @override
  String get release_core_memory_graph_screen_layout_code =>
      'Código de disposição';

  @override
  String get release_core_memory_graph_screen_external_memory_providers =>
      'Fornecedores externos de memória';

  @override
  String
  get release_core_memory_graph_screen_a_value_is_stored_leave_blank_to_keep =>
      'Há um valor guardado. Deixe em branco para o manter.';

  @override
  String get release_core_memory_graph_screen_save_provider =>
      'Guardar fornecedor';

  @override
  String release_core_workspace_profiles_screen_applies_to(String profile) {
    return 'Aplica-se a: $profile';
  }

  @override
  String get release_core_workspace_profiles_screen_choose_another_profile =>
      'Escolher outro perfil';

  @override
  String
  get release_core_workspace_profiles_screen_could_not_verify_the_selected_profile_on_this =>
      'Não foi possível verificar o perfil selecionado neste gateway.';

  @override
  String get release_core_workspace_profiles_screen_create_profile =>
      'Criar perfil';

  @override
  String get release_core_workspace_profiles_screen_new_profile_id =>
      'ID do novo perfil';

  @override
  String get release_core_assets_screen_links => 'Ligações';

  @override
  String get release_core_workspace_picker_no_matching_items =>
      'Sem itens correspondentes.';

  @override
  String get release_core_workspace_picker_save_layout => 'Guardar disposição';

  @override
  String get release_core_workspace_picker_layout_name => 'Nome da disposição';

  @override
  String
  get release_core_workspace_popout_this_chat_already_has_a_pop_out_window =>
      'Esta conversa já tem uma janela independente.';

  @override
  String
  get release_core_workspace_popout_could_not_open_this_saved_chat_check_the =>
      'Não foi possível abrir esta conversa guardada. Verifique a ligação e tente novamente.';

  @override
  String
  get release_core_popout_bootstrap_use_the_main_window_to_change_your_connection =>
      'Utilize a janela principal para alterar a ligação.';

  @override
  String get release_core_guarded_save_refused =>
      'Este ficheiro não pode ser guardado pelo gateway';

  @override
  String get release_core_guarded_save_unavailable =>
      'A gravação protegida não está disponível neste gateway';

  @override
  String release_core_git_files_changed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ficheiros alterados neste turno',
      one: '1 ficheiro alterado neste turno',
    );
    return '$_temp0';
  }

  @override
  String release_core_git_entries_omitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Foram omitidas $count entradas do Git porque não era seguro apresentá-las.',
      one: 'Foi omitida 1 entrada do Git porque não era seguro apresentá-la.',
    );
    return '$_temp0';
  }

  @override
  String get release_core_git_staged => 'Preparado';

  @override
  String get release_core_session_sort_recent => 'Atividade recente';

  @override
  String get release_core_session_sort_created => 'Criadas mais recentemente';

  @override
  String get release_core_session_sort_status => 'Em execução primeiro';

  @override
  String get release_core_session_sort_tokens => 'Mais tokens';

  @override
  String get release_core_session_sort_cost => 'Custo mais elevado';

  @override
  String get release_core_session_group_standard => 'Agrupamento predefinido';

  @override
  String get release_core_session_group_status => 'Agrupar por estado';

  @override
  String get release_core_session_group_project => 'Agrupar por projeto';

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
      'O envio cria um novo turno';

  @override
  String release_core_image_recovery_metadata(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imagens · $date',
      one: '1 imagem · $date',
    );
    return '$_temp0';
  }

  @override
  String release_core_discovery_scanning(String state) {
    return 'Pesquisa: $state';
  }

  @override
  String get release_core_discovery_enabled => 'ativada';

  @override
  String get release_core_discovery_disabled => 'desativada';

  @override
  String get release_core_discovery_none => 'nenhuma';

  @override
  String release_core_discovery_roots(String paths) {
    return 'Raízes de pesquisa: $paths';
  }

  @override
  String release_core_discovery_excluded(String paths) {
    return 'Subárvores excluídas: $paths';
  }

  @override
  String release_core_discovery_repository_sessions(String path, int count) {
    return '$path\nSessões: $count';
  }

  @override
  String get release_core_projects_local_only =>
      'Este gateway do Hermes é anterior aos projetos no servidor, pelo que as conversas só ficam agrupadas neste dispositivo. Atualize o Hermes para partilhar os mesmos projetos entre os seus dispositivos.';

  @override
  String get release_core_fleet_no_address => 'Ainda sem endereço do gateway';

  @override
  String release_core_fleet_diagnostics(String version, String access) {
    return 'Gateway $version · $access';
  }

  @override
  String get release_core_schedule_builtin => 'integrado';

  @override
  String get release_core_memory_gateway_profile => 'gateway';

  @override
  String release_core_memory_profile_summary(String profile, String gateway) {
    return 'Perfil $profile em $gateway. O código de partilha guarda apenas o zoom, o tempo e os filtros.';
  }

  @override
  String release_core_memory_layers_summary(
    int memoryBytes,
    int userBytes,
    String provider,
  ) {
    return 'Memória integrada: $memoryBytes bytes; utilizador: $userBytes bytes. Fornecedor ativo: $provider.';
  }

  @override
  String get release_core_memory_kind_all => 'Todos';

  @override
  String get release_core_memory_kind_skill => 'Competências';

  @override
  String get release_core_memory_kind_memory => 'Memória';

  @override
  String get release_core_workspace_failure_stale => 'a ligação mudou';

  @override
  String get release_core_workspace_failure_unbound =>
      'sem diretório de trabalho verificado';

  @override
  String get release_core_workspace_failure_denied => 'permissão recusada';

  @override
  String get release_core_workspace_failure_ineligible =>
      'operação não permitida para este ficheiro';

  @override
  String get release_core_workspace_failure_unsupported =>
      'não suportado por este gateway';

  @override
  String get release_core_workspace_failure_mismatch => 'o estado remoto mudou';

  @override
  String get release_core_workspace_failure_invalid =>
      'resposta inválida do gateway';

  @override
  String get release_core_workspace_failure_insecure =>
      'é necessária uma ligação segura';

  @override
  String get release_core_workspace_failure_unavailable =>
      'gateway indisponível';

  @override
  String get release_core_queue_state_queued => 'Em fila';

  @override
  String get release_core_queue_state_started => 'Iniciado';

  @override
  String get release_core_queue_state_unknown => 'Resultado desconhecido';

  @override
  String get release_core_unknown_state => 'Desconhecido';

  @override
  String get release_core_fleet_state_idle => 'Sem ligação';

  @override
  String get release_core_fleet_state_connected => 'Ligado';

  @override
  String get release_core_fleet_state_reconnecting => 'A voltar a ligar…';

  @override
  String get release_core_fleet_state_sessionExpired => 'Sessão terminada';

  @override
  String get release_core_fleet_state_failed => 'Falha na ligação';

  @override
  String release_core_workspace_operation_failed(String reason) {
    return 'Não foi possível confirmar a operação do gateway: $reason.';
  }

  @override
  String get release_core_workspace_invalid_data =>
      'Não foi possível verificar os dados ou a entrada. Reveja-os e tente novamente.';

  @override
  String
  get release_core_parallel_workspace_layout_changed_in_this_window_but_could_not =>
      'A disposição mudou nesta janela, mas não foi possível guardá-la.';

  @override
  String get release_core_parallel_workspace_first_pane => 'Primeiro painel';

  @override
  String get release_core_parallel_workspace_second_pane => 'Segundo painel';

  @override
  String get release_core_parallel_workspace_unavailable_page =>
      'Página indisponível';

  @override
  String release_core_parallel_workspace_close_a_tab_first_maximum(
    String maximum,
  ) {
    return 'Feche primeiro um separador (máximo $maximum).';
  }

  @override
  String get release_core_parallel_workspace_dock_beside_current_pane =>
      'Ancorar ao lado do painel atual';

  @override
  String get release_core_parallel_workspace_add_chat => 'Adicionar conversa';

  @override
  String
  get release_core_parallel_workspace_action_failed_check_the_connection_and_try_again =>
      'A ação falhou. Verifique a ligação e tente novamente.';

  @override
  String
  get release_core_parallel_workspace_close_a_tab_before_reopening_another =>
      'Feche um separador antes de voltar a abrir outro.';

  @override
  String release_core_parallel_workspace_replace_layout(String name) {
    return 'Substituir a disposição «$name»?';
  }

  @override
  String
  get release_core_parallel_workspace_layout_limit_reached_replace_an_existing_layout =>
      'Foi atingido o limite de disposições. Substitua uma disposição existente.';

  @override
  String get release_core_parallel_workspace_restore_layout =>
      'Restaurar disposição';

  @override
  String get release_core_parallel_workspace_workspace_options =>
      'Opções do espaço de trabalho';

  @override
  String get release_core_parallel_workspace_dock_another_pane =>
      'Ancorar outro painel';

  @override
  String get release_core_parallel_workspace_swap_panes => 'Trocar painéis';

  @override
  String get release_core_parallel_workspace_undock_second_pane =>
      'Desancorar segundo painel';

  @override
  String get release_core_parallel_workspace_arrange_side_by_side =>
      'Dispor lado a lado';

  @override
  String get release_core_parallel_workspace_arrange_top_to_bottom =>
      'Dispor um por cima do outro';

  @override
  String release_core_parallel_workspace_change_split_size(String percent) {
    return 'Alterar proporção da divisão ($percent%)';
  }

  @override
  String get release_core_parallel_workspace_focus_pane_full_screen =>
      'Focar painel em ecrã inteiro';

  @override
  String get release_core_parallel_workspace_open_chat_in_new_window =>
      'Abrir conversa numa nova janela';

  @override
  String get release_core_parallel_workspace_hide_pane_keep_running =>
      'Ocultar painel (manter em execução)';

  @override
  String get release_core_parallel_workspace_previous_tab =>
      'Separador anterior';

  @override
  String get release_core_parallel_workspace_next_tab => 'Separador seguinte';

  @override
  String get release_core_parallel_workspace_move_tab_left =>
      'Mover separador para a esquerda';

  @override
  String get release_core_parallel_workspace_move_tab_right =>
      'Mover separador para a direita';

  @override
  String get release_core_parallel_workspace_reload_current_tab =>
      'Voltar a carregar o separador atual';

  @override
  String get release_core_parallel_workspace_close_tab => 'Fechar separador';

  @override
  String get release_core_parallel_workspace_close_other_tabs =>
      'Fechar os outros separadores';

  @override
  String get release_core_parallel_workspace_close_tabs_to_the_right =>
      'Fechar separadores à direita';

  @override
  String get release_core_parallel_workspace_close_all_tabs =>
      'Fechar todos os separadores';

  @override
  String get release_core_parallel_workspace_reopen_closed_tab =>
      'Reabrir separador fechado';

  @override
  String get release_core_parallel_workspace_save_named_layout =>
      'Guardar disposição com nome';

  @override
  String get release_core_parallel_workspace_restore_named_layout =>
      'Restaurar disposição com nome';

  @override
  String get release_core_parallel_workspace_refresh_chat_list =>
      'Atualizar lista de conversas';

  @override
  String get release_core_parallel_workspace_workspace_tools =>
      'Ferramentas do espaço de trabalho';

  @override
  String get release_core_parallel_workspace_choose_a_chat_for_this_pane =>
      'Escolha uma conversa para este painel';

  @override
  String release_core_parallel_workspace_choose_chat_for(String pane) {
    return 'Escolher conversa para $pane';
  }

  @override
  String get release_core_parallel_workspace_add_a_chat_to_start_a_workspace =>
      'Adicione uma conversa para iniciar um espaço de trabalho.';

  @override
  String get release_core_parallel_workspace_select_a_tab_to_show_its_pane =>
      'Selecione um separador para mostrar o respetivo painel.';

  @override
  String get release_core_parallel_workspace_parallel_workspace =>
      'Espaço de trabalho em paralelo';

  @override
  String get release_core_parallel_workspace_show_workspace =>
      'Mostrar espaço de trabalho';

  @override
  String get release_core_parallel_workspace_could_not_load_chats_retry =>
      'Não foi possível carregar as conversas. Tentar novamente';

  @override
  String release_core_parallel_workspace_close(String pane) {
    return 'Fechar $pane';
  }

  @override
  String release_core_parallel_workspace_switch_pane(String pane) {
    return 'Mudar de painel: $pane';
  }

  @override
  String get release_core_workspace_registry_session_id_copied =>
      'ID da sessão copiado.';

  @override
  String get release_core_workspace_registry_chat_details =>
      'Detalhes da conversa';

  @override
  String get release_core_workspace_registry_server_default =>
      'Predefinição do servidor';

  @override
  String get release_core_workspace_registry_session_id => 'ID da sessão';

  @override
  String get release_core_workspace_registry_title => 'Título';

  @override
  String get release_core_workspace_label_terminals => 'Terminais';

  @override
  String get release_core_workspace_label_copy_id => 'Copiar ID da sessão';

  @override
  String get release_core_workspace_label_contributions => 'Contribuições';

  @override
  String get release_core_workspace_owner_inactive =>
      'O proprietário deste espaço de trabalho já não está ativo.';

  @override
  String get release_core_workspace_select_chat =>
      'Selecione primeiro uma conversa.';

  @override
  String get release_core_workspace_chat_unavailable =>
      'Esta conversa não está disponível para esta ligação.';

  @override
  String get release_core_workspace_page_unavailable =>
      'Esta página não está disponível para esta ligação.';

  @override
  String release_core_client_queue_count(int count) {
    return '$count em fila';
  }

  @override
  String release_core_client_queue_paused_count(int count) {
    return '$count em fila — em pausa';
  }

  @override
  String release_core_git_diff_truncated(String diff) {
    return '$diff\n… truncado';
  }

  @override
  String get release_core_search_no_models =>
      'O Hermes não devolveu nenhum modelo configurado que possa ser selecionado.';

  @override
  String get release_core_chat_archive_unavailable =>
      'A ação de arquivar a conversa está indisponível.';

  @override
  String get release_core_chat_pin_unconfirmed =>
      'O estado de fixação não foi confirmado.';

  @override
  String get release_core_chat_archive_unconfirmed =>
      'O estado de arquivo não foi confirmado.';

  @override
  String get release_core_chat_archive_history_unavailable =>
      'Histórico arquivado indisponível';

  @override
  String get release_core_quick_chat_history_unavailable =>
      'Histórico da conversa rápida indisponível';

  @override
  String get release_core_chat_project_ownership_unavailable =>
      'Propriedade do projeto indisponível';

  @override
  String get release_core_chat_unknown_project => 'Projeto desconhecido';

  @override
  String get release_core_chat_local_search_fallback =>
      'Pesquisa de mensagens indisponível. A mostrar correspondências locais.';

  @override
  String release_core_fleet_update_eligible(String version) {
    return 'Elegível · $version';
  }

  @override
  String get release_core_fleet_update_state_1 => 'Ignorado: mesma instalação';

  @override
  String get release_core_fleet_update_state_2 => 'Não verificado';

  @override
  String get release_core_fleet_update_state_3 => 'Ignorado: gerido pelo Cloud';

  @override
  String get release_core_fleet_update_state_4 =>
      'Ignorado: não registado como gateway direto';

  @override
  String get release_core_fleet_update_state_5 =>
      'Ignorado: desligado ou ocupado';

  @override
  String get release_core_fleet_update_state_6 => 'Sem atualização aplicável';

  @override
  String get release_core_fleet_update_state_7 =>
      'Não foi possível verificar a elegibilidade';

  @override
  String get release_core_fleet_update_state_8 =>
      'Ignorado: desatualizado, ocupado ou já pedido';

  @override
  String get release_core_fleet_update_state_9 => 'A pedir';

  @override
  String get release_core_fleet_update_state_10 =>
      'Aceite; comprovativo indisponível';

  @override
  String get release_core_fleet_update_state_11 =>
      'Aceite; a aguardar comprovativo';

  @override
  String get release_core_fleet_update_state_12 =>
      'Ignorado: há uma conversa em execução nesta instalação';

  @override
  String get release_core_fleet_update_state_13 =>
      'Não confirmado; não reenviar automaticamente';

  @override
  String get release_core_fleet_update_state_14 =>
      'Volte a ligar para verificar o comprovativo';

  @override
  String get release_core_fleet_update_state_15 => 'Comprovativo indisponível';

  @override
  String get release_core_fleet_update_state_16 =>
      'A aguardar comprovativo correspondente';

  @override
  String get release_core_fleet_update_state_17 =>
      'Atualizado; é necessário acompanhamento';

  @override
  String get release_core_fleet_update_state_19 => 'Parcialmente atualizado';

  @override
  String get release_core_fleet_update_state_20 => 'A atualização falhou';

  @override
  String get release_core_fleet_update_state_21 => 'Não confirmado';

  @override
  String get release_core_cloud_status_ready => 'Pronto';

  @override
  String get release_core_cloud_status_online => 'Em linha';

  @override
  String get release_core_cloud_status_stopped => 'Parado';

  @override
  String get release_core_cloud_status_error => 'Erro';

  @override
  String get ng_release_more_contributions_subtitle =>
      'Cartões de resposta revistos para esta ligação';

  @override
  String get ng_release_more_gateway_fleet => 'Frota de gateways';

  @override
  String get ng_release_more_memory_graph => 'Grafo de memória';

  @override
  String get ng_release_more_memory_graph_subtitle =>
      'Cronologia, edições e fornecedores de memória';

  @override
  String get ng_release_more_capabilities_subtitle =>
      'Instale e administre competências, plugins, conectores e backends de ferramentas';

  @override
  String get ng_release_more_browser_vault => 'Cofre do navegador';

  @override
  String get ng_release_more_browser_vault_subtitle =>
      'Inícios de sessão em sites, moradas, cartões e fontes de credenciais';

  @override
  String get ng_release_more_agent_policy => 'Política do agente';

  @override
  String get ng_release_more_agent_policy_subtitle =>
      'Aprovações, pontos de controlo, acesso ao navegador e métricas partilhadas';

  @override
  String get ng_release_more_schedules => 'Agendamentos';

  @override
  String get ng_release_more_schedules_subtitle =>
      'Todos os perfis, modelos, recuperação de execuções em falta e paragem';

  @override
  String get ng_release_more_host_subtitle =>
      'Registos remotos, estado, manutenção e atualização';

  @override
  String get ng_release_more_providers_routes => 'Fornecedores e rotas';

  @override
  String get ng_release_more_providers_routes_subtitle =>
      'Chaves, endpoints, delegação e misturas';

  @override
  String get ng_release_more_credits_plans => 'Créditos e planos';

  @override
  String get ng_release_more_credits_plans_subtitle =>
      'Faturação da Nous com consentimento quando a conta o permite';

  @override
  String get ng_release_sign_in_or => 'ou';

  @override
  String ng_release_deployment_sign_in_hint(String message) {
    return '$message Ainda pode iniciar sessão com um token de sessão da implementação no passo seguinte.';
  }

  @override
  String get ng_release_message_search_unavailable =>
      'Pesquisa de mensagens indisponível. A mostrar correspondências locais.';

  @override
  String ng_release_insights_days(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias',
      one: '$days dia',
    );
    return '$_temp0';
  }

  @override
  String get ng_release_signed_in_you => 'utilizador atual';

  @override
  String get release_chat_unsent_prompt_gone =>
      'Essa instrução não enviada já não está na fila.';

  @override
  String ng_release_attachment_not_attached(String name) {
    return 'O gateway não anexou $name.';
  }

  @override
  String get ng_release_gateway_not_connected =>
      'Ainda sem ligação ao gateway.';

  @override
  String get ng_release_gateway_unreachable =>
      'Não foi possível aceder ao gateway.';

  @override
  String get ng_release_projects_scope_changed =>
      'O âmbito dos projetos já não está selecionado';

  @override
  String get ng_release_missing_providers => 'Faltam fornecedores';

  @override
  String get ng_release_missing_tasks => 'Faltam tarefas';

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
  String get ng_release_notification_foreground => 'O Ares estava no ecrã';

  @override
  String get ng_release_notification_stopped => 'o turno foi parado';

  @override
  String get ng_release_more_parallel_workspace =>
      'Espaço de trabalho em paralelo';

  @override
  String get ng_release_more_parallel_workspace_subtitle =>
      'Abra várias conversas em separadores ou lado a lado.';

  @override
  String get release_chat_unknown_model => 'desconhecido';

  @override
  String release_chat_profile_default(String model) {
    return 'Predefinição do perfil: $model';
  }

  @override
  String release_chat_profile_default_provider(String model, String provider) {
    return 'Predefinição do perfil: $model • $provider';
  }

  @override
  String get release_chat_choose_provider =>
      'Este modelo está disponível em vários fornecedores. Escolha um fornecedor para continuar.';

  @override
  String get release_chat_slash_needs_gateway =>
      'Os comandos com barra precisam do gateway do Desktop';

  @override
  String get release_chat_recovering_without_resending =>
      'A recuperar sem reenviar';

  @override
  String get release_chat_live_request_unreachable =>
      'Lamento, não consegui contactar o Hermes para esse pedido.';

  @override
  String release_chat_live_working(String tool) {
    return 'O Hermes está a trabalhar: $tool. Ainda não terminou.';
  }

  @override
  String get release_chat_live_finished_without_spoken_result =>
      'O Hermes concluiu esse pedido sem um resultado falado.';

  @override
  String get release_chat_reply_language_unavailable =>
      'O idioma de resposta selecionado está indisponível';

  @override
  String get release_chat_reply_voice_unavailable =>
      'A voz de resposta selecionada está indisponível';

  @override
  String get release_chat_reply_voice_configuration_unavailable =>
      'A configuração da voz de resposta está indisponível';

  @override
  String get release_chat_notification_review_action =>
      'Abra a conversa para rever a ação pedida.';

  @override
  String get release_chat_notification_respond =>
      'Abra a conversa para responder.';

  @override
  String get release_chat_start_new_main_window =>
      'Inicie uma nova conversa na janela principal.';

  @override
  String get release_chat_no_desktop_gateway => 'Sem gateway do Desktop';

  @override
  String get release_chat_attachment_preparation_cancelled =>
      'A preparação do anexo foi cancelada.';

  @override
  String get release_chat_approval_authority_revoked =>
      'A autoridade de aprovação foi revogada.';

  @override
  String get release_chat_gateway_session_disconnected =>
      'A sessão do gateway do Desktop já não está ligada';

  @override
  String get release_chat_stop_requested =>
      'Paragem pedida. A aguardar que o Hermes termine.';

  @override
  String release_chat_stop_request_failed(String error) {
    return 'Não foi possível pedir a paragem: $error';
  }

  @override
  String get release_chat_queued_prompt_not_sent =>
      'A instrução em fila não foi enviada.';

  @override
  String get release_chat_running_turn_unreachable =>
      'Não foi possível aceder ao turno em curso. A voltar a ligar sem reenviar.';

  @override
  String get release_chat_wait_for_composer =>
      'Aguarde que o editor de mensagens esteja disponível.';

  @override
  String get release_chat_find_in_transcript => 'Pesquisar na transcrição';

  @override
  String get release_chat_open_browser_preview =>
      'Abrir pré-visualização do navegador';

  @override
  String get release_chat_more_tools => 'Mais ferramentas da conversa';

  @override
  String get release_chat_queue_until_finished =>
      'Colocar em fila até este turno terminar';

  @override
  String get release_chat_format_bold => 'Negrito';

  @override
  String get release_chat_format_italic => 'Itálico';

  @override
  String get ng_release_chat_gateway_queue_requirements =>
      'A fila do gateway requer uma conversa associada e uma instrução apenas de texto.';

  @override
  String get ng_release_chat_start_new_main_screen =>
      'Inicie uma nova conversa a partir do ecrã principal de conversas.';

  @override
  String get ng_release_chat_image => 'imagem';

  @override
  String ng_release_chat_tool_seconds(String seconds) {
    return '${seconds}s';
  }

  @override
  String get release_preview_chat_changed =>
      'A conversa mudou. Volte a ligar a pré-visualização para continuar.';

  @override
  String get release_preview_authenticating_chat => 'A autenticar a conversa…';

  @override
  String release_preview_unavailable_reason(String reason) {
    return 'Pré-visualização indisponível: $reason';
  }

  @override
  String get release_preview_operation_failed =>
      'A operação de pré-visualização falhou.';

  @override
  String get release_preview_added_to_draft =>
      'Adicionado ao rascunho. Nada foi enviado.';

  @override
  String get release_preview_open_site_title => 'Abrir este site?';

  @override
  String release_preview_open_site_body(String origin) {
    return '$origin\n\nO modo de leitura carrega apenas este documento. Não partilha cookies, dados de início de sessão nem a página com o Hermes.';
  }

  @override
  String get release_preview_open_site => 'Abrir site';

  @override
  String get release_preview_discard_pins_title =>
      'Descartar marcadores ainda não adicionados ao rascunho?';

  @override
  String get release_preview_keep_pins => 'Manter marcadores';

  @override
  String get release_preview_share_page_title =>
      'Partilhar esta página com esta conversa?';

  @override
  String release_preview_share_page_body(String origin) {
    return 'O Hermes pode ler o texto apresentado e a lista de elementos de $origin, e deslocar este painel. A navegação termina a partilha. Os formulários e as credenciais não são partilhados.';
  }

  @override
  String get release_preview_share_page => 'Partilhar página';

  @override
  String release_preview_comment_number(int number) {
    return 'Comentário n.º $number';
  }

  @override
  String get release_preview_note => 'Nota';

  @override
  String get release_preview_keep_pin => 'Manter marcador';

  @override
  String get release_preview_title => 'Pré-visualização do navegador';

  @override
  String get release_preview_hide => 'Ocultar pré-visualização';

  @override
  String get release_preview_close_and_forget => 'Fechar e esquecer a página';

  @override
  String get release_preview_site_address => 'Endereço do site';

  @override
  String get release_preview_go_to_address => 'Ir para o endereço';

  @override
  String get release_preview_forward => 'Avançar';

  @override
  String get release_preview_reload => 'Voltar a carregar';

  @override
  String get release_preview_share_with_hermes =>
      'Partilhar página com o Hermes';

  @override
  String get release_preview_stop_sharing => 'Parar de partilhar página';

  @override
  String get release_preview_annotate => 'Anotar elemento ou região';

  @override
  String get release_preview_reader_console => 'Consola do leitor';

  @override
  String get release_preview_reconnect => 'Voltar a ligar a pré-visualização';

  @override
  String get release_preview_reader_mode_help =>
      'Modo de leitura: HTML e texto. Sem scripts, recursos incorporados ou perfil de navegador com sessão iniciada.';

  @override
  String release_preview_sharing_origin(String origin) {
    return 'A partilhar o leitor com esta conversa: $origin';
  }

  @override
  String get release_preview_annotation_help =>
      'Toque num elemento ou arraste para delimitar uma região e comentar.';

  @override
  String get release_preview_reader_requests =>
      'Pedidos do leitor (JavaScript está desativado)';

  @override
  String release_preview_selected_requests(int count) {
    return '$count selecionados · JavaScript está desativado';
  }

  @override
  String get release_preview_copy_all => 'Copiar tudo';

  @override
  String get release_preview_copy_selected => 'Copiar seleção';

  @override
  String get release_preview_add_log_to_draft =>
      'Adicionar registo ao rascunho';

  @override
  String release_preview_requests_draft(String log) {
    return 'Pedidos do leitor:\n$log';
  }

  @override
  String release_preview_add_pins_to_draft(int count) {
    return 'Adicionar $count ao rascunho';
  }

  @override
  String release_preview_request_loaded(String origin, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos do leitor',
      one: '$count elemento do leitor',
    );
    return 'HTTP 200 · $origin · $_temp0';
  }

  @override
  String release_preview_annotation_intro(String origin) {
    return 'Reveja estes comentários sobre a pré-visualização de $origin. Os recortes anexados estão numerados pela mesma ordem.';
  }

  @override
  String get release_preview_reader_region => 'região do leitor';

  @override
  String get release_preview_capture_failed =>
      'Não foi possível capturar estes píxeis.';

  @override
  String get release_preview_address_not_approved =>
      'Este endereço está fora da origem aprovada para a pré-visualização.';

  @override
  String get release_preview_page_limit =>
      'A página excede o limite do leitor.';

  @override
  String get release_preview_page_unreadable =>
      'Não foi possível ler a página.';

  @override
  String get release_preview_page_complex =>
      'Esta página é demasiado complexa para o modo de leitura.';

  @override
  String release_preview_http_failed(int statusCode) {
    return 'HTTP $statusCode. Não foi seguido qualquer redirecionamento ou início de sessão.';
  }

  @override
  String get release_preview_unsupported_type =>
      'Apenas HTML e texto simples podem ser abertos no modo de leitura.';

  @override
  String get release_preview_load_insecure =>
      'Não foi possível carregar o site em segurança.';

  @override
  String get release_preview_crop_limit =>
      'O recorte da pré-visualização excede o respetivo limite.';

  @override
  String get release_preview_image_unreadable =>
      'A imagem selecionada está vazia ou ilegível.';

  @override
  String get release_preview_image_budget =>
      'A imagem selecionada excede o limite de 64 MiB do rascunho.';

  @override
  String get release_preview_image_format =>
      'Formato de imagem não suportado. Escolha uma imagem JPEG, PNG ou WebP.';

  @override
  String get release_preview_image_decode =>
      'Não foi possível descodificar em segurança a imagem JPEG, PNG ou WebP selecionada.';

  @override
  String get release_preview_image_sanitize =>
      'Não foi possível sanear esta imagem. Escolha uma imagem JPEG, PNG ou WebP válida.';

  @override
  String get release_preview_draft_budget =>
      'Os anexos estão limitados a um total de 64 MiB por rascunho.';

  @override
  String get release_preview_generic_file_limit =>
      'Os ficheiros genéricos estão limitados a 16 MiB cada.';

  @override
  String get release_preview_image_not_sanitized =>
      'As imagens remotas têm de ser saneadas antes do envio.';

  @override
  String get release_preview_stage_failed =>
      'Não foi possível adicionar os elementos comprovativos da pré-visualização ao rascunho. Tente novamente.';

  @override
  String get release_misc_find_hermes_on_lan => 'Procurar o Hermes na LAN';

  @override
  String release_misc_discovery_failed(String error) {
    return 'A descoberta falhou: $error';
  }

  @override
  String get release_misc_no_lan_servers =>
      'Não foram encontrados servidores do Hermes na rede local.';

  @override
  String release_misc_api_key_rejected(String endpoint, int statusCode) {
    return 'A chave de API foi recusada por $endpoint (HTTP $statusCode).';
  }

  @override
  String get release_misc_api_key_required =>
      'O servidor requer uma chave de API. Introduza a sua API_SERVER_KEY.';

  @override
  String release_misc_gateway_not_found(String endpoint) {
    return 'O endpoint $endpoint do gateway devolveu HTTP 404. Verifique o prefixo do caminho do gateway e as rotas do proxy inverso.';
  }

  @override
  String release_misc_gateway_http_error(String endpoint, int statusCode) {
    return 'O endpoint $endpoint do gateway devolveu HTTP $statusCode.';
  }

  @override
  String release_misc_gateway_unreachable(String endpoint) {
    return 'Não é possível aceder ao endpoint $endpoint do gateway.';
  }

  @override
  String get release_core_schedule_invalid_delivery_target =>
      'Destino de entrega inválido';

  @override
  String get release_core_file_save_direct_only =>
      'Só é possível guardar um ficheiro diretamente no diretório de trabalho.';

  @override
  String get release_core_file_save_hidden =>
      'O gateway não pode guardar ficheiros ocultos.';

  @override
  String get rel_admin_choose_provider => 'Escolha um fornecedor e um modelo.';

  @override
  String get rel_admin_known_effort => 'Escolha um nível de esforço conhecido.';

  @override
  String get rel_admin_endpoint_name_required =>
      'Introduza um nome para este ponto de ligação.';

  @override
  String get rel_admin_endpoint_model_required =>
      'Introduza o modelo disponibilizado por este ponto de ligação.';

  @override
  String get rel_admin_known_api_mode =>
      'Escolha Automático ou um modo de API conhecido.';

  @override
  String get rel_admin_endpoint_id_invalid =>
      'Este identificador de ponto de ligação não pode ser utilizado.';

  @override
  String get rel_admin_endpoint_https =>
      'Utilize HTTPS para um ponto de ligação remoto ou HTTP em localhost.';

  @override
  String get rel_admin_key_invalid =>
      'Não é possível guardar essa chave de API.';

  @override
  String get rel_admin_response_shape =>
      'A resposta do gateway não correspondeu à estrutura esperada.';

  @override
  String get rel_admin_limits_required =>
      'Introduza os limites de iterações, simultaneidade e tempo de espera antes de guardar.';

  @override
  String get rel_admin_route_required =>
      'Cada rota precisa de um nome e de um modelo antes de ser guardada.';

  @override
  String get rel_admin_route_unique => 'Os nomes das rotas têm de ser únicos.';

  @override
  String get rel_admin_route_default_invalid =>
      'A rota predefinida tem de ser uma das rotas guardadas.';

  @override
  String get rel_admin_policy_required =>
      'Escolha uma política com aviso ou silenciosa para referências degradadas.';

  @override
  String get rel_admin_mixture_missing =>
      'O gateway não devolveu uma mistura ativa.';

  @override
  String get rel_admin_mixture_slots_required =>
      'Indique um fornecedor e um modelo para o agregador e para cada referência.';

  @override
  String get rel_admin_chat_id_required =>
      'Introduza o ID da conversa a que esta alteração se aplica.';

  @override
  String rel_admin_http_error(String status) {
    return 'O gateway devolveu HTTP $status.';
  }

  @override
  String get rel_admin_response_unreadable =>
      'Não foi possível ler a resposta do gateway.';

  @override
  String get rel_admin_connect_before_change =>
      'Ligue a sessão ativa do gateway antes de alterar a faturação ou uma conversa.';

  @override
  String get rel_admin_operation_unavailable =>
      'Este gateway não disponibiliza essa operação.';

  @override
  String get rel_admin_key_required => 'Introduza a chave a guardar.';

  @override
  String get rel_admin_key_save_failed => 'O gateway não guardou essa chave.';

  @override
  String get rel_admin_key_clear_required =>
      'Escolha uma chave de fornecedor para apagar.';

  @override
  String get rel_admin_key_clear_failed => 'O gateway não apagou essa chave.';

  @override
  String get rel_admin_endpoint_save_failed =>
      'O gateway não guardou esse ponto de ligação.';

  @override
  String get rel_admin_endpoint_activate_failed =>
      'O gateway não ativou esse ponto de ligação.';

  @override
  String get rel_admin_accounts_secure_required =>
      'As contas de fornecedores requerem um gateway HTTPS autenticado ou localhost.';

  @override
  String get rel_admin_accounts_read_failed =>
      'Não foi possível ler as contas de fornecedores.';

  @override
  String get rel_admin_account_disconnect_failed =>
      'O gateway não desligou essa conta.';

  @override
  String get rel_admin_account_not_disconnectable =>
      'Não é possível desligar essa conta de fornecedor.';

  @override
  String get rel_admin_backend_required =>
      'Escolha um dos backends de delegação disponíveis.';

  @override
  String get rel_admin_backend_save_failed =>
      'O gateway não selecionou esse backend.';

  @override
  String get rel_admin_routes_save_failed =>
      'O gateway não guardou essas rotas.';

  @override
  String get rel_admin_profile_route_required =>
      'Cada rota de perfil precisa de um nome de perfil.';

  @override
  String get rel_admin_profile_route_unique =>
      'As rotas de perfil têm de ser únicas.';

  @override
  String get rel_admin_profile_route_default_invalid =>
      'A rota de perfil predefinida tem de ser um dos perfis permitidos.';

  @override
  String get rel_admin_profile_routes_save_failed =>
      'O gateway não guardou essas rotas de perfil.';

  @override
  String get rel_admin_limits_save_failed =>
      'O gateway não guardou esses limites.';

  @override
  String get rel_admin_mixture_save_failed =>
      'O gateway não guardou essa mistura.';

  @override
  String get rel_admin_credit_amount_required =>
      'Escolha um dos montantes de crédito apresentados.';

  @override
  String get rel_admin_charge_check_failed =>
      'Não foi possível verificar essa cobrança.';

  @override
  String get rel_admin_reload_amounts_missing =>
      'Os montantes de recarga automática não foram fornecidos, pelo que não foram alterados.';

  @override
  String get rel_admin_plan_required => 'Escolha primeiro um plano.';

  @override
  String get rel_admin_plan_scheduled_only =>
      'Só é possível confirmar aqui uma alteração de plano agendada.';

  @override
  String get rel_admin_billing_refused =>
      'O gateway recusou este pedido de faturação.';

  @override
  String get rel_admin_request_refused => 'O gateway recusou este pedido.';

  @override
  String get rel_admin_endpoint_answered => 'O ponto de ligação respondeu.';

  @override
  String get rel_admin_endpoint_no_answer =>
      'O ponto de ligação não respondeu.';

  @override
  String get rel_admin_charge_unknown =>
      'O resultado da cobrança é desconhecido. Ainda pode ser liquidada. Consulte o portal antes de tentar novamente.';

  @override
  String get rel_admin_connect_before_billing =>
      'Ligue a sessão ativa do gateway antes de consultar a faturação. Não é cobrado nada nesta página.';

  @override
  String get rel_admin_preset_required =>
      'Guarde uma predefinição antes de a aplicar.';

  @override
  String get rel_admin_cancel => 'Cancelar';

  @override
  String get rel_admin_refresh => 'Atualizar';

  @override
  String get rel_admin_credits_and_plans => 'Créditos e planos';

  @override
  String get rel_admin_saved => 'Guardado';

  @override
  String get rel_admin_name => 'Nome';

  @override
  String get rel_admin_base_url => 'URL base';

  @override
  String get rel_admin_model => 'Modelo';

  @override
  String get rel_admin_signed_in => 'Sessão iniciada';

  @override
  String get rel_admin_not_signed_in => 'Sessão não iniciada';

  @override
  String get rel_admin_provider => 'Provedor';

  @override
  String get rel_admin_apply_to_this_chat => 'Aplicar a este chat';

  @override
  String get rel_admin_auto => 'Automático';

  @override
  String get rel_admin_chat_completions => 'Conclusões de conversa';

  @override
  String get rel_admin_codex_responses => 'Respostas Codex';

  @override
  String get rel_admin_anthropic_messages => 'Mensagens Anthropic';

  @override
  String get rel_admin_could_not_complete_that_request =>
      'Não foi possível concluir esse pedido.';

  @override
  String get rel_admin_confirm => 'Confirmar';

  @override
  String get rel_admin_providers_and_billing => 'Fornecedores e faturação';

  @override
  String get rel_admin_api_keys => 'Chaves de API';

  @override
  String get rel_admin_custom_endpoints => 'Pontos de ligação personalizados';

  @override
  String get rel_admin_provider_accounts => 'Contas de fornecedores';

  @override
  String get rel_admin_effort_and_speed_presets =>
      'Predefinições de esforço e velocidade';

  @override
  String get rel_admin_delegation => 'Delegação';

  @override
  String get rel_admin_mixture_of_agents => 'Mistura de agentes';

  @override
  String get rel_admin_no_provider_keys_were_reported_for_this_profile =>
      'Não foram comunicadas chaves de fornecedores para este perfil.';

  @override
  String get rel_admin_not_saved => 'Não guardado';

  @override
  String get rel_admin_new_key_value => 'Novo valor da chave';

  @override
  String get rel_admin_provider_key_saved => 'Chave do fornecedor guardada.';

  @override
  String get rel_admin_save_key => 'Guardar chave';

  @override
  String get rel_admin_clear_provider_key => 'Apagar chave do fornecedor';

  @override
  String get rel_admin_provider_key_cleared => 'Chave do fornecedor apagada.';

  @override
  String get rel_admin_clear_key => 'Apagar chave';

  @override
  String get rel_admin_new_endpoint => 'Novo ponto de ligação';

  @override
  String get rel_admin_api_key => 'Chave de API';

  @override
  String get rel_admin_leave_blank_to_keep_a_key_this_endpoint_already_has =>
      'Deixe em branco para manter a chave existente deste ponto de ligação.';

  @override
  String get rel_admin_reachable => 'Acessível';

  @override
  String get rel_admin_unreachable => 'Inacessível';

  @override
  String get rel_admin_test_endpoint => 'Testar ponto de ligação';

  @override
  String get rel_admin_endpoint_saved => 'Ponto de ligação guardado.';

  @override
  String get rel_admin_save_endpoint => 'Guardar ponto de ligação';

  @override
  String get rel_admin_use_this_endpoint => 'Utilizar este ponto de ligação';

  @override
  String
  get rel_admin_make_this_named_endpoint_the_current_model_for_this_profile =>
      'Tornar este ponto de ligação nomeado o modelo atual deste perfil?';

  @override
  String get rel_admin_endpoint_is_now_current =>
      'O ponto de ligação é agora o atual.';

  @override
  String get rel_admin_use_endpoint => 'Utilizar ponto de ligação';

  @override
  String get rel_admin_delete_endpoint => 'Eliminar ponto de ligação';

  @override
  String get rel_admin_delete_this_named_endpoint_from_the_profile =>
      'Eliminar este ponto de ligação nomeado do perfil?';

  @override
  String get rel_admin_endpoint_deleted => 'Ponto de ligação eliminado.';

  @override
  String get rel_admin_signing_in_stays_on_the_provider_sign_in_screen =>
      'O início de sessão continua no ecrã do fornecedor. A conta só é desligada quando este gateway indicar que pode ser removida.';

  @override
  String get rel_admin_disconnect_this_provider_account_on_the_gateway =>
      'Desligar esta conta de fornecedor no gateway?';

  @override
  String get rel_admin_provider_account_disconnected =>
      'Conta do fornecedor desligada.';

  @override
  String get rel_admin_disconnect => 'Desligar';

  @override
  String get rel_admin_not_disconnectable => 'Não pode ser desligado';

  @override
  String get rel_admin_fast => 'Rápido';

  @override
  String get rel_admin_preset_saved_for_this_model =>
      'Predefinição guardada para este modelo.';

  @override
  String get rel_admin_save_preset => 'Guardar predefinição';

  @override
  String get rel_admin_chat_id => 'ID da conversa';

  @override
  String get rel_admin_apply_preset => 'Aplicar predefinição';

  @override
  String get rel_admin_set_this_chat_s_effort_and_speed_from_the_saved_preset =>
      'Definir o esforço e a velocidade desta conversa a partir da predefinição guardada?';

  @override
  String get rel_admin_preset_applied_to_this_chat =>
      'Predefinição aplicada a esta conversa.';

  @override
  String get rel_admin_this_route_sends_the_picked_effort_unchanged =>
      'Esta rota envia o esforço escolhido sem alterações.';

  @override
  String get rel_admin_show_route_clamp => 'Mostrar limite da rota';

  @override
  String get rel_admin_delegation_backend => 'Backend de delegação';

  @override
  String get rel_admin_delegation_backend_saved =>
      'Backend de delegação guardado.';

  @override
  String get rel_admin_save_backend => 'Guardar backend';

  @override
  String get rel_admin_max_iterations => 'Máximo de iterações';

  @override
  String get rel_admin_max_concurrent_children =>
      'Máximo de agentes filhos em simultâneo';

  @override
  String get rel_admin_child_timeout_seconds =>
      'Tempo limite dos agentes filhos em segundos';

  @override
  String get rel_admin_delegation_effort_leave_unchanged =>
      'Esforço de delegação, manter inalterado';

  @override
  String get rel_admin_delegation_limits_saved =>
      'Limites de delegação guardados.';

  @override
  String get rel_admin_save_limits => 'Guardar limites';

  @override
  String get rel_admin_remove_route => 'Remover rota';

  @override
  String get rel_admin_route_name => 'Nome da rota';

  @override
  String get rel_admin_route_provider => 'Fornecedor da rota';

  @override
  String get rel_admin_route_model => 'Modelo da rota';

  @override
  String get rel_admin_route_effort_unchanged => 'Esforço da rota inalterado';

  @override
  String get rel_admin_add_route => 'Adicionar rota';

  @override
  String get rel_admin_default_route => 'Rota predefinida';

  @override
  String get rel_admin_delegation_routes_saved =>
      'Rotas de delegação guardadas.';

  @override
  String get rel_admin_save_routes => 'Guardar rotas';

  @override
  String get rel_admin_profile_routes_saved => 'Rotas de perfil guardadas.';

  @override
  String get rel_admin_save_profile_routes => 'Guardar rotas de perfil';

  @override
  String get rel_admin_no_mixture_is_loaded =>
      'Não há nenhuma mistura carregada.';

  @override
  String get rel_admin_mixture_enabled => 'Mistura ativada';

  @override
  String get rel_admin_loud_degraded_references =>
      'Referências degradadas com aviso';

  @override
  String get rel_admin_silent_degraded_references =>
      'Referências degradadas silenciosas';

  @override
  String get rel_admin_aggregator => 'Agregador';

  @override
  String get rel_admin_aggregator_provider => 'Fornecedor do agregador';

  @override
  String get rel_admin_aggregator_model => 'Modelo do agregador';

  @override
  String get rel_admin_reference_provider => 'Fornecedor de referência';

  @override
  String get rel_admin_reference_model => 'Modelo de referência';

  @override
  String get rel_admin_add_reference_model => 'Adicionar modelo de referência';

  @override
  String get rel_admin_mixture_saved => 'Mistura guardada.';

  @override
  String get rel_admin_save_mixture => 'Guardar mistura';

  @override
  String get rel_admin_credit_purchase_submitted =>
      'Compra de créditos enviada.';

  @override
  String get rel_admin_credit_purchase_settled =>
      'Compra de créditos liquidada.';

  @override
  String get rel_admin_credit_and_plan_changes_wait_for_confirmation_a_plan =>
      'As alterações de créditos e planos aguardam confirmação. Um plano com cobrança imediata é apresentado, mas não confirmado aqui.';

  @override
  String get rel_admin_buy_credits => 'Comprar créditos';

  @override
  String get rel_admin_retry_same_charge => 'Repetir a mesma cobrança';

  @override
  String get rel_admin_retry_the_same_credit_charge_this_does_not_start =>
      'Repita a mesma cobrança de créditos. Isto não inicia uma segunda compra.';

  @override
  String get rel_admin_credit_purchases_are_not_available_for_this_account =>
      'A compra de créditos não está disponível para esta conta.';

  @override
  String get rel_admin_auto_reload => 'Recarga automática';

  @override
  String get rel_admin_read_only_until_this_account_can_charge =>
      'Só de leitura até esta conta poder efetuar cobranças.';

  @override
  String get rel_admin_auto_reload_updated => 'Recarga automática atualizada.';

  @override
  String get rel_admin_keep_going_on_credits => 'Continuar com créditos';

  @override
  String get rel_admin_continue_on_credits_when_the_plan_window_is_used_up =>
      'Continuar com créditos quando a quota do período do plano se esgotar?';

  @override
  String
  get rel_admin_stop_continuing_on_credits_when_the_plan_window_is_used_up =>
      'Deixar de continuar com créditos quando a quota do período do plano se esgotar?';

  @override
  String get rel_admin_credit_continuation_updated =>
      'Continuação com créditos atualizada.';

  @override
  String get rel_admin_this_plan_change_is_not_confirmed_from_ares =>
      'Esta alteração de plano não é confirmada a partir do Ares.';

  @override
  String get rel_admin_this_change_is_scheduled_confirm_to_apply_it =>
      'Esta alteração está agendada. Confirme para a aplicar.';

  @override
  String get rel_admin_preview_plan => 'Pré-visualizar plano';

  @override
  String get rel_admin_schedule_plan_change => 'Agendar alteração de plano';

  @override
  String get rel_admin_plan_change_scheduled => 'Alteração de plano agendada.';

  @override
  String get rel_admin_confirm_scheduled_plan_change =>
      'Confirmar alteração de plano agendada';

  @override
  String rel_admin_remove_key_confirm(String key) {
    return 'Remover o valor guardado de $key deste perfil?';
  }

  @override
  String rel_admin_current_endpoint(String name) {
    return '$name · atual';
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
    return 'Desligar $name';
  }

  @override
  String rel_admin_delegation_blocked(String reason) {
    return 'A delegação está bloqueada: $reason';
  }

  @override
  String rel_admin_backend_unavailable(String name) {
    return '$name · indisponível';
  }

  @override
  String rel_admin_reference_number(String number) {
    return 'Referência $number';
  }

  @override
  String rel_admin_reload_enable_confirm(String amount, String threshold) {
    return 'Ativar a recarga automática e cobrar $amount quando o saldo descer abaixo de $threshold?';
  }

  @override
  String rel_admin_reload_disable_confirm(String amount, String threshold) {
    return 'Desativar a recarga automática? Atualmente cobra $amount quando o saldo desce abaixo de $threshold.';
  }

  @override
  String get rel_admin_this_plan => 'este plano';

  @override
  String rel_admin_plan_confirm(String name) {
    return 'Agendar $name. Está previsto para o fim do período atual. Não é feita nenhuma cobrança agora.';
  }

  @override
  String rel_admin_plan_confirm_price(String name, String price) {
    return 'Agendar $name por $price. Está previsto para o fim do período atual. Não é feita nenhuma cobrança agora.';
  }

  @override
  String rel_admin_plan_confirm_when(String name, String when) {
    return 'Agendar $name. Entra em vigor $when. Não é feita nenhuma cobrança agora.';
  }

  @override
  String rel_admin_plan_confirm_price_when(
    String name,
    String price,
    String when,
  ) {
    return 'Agendar $name por $price. Entra em vigor $when. Não é feita nenhuma cobrança agora.';
  }

  @override
  String rel_admin_balance(String amount) {
    return 'Saldo $amount';
  }

  @override
  String rel_admin_buy_confirm(String amount) {
    return 'Cobrar \$$amount ao método de pagamento desta conta Nous. Isto gasta dinheiro real.';
  }

  @override
  String rel_admin_reload_portal(String url) {
    return 'Altere a recarga automática no portal: $url';
  }

  @override
  String rel_admin_team_portal(String url) {
    return 'As subscrições de equipa são alteradas no portal: $url';
  }

  @override
  String get rel_admin_effort_none => 'nenhum';

  @override
  String get rel_admin_effort_minimal => 'mínimo';

  @override
  String get rel_admin_effort_low => 'baixo';

  @override
  String get rel_admin_effort_medium => 'médio';

  @override
  String get rel_admin_effort_high => 'alto';

  @override
  String get rel_admin_effort_xhigh => 'muito alto';

  @override
  String get rel_admin_effort_max => 'máximo';

  @override
  String get rel_admin_effort_ultra => 'ultraelevado';

  @override
  String get rel_admin_auto_lower => 'Automático';

  @override
  String get rel_admin_create => 'Criar';

  @override
  String get rel_admin_prompt => 'Instrução';

  @override
  String get rel_admin_new_profile_id => 'ID do novo perfil';

  @override
  String get rel_admin_this_operation_is_unavailable_on_this_gateway =>
      'Esta operação não está disponível neste gateway.';

  @override
  String get rel_admin_access_denied_by_the_gateway =>
      'Acesso negado pelo gateway.';

  @override
  String get rel_admin_connection_changed_reopen_profiles =>
      'A ligação mudou. Volte a abrir Perfis.';

  @override
  String
  get rel_admin_invalid_input_or_gateway_response_check_the_target_before =>
      'Entrada ou resposta do gateway inválida. Verifique o destino antes de tentar novamente.';

  @override
  String get rel_admin_could_not_verify_the_result_refresh_the_target_before =>
      'Não foi possível verificar o resultado. Atualize o destino antes de tentar novamente.';

  @override
  String get rel_admin_edit_soul_md => 'Editar SOUL.md';

  @override
  String get rel_admin_persona => 'Personalidade';

  @override
  String get rel_admin_persona_saved => 'Personalidade guardada.';

  @override
  String get rel_admin_not_set => 'não definido';

  @override
  String get rel_admin_enabled => 'Ativado';

  @override
  String get rel_admin_keys_to_remove_comma_separated =>
      'Chaves a remover (separadas por vírgulas)';

  @override
  String get rel_admin_saved_and_applied_by_the_gateway =>
      'Guardado e aplicado pelo gateway.';

  @override
  String get rel_admin_saved_a_gateway_restart_may_be_required =>
      'Guardado. Poderá ser necessário reiniciar o gateway.';

  @override
  String get rel_admin_create_signed_route => 'Criar rota assinada';

  @override
  String get rel_admin_route_id => 'ID da rota';

  @override
  String get rel_admin_signature => 'Assinatura';

  @override
  String get rel_admin_events_comma_separated =>
      'Eventos (separados por vírgulas)';

  @override
  String get rel_admin_delivery_target => 'Destino de entrega';

  @override
  String get rel_admin_skills_comma_separated =>
      'Competências (separadas por vírgulas)';

  @override
  String get rel_admin_delivery_mode => 'Modo de entrega';

  @override
  String get rel_admin_delivery_chat_id_optional =>
      'ID da conversa de entrega (opcional)';

  @override
  String get rel_admin_hide_signing_secret => 'Ocultar segredo de assinatura';

  @override
  String get rel_admin_reveal_signing_secret => 'Mostrar segredo de assinatura';

  @override
  String get rel_admin_edit_persona => 'Editar personalidade';

  @override
  String get rel_admin_portable_profile_bundle => 'Pacote de perfil portátil';

  @override
  String get rel_admin_clone_profile => 'Clonar perfil';

  @override
  String get rel_admin_rename_display_label =>
      'Mudar o nome da etiqueta de apresentação';

  @override
  String get rel_admin_rename_profile => 'Mudar o nome do perfil';

  @override
  String get rel_admin_new_name => 'Novo nome';

  @override
  String get rel_admin_rename_verified => 'Alteração de nome verificada.';

  @override
  String get rel_admin_delete_profile => 'Eliminar perfil';

  @override
  String get rel_admin_profile_id_to_delete => 'ID do perfil a eliminar';

  @override
  String get rel_admin_profile_deleted => 'Perfil eliminado.';

  @override
  String
  get rel_admin_profile_deleted_server_identity_cleanup_is_still_pending =>
      'Perfil eliminado. A limpeza da identidade do servidor ainda está pendente.';

  @override
  String get rel_admin_export_profile_archive => 'Exportar arquivo de perfil';

  @override
  String get rel_admin_import_profile_archive => 'Importar arquivo de perfil';

  @override
  String get rel_admin_import_a_trusted_profile =>
      'Importar um perfil de confiança';

  @override
  String get rel_admin_absolute_archive_path_on_gateway =>
      'Caminho absoluto do arquivo no gateway';

  @override
  String get rel_admin_messaging_channels => 'Canais de mensagens';

  @override
  String get rel_admin_dm_pairing_requests =>
      'Pedidos de associação por mensagem direta';

  @override
  String get rel_admin_no_pending_or_approved_users =>
      'Não há utilizadores pendentes ou aprovados.';

  @override
  String get rel_admin_legacy_pairing_no_verifiable_request_id_ask_the_user =>
      'Associação antiga: sem ID de pedido verificável. Peça ao utilizador que volte a associar-se.';

  @override
  String get rel_admin_pairing_change_verified =>
      'Alteração de associação verificada.';

  @override
  String get rel_admin_create_telegram_bot_by_qr =>
      'Criar bot do Telegram por QR';

  @override
  String get rel_admin_create_telegram_bot => 'Criar bot do Telegram';

  @override
  String get rel_admin_bot_name => 'Nome do bot';

  @override
  String get rel_admin_telegram_bot_creation_qr_code =>
      'Código QR para criar um bot do Telegram';

  @override
  String get rel_admin_check_telegram_pairing =>
      'Verificar associação do Telegram';

  @override
  String get rel_admin_waiting_for_telegram => 'A aguardar o Telegram.';

  @override
  String get rel_admin_apply_telegram_bot => 'Aplicar bot do Telegram';

  @override
  String get rel_admin_allowed_numeric_user_ids =>
      'IDs numéricos dos utilizadores permitidos';

  @override
  String get rel_admin_saved_restart_still_required =>
      'Guardado. Ainda é necessário reiniciar.';

  @override
  String get rel_admin_saved_gateway_restart_requested =>
      'Guardado; reinício do gateway solicitado.';

  @override
  String get rel_admin_cancel_telegram_setup =>
      'Cancelar configuração do Telegram';

  @override
  String get rel_admin_inbound_webhooks => 'Webhooks de entrada';

  @override
  String get rel_admin_enable_webhook_service => 'Ativar serviço de webhooks';

  @override
  String get rel_admin_enable_webhooks => 'Ativar webhooks';

  @override
  String get rel_admin_enabled_restart_still_required =>
      'Ativado. Ainda é necessário reiniciar.';

  @override
  String get rel_admin_enabled_restart_requested =>
      'Ativado; reinício solicitado.';

  @override
  String get rel_admin_route_change_verified => 'Alteração de rota verificada.';

  @override
  String get rel_admin_delete_route => 'Eliminar rota';

  @override
  String get rel_admin_disable_route => 'Desativar rota';

  @override
  String get rel_admin_enable_route => 'Ativar rota';

  @override
  String get rel_admin_back_up_entire_agent_home =>
      'Criar cópia de segurança de toda a pasta pessoal do agente';

  @override
  String get rel_admin_transfer_to_a_cloud_agent =>
      'Transferir para um agente Cloud';

  @override
  String get rel_admin_check_backup_progress =>
      'Verificar progresso da cópia de segurança';

  @override
  String get rel_admin_save_backup_to_this_device =>
      'Guardar cópia de segurança neste dispositivo';

  @override
  String get rel_admin_save_sensitive_full_home_archive =>
      'Guardar arquivo sensível de toda a pasta pessoal';

  @override
  String get rel_admin_save_cancelled => 'Gravação cancelada.';

  @override
  String get rel_admin_backup_saved => 'Cópia de segurança guardada.';

  @override
  String get rel_admin_up_to_32_mib_larger_archives_remain_on_the_gateway =>
      'Até 32 MiB. Os arquivos maiores permanecem no gateway.';

  @override
  String rel_admin_persona_scope(String scope) {
    return 'Guarde a personalidade de $scope.';
  }

  @override
  String rel_admin_configure_channel(String name) {
    return 'Configurar $name';
  }

  @override
  String rel_admin_channel_warning(String scope) {
    return 'Aplica-se a $scope. Em branco mantém o valor existente. Para remover um valor, indique a chave abaixo.';
  }

  @override
  String rel_admin_hook_warning(String scope) {
    return 'Aplica-se a $scope. Use um nome único. O gateway cria um segredo de assinatura. Se outro operador criar o nome em simultâneo, o anfitrião pode substituir essa rota.';
  }

  @override
  String rel_admin_hook_created(String url) {
    return 'Criado $url. Guarde o segredo de assinatura antes de sair.';
  }

  @override
  String rel_admin_clone_warning(String scope) {
    return 'Copie definições, competências, personalidade e possivelmente credenciais de fornecedores de $scope. Os tokens de mensagens não são pedidos.';
  }

  @override
  String rel_admin_cloned(String source, String destination) {
    return '$source clonado para $destination.';
  }

  @override
  String rel_admin_rename_target(String name) {
    return 'Mudar o nome de $name';
  }

  @override
  String rel_admin_rename_label_warning(String scope) {
    return 'Altere a etiqueta de apresentação de $scope. O ID mantém-se default.';
  }

  @override
  String rel_admin_rename_warning(String scope) {
    return 'Mude o nome de $scope no servidor. Um gateway em execução pode parar.';
  }

  @override
  String rel_admin_delete_target(String name) {
    return 'Eliminar $name';
  }

  @override
  String rel_admin_delete_profile_warning(String scope) {
    return 'Elimine permanentemente $scope, incluindo sessões e credenciais. Introduza o ID exato do perfil.';
  }

  @override
  String rel_admin_export_target(String name) {
    return 'Exportar $name';
  }

  @override
  String rel_admin_export_warning(String scope) {
    return 'Crie um .tar.gz em $scope. Os repositórios de credenciais conhecidos são excluídos, mas podem restar dados privados. Reveja antes de partilhar.';
  }

  @override
  String rel_admin_archive_on(String gateway, String path) {
    return 'Arquivo em $gateway: $path';
  }

  @override
  String rel_admin_import_warning(String gateway) {
    return 'Utilize um .tar.gz revisto que já esteja em $gateway. Pode conter plugins, scripts e agendamentos. É necessário um novo ID de perfil.';
  }

  @override
  String rel_admin_imported(String name) {
    return '$name importado.';
  }

  @override
  String rel_admin_approve_user(String user) {
    return 'Aprovar $user';
  }

  @override
  String rel_admin_revoke_user(String user) {
    return 'Revogar $user';
  }

  @override
  String rel_admin_allow_pair(String platform, String scope) {
    return '$platform em $scope: permitir o acesso deste utilizador às mensagens.';
  }

  @override
  String rel_admin_remove_pair(String platform, String scope) {
    return '$platform em $scope: remover o acesso deste utilizador às mensagens.';
  }

  @override
  String rel_admin_telegram_start(String scope) {
    return 'Inicie uma associação do Telegram em $scope com o serviço de configuração do gateway.';
  }

  @override
  String rel_admin_expires(String time) {
    return 'Expira: $time';
  }

  @override
  String rel_admin_telegram_apply(String bot, String scope) {
    return 'Ative @$bot em $scope e tente reiniciar o gateway. Só os utilizadores indicados podem enviar-lhe mensagens.';
  }

  @override
  String rel_admin_hooks_enable(String scope) {
    return 'Ative os webhooks de entrada em $scope e tente reiniciar o gateway.';
  }

  @override
  String rel_admin_disable_target(String name) {
    return 'Desativar $name';
  }

  @override
  String rel_admin_enable_target(String name) {
    return 'Ativar $name';
  }

  @override
  String rel_admin_hook_change(String name, String scope) {
    return 'Altere exatamente $name em $scope.';
  }

  @override
  String rel_admin_backup_warning(String gateway) {
    return 'Isto não é uma cópia de segurança das definições do Ares. Guarde todos os perfis, sessões e credenciais em $gateway. O arquivo é sensível.';
  }

  @override
  String rel_admin_backup_started(String gateway) {
    return 'Cópia de segurança iniciada em $gateway.';
  }

  @override
  String rel_admin_backup_verified(String gateway, String path) {
    return 'Cópia de segurança verificada em $gateway: $path';
  }

  @override
  String rel_admin_backup_running(String gateway) {
    return 'A cópia de segurança ainda está em curso em $gateway.';
  }

  @override
  String get rel_admin_choice_yes => 'sim';

  @override
  String get rel_admin_choice_no => 'não';

  @override
  String get rel_admin_choice_generic => 'genérico';

  @override
  String get rel_admin_choice_log => 'registo';

  @override
  String get rel_admin_choice_email => 'correio eletrónico';

  @override
  String get rel_admin_choice_github_comment => 'comentário no GitHub';

  @override
  String get rel_admin_choice_agent => 'O agente processa o evento';

  @override
  String get rel_admin_choice_direct => 'Entrega direta';

  @override
  String get rel_admin_configured => 'configurado';

  @override
  String get rel_admin_state_pending_restart => 'reinício pendente';

  @override
  String get rel_admin_state_unknown => 'desconhecido';

  @override
  String get rel_admin_state_connected => 'ligado';

  @override
  String get rel_admin_state_disconnected => 'desligado';

  @override
  String get rel_admin_state_disabled => 'desativado';

  @override
  String get rel_admin_state_enabled => 'ativado';

  @override
  String get rel_admin_state_running => 'em execução';

  @override
  String get rel_admin_state_stopped => 'parado';

  @override
  String get rel_admin_state_error => 'erro';

  @override
  String get rel_admin_state_not_configured => 'não configurado';

  @override
  String get rel_admin_state_startup_failed => 'falha no arranque';

  @override
  String get rel_admin_state_gateway_stopped => 'gateway parado';

  @override
  String get rel_admin_state_connecting => 'a ligar';

  @override
  String get rel_admin_state_retrying => 'a tentar novamente';

  @override
  String get rel_admin_state_fatal => 'erro fatal';

  @override
  String get rel_admin_unsupported_or_oversized_profile_archive =>
      'Arquivo de perfil não suportado ou demasiado grande.';

  @override
  String get rel_admin_current_layout => 'Disposição atual';

  @override
  String get rel_admin_one_pane => 'Um painel';

  @override
  String get rel_admin_stacked => 'Empilhado';

  @override
  String get rel_admin_side_by_side => 'Lado a lado';

  @override
  String get rel_admin_no_supported_appearance_in_this_profile =>
      'Não existe uma aparência suportada neste perfil.';

  @override
  String get rel_admin_review_appearance_saved_with_this_profile =>
      'Rever a aparência guardada com este perfil';

  @override
  String get rel_admin_applies_only_to_this_named_profile_on_this_device =>
      'Aplica-se apenas a este perfil nomeado neste dispositivo. Uma disposição importada começa com painéis vazios; escolha as conversas.';

  @override
  String get rel_admin_apply_to_this_profile_on_this_device =>
      'Aplicar a este perfil neste dispositivo';

  @override
  String get rel_admin_export_prepares_a_tar_gz_on_the_gateway_review =>
      'A exportação prepara um .tar.gz no gateway. Reveja os ficheiros portáteis antes de guardar uma cópia aqui. A importação abre um arquivo local para revisão; só abrir não carrega nada.';

  @override
  String get rel_admin_prepare_profile_export =>
      'Preparar exportação de perfil';

  @override
  String get rel_admin_open_tar_gz_from_this_device =>
      'Abrir .tar.gz deste dispositivo';

  @override
  String get rel_admin_only_selected_text_files_travel_review_for_secrets_and =>
      'Só são transferidos os ficheiros de texto selecionados. Verifique se contêm segredos e informação privada. A configuração, as competências e os agendamentos podem alterar o comportamento do novo perfil.';

  @override
  String get rel_admin_include_this_reviewed_file =>
      'Incluir este ficheiro revisto';

  @override
  String get rel_admin_apply_appearance_to_the_new_profile_on_this_device =>
      'Aplicar a aparência ao novo perfil neste dispositivo';

  @override
  String
  get rel_admin_imports_colours_and_pane_sizes_never_chats_tools_or_session_ids =>
      'Importa cores e tamanhos dos painéis, nunca conversas, ferramentas ou IDs de sessão.';

  @override
  String
  get rel_admin_the_gateway_retains_a_private_staged_copy_import_creates =>
      'O gateway mantém uma cópia privada preparada. A importação cria um novo perfil; não substitui um existente.';

  @override
  String get rel_admin_appearance_not_applied_the_gateway_did_not_confirm_the =>
      ' Aparência não aplicada: o gateway não confirmou a sobreposição revista.';

  @override
  String get rel_admin_appearance_applied_on_this_device =>
      ' Aparência aplicada neste dispositivo.';

  @override
  String get rel_admin_appearance_was_not_saved_on_this_device =>
      ' A aparência não foi guardada neste dispositivo.';

  @override
  String get rel_admin_save_reviewed_profile_bundle =>
      'Guardar pacote de perfil revisto';

  @override
  String get rel_admin_profile_bundle_saved => 'Pacote de perfil guardado.';

  @override
  String get rel_admin_import_selected_files =>
      'Importar ficheiros selecionados';

  @override
  String get rel_admin_save_selected_files_to_device =>
      'Guardar ficheiros selecionados no dispositivo';

  @override
  String rel_admin_layout_first_pane(String layout, String percent) {
    return '$layout · $percent% primeiro painel';
  }

  @override
  String rel_admin_appearance_summary(String skin, String mode, String layout) {
    return 'Tema: $skin · Modo: $mode · $layout';
  }

  @override
  String rel_admin_appearance_applied(String gateway, String profile) {
    return 'Aparência aplicada a $gateway / $profile.';
  }

  @override
  String rel_admin_bundle_summary(
    String profile,
    String count,
    String omitted,
  ) {
    return 'Pacote: $profile · $count ficheiros para revisão · $omitted omitidos';
  }

  @override
  String rel_admin_imported_on(String name, String gateway) {
    return '$name importado em $gateway.';
  }

  @override
  String get rel_admin_unchanged => 'inalterado';

  @override
  String get rel_admin_mode_system => 'sistema';

  @override
  String get rel_admin_mode_light => 'claro';

  @override
  String get rel_admin_mode_dark => 'escuro';

  @override
  String get rel_admin_skin_classic => 'clássico';

  @override
  String get rel_admin_skin_midnight => 'meia-noite';

  @override
  String get rel_admin_skin_ember => 'brasa';

  @override
  String get rel_admin_skin_mono => 'monocromático';

  @override
  String get rel_admin_skin_cyberpunk => 'ciberpunk';

  @override
  String get rel_admin_skin_slate => 'ardósia';

  @override
  String get rel_admin_no_available_cloud_agents_in_this_account =>
      'Não há agentes Cloud disponíveis nesta conta.';

  @override
  String get rel_admin_the_previous_undo_receipt_could_not_be_verified_no =>
      'Não foi possível verificar o recibo de anulação anterior. Não foi feita nenhuma alteração.';

  @override
  String get rel_admin_transfer_to_cloud => 'Transferir para Cloud';

  @override
  String
  get rel_admin_connection_changed_leave_this_page_a_restore_already_submitted =>
      'A ligação mudou. Saia desta página. Um restauro já enviado poderá continuar.';

  @override
  String get rel_admin_find_my_cloud_agents =>
      'Encontrar os meus agentes Cloud';

  @override
  String
  get rel_admin_undo_replaces_the_destination_with_its_pre_transfer_backup =>
      'A anulação substitui o destino pela cópia de segurança anterior à transferência.';

  @override
  String get rel_admin_replace_this_cloud_agent_with_the_entire_source_home =>
      'Substitua este agente Cloud por toda a pasta pessoal de origem, incluindo credenciais, conversas e ficheiros. A origem não é eliminada. Os bots de mensagens recebidas são desligados.';

  @override
  String get rel_admin_type_destination_agent_id =>
      'Introduza o ID do agente de destino';

  @override
  String
  get rel_admin_could_not_retain_the_local_undo_receipt_keep_this_page_open =>
      'Não foi possível guardar o recibo de anulação local. Mantenha esta página aberta.';

  @override
  String get rel_admin_undo_transfer => 'Anular transferência';

  @override
  String get rel_admin_replace_cloud_agent => 'Substituir agente Cloud';

  @override
  String
  get rel_admin_local_undo_receipt_forgotten_no_remote_backup_was_removed =>
      'Recibo de anulação local esquecido. Nenhuma cópia de segurança remota foi removida.';

  @override
  String get rel_admin_forget_local_undo_receipt_only =>
      'Esquecer apenas o recibo de anulação local';

  @override
  String get rel_admin_stop_before_restore => 'Parar antes de restaurar';

  @override
  String get rel_admin_do_not_close_this_page_restore_runs_on_the =>
      'Não feche esta página. O restauro é executado no destino e não pode ser cancelado.';

  @override
  String get rel_admin_files_restored_destination_gateway_needs_attention =>
      'Ficheiros restaurados; o gateway de destino requer atenção.';

  @override
  String rel_admin_transfer_sign_in(String origin) {
    return 'Inicie sessão em exatamente uma ligação Ares guardada para $origin e volte aqui.';
  }

  @override
  String rel_admin_transfer_source(String gateway, String profile) {
    return 'Origem: $gateway / $profile';
  }

  @override
  String rel_admin_transfer_destination(String name, String origin) {
    return 'Destino: $name · $origin / default';
  }

  @override
  String rel_admin_agent_id(String id) {
    return 'ID do agente: $id';
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
    return 'Ponto de anulação no destino: $path';
  }

  @override
  String rel_admin_messaging_disabled(String channels) {
    return 'Mensagens desativadas: $channels';
  }

  @override
  String get rel_admin_phase_prepared => 'preparado';

  @override
  String get rel_admin_phase_backup => 'cópia de segurança';

  @override
  String get rel_admin_phase_upload => 'carregamento';

  @override
  String get rel_admin_phase_restore => 'restauro';

  @override
  String get rel_admin_phase_finished => 'concluído';

  @override
  String get rel_admin_phase_failed => 'falhou';

  @override
  String get rel_admin_phase_undo => 'anulação';

  @override
  String get rel_admin_phase_undone => 'anulado';

  @override
  String rel_ops_cap_install_blocked(String verdict, String detail) {
    return 'Instalação bloqueada ($verdict): $detail';
  }

  @override
  String rel_ops_cap_scan_confirm(String verdict, String requested) {
    return 'Resultado da análise: $verdict. Confirme $requested antes de instalar.';
  }

  @override
  String rel_ops_cap_install_unconfirmed(String requested) {
    return 'O gateway não confirmou que $requested está instalado.';
  }

  @override
  String rel_ops_cap_edit_skill(String name) {
    return 'Editar $name';
  }

  @override
  String rel_ops_cap_archive_skill(String name) {
    return 'Arquivar $name?';
  }

  @override
  String rel_ops_cap_archive_explanation(String command) {
    return 'A competência será arquivada e poderá ser restaurada com $command.';
  }

  @override
  String rel_ops_cap_install_anyway(String name) {
    return 'Instalar $name na mesma';
  }

  @override
  String rel_ops_cap_install_despite_scan(String name) {
    return 'Instalar $name apesar da análise?';
  }

  @override
  String rel_ops_cap_scan_warning(String name) {
    return 'A análise de segurança bloqueou $name. Esta confirmação aplica-se apenas a $name.';
  }

  @override
  String rel_ops_cap_accept_scan_warning(String name) {
    return 'Aceitar capacidades não ignora a análise de $name.';
  }

  @override
  String rel_ops_cap_review_scan(String name) {
    return 'Rever a análise de $name';
  }

  @override
  String rel_ops_cap_desktop_grants(String description) {
    return '$description\nAs permissões de pastas e de scripts de pré-visualização permanecem na aplicação Desktop desse computador. Remover o plugin aqui não revoga essas permissões locais.';
  }

  @override
  String rel_ops_cap_remove_plugin(String name) {
    return 'Remover $name?';
  }

  @override
  String rel_ops_cap_probe_result(String name, String tools) {
    return 'Teste de $name: $tools';
  }

  @override
  String rel_ops_cap_save_tool_grants_for(String connector) {
    return 'Guardar permissões de ferramentas para $connector';
  }

  @override
  String rel_ops_cap_backends_for(String name) {
    return 'Motores para $name';
  }

  @override
  String rel_ops_cap_use_backend_confirmation(String name) {
    return 'Utilizar $name?';
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
  String get rel_ops_cap_save_skill => 'Guardar competência';

  @override
  String get rel_ops_cap_archive => 'Arquivar';

  @override
  String get rel_ops_cap_hub_identifier => 'Identificador do Hub';

  @override
  String get rel_ops_cap_install => 'Instalar';

  @override
  String get rel_ops_cap_update_all => 'Atualizar tudo';

  @override
  String get rel_ops_cap_unlock => 'Desbloquear';

  @override
  String get rel_ops_cap_lock => 'Bloquear';

  @override
  String get rel_ops_cap_this_update_adds_capabilities_nothing_changed_yet =>
      'Esta atualização adiciona capacidades. Ainda não foi alterado nada.';

  @override
  String get rel_ops_cap_the_scan_blocked_this_plugin =>
      'A análise bloqueou este plugin.';

  @override
  String get rel_ops_cap_the_plugin_was_not_changed =>
      'O plugin não foi alterado.';

  @override
  String get rel_ops_cap_repository => 'Repositório';

  @override
  String get rel_ops_cap_install_plugin => 'Instalar plugin';

  @override
  String get rel_ops_cap_update_plugins => 'Atualizar plugins';

  @override
  String get rel_ops_cap_accept_capabilities => 'Aceitar capacidades';

  @override
  String get rel_ops_cap_update => 'Atualizar';

  @override
  String get rel_ops_cap_remove_desktop_half =>
      'Remover o componente de computador';

  @override
  String get rel_ops_cap_server_name => 'Nome do servidor';

  @override
  String get rel_ops_cap_command => 'Comando';

  @override
  String get rel_ops_cap_http_url => 'URL HTTP';

  @override
  String get rel_ops_cap_add_server => 'Adicionar servidor';

  @override
  String get rel_ops_cap_probe => 'Testar';

  @override
  String get rel_ops_cap_probe_failed => 'O teste falhou.';

  @override
  String get rel_ops_cap_logs => 'Registos';

  @override
  String get rel_ops_cap_mcp_log => 'Registo MCP';

  @override
  String get rel_ops_cap_connector => 'Conector';

  @override
  String get rel_ops_cap_account_alias => 'Nome alternativo da conta';

  @override
  String get rel_ops_cap_link_account => 'Associar conta';

  @override
  String get rel_ops_cap_remove_account => 'Remover conta';

  @override
  String get rel_ops_cap_tool_connector => 'Conector de ferramentas';

  @override
  String get rel_ops_cap_load_tools => 'Carregar ferramentas';

  @override
  String get rel_ops_cap_save_tool_grants =>
      'Guardar permissões de ferramentas';

  @override
  String
  get rel_ops_cap_this_policy_has_no_member_revision_so_tool_grants_stay_unchanged =>
      'Esta política não tem uma revisão de membro, pelo que as permissões de ferramentas permanecem inalteradas.';

  @override
  String get rel_ops_cap_active => 'Ativo';

  @override
  String get rel_ops_cap_use => 'Utilizar';

  @override
  String get rel_ops_cap_run_setup => 'Iniciar configuração';

  @override
  String get rel_ops_cap_terminal_backends => 'Motores de terminal';

  @override
  String get rel_ops_cap_this_changes_the_terminal_backend_for_this_profile =>
      'Isto altera o motor de terminal deste perfil.';

  @override
  String get rel_ops_cap_use_backend => 'Utilizar motor';

  @override
  String get rel_ops_cap_select => 'Selecionar';

  @override
  String get rel_ops_cap_browser_vault => 'Cofre do navegador';

  @override
  String
  get rel_ops_cap_saved_site_logins_addresses_and_cards_passwords_stay_in_the_secure_fields_and_are_not_listed_here =>
      'Inícios de sessão em sites, moradas e cartões guardados. As palavras-passe permanecem nos campos seguros e não são apresentadas aqui.';

  @override
  String get rel_ops_cap_remove_saved_item => 'Remover item guardado';

  @override
  String get rel_ops_cap_delete_this_item => 'Eliminar este item?';

  @override
  String get rel_ops_cap_unlocked => 'Desbloqueado';

  @override
  String get rel_ops_cap_locked => 'Bloqueado';

  @override
  String get rel_ops_cap_not_detected => 'Não detetado';

  @override
  String get rel_ops_cap_master_password => 'Palavra-passe mestra';

  @override
  String get rel_ops_cap_login => 'Dados de início de sessão';

  @override
  String get rel_ops_cap_address => 'Morada';

  @override
  String get rel_ops_cap_card => 'Cartão';

  @override
  String get rel_ops_cap_label => 'Etiqueta';

  @override
  String get rel_ops_cap_site_origin => 'Origem do site';

  @override
  String get rel_ops_cap_identifier => 'Identificador';

  @override
  String get rel_ops_cap_password => 'Palavra-passe';

  @override
  String get rel_ops_cap_authenticator_key => 'Chave de autenticação';

  @override
  String get rel_ops_cap_street => 'Rua';

  @override
  String get rel_ops_cap_city => 'Localidade';

  @override
  String get rel_ops_cap_postal_code => 'Código postal';

  @override
  String get rel_ops_cap_country => 'País';

  @override
  String get rel_ops_cap_name_on_card => 'Nome no cartão';

  @override
  String get rel_ops_cap_card_number => 'Número do cartão';

  @override
  String get rel_ops_cap_expiry_month => 'Mês de validade';

  @override
  String get rel_ops_cap_expiry_year => 'Ano de validade';

  @override
  String get rel_ops_cap_security_code => 'Código de segurança';

  @override
  String get rel_ops_cap_this_gateway_has_no_shared_metrics_consent_method =>
      'Este gateway não tem um método de consentimento para a partilha de métricas.';

  @override
  String get rel_ops_cap_agent_policy => 'Política do agente';

  @override
  String get rel_ops_cap_loading_policy => 'A carregar política';

  @override
  String get rel_ops_cap_approval_timeout => 'Tempo limite de aprovação';

  @override
  String get rel_ops_cap_confirm_mcp_reloads => 'Confirmar recarregamentos MCP';

  @override
  String get rel_ops_cap_command_allowlist => 'Lista de comandos permitidos';

  @override
  String get rel_ops_cap_file_checkpoints => 'Pontos de restauro de ficheiros';

  @override
  String get rel_ops_cap_checkpoint_limit => 'Limite de pontos de restauro';

  @override
  String get rel_ops_cap_browser_private_urls => 'URL privados no navegador';

  @override
  String get rel_ops_cap_use_my_real_browser_profile =>
      'Utilizar o meu perfil real do navegador';

  @override
  String get rel_ops_cap_save_policy => 'Guardar política';

  @override
  String get rel_ops_cap_shared_metrics_for_this_profile =>
      'Métricas partilhadas deste perfil';

  @override
  String get rel_ops_cap_send_shared_metrics => 'Enviar métricas partilhadas';

  @override
  String get rel_ops_cap_error_enter_a_label => 'Introduza uma etiqueta.';

  @override
  String get rel_ops_cap_error_enter_a_valid_url_like_https_example_com =>
      'Introduza um URL válido, como https://example.com.';

  @override
  String get rel_ops_cap_error_enter_the_identifier_and_password =>
      'Introduza o identificador e a palavra-passe.';

  @override
  String
  get rel_ops_cap_error_enter_the_card_name_number_expiry_and_security_code =>
      'Introduza o nome no cartão, o número, a validade e o código de segurança.';

  @override
  String get rel_ops_cap_error_enter_the_street_city_postal_code_and_country =>
      'Introduza a rua, a localidade, o código postal e o país.';

  @override
  String
  get rel_ops_cap_error_the_gateway_returned_a_response_that_could_not_be_read =>
      'O gateway devolveu uma resposta que não foi possível ler.';

  @override
  String rel_ops_cap_error_the_gateway_refused_the_request_status(
    int statusCode,
  ) {
    return 'O gateway recusou o pedido ($statusCode).';
  }

  @override
  String
  rel_ops_cap_error_this_connection_has_no_gateway_socket_so_method_is_unavailable(
    String method,
  ) {
    return 'Esta ligação não tem um socket de gateway, pelo que $method não está disponível.';
  }

  @override
  String get rel_ops_cap_error_choose_a_skill => 'Escolha uma competência.';

  @override
  String get rel_ops_cap_error_the_skill_text_was_not_returned =>
      'O texto da competência não foi devolvido.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_saved =>
      'A competência não foi guardada.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_archived =>
      'A competência não foi arquivada.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_installed =>
      'A competência não foi instalada.';

  @override
  String get rel_ops_cap_error_skill_updates_did_not_start =>
      'As atualizações das competências não foram iniciadas.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_removed =>
      'A competência não foi removida.';

  @override
  String get rel_ops_cap_error_enter_a_skill_or_plugin_identifier =>
      'Introduza um identificador de competência ou plugin.';

  @override
  String get rel_ops_cap_error_choose_a_plugin => 'Escolha um plugin.';

  @override
  String get rel_ops_cap_error_the_plugin_was_not_removed =>
      'O plugin não foi removido.';

  @override
  String get rel_ops_cap_error_the_desktop_half_was_not_removed =>
      'O componente de computador não foi removido.';

  @override
  String
  get rel_ops_cap_error_this_gateway_did_not_give_the_plugin_a_stable_key =>
      'Este gateway não atribuiu uma chave estável ao plugin.';

  @override
  String get rel_ops_cap_error_the_plugin_was_not_changed =>
      'O plugin não foi alterado.';

  @override
  String get rel_ops_cap_error_choose_a_server => 'Escolha um servidor.';

  @override
  String get rel_ops_cap_error_name_the_server => 'Dê um nome ao servidor.';

  @override
  String get rel_ops_cap_error_give_the_server_a_command_or_an_http_s_url =>
      'Indique um comando ou um URL http(s) para o servidor.';

  @override
  String get rel_ops_cap_error_choose_a_toolset =>
      'Escolha um conjunto de ferramentas.';

  @override
  String get rel_ops_cap_error_tool_backend_status_was_not_returned =>
      'O estado do motor de ferramentas não foi devolvido.';

  @override
  String get rel_ops_cap_error_choose_a_provider => 'Escolha um fornecedor.';

  @override
  String get rel_ops_cap_error_this_provider_has_no_setup_action =>
      'Este fornecedor não tem uma ação de configuração.';

  @override
  String get rel_ops_cap_error_setup_did_not_start =>
      'A configuração não foi iniciada.';

  @override
  String get rel_ops_cap_error_choose_a_terminal_backend =>
      'Escolha um motor de terminal.';

  @override
  String get rel_ops_cap_error_name_the_connector => 'Dê um nome ao conector.';

  @override
  String get rel_ops_cap_error_choose_an_account => 'Escolha uma conta.';

  @override
  String
  get rel_ops_cap_error_reload_the_connector_policy_before_changing_tool_grants =>
      'Recarregue a política do conector antes de alterar as permissões de ferramentas.';

  @override
  String get rel_ops_cap_error_choose_an_item => 'Escolha um item.';

  @override
  String get rel_ops_cap_error_choose_a_source => 'Escolha uma origem.';

  @override
  String get rel_ops_cap_error_enter_the_master_password =>
      'Introduza a palavra-passe mestra.';

  @override
  String get rel_ops_cap_error_gateway_config_was_not_returned =>
      'A configuração do gateway não foi devolvida.';

  @override
  String get rel_ops_cap_error_choose_a_known_approval_mode =>
      'Escolha um modo de aprovação conhecido.';

  @override
  String get rel_ops_cap_error_use_a_positive_limit =>
      'Utilize um limite positivo.';

  @override
  String get rel_ops_cap_error_the_policy_was_not_saved =>
      'A política não foi guardada.';

  @override
  String get rel_ops_cap_value_manual => 'manual';

  @override
  String get rel_ops_cap_value_smart => 'inteligente';

  @override
  String get rel_ops_cap_value_off => 'desligado';

  @override
  String get rel_ops_cap_value_safe => 'seguro';

  @override
  String get rel_ops_cap_value_caution => 'cuidado';

  @override
  String get rel_ops_cap_value_dangerous => 'perigoso';

  @override
  String get rel_ops_cap_value_blocked => 'bloqueado';

  @override
  String get rel_ops_cap_value_clean => 'sem ameaças';

  @override
  String get rel_ops_cap_value_ready => 'pronto';

  @override
  String get rel_ops_cap_value_available => 'disponível';

  @override
  String get rel_ops_cap_value_unavailable => 'indisponível';

  @override
  String get rel_ops_cap_value_enabled => 'ativado';

  @override
  String get rel_ops_cap_value_disabled => 'desativado';

  @override
  String get rel_ops_cap_value_active => 'ativo';

  @override
  String get rel_ops_cap_value_inactive => 'inativo';

  @override
  String get rel_ops_cap_value_installed => 'instalado';

  @override
  String get rel_ops_cap_value_missing => 'em falta';

  @override
  String get rel_ops_cap_value_configured => 'configurado';

  @override
  String get rel_ops_cap_value_not_configured => 'não configurado';

  @override
  String get rel_ops_cap_value_error => 'erro';

  @override
  String get rel_ops_cap_value_unknown => 'desconhecido';

  @override
  String get rel_ops_cap_value_login => 'início de sessão';

  @override
  String get rel_ops_cap_value_address => 'morada';

  @override
  String get rel_ops_cap_value_payment => 'pagamento';

  @override
  String get rel_ops_term_connecting => 'A ligar…';

  @override
  String get rel_ops_term_unbound =>
      'Não existe nenhuma sessão ativa ou diretório de trabalho do anfitrião correspondente. Abra primeiro a conversa associada.';

  @override
  String get rel_ops_term_unsupported =>
      'Este Gateway não disponibiliza esta funcionalidade de terminal. Não foi iniciado nenhum interpretador de comandos local.';

  @override
  String get rel_ops_term_local_pty_unavailable =>
      'O pseudoterminal local (PTY) incluído não está disponível neste dispositivo.';

  @override
  String get rel_ops_term_operation_failed =>
      'Não foi possível abrir ou controlar o terminal. Verifique o anfitrião, as credenciais e a impressão digital. Não foi iniciado nenhum interpretador de comandos alternativo.';

  @override
  String get rel_ops_term_input_refused =>
      'Entrada recusada. Volte a abrir a conversa de origem.';

  @override
  String get rel_ops_term_cancel => 'Cancelar';

  @override
  String get rel_ops_term_confirm => 'Confirmar';

  @override
  String get rel_ops_term_open_device_title =>
      'Abrir um interpretador de comandos neste dispositivo?';

  @override
  String get rel_ops_term_ssh_shell => 'Interpretador de comandos SSH';

  @override
  String get rel_ops_term_local_shell => 'Interpretador de comandos local';

  @override
  String get rel_ops_term_connection_lost => 'Ligação perdida';

  @override
  String get rel_ops_term_shell_ended => 'Interpretador de comandos terminado';

  @override
  String get rel_ops_term_no_owner =>
      'Esta conversa não tem um proprietário autenticado do terminal do Gateway. Um URL ou um início de sessão na nuvem, por si só, não dá acesso a um interpretador de comandos.';

  @override
  String get rel_ops_term_open_gateway_title =>
      'Abrir um interpretador de comandos no Gateway?';

  @override
  String get rel_ops_term_shell_expired =>
      'Interpretador de comandos terminado ou expirado';

  @override
  String get rel_ops_term_disconnected => 'Desligado';

  @override
  String get rel_ops_term_gateway_shell =>
      'Interpretador de comandos do Gateway';

  @override
  String get rel_ops_term_close_body =>
      'Terminar este interpretador de comandos. Para o manter em execução, oculte o painel em vez de o fechar.';

  @override
  String get rel_ops_term_closing => 'A fechar…';

  @override
  String get rel_ops_term_close_unconfirmed => 'Fecho não confirmado';

  @override
  String get rel_ops_term_processes_require_chat =>
      'Os processos do agente requerem a conversa autenticada à qual pertencem.';

  @override
  String get rel_ops_term_watching_processes =>
      'A monitorizar os processos do agente desta conversa. Fechar uma vista espelhada nunca para o respetivo processo.';

  @override
  String get rel_ops_term_paste_limit => 'A colagem está limitada a 16 KiB.';

  @override
  String get rel_ops_term_paste => 'Colar';

  @override
  String get rel_ops_term_select_first =>
      'Selecione primeiro a saída do terminal.';

  @override
  String get rel_ops_term_open_chat_to_insert =>
      'Abra a conversa de origem antes de inserir a saída.';

  @override
  String get rel_ops_term_added_to_draft =>
      'Adicionado ao rascunho da conversa de origem. Nada foi enviado.';

  @override
  String get rel_ops_term_close => 'Fechar';

  @override
  String get rel_ops_term_add_selection =>
      'Adicionar seleção ao rascunho da conversa';

  @override
  String get rel_ops_term_new_terminal => 'Novo terminal';

  @override
  String get rel_ops_term_gateway_terminal =>
      'Terminal do anfitrião do Gateway';

  @override
  String get rel_ops_term_verified_ssh_terminal => 'Terminal SSH verificado';

  @override
  String get rel_ops_term_device_local_shell =>
      'Este dispositivo (interpretador de comandos local)';

  @override
  String get rel_ops_term_local_unavailable_mobile =>
      'Interpretador de comandos local indisponível em dispositivos móveis';

  @override
  String get rel_ops_term_watch_processes => 'Monitorizar processos do agente';

  @override
  String get rel_ops_term_select_output => 'Selecionar ou copiar a saída';

  @override
  String get rel_ops_term_add_selected_output =>
      'Adicionar a saída selecionada ao rascunho da conversa';

  @override
  String get rel_ops_term_review_paste =>
      'Rever a colagem da área de transferência';

  @override
  String get rel_ops_term_reconnect =>
      'Voltar a ligar ao mesmo interpretador de comandos';

  @override
  String get rel_ops_term_close_mirror => 'Fechar vista espelhada';

  @override
  String get rel_ops_term_close_shell => 'Fechar interpretador de comandos';

  @override
  String get rel_ops_term_empty =>
      'Selecione + para abrir um terminal. Nenhum interpretador de comandos é iniciado automaticamente.';

  @override
  String get rel_ops_term_reason_stale => 'desatualizado';

  @override
  String get rel_ops_term_reason_mismatch => 'não correspondente';

  @override
  String get rel_ops_term_reason_unbound => 'não associado';

  @override
  String get rel_ops_term_reason_unsupported => 'não suportado';

  @override
  String get rel_ops_term_reason_denied => 'recusado';

  @override
  String get rel_ops_term_reason_ineligible => 'não elegível';

  @override
  String get rel_ops_term_reason_unavailable => 'indisponível';

  @override
  String get rel_ops_term_reason_invalid => 'inválido';

  @override
  String get rel_ops_term_reason_insecure => 'inseguro';

  @override
  String rel_ops_term_refused(String reason) {
    return 'O Gateway recusou esta operação de terminal ($reason).';
  }

  @override
  String rel_ops_term_open_device_body(String connection) {
    return 'Este é o dispositivo do Ares, não $connection. O interpretador de comandos utiliza as permissões da aplicação e inicia-se no armazenamento da aplicação.';
  }

  @override
  String rel_ops_term_open_gateway_body(String host) {
    return 'Inicie um interpretador de comandos em $host, no diretório de trabalho verificado da conversa. Não se trata de um interpretador de comandos do dispositivo.';
  }

  @override
  String rel_ops_term_close_tab_title(String label) {
    return 'Fechar $label?';
  }

  @override
  String rel_ops_term_read_only_status(String status) {
    return 'Só de leitura · $status';
  }

  @override
  String rel_ops_term_paste_title(String label) {
    return 'Colar em $label?';
  }

  @override
  String rel_ops_term_output_title(String label) {
    return 'Saída · $label';
  }

  @override
  String rel_ops_term_mirror_status(String label) {
    return 'Vista espelhada do processo só de leitura · $label';
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
  String get rel_ops_term_earlier_output_trimmed => '[Saída anterior truncada]';

  @override
  String get rel_ops_term_ssh_dialog_title =>
      'Abrir um terminal SSH verificado';

  @override
  String get rel_ops_term_ssh_dialog_body =>
      'Utilize uma impressão digital obtida de forma independente junto do administrador do anfitrião. Isto abre uma nova sessão remota, não o Gateway nem um interpretador de comandos local.';

  @override
  String get rel_ops_term_ssh_host => 'Anfitrião SSH';

  @override
  String get rel_ops_term_ssh_port => 'Porta';

  @override
  String get rel_ops_term_ssh_user => 'Utilizador';

  @override
  String get rel_ops_term_ssh_fingerprint =>
      'Impressão digital da chave do anfitrião (SHA256:…)';

  @override
  String get rel_ops_term_ssh_password => 'Palavra-passe SSH (não é guardada)';

  @override
  String get rel_ops_term_connect => 'Ligar';

  @override
  String get rel_ops_ssh_invalid_destination =>
      'Anfitrião, porta ou utilizador SSH inválido.';

  @override
  String get rel_ops_ssh_public_key_required =>
      'É necessária uma chave pública do anfitrião OpenSSH Ed25519.';

  @override
  String get rel_ops_ssh_invalid_public_key =>
      'Chave do anfitrião Ed25519 inválida.';

  @override
  String get rel_ops_ssh_invalid_saved_key =>
      'A chave do anfitrião guardada é inválida.';

  @override
  String get rel_ops_ssh_enrollment_unverified =>
      'Não foi possível verificar o registo da chave do anfitrião.';

  @override
  String get rel_ops_ssh_different_key_pinned =>
      'Já existe outra chave fixada. Verifique a alteração separadamente.';

  @override
  String get rel_ops_ssh_open_ssh_unavailable =>
      'O OpenSSH do sistema não está disponível.';

  @override
  String get rel_ops_ssh_confirm_host_key =>
      'Confirme a chave do anfitrião antes de estabelecer a ligação.';

  @override
  String get rel_ops_ssh_absolute_identity_required =>
      'Selecione um ficheiro de identidade com um caminho absoluto.';

  @override
  String get rel_ops_ssh_invalid_remote_port => 'Porta remota inválida.';

  @override
  String get rel_ops_ssh_preview_too_large =>
      'A pré-visualização excede o limite de 64 KiB.';

  @override
  String get rel_ops_ssh_connection_refused =>
      'Ligação SSH recusada. Verifique a chave do anfitrião registada, a identidade e o serviço.';

  @override
  String get rel_ops_ssh_http_not_ok =>
      'O serviço remoto não devolveu HTTP 200.';

  @override
  String get rel_ops_ssh_encoded_response =>
      'Esta pré-visualização não suporta respostas codificadas.';

  @override
  String get rel_ops_ssh_preview_type_unsupported =>
      'Só é possível pré-visualizar texto e código-fonte HTML.';

  @override
  String get rel_ops_ssh_health_unconfirmed =>
      'O serviço não confirmou o bom funcionamento do gateway.';

  @override
  String get rel_ops_ssh_enroll_host_key_first =>
      'Registe primeiro a chave pública do anfitrião.';

  @override
  String get rel_ops_ssh_cancel => 'Cancelar';

  @override
  String get rel_ops_ssh_confirm => 'Confirmar';

  @override
  String get rel_ops_ssh_pin_title => 'Fixar esta chave do anfitrião SSH?';

  @override
  String rel_ops_ssh_pin_detail(String destination, String fingerprint) {
    return '$destination\n$fingerprint\nCompare esta impressão digital com o administrador do anfitrião através de um canal independente. Não será estabelecida qualquer ligação.';
  }

  @override
  String get rel_ops_ssh_host_key_pinned => 'Chave do anfitrião fixada.';

  @override
  String get rel_ops_ssh_shell_detail =>
      'Abrir uma shell de início de sessão interativa.';

  @override
  String rel_ops_ssh_read_detail(String path, int port) {
    return 'Ler $path em 127.0.0.1:$port da máquina remota através de um canal SSH.';
  }

  @override
  String rel_ops_ssh_connect_title(String destination) {
    return 'Ligar a $destination?';
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
  String get rel_ops_ssh_agent_auth => 'Autentique-se com o seu agente SSH.';

  @override
  String get rel_ops_ssh_identity_auth =>
      'Utilizar o ficheiro de identidade selecionado.';

  @override
  String rel_ops_ssh_gateway_responding(int port) {
    return 'O gateway está a responder na porta de loopback remota $port.';
  }

  @override
  String get rel_ops_ssh_session_closed => 'Sessão SSH fechada.';

  @override
  String get rel_ops_ssh_session_unclean =>
      'A sessão SSH terminou sem uma saída normal.';

  @override
  String get rel_ops_ssh_operation_failed =>
      'A operação SSH falhou. Verifique o destino e a identidade.';

  @override
  String get rel_ops_ssh_title => 'SSH verificado';

  @override
  String get rel_ops_ssh_unsupported =>
      'Este dispositivo não dispõe de um transporte OpenSSH do sistema suportado. O retransmissor do gateway fixado aceita automaticamente novas chaves e não pode ser utilizado para um registo verificado.';

  @override
  String get rel_ops_ssh_host => 'Anfitrião SSH';

  @override
  String get rel_ops_ssh_port => 'Porta SSH';

  @override
  String get rel_ops_ssh_user => 'Utilizador SSH';

  @override
  String get rel_ops_ssh_identity =>
      'Ficheiro de identidade (opcional; caso contrário, utilizar o agente SSH)';

  @override
  String get rel_ops_ssh_public_key =>
      'Chave pública do anfitrião fornecida pelo administrador (ssh-ed25519)';

  @override
  String get rel_ops_ssh_review_key => 'Rever chave do anfitrião';

  @override
  String get rel_ops_ssh_remote_port => 'Porta do serviço de loopback remoto';

  @override
  String get rel_ops_ssh_check_gateway => 'Verificar gateway por SSH';

  @override
  String get rel_ops_ssh_preview_source =>
      'Pré-visualizar código-fonte por SSH';

  @override
  String get rel_ops_ssh_open_shell => 'Abrir shell SSH';

  @override
  String get rel_ops_ssh_shell_line => 'Linha para a shell remota';

  @override
  String get rel_ops_ssh_disconnect => 'Desligar shell';

  @override
  String get rel_ops_host_cancel => 'Cancelar';

  @override
  String get rel_ops_host_confirm => 'Confirmar';

  @override
  String get rel_ops_host_title => 'Host';

  @override
  String get rel_ops_host_refresh => 'Atualizar';

  @override
  String get rel_ops_host_update => 'Atualizar o Hermes remoto';

  @override
  String rel_ops_host_update_confirmation(String profile) {
    return 'Isto inicia uma atualização da instalação existente no host do gateway para $profile. Não atualiza o Ares neste dispositivo. O sucesso é comprovado pelo comprovativo de atualização correspondente, e não pelo facto de o host continuar acessível.';
  }

  @override
  String get rel_ops_host_update_awaiting =>
      'A aguardar o comprovativo correspondente. A atualização ainda está em curso.';

  @override
  String get rel_ops_host_receipt_success =>
      'O comprovativo de atualização indica sucesso.';

  @override
  String get rel_ops_host_receipt_partial =>
      'Atualização aplicada, mas ainda há passos de acompanhamento por concluir.';

  @override
  String get rel_ops_host_receipt_failed =>
      'O comprovativo de atualização indica uma falha.';

  @override
  String get rel_ops_host_receipt_refused =>
      'O comprovativo de atualização indica uma recusa.';

  @override
  String get rel_ops_host_update_running =>
      'A atualização ainda está em curso.';

  @override
  String get rel_ops_host_update_unknown =>
      'O resultado da atualização é desconhecido. Um gateway ativo não significa uma atualização bem-sucedida.';

  @override
  String get rel_ops_host_default_profile => 'o perfil predefinido do gateway';

  @override
  String get rel_ops_host_restart => 'Reiniciar o gateway remoto';

  @override
  String rel_ops_host_restart_shared_confirmation(String profiles) {
    return 'Isto reinicia o gateway partilhado por $profiles. Os turnos em curso neste gateway serão interrompidos. Volte a ligar-se depois. A acessibilidade não comprova que o reinício terminou.';
  }

  @override
  String rel_ops_host_restart_confirmation(String profile) {
    return 'Isto reinicia o gateway remoto para $profile. Os turnos em curso neste gateway serão interrompidos. Volte a ligar-se depois.';
  }

  @override
  String get rel_ops_host_restart_running =>
      'O comando de reinício ainda está em execução.';

  @override
  String get rel_ops_host_restart_finished =>
      'O comando de reinício terminou. Volte a ligar-se ao host manualmente.';

  @override
  String get rel_ops_host_restart_failed => 'O comando de reinício falhou.';

  @override
  String rel_ops_host_maintenance_running(String name) {
    return '$name ainda está em execução';
  }

  @override
  String rel_ops_host_maintenance_finished(String name) {
    return '$name terminou';
  }

  @override
  String rel_ops_host_maintenance_failed(String name) {
    return '$name falhou';
  }

  @override
  String get rel_ops_host_curator_paused_result => 'Curador em pausa.';

  @override
  String get rel_ops_host_curator_resumed_result => 'Curador retomado.';

  @override
  String get rel_ops_host_reset => 'Repor ficheiros de memória remotos';

  @override
  String rel_ops_host_reset_confirmation(String targetName, String profile) {
    return 'Eliminar o ficheiro de memória $targetName em $profile? Não é possível anular esta ação a partir do Ares.';
  }

  @override
  String rel_ops_host_reset_result(String targetName, int count) {
    return '$targetName reposto. Foram removidos $count ficheiro(s) remoto(s).';
  }

  @override
  String get rel_ops_host_share_not_redacted =>
      'O host não confirmou que os dados sensíveis do pacote foram ocultados. Não é apresentada nenhuma ligação.';

  @override
  String rel_ops_host_scope(String connection, String profile) {
    return 'Estes controlos atuam sobre o gateway remoto $connection para $profile, não sobre este dispositivo nem sobre a atualização do cliente Ares.';
  }

  @override
  String rel_ops_host_health_running(String version, int count) {
    return 'Processo do gateway em execução $version · $count sessões';
  }

  @override
  String rel_ops_host_health_stopped(String version, int count) {
    return 'Processo do gateway parado $version · $count sessões';
  }

  @override
  String rel_ops_host_heartbeat_stale(num seconds) {
    return 'O sinal de atividade do host está desatualizado ($seconds s).';
  }

  @override
  String get rel_ops_host_doctor => 'Executar Doctor';

  @override
  String get rel_ops_host_security_audit => 'Auditoria de segurança';

  @override
  String get rel_ops_host_check_receipt =>
      'Verificar comprovativo da atualização';

  @override
  String get rel_ops_host_logs => 'Registos do host remoto';

  @override
  String get rel_ops_host_search_logs => 'Pesquisar registos do host';

  @override
  String get rel_ops_host_driver => 'Controlador do host remoto';

  @override
  String get rel_ops_host_driver_scope =>
      'A prontidão do controlo do computador depende do controlador e das permissões do sistema operativo da máquina do gateway, não deste dispositivo.';

  @override
  String rel_ops_host_computer_status(
    String platform,
    String installed,
    String ready,
  ) {
    return '$platform · instalado $installed · pronto $ready';
  }

  @override
  String get rel_ops_host_null => 'indisponível';

  @override
  String get rel_ops_host_true => 'sim';

  @override
  String get rel_ops_host_false => 'não';

  @override
  String get rel_ops_host_curator => 'Curador';

  @override
  String get rel_ops_host_curator_paused => 'Curador em pausa';

  @override
  String get rel_ops_host_curator_running => 'Curador em execução';

  @override
  String get rel_ops_host_no_run => 'Nenhuma execução concluída';

  @override
  String get rel_ops_host_run_curator => 'Executar Curador agora';

  @override
  String get rel_ops_host_reset_memory => 'Repor ficheiro de memória';

  @override
  String get rel_ops_host_reset_user => 'Repor ficheiro do utilizador';

  @override
  String get rel_ops_host_reset_both => 'Repor ambos os ficheiros';

  @override
  String get rel_ops_host_share_consent =>
      'Concordo em carregar um pacote de diagnóstico do host remoto com os dados sensíveis ocultados';

  @override
  String get rel_ops_host_share =>
      'Partilhar diagnósticos com dados sensíveis ocultados';

  @override
  String get rel_ops_host_update_unknown_installation =>
      'Esta instalação é desconhecida, pelo que a atualização não foi enviada';

  @override
  String get rel_ops_host_update_busy_installation =>
      'Está em curso uma conversa nesta instalação';

  @override
  String get rel_ops_host_update_refused => 'Atualização remota recusada';

  @override
  String get rel_ops_host_error_stale =>
      'Área de trabalho remota: desatualizada';

  @override
  String get rel_ops_host_error_mismatch =>
      'Área de trabalho remota: não corresponde';

  @override
  String get rel_ops_host_error_unbound =>
      'Área de trabalho remota: sem associação';

  @override
  String get rel_ops_host_error_unsupported =>
      'Área de trabalho remota: não suportada';

  @override
  String get rel_ops_host_error_denied =>
      'Área de trabalho remota: acesso negado';

  @override
  String get rel_ops_host_error_ineligible =>
      'Área de trabalho remota: não elegível';

  @override
  String get rel_ops_host_error_unavailable =>
      'Área de trabalho remota: indisponível';

  @override
  String get rel_ops_host_error_invalid => 'Área de trabalho remota: inválida';

  @override
  String get rel_ops_host_error_insecure => 'Área de trabalho remota: insegura';

  @override
  String get rel_ops_host_error_request =>
      'Não foi possível concluir o pedido.';

  @override
  String get rel_svc_push_api_select_sessions =>
      'Selecione entre 1 e 128 IDs de sessão duradouros, cada um com 1–200 carateres ASCII, utilizando apenas letras, algarismos, _ . : @ ou -. Remova IDs vazios e espaços em branco.';

  @override
  String get rel_svc_push_api_unavailable =>
      'As notificações push móveis não estão disponíveis neste servidor.';

  @override
  String get rel_svc_push_api_invalid_vapid =>
      'A chave pública VAPID do servidor é inválida.';

  @override
  String get rel_svc_push_api_update_plugin =>
      'Este servidor necessita de um plugin mobile-push atualizado para subscrições automáticas.';

  @override
  String get rel_svc_push_status_android_only => 'Apenas Android';

  @override
  String get rel_svc_push_native_prefs_sync_failed =>
      'Não foi possível sincronizar as preferências de notificações nativas.';

  @override
  String get rel_svc_push_choose_android_connection =>
      'Escolha primeiro uma ligação guardada no Android.';

  @override
  String get rel_svc_push_status_checking_authorization =>
      'A verificar a autorização do servidor';

  @override
  String get rel_svc_push_revoke_persist_failed =>
      'Não foi possível guardar a revogação. Tente desativar novamente antes de sair da aplicação.';

  @override
  String get rel_svc_push_status_off_api_ready =>
      'Desativado; API do servidor pronta';

  @override
  String get rel_svc_push_status_off_revoke_pending =>
      'Desativado; revogação no servidor pendente';

  @override
  String get rel_svc_push_status_off_connection_changed =>
      'Desativado; a ligação guardada foi alterada';

  @override
  String get rel_svc_push_status_pending_endpoint =>
      'A aguardar o endpoint do distribuidor';

  @override
  String get rel_svc_push_status_registering => 'A registar';

  @override
  String get rel_svc_push_status_pending_challenge =>
      'Desafio encriptado pendente (a aguardar uma notificação push silenciosa de verificação do servidor)';

  @override
  String get rel_svc_push_allow_android_notifications_retry =>
      'Permita as notificações do Android nas definições do sistema e tente novamente.';

  @override
  String get rel_svc_push_plugin_invalid =>
      'O plugin mobile-push do servidor está indisponível, desatualizado ou devolveu uma resposta de subscrição inválida. Peça ao operador para o atualizar e tente novamente.';

  @override
  String get rel_svc_push_transport_unavailable =>
      'Não está disponível qualquer transporte push. A entrega integrada requer Google Play Services funcional; em alternativa, instale um distribuidor UnifiedPush e tente novamente.';

  @override
  String get rel_svc_push_transport_choice =>
      'Estão disponíveis vários distribuidores UnifiedPush. Escolha um em Transporte avançado e tente novamente.';

  @override
  String get rel_svc_push_transport_missing =>
      'O distribuidor UnifiedPush selecionado não está disponível. Restaure-o ou escolha outro em Transporte avançado.';

  @override
  String get rel_svc_push_companion_unavailable =>
      'O componente mobile-push do servidor não está disponível. Pode estar em falta ou desativado, ou esta ligação pode apontar para o painel errado. Instale ou ative o componente no servidor, verifique a ligação ao painel e atualize. Consulte o guia de configuração do servidor acima.';

  @override
  String get rel_svc_push_server_denied =>
      'O servidor recusou as notificações push móveis. Peça ao operador para autorizar este principal e estas sessões.';

  @override
  String get rel_svc_push_not_ready =>
      'As notificações push móveis não estão prontas. Verifique a autorização do plugin do servidor, o distribuidor e a rede e tente novamente.';

  @override
  String get rel_svc_push_availability_read_failed =>
      'Não foi possível verificar a disponibilidade de push no Android. Tente novamente abaixo.';

  @override
  String get rel_svc_push_setup_failed =>
      'A configuração de push falhou. Verifique a permissão do Android, a autorização do servidor e o transporte e tente novamente.';

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
    return 'Estado: associado a $bound (não ativo para $connection; negociação: $status)';
  }

  @override
  String get rel_svc_push_another_saved_connection => 'outra ligação guardada';

  @override
  String get rel_svc_push_background_notifications =>
      'Notificações em segundo plano';

  @override
  String rel_svc_push_bound_subtitle(String bound, String connection) {
    return 'Associado a $bound — revogue esta associação abaixo antes de ativar para $connection';
  }

  @override
  String rel_svc_push_private_activity(String connection) {
    return 'Atividade privada do servidor para $connection';
  }

  @override
  String rel_svc_push_bound_warning_named(String bound) {
    return 'Associado a outra ligação guardada ($bound). Desative e revogue essa associação antes de ativar para esta ligação.';
  }

  @override
  String get rel_svc_push_bound_warning =>
      'Associado a outra ligação guardada. Desative e revogue essa associação antes de ativar para esta ligação.';

  @override
  String get rel_svc_push_local_notifications_muted =>
      'As notificações locais estão desativadas acima. O consentimento para notificações em segundo plano mantém-se, mas os avisos de atividade normais ficam silenciados até ativar \"Ativar notificações\".';

  @override
  String rel_svc_push_legacy_subscription(int count) {
    return 'Subscrição antiga: apenas $count sessão(ões) selecionada(s). Não será expandida automaticamente. Desative e volte a ativar para aceitar sessões autorizadas pelo servidor.';
  }

  @override
  String get rel_svc_push_authorized_binding =>
      'Associado apenas a esta ligação guardada e perfil. O acesso às sessões segue a autorização atual do servidor.';

  @override
  String get rel_svc_push_revocation_pending =>
      'Revogação no servidor pendente. A entrega local está desativada; tente novamente enquanto o início de sessão guardado original estiver disponível.';

  @override
  String get rel_svc_push_refresh_retry => 'Atualizar / tentar novamente';

  @override
  String rel_svc_push_disable_named(String bound) {
    return 'Desativar e revogar $bound';
  }

  @override
  String get rel_svc_push_other_connection => 'outra ligação';

  @override
  String get rel_svc_push_disable => 'Desativar e revogar';

  @override
  String get rel_svc_push_refresh_explanation =>
      'Atualizar / tentar novamente volta a verificar a disponibilidade após configurar o servidor; não instala o componente. Ativar notificações continua a ser uma escolha separada.';

  @override
  String get rel_svc_push_companion_required =>
      'As notificações em segundo plano requerem um componente mobile-push do servidor instalado e ativado separadamente. O Android não o pode instalar. Atualizar apenas o APK não configura o servidor.';

  @override
  String get rel_svc_push_server_setup_guide =>
      'Guia de configuração do servidor';

  @override
  String get rel_svc_push_enable_disclosure =>
      'Ative para pedir permissão de notificações do Android e partilhar com este servidor o endpoint e as chaves de encriptação desta instalação. Os avisos de atividade encriptados não contêm conteúdo de conversas. Incluem-se apenas sessões autorizadas pelo seu início de sessão no servidor.';

  @override
  String get rel_svc_push_transport_disclosure =>
      'A entrega integrada usa o transporte push da Google e requer Google Play Services, mas não inclui o SDK Firebase. Pode usar um distribuidor UnifiedPush opcional. A entrega é por melhor esforço; reabra o Hermes para reconciliar.';

  @override
  String get rel_svc_push_advanced_transport => 'Transporte avançado';

  @override
  String get rel_svc_push_automatic_explanation =>
      'Automático mantém a escolha de distribuidor existente; caso contrário, usa a entrega Google integrada quando disponível. Desative antes de mudar o transporte.';

  @override
  String get rel_svc_push_transport_label => 'Transporte push';

  @override
  String get rel_svc_push_automatic_recommended => 'Automático (recomendado)';

  @override
  String get rel_svc_push_selected_unavailable =>
      'Distribuidor selecionado (indisponível)';

  @override
  String get rel_svc_push_no_transport_detected =>
      'Não foi detetado qualquer transporte disponível. A entrega integrada requer Google Play Services; sem ele, instale e configure um distribuidor UnifiedPush e atualize.';

  @override
  String get rel_svc_push_channel_turns_name => 'Turnos do Ares';

  @override
  String get rel_svc_push_channel_turns_description =>
      'Notificações de turnos concluídos em segundo plano';

  @override
  String get rel_svc_push_channel_attention_name => 'Atenção do Ares';

  @override
  String get rel_svc_push_channel_attention_description =>
      'Aprovações e pedidos de entrada que precisam de si';

  @override
  String get rel_svc_push_channel_background_name => 'Ares em segundo plano';

  @override
  String get rel_svc_push_channel_background_description =>
      'Conclusões de tarefas em segundo plano';

  @override
  String get rel_svc_push_channel_notices_name => 'Avisos do Ares';

  @override
  String get rel_svc_push_channel_notices_description =>
      'Avisos de créditos e plugins';

  @override
  String get rel_svc_push_diag_not_initialised => 'não inicializado';

  @override
  String get rel_svc_push_diag_replies_off => 'as respostas estão desativadas';

  @override
  String get rel_svc_push_diag_conversation => 'conversa';

  @override
  String get rel_svc_push_diag_conversation_permission_denied =>
      'conversa; permissão negada';

  @override
  String rel_svc_push_diag_conversation_error(String error) {
    return 'conversa: $error';
  }

  @override
  String get rel_svc_push_diag_failures_off => 'as falhas estão desativadas';

  @override
  String rel_svc_push_diag_kind_off(String kind) {
    return '$kind está desativado';
  }

  @override
  String get rel_svc_push_diag_windows_setting_unknown =>
      'O Windows não comunicou a definição de notificações';

  @override
  String get rel_svc_backup_not_hermes_configuration_backup =>
      'Este ficheiro não é uma cópia de segurança da configuração do Hermes.';

  @override
  String get rel_svc_backup_newer_version_cannot_import =>
      'Esta cópia de segurança foi criada por uma versão mais recente da aplicação e não pode ser importada.';

  @override
  String get rel_svc_backup_missing_client_certificate =>
      'Esta cópia de segurança declara um certificado de cliente para uma ligação, mas não o contém, pelo que não é possível restaurar tudo.';

  @override
  String get rel_svc_backup_damaged_unreadable =>
      'Este ficheiro de cópia de segurança está danificado e não foi possível lê-lo.';

  @override
  String get rel_svc_backup_unsupported_preference_type =>
      'Uma preferência guardada tem um tipo não suportado e não pode ser exportada.';

  @override
  String get rel_svc_backup_choose_passphrase_api_keys =>
      'Escolha uma frase-passe — a cópia de segurança contém as suas chaves de API.';

  @override
  String get rel_svc_backup_could_not_protect_safely =>
      'Não foi possível proteger a cópia de segurança em segurança.';

  @override
  String get rel_svc_backup_unsupported_encryption =>
      'Esta cópia de segurança utiliza um esquema de encriptação não suportado.';

  @override
  String get rel_svc_backup_wrong_passphrase_or_altered =>
      'A frase-passe está errada ou este ficheiro de cópia de segurança foi alterado.';

  @override
  String get rel_svc_backup_share_subject =>
      'Cópia de segurança da configuração do Hermes';

  @override
  String get rel_svc_backup_selected_file_unreadable =>
      'Não foi possível ler esse ficheiro.';

  @override
  String rel_svc_backup_connections_added(int count) {
    return '$count adicionadas';
  }

  @override
  String rel_svc_backup_connections_updated(int count) {
    return '$count atualizadas';
  }

  @override
  String rel_svc_backup_connections_removed(int count) {
    return '$count removidas';
  }

  @override
  String get rel_svc_backup_no_connection_changes =>
      'Sem alterações às ligações';

  @override
  String rel_svc_backup_connections_summary(String changes) {
    return 'Ligações: $changes';
  }

  @override
  String rel_svc_backup_restore_summary(String connections, int count) {
    return '$connections · $count definições restauradas';
  }

  @override
  String rel_svc_backup_certificate_not_included(String label, String error) {
    return 'Não foi possível incluir o certificado de cliente de \"$label\" nesta cópia de segurança: $error';
  }

  @override
  String get rel_svc_backup_certificate_password_needed =>
      'Este certificado precisa da respetiva palavra-passe. Introduza-a abaixo e será aberto automaticamente.';

  @override
  String get rel_svc_backup_certificate_password_or_corrupt =>
      'A palavra-passe do certificado está incorreta ou o ficheiro está danificado.';

  @override
  String get rel_svc_backup_certificate_password_incorrect =>
      'A palavra-passe do certificado está incorreta.';

  @override
  String get rel_svc_backup_certificate_unsupported_encryption =>
      'Este certificado utiliza um método de encriptação que a aplicação não consegue ler.';

  @override
  String get rel_svc_backup_certificate_unreadable_pkcs12 =>
      'O ficheiro selecionado não é um certificado PKCS#12 (.p12/.pfx) legível.';

  @override
  String get rel_svc_backup_certificate_unreadable =>
      'Não foi possível ler o certificado selecionado.';

  @override
  String get rel_svc_backup_not_certificate_file =>
      'Esse ficheiro não é um certificado: escolha um contentor .p12/.pfx ou ficheiros de certificado e chave PEM.';

  @override
  String get rel_svc_backup_not_pem_certificate =>
      'O certificado selecionado não é um certificado PEM.';

  @override
  String get rel_svc_backup_not_pem_private_key =>
      'A chave privada selecionada não é uma chave privada PEM.';

  @override
  String get rel_svc_backup_certificate_pair_unloadable =>
      'Não foi possível carregar o certificado e a chave privada selecionados.';

  @override
  String get rel_svc_backup_saved_certificate_files_unreadable =>
      'Não foi possível ler os ficheiros guardados do certificado de cliente.';

  @override
  String get rel_svc_backup_client_certificate_storage_failed =>
      'Não foi possível guardar o certificado de cliente em segurança neste dispositivo.';

  @override
  String get rel_svc_backup_certificate_storage_failed =>
      'Não foi possível guardar o certificado em segurança neste dispositivo.';

  @override
  String get rel_svc_backup_client_certificate_label =>
      'Certificado de cliente';

  @override
  String rel_svc_backup_search_dashboard_unreachable(String error) {
    return 'Não foi possível aceder ao painel: $error';
  }

  @override
  String get rel_svc_backup_search_credentials_rejected =>
      'O painel rejeitou as credenciais guardadas. Verifique o nome de utilizador e a palavra-passe do painel para esta ligação.';

  @override
  String get rel_svc_backup_search_not_supported =>
      'Este painel não disponibiliza a pesquisa de sessões. Atualize o Hermes no anfitrião ou volte à pesquisa no dispositivo.';

  @override
  String rel_svc_backup_search_redirected(int statusCode) {
    return 'O painel redirecionou a pesquisa de sessões (HTTP $statusCode). O Ares não segue redirecionamentos com credenciais guardadas; verifique o endereço da ligação.';
  }

  @override
  String rel_svc_backup_search_http_failed(int statusCode) {
    return 'A pesquisa de sessões falhou com HTTP $statusCode.';
  }

  @override
  String get rel_svc_backup_search_malformed_response =>
      'O painel devolveu uma resposta de pesquisa malformada.';

  @override
  String get rel_svc_backup_search_unexpected_response =>
      'O painel devolveu uma resposta de pesquisa inesperada.';

  @override
  String get rel_svc_backup_search_too_many_results =>
      'O painel devolveu mais resultados de pesquisa do que os pedidos.';

  @override
  String get rel_svc_backup_message_search_unexpected_response =>
      'Resposta inesperada da pesquisa de mensagens.';

  @override
  String get rel_svc_backup_message_search_unexpected_result =>
      'Resultado inesperado da pesquisa de mensagens.';

  @override
  String get rel_svc_backup_ai_search_api_key_rejected =>
      'A API do Hermes rejeitou a chave de API guardada.';

  @override
  String rel_svc_backup_ai_search_http_failed(int statusCode) {
    return 'A reformulação da consulta por IA falhou com HTTP $statusCode.';
  }

  @override
  String get rel_svc_backup_ai_search_no_usable_query =>
      'O modelo selecionado não devolveu uma consulta de pesquisa utilizável.';

  @override
  String get rel_svc_backup_ai_search_malformed_response =>
      'O Hermes devolveu uma resposta de reformulação por IA malformada.';

  @override
  String get rel_svc_backup_space_name_already_exists =>
      'Já existe um espaço com este nome';

  @override
  String get rel_svc_backup_space_name_length_invalid =>
      'O nome do espaço deve ter entre 1 e 80 carateres';

  @override
  String get ng_rel_svc_backup_gateway_address_required =>
      'Introduza o endereço do seu painel do Hermes.';

  @override
  String ng_rel_svc_backup_gateway_address_scheme(String scheme) {
    return 'O endereço tem de começar por http:// ou https:// (recebido: $scheme).';
  }

  @override
  String get ng_rel_svc_backup_gateway_address_invalid =>
      'Esse endereço não é válido.';

  @override
  String get ng_rel_svc_backup_gateway_address_no_host =>
      'O endereço não tem nome de anfitrião.';

  @override
  String get ng_rel_svc_backup_sign_in_main_window =>
      'Inicie sessão na janela principal.';

  @override
  String get rel_svc_backup_sign_in_renewal_failed =>
      'O gateway não conseguiu renovar o início de sessão neste momento.';

  @override
  String get rel_svc_backup_sign_in_provider_unreachable =>
      'O gateway não conseguiu renovar o início de sessão: o fornecedor de início de sessão está inacessível.';

  @override
  String get rel_svc_backup_sign_in_renewal_timed_out =>
      'O tempo limite para renovar o início de sessão foi excedido.';

  @override
  String get rel_svc_backup_sign_in_no_tokens =>
      'O gateway não devolveu tokens de início de sessão.';

  @override
  String get ng_rel_svc_backup_probe_timed_out =>
      'O tempo limite foi excedido. Verifique o endereço e a ligação VPN ou Tailscale.';

  @override
  String ng_rel_svc_backup_probe_tls_failed(String error) {
    return 'A negociação TLS falhou: $error';
  }

  @override
  String ng_rel_svc_backup_gateway_answered_http(int statusCode) {
    return 'O gateway respondeu com HTTP $statusCode.';
  }

  @override
  String get ng_rel_svc_backup_gateway_answer_timed_out =>
      'O gateway demorou demasiado a responder.';

  @override
  String ng_rel_svc_backup_browser_callback_not_ready(String error) {
    return 'Não foi possível preparar o regresso do navegador: $error';
  }

  @override
  String get ng_rel_svc_backup_browser_signed_in_body =>
      'Já pode voltar ao Hermes.';

  @override
  String get ng_rel_svc_backup_browser_waiting_title =>
      'A aguardar o início de sessão';

  @override
  String get ng_rel_svc_backup_browser_not_current =>
      'Esta página não faz parte do início de sessão atual.';

  @override
  String get ng_rel_svc_backup_browser_open_failed =>
      'Não foi possível abrir o navegador para iniciar sessão.';

  @override
  String get ng_rel_svc_backup_browser_sign_in_timed_out =>
      'O início de sessão demorou demasiado. Tente novamente.';

  @override
  String ng_rel_svc_backup_gateway_refused_sign_in(int statusCode) {
    return 'O gateway recusou o início de sessão (HTTP $statusCode).';
  }

  @override
  String get rel_svc_misc_alert_caution => 'Cuidado';

  @override
  String get rel_svc_misc_alert_important => 'Importante';

  @override
  String get rel_svc_misc_alert_tip => 'Sugestão';

  @override
  String get rel_svc_misc_alert_warning => 'Aviso';

  @override
  String get rel_svc_misc_allow_folder_session =>
      'Permitir esta pasta até a sessão terminar.';

  @override
  String get rel_svc_misc_allow_website_session =>
      'Permitir este site até a sessão terminar.';

  @override
  String rel_svc_misc_approval_needed_title(String title) {
    return 'Aprovação necessária — $title';
  }

  @override
  String get rel_svc_misc_attach_file_reference =>
      'Anexar uma referência de ficheiro';

  @override
  String get rel_svc_misc_attach_folder_reference =>
      'Anexar uma referência de pasta';

  @override
  String get rel_svc_misc_attach_git_context => 'Anexar contexto git';

  @override
  String get rel_svc_misc_attach_image_reference =>
      'Anexar uma referência de imagem';

  @override
  String get rel_svc_misc_attach_staged_diff => 'Anexar o diff preparado';

  @override
  String get rel_svc_misc_attach_tool_reference =>
      'Anexar uma referência de ferramenta';

  @override
  String get rel_svc_misc_attach_unstaged_diff => 'Anexar o diff não preparado';

  @override
  String get rel_svc_misc_attach_url_reference =>
      'Anexar uma referência de URL';

  @override
  String get rel_svc_misc_background_task_completed =>
      'Tarefa em segundo plano concluída';

  @override
  String rel_svc_misc_background_task_named_completed(String taskId) {
    return 'Tarefa em segundo plano $taskId concluída';
  }

  @override
  String get rel_svc_misc_chat => 'Conversa';

  @override
  String get rel_svc_misc_compacting_context =>
      'A compactar o contexto da conversa…';

  @override
  String rel_svc_misc_completed_in(String duration) {
    return 'Concluído em $duration';
  }

  @override
  String get rel_svc_misc_context_compacted =>
      'Contexto da conversa compactado';

  @override
  String get rel_svc_misc_cron_readback_mismatch =>
      'A releitura do modelo Cron não correspondeu';

  @override
  String get rel_svc_misc_cron_update_rejected =>
      'Atualização do Cron recusada';

  @override
  String get rel_svc_misc_deny_folder_grant =>
      'Não conceder acesso a esta pasta.';

  @override
  String get rel_svc_misc_deny_website_grant =>
      'Não conceder acesso a este site.';

  @override
  String rel_svc_misc_failed_after(String duration) {
    return 'Falhou após $duration';
  }

  @override
  String get rel_svc_misc_gateway_folder_unnamed =>
      'O gateway não indicou uma pasta.';

  @override
  String get rel_svc_misc_gateway_idle_unconfirmed =>
      'O gateway está inativo. Não foi possível confirmar o resultado do turno anterior.';

  @override
  String get rel_svc_misc_gateway_turn_failed => 'O turno do gateway falhou';

  @override
  String rel_svc_misc_gateway_turn_status(String status) {
    return 'Turno do gateway: $status';
  }

  @override
  String get rel_svc_misc_gateway_website_unnamed =>
      'O gateway não indicou um site.';

  @override
  String get rel_svc_misc_hermes_review => 'Revisão do Hermes';

  @override
  String get rel_svc_misc_hermes_turn_failed => 'O turno do Hermes falhou';

  @override
  String get rel_svc_misc_image_recovery_companion_gap =>
      'A recuperação de imagens e texto não está disponível na recuperação complementar. Um envio de imagem não confirmado não pode ser restaurado nesta ligação e nada é reenviado automaticamente.';

  @override
  String get rel_svc_misc_image_recovery_rest_gap =>
      'A recuperação de imagens e texto não está disponível no Classic REST/SSE. Um envio de imagem não confirmado não pode ser restaurado nesta ligação e nada é reenviado automaticamente.';

  @override
  String rel_svc_misc_input_needed_title(String title) {
    return 'Resposta necessária — $title';
  }

  @override
  String get rel_svc_misc_parallel_workspace_connection_changed =>
      'A ligação foi alterada. Volte a abri-la para utilizar o espaço de trabalho.';

  @override
  String get rel_svc_misc_preparing => 'A preparar';

  @override
  String get rel_svc_misc_save_folder_grant =>
      'Guardar esta permissão de pasta para pedidos posteriores.';

  @override
  String get rel_svc_misc_save_website_grant =>
      'Guardar esta permissão do site para pedidos posteriores.';

  @override
  String get rel_svc_misc_stored_identity_turn_conflict =>
      'Esta conversa foi aberta através da respetiva identidade guardada enquanto outro turno estava admitido. O pedido por enviar não foi enviado; tente novamente de forma explícita depois de esse turno terminar.';

  @override
  String get rel_svc_misc_untitled => 'Sem título';

  @override
  String get rel_svc_misc_wake_capture_silent =>
      'A captura de ativação do cliente apenas deteta silêncio — verifique o acesso do sistema operativo ao microfone e volte a ativar a palavra de ativação.';

  @override
  String get rel_svc_misc_wake_capture_stalled =>
      'A captura de ativação do cliente parou: não chegaram chamadas de retorno de áudio do microfone.';

  @override
  String rel_svc_misc_wake_feed_refused(int count, String detail) {
    return 'O fluxo da palavra de ativação recusou $count fotogramas consecutivos$detail — volte a ativar a palavra de ativação.';
  }

  @override
  String rel_svc_misc_wake_microphone_failed(String error) {
    return 'O fluxo do microfone de ativação do cliente falhou: $error';
  }

  @override
  String get rel_svc_misc_wake_track_ended =>
      'A faixa do microfone terminou durante a captura da palavra de ativação — volte a ativar a palavra de ativação.';

  @override
  String get rel_svc_misc_website => 'Site';

  @override
  String get rel_svc_lan_timeout =>
      'A descoberta na LAN excedeu o tempo limite';

  @override
  String get rel_svc_notification_permission_denied => 'permissão recusada';

  @override
  String get rel_svc_notifications_off => 'as notificações estão desativadas';

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
  String get fleet_managed_ssh_title => 'SSH gerido pelo gateway';

  @override
  String get fleet_managed_ssh_intro =>
      'Gira os anfitriões SSH já guardados neste gateway a partir de qualquer dispositivo. O Hermes tem de estar instalado no anfitrião remoto. Esta operação inicia um serviço remoto pertencente ao gateway ou liga-se a esse serviço, não estabelece uma ligação de conversa do Ares. As atualizações geridas e a recuperação só estão disponíveis na aplicação nativa de computador.';

  @override
  String get fleet_managed_ssh_read => 'Ler anfitriões SSH guardados';

  @override
  String get fleet_managed_ssh_trust =>
      'Nesta primeira ligação, o gateway irá confiar na chave SSH deste anfitrião e memorizá-la. Uma alteração posterior da chave será assinalada e bloqueada. O gateway não comunica a impressão digital da chave, pelo que o Ares não a pode apresentar nem guardar. Continue apenas se confiar nesta primeira ligação.';

  @override
  String get fleet_managed_ssh_changed =>
      'A chave SSH deste anfitrião foi alterada. Ligação bloqueada. Alguém com acesso ao anfitrião do gateway tem de verificar de forma independente a impressão digital da nova chave e remover aí a antiga chave de confiança. Tente novamente apenas após essa verificação e reparação. O Ares não substitui a chave de confiança.';

  @override
  String get fleet_managed_ssh_disconnect_warning =>
      'Desligar o túnel SSH e parar o serviço remoto pertencente a este gateway? Isto pode interromper outros clientes que utilizem esse serviço.';

  @override
  String get fleet_managed_ssh_verify =>
      'Verificar a chave pessoalmente em alternativa';

  @override
  String fleet_managed_ssh_pending(int seconds) {
    return 'A aguardar o gateway: $seconds s. Sair desta página não cancela a inicialização. Se o pedido falhar, verifique o estado antes de tentar novamente.';
  }

  @override
  String fleet_managed_ssh_status(
    String host,
    int localPort,
    int remotePort,
    String version,
    String reused,
  ) {
    return 'Anfitrião: $host\nPorta de loopback do gateway: $localPort\nPorta de loopback remota: $remotePort\nHermes: $version\nReutilizado: $reused';
  }

  @override
  String get fleet_managed_ssh_disconnect => 'Desligar';

  @override
  String get ng_slash_suggestions_loading => 'A carregar comandos…';

  @override
  String get ng_slash_suggestions_empty => 'Nenhum comando correspondente';

  @override
  String get ng_slash_suggestions_label => 'Sugestões de comandos';

  @override
  String get ng_slash_suggestions_skill => 'Competência';

  @override
  String get settings_classic_title => 'Definições Classic';

  @override
  String get settings_nextgen_title => 'Definições NextGen';

  @override
  String get settings_category_general => 'Geral e idioma';

  @override
  String get settings_category_chat => 'Conversa e sessões';

  @override
  String get settings_category_device => 'Dispositivo e atalhos';

  @override
  String get settings_category_connections => 'Ligações e modelos';

  @override
  String get settings_category_security => 'Privacidade e cópia de segurança';

  @override
  String get settings_category_about => 'Acerca de e ajuda';

  @override
  String get settings_reopen_chat =>
      'Restaurar a última conversa ao regressar a um gateway';

  @override
  String get settings_reopen_chat_hint =>
      'Um arranque a frio abre o ecrã de boas-vindas. As ligações e notificações abrem a conversa pedida.';

  @override
  String get settings_danger => 'Zona de perigo';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get attachment_audio_failed =>
      'Não foi possível reproduzir este áudio. O formato ou codec pode não ser compatível, ou o limite de tamanho da prévia foi excedido. Tente novamente, salve ou compartilhe o arquivo original.';

  @override
  String get attachment_audio_seek => 'Posição do áudio';

  @override
  String get workspace_workers => 'Subagentes ativos';

  @override
  String get workers_unattached =>
      'Apenas contagens. Para orientar um subagente, selecione Subagentes ativos na conversa principal conectada.';

  @override
  String get slash_local_arguments =>
      'Este atalho não aceita argumentos aqui. Use os controles do aplicativo; seu rascunho foi mantido.';

  @override
  String get fallback_title => 'Modelos alternativos';

  @override
  String get fallback_notice =>
      'São tentados em ordem quando o modelo principal está indisponível. As alterações se aplicam apenas a este perfil; salve explicitamente a lista completa.';

  @override
  String get fallback_unavailable =>
      'As configurações alternativas estão indisponíveis ou são inválidas. Verifique a conexão, o perfil selecionado e a versão do servidor e tente novamente.';

  @override
  String get fallback_discovery_unavailable =>
      'Não foi possível obter os provedores. As entradas existentes são preservadas; tente novamente para escolher provedores e modelos.';

  @override
  String get fallback_empty => 'Não há entradas nesta lista de alternativas.';

  @override
  String get fallback_incomplete =>
      'Escolha um provedor e um modelo para cada entrada ou remova as entradas incompletas antes de salvar.';

  @override
  String get fallback_add => 'Adicionar alternativa';

  @override
  String get fallback_save => 'Salvar lista de alternativas';

  @override
  String get fallback_save_failed =>
      'Não foi possível verificar a lista salva. Seu rascunho foi preservado. Salve novamente ou atualize para carregar as configurações do servidor.';

  @override
  String get fallback_saved => 'Lista de alternativas salva e verificada.';

  @override
  String get fallback_legacy_title => 'Alternativas antigas (somente leitura)';

  @override
  String get fallback_legacy_notice =>
      'O servidor também usa fallback_model após esta lista, ignorando rotas duplicadas. Essas entradas antigas são preservadas mesmo com a lista acima vazia. Edite-as no servidor.';

  @override
  String fallback_priority(String position) {
    return 'Prioridade $position';
  }

  @override
  String get fallback_move_up => 'Mover para cima';

  @override
  String get fallback_move_down => 'Mover para baixo';

  @override
  String get fallback_routing_read_only =>
      'Os detalhes de roteamento ou um provedor não listado são preservados. Edite este provedor/modelo no servidor; você pode reordenar ou remover a entrada aqui.';

  @override
  String get cron_model_default => 'Seguir padrão';

  @override
  String get cron_model_notice =>
      'Aplica-se apenas a esta tarefa cron. Sem modelo fixo, o Hermes usa o padrão cron e depois o modelo principal. Gerencie modelos personalizados no servidor.';

  @override
  String get model_management_unavailable =>
      'Não foi possível carregar ou salvar as configurações do modelo. Atualize e tente novamente.';

  @override
  String get model_management_subtitle =>
      'Modelos principal, alternativos e auxiliares deste perfil';

  @override
  String get usage => 'Uso';

  @override
  String get nous_portal => 'Nous Portal';

  @override
  String get portal_menu_subtitle => 'Status do gateway e uso registrado';

  @override
  String get portal_read_only =>
      'Dados somente leitura do gateway. Gerencie a autenticação Nous no host do Hermes. Estes endpoints não fornecem saldos de assinatura nem créditos.';

  @override
  String get portal_status => 'Status do Portal no gateway';

  @override
  String get portal_free_tier => 'Acesso gratuito (sem conta conectada)';

  @override
  String get portal_signed_in => 'Conectado';

  @override
  String get portal_signed_out => 'Não conectado';

  @override
  String get portal_account_tier => 'Nível da conta';

  @override
  String get portal_recorded_usage => 'Uso registrado';

  @override
  String get portal_all_providers =>
      'Todos os provedores do perfil de gateway selecionado. Um custo registrado de zero não significa que o modelo seja gratuito.';

  @override
  String portal_period(String days) {
    return 'Últimos $days dias';
  }

  @override
  String get portal_sessions => 'Sessões';

  @override
  String get portal_input => 'Tokens de entrada';

  @override
  String get portal_output => 'Tokens de saída';

  @override
  String get portal_estimated => 'Custo estimado registrado';

  @override
  String get portal_actual => 'Custo real registrado';

  @override
  String get portal_recorded_models => 'Modelos registrados';

  @override
  String get portal_no_models => 'Nenhum modelo registrado.';

  @override
  String get portal_unavailable =>
      'Indisponível. Verifique a conexão, o perfil selecionado e a versão do gateway e tente novamente.';

  @override
  String get paste_attachment_failed_text_kept =>
      'Não foi possível anexar o texto colado. O texto foi mantido na mensagem.';

  @override
  String get background_task_report => 'Tarefa em segundo plano';

  @override
  String get background_process_report => 'Processo em segundo plano';

  @override
  String get background_report_issues =>
      'Problemas relatados — expanda para ver os detalhes.';

  @override
  String get background_report_expand => 'Expandir relatório';

  @override
  String get background_report_collapse => 'Recolher relatório';

  @override
  String get ng_brand_open_chat => 'Abrir um chat';

  @override
  String get ng_brand_recent => 'Recentes';

  @override
  String get ng_brand_sidebar_hint => 'ou escolha um chat na barra lateral';

  @override
  String get copy_session_id => 'Copiar ID da sessão';

  @override
  String get copy_session_id_failed =>
      'Não foi possível copiar o ID da sessão.';

  @override
  String get setup_interface_title => 'Escolha sua interface';

  @override
  String get setup_interface_classic => 'Classic';

  @override
  String get setup_interface_nextgen => 'NextGen';

  @override
  String get setup_interface_classic_description =>
      'A área de trabalho original do Ares, com todos os controles de conexão e configurações do Classic.';

  @override
  String get setup_interface_nextgen_description =>
      'Um visual novo com uma única entrada no painel, planos ao vivo, subagentes e notificações.';

  @override
  String get setup_interface_switch_later =>
      'Você pode trocar quando quiser em Configurações.';

  @override
  String get ng_confirm_model_switch => 'Trocar de modelo?';

  @override
  String get ng_switch => 'Trocar';

  @override
  String get ng_model_confirmation_required =>
      'Este modelo precisa de confirmação antes de ser selecionado.';

  @override
  String ng_model_switches_next_turn(String model) {
    return 'Troca para $model no próximo turno.';
  }

  @override
  String get ng_model_switch_not_connected =>
      'A conversa não está pronta para trocar de modelo. Abra-a novamente e tente de novo.';

  @override
  String ng_gateway_kept_default_model(String model) {
    return 'O gateway manteve $model nesta conversa. Escolha o modelo novamente antes de enviar.';
  }

  @override
  String get hands_free_title => 'Mãos livres';

  @override
  String get hands_free_start => 'Iniciar mãos livres';

  @override
  String get hands_free_stop => 'Parar mãos livres';

  @override
  String get hands_free_preparing => 'Preparando voz — aguarde';

  @override
  String get hands_free_listening => 'Diga Hey Hermes';

  @override
  String get hands_free_recording => 'Pronto — fale agora';

  @override
  String get hands_free_waiting => 'Aguardando Hermes';

  @override
  String get hands_free_speaking => 'Falando — microfone desligado';

  @override
  String hands_free_followup(int seconds) {
    return 'Ouvir por até $seconds segundos';
  }

  @override
  String get hands_free_error => 'Mãos livres parado';

  @override
  String get hands_free_setup => 'Configurar mãos livres';

  @override
  String hands_free_preview(String transcript) {
    return 'Prévia de voz: $transcript';
  }

  @override
  String get hands_free_short_disclosure =>
      'Só com este chat aberto em primeiro plano. Ativação offline; a voz pode usar redes. Consome bateria.';

  @override
  String get hands_free_error_action =>
      'Confira microfone, serviço de voz, voz da resposta e conexão. Toque em Parar e Iniciar. Nada é reenviado.';

  @override
  String get hands_free_disclosure =>
      'A ativação funciona offline na CPU. O reconhecimento Android, a voz escolhida e o gateway podem usar redes. A escuta consome bateria e pode ativar por engano. Para ao cobrir ou fechar o chat ou sair do primeiro plano, sem reinício automático. O ditado manual continua como rascunho editável.';

  @override
  String get hands_free_ready_cue =>
      'Diga “Hey Hermes”, espere por “Pronto” e fale. Sem captura na mesma frase nem áudio anterior. Se a permissão sair do app, toque em Iniciar novamente após concedê-la.';

  @override
  String get hands_free_settings_title => 'Voz mãos-livres';

  @override
  String get hands_free_settings_subtitle =>
      'Mostra o controle de início \"Hey Hermes\" nos chats. Desligar interrompe qualquer sessão mãos-livres em andamento.';

  @override
  String get hands_free_timing_limit =>
      'A janela de continuação é um máximo, não um mínimo. O Android pode parar antes. O silêncio volta à ativação local sem reinícios repetidos do reconhecimento.';

  @override
  String get hands_free_followup_off =>
      'Continuação desativada — diga Hey Hermes para cada mensagem';

  @override
  String get hands_free_start_blocked =>
      'Requer rascunho vazio, sem anexos, chat conectado e sem atividade e respostas faladas ativas. Termine primeiro as ações de voz manuais.';

  @override
  String get hands_free_setup_complete =>
      'Configuração do microfone concluída. Toque em Iniciar novamente.';

  @override
  String message_time_recorded(String time) {
    return 'Registrado pelo servidor: $time (horário local)';
  }

  @override
  String message_time_sent(String time) {
    return 'Envio observado neste dispositivo: $time (horário local)';
  }

  @override
  String message_time_received(String time) {
    return 'Recebido pela primeira vez neste dispositivo: $time (horário local)';
  }

  @override
  String get stop_and_send => 'Parar e enviar';

  @override
  String get message_queued_for_running_turn =>
      'Mensagem na fila da execução atual.';

  @override
  String get running_message_not_accepted =>
      'O Hermes não conseguiu aceitar esta mensagem. Seu rascunho foi mantido; pare a resposta ou aguarde e envie novamente.';

  @override
  String get running_message_delivery_unknown =>
      'Não foi possível confirmar a entrega. Seu rascunho foi mantido. Confira a conversa antes de tentar novamente.';

  @override
  String get attachment_tap_to_preview => 'Toque para visualizar';

  @override
  String get attachment_save => 'Salvar';

  @override
  String get attachment_share => 'Compartilhar';

  @override
  String get attachment_saved => 'Arquivo salvo';

  @override
  String get attachment_save_cancelled => 'Salvamento cancelado';

  @override
  String get attachment_save_failed =>
      'Não foi possível salvar este arquivo. Tente novamente.';

  @override
  String get attachment_share_failed =>
      'Não foi possível compartilhar este arquivo. Tente novamente.';

  @override
  String get attachment_download_failed =>
      'Não foi possível carregar este arquivo. Verifique a conexão e tente novamente.';

  @override
  String get attachment_no_inline_preview =>
      'Não há prévia disponível para este tipo de arquivo. Salve ou compartilhe o arquivo original para abri-lo em outro aplicativo.';

  @override
  String get attachment_image_failed =>
      'Não foi possível decodificar esta imagem. Você ainda pode salvar ou compartilhar o arquivo original.';

  @override
  String get attachment_text_truncated =>
      'Prévia abreviada. Salve ou compartilhe o arquivo para ler todo o conteúdo.';

  @override
  String get attachment_text_unavailable =>
      'Não foi possível exibir este arquivo como texto. Salve ou compartilhe o arquivo original.';

  @override
  String get attachment_pdf_failed =>
      'Não foi possível visualizar este PDF. Salve ou compartilhe o arquivo original.';

  @override
  String get attachment_pdf_unavailable =>
      'A prévia de PDF está disponível no Android. Você ainda pode salvar ou compartilhar este arquivo.';

  @override
  String attachment_pdf_page(int page, int total) {
    return 'Página $page de $total';
  }

  @override
  String get attachment_previous_page => 'Página anterior';

  @override
  String get attachment_next_page => 'Próxima página';

  @override
  String get attachment_loading => 'Carregando prévia…';

  @override
  String get attachment_document_text_notice =>
      'Prévia do texto. O layout, as imagens e a formatação podem diferir do original.';

  @override
  String get attachment_document_failed =>
      'Não foi possível visualizar este documento. Salve ou compartilhe o arquivo original.';

  @override
  String get attachment_document_empty =>
      'Nenhum texto legível foi encontrado neste documento.';

  @override
  String get attachment_video_failed =>
      'Não foi possível reproduzir este vídeo. O formato ou codec pode não ser compatível. Salve ou compartilhe o arquivo original.';

  @override
  String get attachment_video_play => 'Reproduzir';

  @override
  String get attachment_video_pause => 'Pausar';

  @override
  String get attachment_video_mute => 'Silenciar';

  @override
  String get attachment_video_unmute => 'Ativar som';

  @override
  String get attachment_video_seek => 'Posição do vídeo';

  @override
  String get attachment_close => 'Fechar prévia';

  @override
  String get attachment_retry => 'Tentar novamente';

  @override
  String get saved_history_heading => 'Histórico salvo';

  @override
  String get received_output_heading =>
      'Resposta recebida — correspondência com o histórico salvo não confirmada';

  @override
  String get received_output_details => 'Sobre a resposta recebida';

  @override
  String get received_output_explanation =>
      'Isso também pode aparecer no histórico salvo. O app não consegue confirmar a correspondência.';

  @override
  String get local_prompt_context => 'Contexto local do prompt';

  @override
  String get received_output_badge =>
      'Recebido · correspondência não confirmada';

  @override
  String get received_output_lifetime =>
      'A resposta recebida é mantida temporariamente nesta sessão do app e pode ser encurtada ou removida ao atingir os limites. Ela pode não estar disponível após o fechamento do app ou da conexão.';

  @override
  String get theme_palette => 'Tema de cor';

  @override
  String get theme_palette_gold => 'Dourado';

  @override
  String get theme_palette_purple => 'Roxo';

  @override
  String get theme_palette_orange => 'Laranja';

  @override
  String get theme_palette_green => 'Verde';

  @override
  String get theme_palette_blue => 'Azul';

  @override
  String get theme_palette_red => 'Vermelho';

  @override
  String get theme_palette_teal => 'Verde-petróleo';

  @override
  String get theme_palette_pink => 'Rosa';

  @override
  String get theme_palette_indigo => 'Índigo';

  @override
  String get theme_palette_cyan => 'Ciano';

  @override
  String get assets_recent_subtitle =>
      'Encontre arquivos compartilhados pelo Hermes em chats salvos';

  @override
  String get assets_scope_notice =>
      'Arquivos gerados e compartilhados explicitamente pelo Hermes em respostas salvas. Esta é uma visão parcial do histórico de chats, não um catálogo completo de arquivos ou anexos. Os arquivos referenciados podem não existir mais.';

  @override
  String get assets_download_limit =>
      'Os arquivos só são carregados ao tocar neles. Pré-visualizações e downloads têm limite de 25 MiB por arquivo; use o painel para arquivos maiores.';

  @override
  String get assets_search_hint =>
      'Buscar nos arquivos encontrados ou nos chats de origem';

  @override
  String get assets_all => 'Todos';

  @override
  String get assets_images => 'Imagens';

  @override
  String get assets_audio => 'Áudio';

  @override
  String get assets_video => 'Vídeo';

  @override
  String get assets_documents => 'Documentos e outros arquivos';

  @override
  String get assets_empty =>
      'Nenhum recurso encontrado nas mensagens examinadas';

  @override
  String get assets_empty_detail =>
      'Examine mais chats ou mensagens mais antigas para consultar um período anterior. Anexos comuns e arquivos sem links não são indexados aqui.';

  @override
  String get assets_no_matches => 'Nenhum recurso correspondente';

  @override
  String get assets_load_more_chats => 'Examinar mais chats';

  @override
  String get assets_load_older_messages => 'Examinar mensagens mais antigas';

  @override
  String get assets_load_failed =>
      'Algumas partes do histórico não puderam ser lidas. Os resultados estão incompletos. Verifique a conexão com o painel e tente novamente.';

  @override
  String get assets_retry_failed => 'Tentar novamente as leituras que falharam';

  @override
  String get assets_partial =>
      'O servidor informou que o histórico está incompleto. Verifique o painel e atualize em seguida.';

  @override
  String assets_scan_summary(int files, int chats) {
    return 'Referências a arquivos encontradas: $files · Chats examinados: $chats';
  }

  @override
  String assets_open_chat(String title) {
    return 'Abrir chat: $title';
  }

  @override
  String get assets_file_too_large =>
      'Este arquivo excede o limite de download. Abra o painel para baixá-lo.';

  @override
  String get a_one_off_question_archives_itself_after_72_hours_anything =>
      'Uma pergunta pontual. É arquivada automaticamente após 72 horas; o que valer a pena guardar continua na memória.';

  @override
  String get archive_chat => 'Arquivar chat';

  @override
  String get unarchive_chat => 'Desarquivar chat';

  @override
  String get chat_archived => 'Chat arquivado';

  @override
  String get chat_unarchived => 'Chat desarquivado';

  @override
  String could_not_update_chat_archive(Object error) {
    return 'Não foi possível alterar o arquivo do chat: $error';
  }

  @override
  String get quick_chat_description => 'Uma pergunta pontual.';

  @override
  String get ai_full_text => 'IA + texto completo';

  @override
  String get ai_search_model => 'Modelo de busca com IA';

  @override
  String ai_searched_for(Object aiRewrittenQuery) {
    return 'A IA buscou: $aiRewrittenQuery';
  }

  @override
  String get ai_assisted_filing => 'Arquivamento assistido por IA';

  @override
  String get api_key => 'Chave de API';

  @override
  String get api_server_key_from_hermes_env =>
      'API_SERVER_KEY de ~/.hermes/.env';

  @override
  String get active => 'Ativo';

  @override
  String get activity => 'Atividade';

  @override
  String get activity_reads_the_durable_turn_journal_to_know_what_hermes =>
      'A atividade lê o diário de turnos durável para saber o que o Hermes está fazendo. Verifique se o Gateway está acessível e tente novamente.';

  @override
  String get add => 'Adicionar';

  @override
  String get add_connection => 'Adicionar conexão';

  @override
  String get add_cron_job => 'Adicionar tarefa Cron';

  @override
  String get add_gateway_connection => 'Adicionar conexão de Gateway';

  @override
  String get add_and_update_connections_from_the_backup_keep_the_rest =>
      'Adicionar e atualizar conexões do backup; manter as demais.';

  @override
  String get add_attachment => 'Adicionar anexo';

  @override
  String get add_new_cron_job => 'Adicionar nova tarefa Cron';

  @override
  String get add_to_chat => 'Adicionar ao chat';

  @override
  String get all_chats => 'Todos os chats';

  @override
  String get all_stored_message_content =>
      'Todo o conteúdo de mensagens armazenado';

  @override
  String get allow_for_this_session => 'Permitir nesta sessão';

  @override
  String get allow_matching_commands_until_this_hermes_session_ends =>
      'Permitir comandos correspondentes até esta sessão do Hermes terminar.';

  @override
  String get allow_folder_until_sandbox_off =>
      'Permitir esta pasta até a sandbox ser desativada.';

  @override
  String get allow_once => 'Permitir uma vez';

  @override
  String get allow_website_until_sandbox_off =>
      'Permitir este site até a sandbox ser desativada.';

  @override
  String get always_allow => 'Permitir sempre';

  @override
  String get apply_to_this_chat => 'Aplicar a este chat';

  @override
  String get approval_needed => 'Aprovação necessária';

  @override
  String get approval_needed_description =>
      'Um comando aguarda sua aprovação ou recusa.';

  @override
  String get approve => 'Aprovar';

  @override
  String get archive => 'Arquivar';

  @override
  String get archive_project => 'Arquivar projeto';

  @override
  String archive_2(Object projectName) {
    return 'Arquivar $projectName?';
  }

  @override
  String archive_3(Object name) {
    return 'Arquivar $name?';
  }

  @override
  String get archived => 'Arquivado';

  @override
  String get archived_conversations_appear_here =>
      'Só as conversas arquivadas aparecem aqui. Os chats antigos continuam em Todos os chats.';

  @override
  String get archived_quick_chats => 'Chats rápidos arquivados';

  @override
  String get artifacts_attachments_and_generated_media =>
      'Artefatos, anexos e mídia gerada';

  @override
  String get ask_ai_to_find_a_conversation =>
      'Pedir à IA para encontrar uma conversa';

  @override
  String get assets => 'Recursos';

  @override
  String get assets_need_a_server_authoritative_assets_index_in_the_hermes =>
      'Os recursos precisam de um índice autoritativo do servidor no Gateway do Hermes antes de serem exibidos por projeto.';

  @override
  String get assets_unavailable => 'Recursos indisponíveis';

  @override
  String get attach_image_or_file => 'Anexar imagem ou arquivo';

  @override
  String get attachment_drafts => 'Rascunhos de anexos';

  @override
  String get recover_text_draft => 'Recuperar um rascunho de texto';

  @override
  String get undo_draft_recovery => 'Desfazer';

  @override
  String get draft_session_exists =>
      'Esta conversa ainda existe. Abra-a para continuar o rascunho.';

  @override
  String get draft_recovery_unavailable =>
      'Não foi possível verificar o rascunho. Nada foi alterado.';

  @override
  String attachment_of(Object index, Object total) {
    return 'Anexo $index de $total';
  }

  @override
  String get auto_device_default => 'Automático (padrão do dispositivo)';

  @override
  String get agent => 'Agente';

  @override
  String get autonomous_agents => 'Agentes autônomos';

  @override
  String get background_recovery_unavailable_legacy_transport =>
      'Recuperação em segundo plano indisponível — transporte legado';

  @override
  String get background_task_completed => 'Tarefa em segundo plano concluída';

  @override
  String get background_task_completed_description =>
      'Um comando de terminal em segundo plano foi concluído.';

  @override
  String get backup_restore => 'Backup e restauração';

  @override
  String backup_exported(Object destination) {
    return 'Backup exportado — $destination';
  }

  @override
  String get base_url => 'URL base';

  @override
  String get binary_preview_is_unavailable_download_the_file_to_open_it =>
      'A pré-visualização de binários não está disponível. Baixe o arquivo para abri-lo.';

  @override
  String get branch => 'Ramificação';

  @override
  String get branch_chat => 'Criar ramificação do chat';

  @override
  String get branch_created_in_hermes_history =>
      'Ramificação criada no histórico do Hermes.';

  @override
  String get browse_and_manage_your_hermes_agent_sessions_from_your_phone =>
      'Navegue e gerencie suas sessões do Hermes Agent pelo celular. Conecta-se a um painel do Hermes em execução na sua rede local.';

  @override
  String get browse_server_files => 'Navegar pelos arquivos do servidor';

  @override
  String get browse_the_miniserver_folders_behind_your_projects =>
      'Navegue pelas pastas do miniserver por trás dos seus projetos';

  @override
  String get cancel => 'Cancelar';

  @override
  String get cancel_voice_input => 'Cancelar entrada de voz';

  @override
  String cannot_reach(Object host, Object port) {
    return 'Não é possível alcançar $host:$port.';
  }

  @override
  String cannot_reach_check_the_host_and_port(Object host, Object port) {
    return 'Não é possível alcançar $host:$port. Verifique o host e a porta.';
  }

  @override
  String get change_ai_search_model => 'Alterar modelo de busca com IA';

  @override
  String changes_the_default_for_use_the_selector_in_a_chat(Object label) {
    return 'Altera o padrão de $label. Use o seletor em um chat para substituir apenas aquela conversa.';
  }

  @override
  String get chat_actions => 'Ações do chat';

  @override
  String get chats => 'Chats';

  @override
  String get chats_from_this_gateway_are_not_grouped_yet_grouping_stays =>
      'Os chats deste Gateway ainda não são agrupados. O agrupamento fica neste celular até que o Gateway possa hospedar projetos.';

  @override
  String get chats_in_this_project_will_show_their_state_and_last =>
      'Os chats deste projeto mostrarão aqui seu estado e última atividade.';

  @override
  String get chats_that_are_not_assigned_to_a_project =>
      'Chats que não estão atribuídos a um projeto';

  @override
  String get chats_you_start_in_this_project_will_appear_here_on =>
      'Os chats que você iniciar neste projeto aparecerão aqui, em todos os dispositivos conectados a este Hermes.';

  @override
  String get check_that_the_gateway_is_running_and_reachable_then_try =>
      'Verifique se o Gateway está em execução e acessível e tente novamente.';

  @override
  String get check_the_dashboard_connection_and_try_again =>
      'Verifique a conexão do painel e tente novamente.';

  @override
  String get check_the_connection_and_try_again =>
      'Verifique a conexão e tente novamente.';

  @override
  String get choose_a_small_model_to_rewrite_queries =>
      'Escolha um modelo pequeno para reescrever consultas';

  @override
  String get choose_an_ai_search_model_before_using_ai_search =>
      'Escolha um modelo de busca com IA antes de usar a busca com IA.';

  @override
  String get choose_an_active_project_next =>
      'Escolha um projeto ativo em seguida';

  @override
  String get choose_chat_model => 'Escolher modelo do chat';

  @override
  String get choose_files => 'Escolher arquivos';

  @override
  String get choose_image => 'Escolher imagem';

  @override
  String get choose_images => 'Escolher imagens';

  @override
  String get choose_its_destination_space => 'Escolha o espaço de destino';

  @override
  String get clear_search => 'Limpar busca';

  @override
  String get close => 'Fechar';

  @override
  String get code_copied => 'Código copiado';

  @override
  String get code_format => 'Código';

  @override
  String get coming_next => 'Em breve';

  @override
  String get command => 'Comando';

  @override
  String get command_palette => 'Paleta de comandos';

  @override
  String get command_palette_hint => 'Digite um comando';

  @override
  String get command_palette_no_results => 'Nenhum comando encontrado';

  @override
  String get command_palette_new_chat => 'Novo chat';

  @override
  String get command_palette_search_chats => 'Buscar chats';

  @override
  String get command_palette_toggle_theme => 'Alternar tema';

  @override
  String get command_palette_copy_last_code => 'Copiar último bloco de código';

  @override
  String get command_line_chats => 'Chats de linha de comando';

  @override
  String get compatibility_mode => 'Modo de compatibilidade';

  @override
  String get configure_a_valid_desktop_gateway_url_before_attaching_files =>
      'Configure uma URL válida do Desktop Gateway antes de anexar arquivos.';

  @override
  String get confirm_always_allow => 'Confirmar permitir sempre';

  @override
  String get confirm_passphrase => 'Confirmar frase secreta';

  @override
  String connecting_to(Object baseUrl) {
    return 'Conectando a $baseUrl...';
  }

  @override
  String get connection_issue => 'Problema de conexão';

  @override
  String
  get connection_switched_the_running_reply_continues_on_the_server_and =>
      'Conexão alterada — a resposta em andamento continua no servidor e será reconectada automaticamente.';

  @override
  String get connection_appearance_and_device_preferences =>
      'Conexão, aparência e preferências do dispositivo';

  @override
  String context_tokens(Object effectiveContextLength) {
    return 'Contexto: $effectiveContextLength tokens';
  }

  @override
  String get continue_label => 'Continuar';

  @override
  String get continue_working => 'Continuar trabalhando';

  @override
  String get conversations_in_this_project => 'Conversas neste projeto';

  @override
  String get copy_code => 'Copiar código';

  @override
  String get copy_message => 'Copiar mensagem';

  @override
  String could_not_branch_chat(Object error) {
    return 'Não foi possível criar ramificação do chat: $error';
  }

  @override
  String could_not_delete_session(Object error) {
    return 'Não foi possível excluir a sessão: $error';
  }

  @override
  String could_not_deny_the_command(Object error) {
    return 'Não foi possível negar o comando: $error';
  }

  @override
  String could_not_load_ai_search_models(Object error) {
    return 'Não foi possível carregar os modelos de busca com IA: $error';
  }

  @override
  String get could_not_load_conversations =>
      'Não foi possível carregar as conversas';

  @override
  String get could_not_load_files => 'Não foi possível carregar os arquivos';

  @override
  String could_not_load_models_for_this_profile(Object error) {
    return 'Não foi possível carregar os modelos deste perfil: $error';
  }

  @override
  String could_not_load_more_chats(Object error) {
    return 'Não foi possível carregar mais chats: $error';
  }

  @override
  String get could_not_open_link => 'Não foi possível abrir este link.';

  @override
  String get could_not_open_the_hermes_dashboard =>
      'Não foi possível abrir o painel do Hermes.';

  @override
  String get could_not_open_this_project =>
      'Não foi possível abrir este projeto';

  @override
  String get could_not_preview_file =>
      'Não foi possível pré-visualizar o arquivo';

  @override
  String get could_not_reach_hermes => 'Não foi possível alcançar o Hermes';

  @override
  String could_not_reach_authenticate_the_dashboard_at_check_the_port(
    Object dashboardPort,
    Object host,
  ) {
    return 'Não foi possível alcançar/autenticar o painel em $host:$dashboardPort. Verifique a porta e as credenciais.';
  }

  @override
  String get could_not_read_activity => 'Não foi possível ler a atividade';

  @override
  String could_not_rename_chat(Object error) {
    return 'Não foi possível renomear o chat: $error';
  }

  @override
  String could_not_send_the_approval(Object error) {
    return 'Não foi possível enviar a aprovação: $error';
  }

  @override
  String get could_not_skip_the_hermes_question =>
      'Não foi possível pular a pergunta do Hermes.';

  @override
  String could_not_the_project(Object action, Object error) {
    return 'Não foi possível $action o projeto: $error';
  }

  @override
  String get couldn_t_delete_project => 'Não foi possível excluir o projeto';

  @override
  String couldn_t_load_runs(Object error) {
    return 'Não foi possível carregar as execuções: $error';
  }

  @override
  String get couldn_t_move_conversation => 'Não foi possível mover a conversa';

  @override
  String couldn_t_move_to(Object label, Object reason) {
    return 'Não foi possível mover para $label: $reason';
  }

  @override
  String get couldn_t_prepare_the_shared_files =>
      'Não foi possível preparar os arquivos compartilhados.';

  @override
  String get couldn_t_promote_conversation =>
      'Não foi possível promover a conversa';

  @override
  String couldn_t_project(Object action) {
    return 'Não foi possível $action o projeto';
  }

  @override
  String get create => 'Criar';

  @override
  String get create_a_project => 'Criar um projeto';

  @override
  String get create_a_project_first_then_chats_can_live_inside_it =>
      'Crie um projeto primeiro; depois os chats poderão viver dentro dele.';

  @override
  String get create_a_space_to_separate_related_conversations =>
      'Crie um espaço para separar conversas relacionadas.';

  @override
  String get create_branch => 'Criar ramificação';

  @override
  String get credit_notifications => 'Notificações de crédito';

  @override
  String get credit_notifications_description =>
      'O uso de crédito foi interrompido ou restaurado.';

  @override
  String get cron => 'Cron';

  @override
  String get crons => 'Agenda';

  @override
  String get cron_conversations_empty =>
      'As conversas de tarefas agendadas aparecem aqui, incluindo execuções anteriores.';

  @override
  String get search_cron_conversations =>
      'Buscar conversas de tarefas agendadas';

  @override
  String get cron_jobs => 'Tarefas Cron';

  @override
  String cron_schedule_timezone(Object zone) {
    return 'Fuso horário do agendamento: $zone';
  }

  @override
  String get crons_upcoming => 'Próximas';

  @override
  String get crons_history => 'Histórico';

  @override
  String cron_time_with_zone(Object time, Object zone) {
    return '$time ($zone)';
  }

  @override
  String cron_time_zone_unknown(Object time) {
    return '$time (fuso horário desconhecido)';
  }

  @override
  String get cron_no_next_run => 'Sem próxima execução agendada';

  @override
  String get cron_status_scheduled => 'Agendada';

  @override
  String get cron_status_paused => 'Em pausa';

  @override
  String cron_delivers_to(Object target) {
    return 'Entrega em $target';
  }

  @override
  String get cron_upcoming_empty_title => 'Sem tarefas agendadas';

  @override
  String get cron_upcoming_empty_message =>
      'Não há nada agendado para executar. Crie uma tarefa em Tarefas Cron ou peça ao agente para agendar uma.';

  @override
  String get cron_upcoming_unavailable => 'Tarefas agendadas indisponíveis';

  @override
  String get cron_upcoming_needs_dashboard =>
      'As tarefas agendadas precisam de uma conexão com o painel. Este endereço não disponibiliza o agendamento Cron. Verifique o endereço do painel e o suporte do host.';

  @override
  String get cron_upcoming_needs_dashboard_auth =>
      'As tarefas agendadas precisam de autenticação no painel. Adicione o usuário e a senha do painel a esta conexão ou ative o modo com proxy.';

  @override
  String get cron_upcoming_dashboard_unreachable =>
      'Não foi possível alcançar o painel. Verifique o host, a porta do painel e a rede e tente novamente.';

  @override
  String get cron_upcoming_load_failed =>
      'Não foi possível ler as tarefas agendadas. Verifique a conexão do painel e tente novamente.';

  @override
  String get cron_upcoming_refresh_failed =>
      'Não foi possível atualizar o agendamento. A última leitura bem-sucedida está sendo exibida.';

  @override
  String get cron_job_added => 'Tarefa Cron adicionada';

  @override
  String get cron_job_updated => 'Tarefa Cron atualizada';

  @override
  String get cron_run => 'Execução do Cron';

  @override
  String get cross_device_ordering_and_reversible_bulk_organization =>
      'Ordenação entre dispositivos e organização em massa reversível';

  @override
  String get current_profile_default => 'Padrão do perfil atual';

  @override
  String get custom_proxy_and_dashboard_details =>
      'Detalhes personalizados de proxy e painel';

  @override
  String get dark => 'Escuro';

  @override
  String get dashboard_proxy_settings => 'Configurações do painel / proxy';

  @override
  String get dashboard_password_optional => 'Senha do painel (opcional)';

  @override
  String get dashboard_port => 'Porta do painel';

  @override
  String get dashboard_username_optional =>
      'Nome de usuário do painel (opcional)';

  @override
  String get dashboard_behind_proxy => 'Painel atrás de proxy';

  @override
  String get dashboard_path_prefix => 'Prefixo de caminho do painel';

  @override
  String delegated_task(Object goal) {
    return 'Tarefa delegada: $goal';
  }

  @override
  String get delete => 'Excluir';

  @override
  String delete_2(Object name) {
    return 'Excluir “$name”?';
  }

  @override
  String delete_from_the_remote_hermes_history_this_cannot_be_undone(
    Object title,
  ) {
    return 'Excluir “$title” do histórico remoto do Hermes? Esta ação não pode ser desfeita.';
  }

  @override
  String get delete_cron_job => 'Excluir tarefa Cron';

  @override
  String get delete_connections_that_are_not_in_the_backup =>
      'Excluir conexões que não estão no backup.';

  @override
  String delete_failed(Object error) {
    return 'Falha ao excluir: $error';
  }

  @override
  String get delete_project => 'Excluir projeto';

  @override
  String get delete_session => 'Excluir sessão?';

  @override
  String delete_3(Object projectName) {
    return 'Excluir $projectName?';
  }

  @override
  String deleted(Object name) {
    return '“$name” excluído';
  }

  @override
  String get delivery_is_uncertain_recovering_without_resending =>
      'A entrega é incerta; recuperando sem reenviar…';

  @override
  String get desktop_gateway_url_optional =>
      'URL do Desktop Gateway (opcional)';

  @override
  String get desktop_gateway_is_not_configured_for_this_connection =>
      'O Desktop Gateway não está configurado para esta conexão.';

  @override
  String get desktop_app => 'Aplicativo para desktop';

  @override
  String get developer_tool_calls => 'Chamadas de ferramentas do desenvolvedor';

  @override
  String get discord_chats => 'Chats do Discord';

  @override
  String get dismiss => 'Descartar';

  @override
  String get do_not_run_this_command => 'Não execute este comando.';

  @override
  String get documents_archives_audio_video_or_data =>
      'Documentos, arquivos compactados, áudio, vídeo ou dados';

  @override
  String get download => 'Baixar';

  @override
  String download_failed(Object error) {
    return 'Falha no download: $error';
  }

  @override
  String get durable_facts_hermes_keeps_about_you =>
      'Fatos duráveis que o Hermes guarda sobre você';

  @override
  String get durable_work_inside_one_of_your_projects_shared_with_desktop =>
      'Trabalho durável dentro de um dos seus projetos, compartilhado com o Desktop.';

  @override
  String get edit => 'Editar';

  @override
  String get edit_connection => 'Editar conexão';

  @override
  String get edit_cron_job => 'Editar tarefa Cron';

  @override
  String get edit_gateway_connection => 'Editar conexão de Gateway';

  @override
  String get edit_and_resend => 'Editar e reenviar';

  @override
  String get enable_notifications => 'Ativar notificações';

  @override
  String get enable_notifications_description =>
      'Desativar isto desativa todas as notificações abaixo.';

  @override
  String get enables_file_attachments_through_the_desktop_remote_gateway =>
      'Permite anexos de arquivos pelo Gateway remoto do Desktop.';

  @override
  String get enter_a_name => 'Digite um nome';

  @override
  String get enter_a_passphrase => 'Digite uma frase secreta.';

  @override
  String get enter_the_passphrase_for_this_backup =>
      'Digite a frase secreta deste backup.';

  @override
  String get every_conversation_is_already_assigned_to_a_project =>
      'Todas as conversas já estão atribuídas a um projeto.';

  @override
  String get everything_not_yet_native_in_the_authenticated_web_dashboard =>
      'Tudo que ainda não é nativo, no painel web autenticado';

  @override
  String get explain_the_attached_content_clearly =>
      'Explique claramente o conteúdo anexado.';

  @override
  String explain_this_content_clearly(Object text) {
    return 'Explique claramente este conteúdo:\n\n$text';
  }

  @override
  String
  get explicit_choices_adjust_android_accessibility_text_size_system_leaves_it =>
      'Escolhas explícitas ajustam o tamanho do texto de acessibilidade do Android; “Sistema” o mantém inalterado.';

  @override
  String get export_label => 'Exportar';

  @override
  String get export_share => 'Exportar / compartilhar';

  @override
  String get external_api_clients => 'Clientes de API externos';

  @override
  String get extra_high => 'Muito alto';

  @override
  String get extract_tasks => 'Extrair tarefas';

  @override
  String
  get extract_the_decisions_deadlines_owners_and_actionable_action_items_from =>
      'Extraia do conteúdo anexado as decisões, prazos, responsáveis e itens de ação executáveis.';

  @override
  String
  extract_the_decisions_deadlines_owners_and_actionable_action_items_from_2(
    Object text,
  ) {
    return 'Extraia deste conteúdo as decisões, prazos, responsáveis e itens de ação executáveis:\n\n$text';
  }

  @override
  String failed_to_add_job(Object error) {
    return 'Falha ao adicionar tarefa: $error';
  }

  @override
  String get failed_to_load_cron_jobs => 'Falha ao carregar as tarefas Cron';

  @override
  String get failed_to_load_memory => 'Falha ao carregar a memória';

  @override
  String get failed_to_load_messages => 'Falha ao carregar as mensagens';

  @override
  String get failed_to_load_settings => 'Falha ao carregar as configurações';

  @override
  String get failed_to_load_skills => 'Falha ao carregar as habilidades';

  @override
  String failed_to_update_job(Object error) {
    return 'Falha ao atualizar tarefa: $error';
  }

  @override
  String failed(Object error) {
    return 'Falha: $error';
  }

  @override
  String get file_attached_document_catalog_registration_is_pending =>
      'Arquivo anexado; o registro no catálogo de documentos está pendente.';

  @override
  String get file_reference_added_to_chat =>
      'Referência de arquivo adicionada ao chat';

  @override
  String get files => 'Arquivos';

  @override
  String get fill_from_document => 'Preencher a partir do documento';

  @override
  String get folder_is_empty => 'A pasta está vazia';

  @override
  String get folders => 'Pastas';

  @override
  String get full_text => 'Texto completo';

  @override
  String get gateway_api_access => 'Acesso à API do Gateway';

  @override
  String get gateway_connected_but_the_dashboard_could_not_be_reached_or =>
      'Gateway conectado, mas o painel não pôde ser alcançado ou autenticado. Verifique os detalhes do painel ou limpe-os para pular.';

  @override
  String get gateway_path_prefix => 'Prefixo de caminho do Gateway';

  @override
  String get go_to_end => 'Ir para o fim';

  @override
  String get hermes_agent => 'Ares - formerly Hermes Android';

  @override
  String get hermes_agent_for_android => 'Ares - formerly Hermes Android';

  @override
  String get hermes_could_not_accept_the_answer_please_try_again =>
      'O Hermes não pôde aceitar a resposta. Tente novamente.';

  @override
  String get hermes_could_not_load_your_saved_connections =>
      'O Hermes não pôde carregar suas conexões salvas';

  @override
  String get hermes_did_not_accept_the_response_please_try_again =>
      'O Hermes não aceitou a resposta. Tente novamente.';

  @override
  String get hermes_is_responding => 'O Hermes está respondendo…';

  @override
  String get hermes_is_waiting_for_input =>
      'O Hermes está aguardando sua entrada…';

  @override
  String get hermes_keeps_android_accessibility_text_scaling_active =>
      'O Ares mantém a escala de texto de acessibilidade do Android ativa.';

  @override
  String get hermes_needs_your_input => 'O Hermes precisa da sua entrada';

  @override
  String get hermes_profile_optional => 'Perfil do Hermes (opcional)';

  @override
  String get hermes_profile_must_be_a_plain_profile_name_such_as =>
      'O perfil do Hermes deve ser um nome simples de perfil, como “sol”, e não um caminho.';

  @override
  String get hermes_reasoning_details => 'Detalhes de raciocínio do Hermes';

  @override
  String hermes_recovery_is_unavailable(Object error) {
    return 'A recuperação do Hermes está indisponível: $error';
  }

  @override
  String get hermes_stopped_recovery_safely_no_prompt_was_resent =>
      'O Hermes interrompeu a recuperação com segurança. Nenhum prompt foi reenviado.';

  @override
  String get hide_passphrase => 'Ocultar frase secreta';

  @override
  String get home_needs_your_recent_chats_to_know_what_deserves_your =>
      'O início precisa dos seus chats recentes para saber o que merece sua atenção. Verifique se o Gateway está acessível e tente novamente.';

  @override
  String get host => 'Host';

  @override
  String get image_selection_was_interrupted_try_again =>
      'A seleção de imagem foi interrompida. Tente novamente.';

  @override
  String get import_label => 'Importar';

  @override
  String get inbox => 'Caixa de entrada';

  @override
  String get inbox_is_clear => 'Caixa de entrada vazia';

  @override
  String get input_needed => 'Entrada necessária';

  @override
  String get input_needed_description =>
      'O Hermes fez uma pergunta ou precisa de uma senha ou segredo.';

  @override
  String get insert_a_remote_file_reference =>
      'Inserir uma referência remota a @file';

  @override
  String get invalid_port_number => 'Número de porta inválido.';

  @override
  String get job_paused => 'Tarefa pausada';

  @override
  String get job_resumed => 'Tarefa retomada';

  @override
  String get job_triggered => 'Tarefa acionada';

  @override
  String get label => 'Rótulo';

  @override
  String last_activity(Object day, Object month, Object year) {
    return 'Última atividade $day/$month/$year';
  }

  @override
  String last(Object lastRun) {
    return 'Última: $lastRun';
  }

  @override
  String get leave_blank_for_default_8642_443_with_https =>
      'Deixe em branco para o padrão (8642; 443 com https)';

  @override
  String get leave_blank_for_default_9119 =>
      'Deixe em branco para o padrão (9119)';

  @override
  String get light => 'Claro';

  @override
  String listening(Object elapsed) {
    return 'Ouvindo • $elapsed';
  }

  @override
  String listening_elapsed(Object elapsed) {
    return 'Ouvindo, decorrido: $elapsed';
  }

  @override
  String get load_more => 'Carregar mais…';

  @override
  String get loading => 'Carregando';

  @override
  String get location => 'Localização';

  @override
  String get make_sure_the_gateway_api_server_is_running_hermes_gateway =>
      'Certifique-se de que o servidor de API do Gateway esteja em execução\n(hermes gateway status)';

  @override
  String matches(Object assigned, Object name) {
    return 'Corresponde a $name · $assigned';
  }

  @override
  String get memory => 'Memória';

  @override
  String get memory_about_you => 'Sobre você';

  @override
  String get memory_agent_notes => 'Notas do agente';

  @override
  String get memory_builtin_scope =>
      'Fatos salvos em USER.md e MEMORY.md deste perfil. Provedores de memória externos (incluindo MemPalace) não são exibidos aqui.';

  @override
  String get memory_read_only =>
      'Somente leitura. Peça ao Hermes no chat para corrigir ou esquecer um fato.';

  @override
  String get memory_unavailable =>
      'Este gateway ou perfil não pode fornecer os fatos salvos. Confira o perfil selecionado e atualize o Hermes, se necessário.';

  @override
  String get memory_load_error =>
      'Confira a conexão e a autenticação do painel e tente novamente.';

  @override
  String get memory_read_full_fact => 'Ler o fato completo';

  @override
  String get memory_full_fact_requires_update =>
      'Os fatos completos exigem um gateway Hermes mais recente. Atualize o Hermes e a lista.';

  @override
  String get memory_fact_detail_error =>
      'Não foi possível carregar o fato completo. Ele pode ter mudado; atualize a lista e tente novamente.';

  @override
  String get memory_entries_are_cross_session_facts_the_agent_remembers_they =>
      'Os fatos salvos aparecerão aqui quando o Hermes os memorizar.';

  @override
  String get merge => 'Mesclar';

  @override
  String get message => 'Mensagem';

  @override
  String get message_hermes => 'Enviar mensagem ao Hermes…';

  @override
  String get message_actions => 'Ações da mensagem';

  @override
  String get message_copied => 'Mensagem copiada';

  @override
  String get migrating => 'Migrando…';

  @override
  String get migration_complete => 'Migração concluída';

  @override
  String get migration_failed_local_spaces_were_kept_unchanged =>
      'A migração falhou. Os espaços locais foram mantidos inalterados.';

  @override
  String get migration_incomplete => 'Migração incompleta';

  @override
  String get migration_preview => 'Pré-visualização da migração';

  @override
  String get model => 'Modelo';

  @override
  String get model_and_thinking_for_this_chat =>
      'Modelo e raciocínio para este chat';

  @override
  String model_was_not_changed(Object error) {
    return 'O modelo não foi alterado: $error';
  }

  @override
  String get move_attachment_next => 'Mover anexo para frente';

  @override
  String get move_attachment_previous => 'Mover anexo para trás';

  @override
  String get move_chat => 'Mover chat';

  @override
  String get move_conversation => 'Mover conversa';

  @override
  String get move_to_project => 'Mover para projeto';

  @override
  String get move_to_space => 'Mover para espaço';

  @override
  String get moved_to_a_project => 'Movido para um projeto';

  @override
  String moved_to(Object label) {
    return 'Movido para $label';
  }

  @override
  String get name => 'Nome';

  @override
  String get name_prompt_and_schedule_are_required =>
      'Nome, prompt e agendamento são obrigatórios';

  @override
  String get nav_activity => 'Atividade';

  @override
  String get nav_projects => 'Projetos';

  @override
  String get needs_a_correction_aware_filing_contract_in_the_hermes_gateway =>
      'Requer um contrato de arquivamento com correção no Gateway do Hermes.';

  @override
  String get needs_a_reachable_hermes_dashboard_check_the_host_port_and =>
      'Requer um painel do Hermes acessível. Verifique o host, a porta e as credenciais desta conexão.';

  @override
  String get needs_a_server_authoritative_assets_index_in_the_hermes_gateway =>
      'Requer um índice de recursos autoritativo do servidor no Gateway do Hermes.';

  @override
  String get needs_durable_pin_ordering_batch_mutation_and_undo_contracts_in =>
      'Requer contratos de ordenação de fixados, mutação em lote e desfazer no Gateway do Hermes.';

  @override
  String get needs_you => 'Precisa de você';

  @override
  String get new_label => 'Novo';

  @override
  String get new_chat => 'Novo chat';

  @override
  String get new_chat_2 => 'Novo chat';

  @override
  String new_chat_3(Object projectName) {
    return 'Novo chat · $projectName';
  }

  @override
  String get new_project => 'Novo projeto';

  @override
  String get new_space => 'Novo espaço';

  @override
  String next(Object nextRun) {
    return 'Próxima: $nextRun';
  }

  @override
  String get nginx_injects_auth_app_sends_clean_requests =>
      'O Nginx injeta a autenticação — o app envia requisições limpas';

  @override
  String get no_tts_voices_found_ninstall_google_text_to_speech_and =>
      'Nenhuma voz de TTS encontrada.\nInstale o Google Text-to-Speech e baixe os dados de voz.';

  @override
  String get no_active_projects_on_this_gateway =>
      'Nenhum projeto ativo neste Gateway';

  @override
  String get no_activity_yet => 'Nenhuma atividade ainda';

  @override
  String get no_chat_is_blocked_running_or_waiting_to_be_resumed =>
      'Nenhum chat está bloqueado, em execução ou aguardando retomada. Inicie um novo quando quiser.';

  @override
  String no_chats_in_this_project_match(Object searchQuery) {
    return 'Nenhum chat deste projeto corresponde a “$searchQuery”.';
  }

  @override
  String get no_chats_in_this_space_yet_tap_to_start_one =>
      'Ainda não há chats neste espaço. Toque em + para iniciar um.';

  @override
  String get no_chats_yet => 'Ainda não há chats';

  @override
  String get no_connections => 'Sem conexões';

  @override
  String get no_conversation_matches_this_view =>
      'Nenhuma conversa corresponde a esta visualização.';

  @override
  String get no_cron_jobs => 'Sem tarefas Cron';

  @override
  String get no_folders_yet => 'Ainda não há pastas';

  @override
  String get no_local_spaces_were_found_for_this_connection_so_projects =>
      'Nenhum espaço local foi encontrado para esta conexão, então os projetos já são a única forma de organização em uso aqui.';

  @override
  String get no_matches => 'Sem correspondências';

  @override
  String get no_memory_entries => 'Sem entradas de memória';

  @override
  String get no_message_content_matches =>
      'Nenhuma correspondência no conteúdo das mensagens';

  @override
  String get no_new_messages => 'Sem mensagens novas';

  @override
  String get no_projects_yet => 'Ainda não há projetos';

  @override
  String get no_runs_yet => 'Ainda não há execuções.';

  @override
  String no_server_project_matches_this_name(Object assigned) {
    return 'Nenhum projeto do servidor corresponde a este nome · $assigned';
  }

  @override
  String get no_sessions_yet => 'Ainda não há sessões';

  @override
  String get no_skills_found => 'Nenhuma habilidade encontrada';

  @override
  String get no_spaces_on_this_device => 'Nenhum espaço neste dispositivo';

  @override
  String get no_text_shared => 'Nenhum texto compartilhado';

  @override
  String get no_turn_is_blocked_in_flight_or_recently_finished_work =>
      'Nenhum turno está bloqueado, em andamento ou recém-concluído. O trabalho que você iniciar aparecerá aqui.';

  @override
  String get no_turn_needs_your_input_or_has_failed =>
      'Nenhum turno precisa da sua entrada ou falhou.';

  @override
  String get no_unassigned_chats => 'Nenhum chat não atribuído.';

  @override
  String get nothing_changed_in_the_last_seven_days =>
      'Nada mudou nos últimos sete dias.';

  @override
  String get nothing_has_moved_yet_this_is_only_what_a_migration =>
      'Nada foi movido ainda — isto é apenas o que uma migração faria.';

  @override
  String get nothing_here => 'Nada aqui';

  @override
  String get nothing_is_running => 'Nada em execução';

  @override
  String get nothing_needs_you => 'Nada precisa de você';

  @override
  String get nothing_to_migrate => 'Nada para migrar';

  @override
  String get notifications => 'Notificações';

  @override
  String get windows_notifications_blocked =>
      'As notificações estão indisponíveis. Use o app Ares instalado e verifique Configurações → Sistema → Notificações no Windows.';

  @override
  String get windows_notification_diagnostics =>
      'O que o Ares enviou ao Windows';

  @override
  String get chat_activity_share => 'Compartilhar atividade do chat';

  @override
  String get chat_activity_share_hint =>
      'Informe a um gateway conectado e compatível quando você estiver usando este chat, para que o plugin de notificações do celular evite alertas duplicados. Não são enviadas chaves nem textos de mensagens.';

  @override
  String get completion_sound => 'Som de conclusão';

  @override
  String get completion_sound_system => 'Padrão do sistema';

  @override
  String get completion_sound_mail => 'E-mail';

  @override
  String get completion_sound_reminder => 'Lembrete';

  @override
  String get completion_sound_silent => 'Silencioso';

  @override
  String get completion_sound_scope =>
      'Toca para respostas concluídas, na notificação de teste e dentro do app. Aprovações e outros alertas mantêm o som habitual.';

  @override
  String get completion_sound_scope_android =>
      'Toca para respostas concluídas, na notificação de teste e dentro do app. Aprovações, outros alertas, notificações em segundo plano do servidor e mensagens do Android Auto mantêm o som habitual.';

  @override
  String get notification_open_action => 'Abrir';

  @override
  String get app_sounds_mute => 'Silenciar sons do app';

  @override
  String get app_sounds_mute_hint =>
      'Interrompe o som de conclusão que o Ares toca enquanto está aberto. As notificações mantêm seu próprio som.';

  @override
  String get notifications_permission_denied =>
      'As notificações estão bloqueadas pelo sistema. Ative-as para este app nas configurações do Android.';

  @override
  String get off_no_thinking => 'Desativado (sem raciocínio)';

  @override
  String get offline_showing_the_last_known_activity =>
      'Offline — mostrando a última atividade conhecida.';

  @override
  String get offline_showing_the_last_known_chats =>
      'Offline — mostrando os últimos chats conhecidos';

  @override
  String get offline_showing_the_last_known_projects =>
      'Offline — mostrando os últimos projetos conhecidos.';

  @override
  String get on_this_device => 'Neste dispositivo';

  @override
  String get on_device => 'No dispositivo';

  @override
  String get open_inbox => 'Abrir caixa de entrada';

  @override
  String open_inbox_2(Object count) {
    return 'Abrir caixa de entrada ($count)';
  }

  @override
  String get open_the_hermes_dashboard => 'Abrir o painel do Hermes';

  @override
  String get optional_for_the_memory_cron_skills_settings_tabs_leave_blank =>
      'Opcional. Para as abas Memória/Cron/Habilidades/Configurações. Deixe em branco para usar a porta padrão do painel (9119) sem login.';

  @override
  String get organization => 'Organização';

  @override
  String get other_answer => 'Outra resposta';

  @override
  String get overview => 'Visão geral';

  @override
  String get passphrase => 'Frase secreta';

  @override
  String get password_optional => 'Senha (opcional)';

  @override
  String get phone_or_tablet => 'Telefone ou tablet';

  @override
  String get pin_batch_and_undo => 'Fixar, em lote e desfazer';

  @override
  String get plugin_notifications => 'Notificações de plugins';

  @override
  String get plugin_notifications_description =>
      'O gateway enviou um aviso enquanto o app estava em segundo plano.';

  @override
  String get port => 'Porta';

  @override
  String get preparing_attachments => 'Preparando anexos…';

  @override
  String get preview_truncated => 'Pré-visualização truncada';

  @override
  String get preview_unavailable => 'Pré-visualização indisponível';

  @override
  String get profile => 'Perfil';

  @override
  String get profile_default_model => 'Modelo padrão do perfil';

  @override
  String profile_default_set_to_chats_with_their_own_model_keep(
    Object selectedModel,
  ) {
    return 'Padrão do perfil definido como $selectedModel. Chats com modelo próprio mantêm essa substituição.';
  }

  @override
  String
  get profile_this_connection_chats_as_when_the_dashboard_serves_several =>
      'Perfil com que esta conexão conversa quando o painel serve vários perfis. Deixe em branco para um painel isolado por perfil.';

  @override
  String get project => 'Projeto';

  @override
  String get project_actions => 'Ações do projeto';

  @override
  String get project_chat => 'Chat do projeto';

  @override
  String get project_chats_unavailable => 'Chats do projeto indisponíveis';

  @override
  String get projects => 'Projetos';

  @override
  String get projects_group_related_chats_files_and_activity_and_stay_in =>
      'Os projetos agrupam chats, arquivos e atividades relacionados e ficam sincronizados com o Hermes no seu computador.';

  @override
  String
  get projects_need_a_desktop_gateway_connection_add_the_desktop_gateway =>
      'Os projetos precisam de uma conexão com o Desktop Gateway. Adicione a URL do Desktop Gateway a esta conexão para organizar chats entre dispositivos.';

  @override
  String get projects_unavailable => 'Projetos indisponíveis';

  @override
  String get projects_activity_new_navigation =>
      'Projetos, Atividade — nova navegação';

  @override
  String get promote_to_project => 'Promover a projeto';

  @override
  String get prompt => 'Prompt';

  @override
  String get protect_this_backup => 'Proteger este backup';

  @override
  String get provider => 'Provedor';

  @override
  String get proxy_injects_auth_app_sends_clean_requests =>
      'O proxy injeta a autenticação; o app envia requisições limpas';

  @override
  String get quick_chat => 'Chat rápido';

  @override
  String get quick_chats_appear_here_after_their_retention_period =>
      'Chats rápidos aparecem aqui após o período de retenção.';

  @override
  String get read_aloud => 'Ler em voz alta';

  @override
  String get read_aloud_is_unavailable_on_this_device =>
      'A leitura em voz alta não está disponível neste dispositivo';

  @override
  String get reading_response_aloud => 'Lendo a resposta em voz alta';

  @override
  String get ready_to_upload => 'Pronto para enviar';

  @override
  String get reasoning => 'Raciocínio';

  @override
  String get recently_completed => 'Concluído recentemente';

  @override
  String get recently_active => 'Ativo recentemente';

  @override
  String get recovering_hermes => 'Recuperando o Hermes…';

  @override
  String get refresh => 'Atualizar';

  @override
  String get regenerate_response => 'Regenerar resposta';

  @override
  String get remove_attachment => 'Remover anexo';

  @override
  String get rename => 'Renomear';

  @override
  String get rename_chat => 'Renomear chat';

  @override
  String get rename_project => 'Renomear projeto';

  @override
  String get rename_space => 'Renomear espaço';

  @override
  String rename_2(Object projectName) {
    return 'Renomear $projectName';
  }

  @override
  String rename_3(Object name) {
    return 'Renomear $name';
  }

  @override
  String get replace => 'Substituir';

  @override
  String get repositories => 'Repositórios';

  @override
  String
  get research_the_attached_content_verify_the_important_claims_and_cite =>
      'Pesquise o conteúdo anexado, verifique as afirmações importantes e cite as fontes.';

  @override
  String research_this_content_verify_the_important_claims_and_cite_sources(
    Object text,
  ) {
    return 'Pesquise este conteúdo, verifique as afirmações importantes e cite as fontes:\n\n$text';
  }

  @override
  String reset_failed_the_secure_storage_may_need_reinstall(Object retryError) {
    return 'Falha na redefinição: $retryError. O armazenamento seguro pode precisar ser reinstalado.';
  }

  @override
  String get reset_saved_connections => 'Redefinir conexões salvas';

  @override
  String get responding => 'Respondendo…';

  @override
  String response_closed_locally_gateway_stop_failed(Object error) {
    return 'Resposta fechada localmente; falha ao parar o Gateway: $error';
  }

  @override
  String get response_closed_locally_no_active_gateway_turn_was_found =>
      'Resposta fechada localmente; nenhum turno ativo do Gateway foi encontrado.';

  @override
  String get response_complete => 'Resposta concluída';

  @override
  String get response_complete_description =>
      'Um turno foi concluído enquanto o app estava em segundo plano.';

  @override
  String get response_ready => 'Resposta pronta';

  @override
  String get response_stopped => 'Resposta interrompida.';

  @override
  String get restore => 'Restaurar';

  @override
  String get restore_configuration => 'Restaurar configuração';

  @override
  String get restore_project => 'Restaurar projeto';

  @override
  String get retry => 'Tentar novamente';

  @override
  String retry_failed_for_the_draft_and_prompt_were_kept(Object name) {
    return 'Falha ao tentar novamente para $name. O rascunho e o prompt foram mantidos.';
  }

  @override
  String get retry_upload => 'Tentar enviar novamente';

  @override
  String retrying(Object name) {
    return 'Tentando novamente $name…';
  }

  @override
  String get review_local_spaces => 'Revisar espaços locais';

  @override
  String get review_or_promote_quick_chats_past_their_retention_period =>
      'Revisar ou promover chats rápidos além do período de retenção';

  @override
  String get review_the_attached_content => 'Revise o conteúdo anexado.';

  @override
  String get run_only_this_command => 'Execute apenas este comando.';

  @override
  String get running_now => 'Em execução';

  @override
  String get save => 'Salvar';

  @override
  String get save_changes => 'Salvar alterações';

  @override
  String get save_a_permanent_rule_in_the_hermes_configuration =>
      'Salve uma regra permanente na configuração do Hermes.';

  @override
  String get save_the_durable_facts_from_the_attached_content_to_memory =>
      'Salve os fatos duráveis do conteúdo anexado na memória e confirme o que foi retido.';

  @override
  String save_the_durable_facts_from_this_content_to_memory_then(Object text) {
    return 'Salve os fatos duráveis deste conteúdo na memória e confirme o que foi retido:\n\n$text';
  }

  @override
  String get save_your_connections_and_settings_to_an_encrypted_file_then =>
      'Salve suas conexões e configurações em um arquivo criptografado e restaure-as após reinstalar ou em outro dispositivo.';

  @override
  String save_2(Object filename) {
    return 'Salvar $filename';
  }

  @override
  String get schedule => 'Agendamento';

  @override
  String get scheduled_jobs_and_their_last_runs =>
      'Tarefas agendadas e suas últimas execuções';

  @override
  String get scheduled_tasks => 'Tarefas agendadas';

  @override
  String get script_only_no_agent => 'Somente script (sem agente)';

  @override
  String get scroll_horizontally => 'Rolar horizontalmente';

  @override
  String get search_all_chats => 'Pesquisar todos os chats';

  @override
  String get search_all_message_content =>
      'Pesquisar todo o conteúdo das mensagens';

  @override
  String get search_chats => 'Pesquisar chats';

  @override
  String get search_conversations => 'Pesquisar conversas';

  @override
  String get search_loaded_chats => 'Pesquisar chats carregados';

  @override
  String get search_mode => 'Modo de busca';

  @override
  String get select_one_option_or_enter_another_answer =>
      'Selecione uma opção ou digite outra resposta.';

  @override
  String get select_one_or_more_options_then_continue =>
      'Selecione uma ou mais opções e continue.';

  @override
  String get select_text => 'Selecionar texto';

  @override
  String get send => 'Enviar';

  @override
  String send_failed(Object error) {
    return 'Falha no envio: $error';
  }

  @override
  String send_failed_api_only_permission_denied(Object error) {
    return 'Falha no envio: $error. O servidor recusou esta gravação para o principal da chave de API. Se esta conversa pertencer ao Dashboard, adicionar o nome de usuário e a senha do Dashboard desta conexão pode permitir o envio; o servidor também pode estar recusando de forma deliberada.';
  }

  @override
  String get send_message => 'Enviar mensagem';

  @override
  String get send_test_notification => 'Enviar notificação de teste';

  @override
  String get session_sources => 'Fontes de sessões';

  @override
  String get session_deleted_from_remote_hermes =>
      'Sessão excluída do Hermes remoto.';

  @override
  String session_search_failed(Object error) {
    return 'Falha na busca de sessões: $error';
  }

  @override
  String get set_profile_default => 'Definir como padrão do perfil';

  @override
  String get settings => 'Configurações';

  @override
  String get share_to_hermes => 'Compartilhar com o Hermes';

  @override
  String get show_passphrase => 'Mostrar frase secreta';

  @override
  String get show_tool_calls_thinking_and_message_metadata =>
      'Mostrar chamadas de ferramentas, raciocínio e metadados de mensagens';

  @override
  String get signal_messages => 'Mensagens do Signal';

  @override
  String get skills => 'Habilidades';

  @override
  String skills_2(Object count) {
    return 'Habilidades ($count)';
  }

  @override
  String get skills_and_tools => 'Habilidades e ferramentas';

  @override
  String get skip => 'Pular';

  @override
  String get slack_chats => 'Chats do Slack';

  @override
  String source(Object source) {
    return 'Origem: $source';
  }

  @override
  String get space_actions => 'Ações do espaço';

  @override
  String get spaces => 'Espaços';

  @override
  String get speak_to_hermes => 'Fale com o Hermes';

  @override
  String get speech_recognition_is_unavailable =>
      'O reconhecimento de fala não está disponível';

  @override
  String get spoken_replies => 'Respostas faladas';

  @override
  String get spoken_replies_off => 'Respostas faladas desativadas';

  @override
  String get spoken_replies_on => 'Respostas faladas ativadas';

  @override
  String get stalled_no_update_from_hermes =>
      'Travado — sem atualizações do Hermes';

  @override
  String get start_something_new => 'Começar algo novo';

  @override
  String get start_voice_input => 'Iniciar entrada de voz';

  @override
  String get starting_hermes => 'Iniciando o Hermes…';

  @override
  String get media_card_download => 'Baixar arquivo';

  @override
  String get media_card_tap_to_download => 'Toque para baixar';

  @override
  String get still_loading_your_projects => 'Ainda carregando seus projetos.';

  @override
  String get stop => 'Parar';

  @override
  String get stop_response => 'Parar resposta';

  @override
  String get stop_voice_input => 'Parar entrada de voz';

  @override
  String get submitted_waiting_for_hermes => 'Enviado, aguardando o Hermes';

  @override
  String get suggest_projects_and_learn_from_your_corrections =>
      'Sugerir projetos e aprender com suas correções';

  @override
  String get summarize_the_attached_content => 'Resuma o conteúdo anexado.';

  @override
  String summarize_this_content(Object text) {
    return 'Resuma este conteúdo:\n\n$text';
  }

  @override
  String get switch_profile => 'Trocar de perfil';

  @override
  String get system => 'Sistema';

  @override
  String get take_photo => 'Tirar foto';

  @override
  String get tap_to_add_a_remote_hermes_gateway_api_server_port =>
      'Toque em + para adicionar um Gateway do Hermes remoto\n(servidor de API, porta 8642)';

  @override
  String get tap_the_button_to_start_a_new_chat =>
      'Toque no botão + para iniciar um novo chat';

  @override
  String get telegram_messages => 'Mensagens do Telegram';

  @override
  String get terminal_sessions => 'Sessões de terminal';

  @override
  String get test_notification_body =>
      'Se você está vendo isto, as notificações estão funcionando.';

  @override
  String get test_notification_sent => 'Notificação de teste enviada.';

  @override
  String get test_notification_title => 'Teste de notificação do Hermes';

  @override
  String get test_notification_unsupported =>
      'Não foi possível enviar a notificação — verifique se o sistema permite notificações.';

  @override
  String get text_size => 'Tamanho do texto';

  @override
  String get text_size_preview => 'Pré-visualização do tamanho do texto';

  @override
  String text_size_2(Object label) {
    return 'Tamanho do texto: $label';
  }

  @override
  String get the_api_key_could_not_be_stored_securely =>
      'A chave de API não pôde ser armazenada com segurança.';

  @override
  String get the_project_will_move_to_archived_its_chats_and_files =>
      'O projeto será movido para “Arquivado”. Seus chats e arquivos permanecem intactos, e você pode restaurá-lo a qualquer momento.';

  @override
  String get the_project_will_move_to_archived_its_chats_and_files_2 =>
      'O projeto será movido para “Arquivado”. Seus chats e arquivos permanecem intactos, e você pode restaurá-lo depois.';

  @override
  String get the_active_profile_did_not_return_any_selectable_models =>
      'O perfil ativo não retornou nenhum modelo selecionável.';

  @override
  String get the_backup_could_not_be_exported =>
      'O backup não pôde ser exportado.';

  @override
  String get the_backup_could_not_be_restored =>
      'O backup não pôde ser restaurado.';

  @override
  String get the_connection_could_not_be_deleted_safely =>
      'A conexão não pôde ser excluída com segurança.';

  @override
  String get the_connection_could_not_be_stored_securely =>
      'A conexão não pôde ser armazenada com segurança.';

  @override
  String get the_dashboard_credentials_could_not_be_stored_securely =>
      'As credenciais do painel não puderam ser armazenadas com segurança.';

  @override
  String get the_detached_reply_failed => 'A resposta desacoplada falhou.';

  @override
  String the_detached_reply_failed_2(Object error) {
    return 'A resposta desacoplada falhou: $error';
  }

  @override
  String get the_file_contains_your_api_keys_and_dashboard_password_so =>
      'O arquivo contém suas chaves de API e a senha do painel, por isso é criptografado. Sem esta frase secreta, o backup não pode ser restaurado.';

  @override
  String get the_last_turn_failed => 'O último turno falhou';

  @override
  String the_local_connection_store_looks_damaged_you_can_reset_the(
    Object errorType,
  ) {
    return 'O armazenamento local de conexões parece danificado ($errorType). Você pode redefinir as conexões salvas e começar do zero. Os chats no seu Gateway não são afetados.';
  }

  @override
  String get the_model_only_rewrites_your_question_into_a_short_full =>
      'O modelo apenas reescreve sua pergunta como uma consulta curta de texto completo. O Hermes usa as credenciais do provedor já configuradas no host.';

  @override
  String get the_server_has_not_reported_folders_for_this_project_yet =>
      'O servidor ainda não informou pastas para este projeto. Arquivos globais continua disponível em Mais.';

  @override
  String get the_turn_failed => 'O turno falhou';

  @override
  String get the_two_passphrases_do_not_match =>
      'As duas frases secretas não coincidem.';

  @override
  String get the_value_is_sent_directly_to_the_active_hermes_gateway =>
      'O valor é enviado diretamente ao Gateway do Hermes ativo e não é salvo por este app Android.';

  @override
  String get there_are_no_visible_files_in_this_server_folder =>
      'Não há arquivos visíveis nesta pasta do servidor.';

  @override
  String get thinking_effort => 'Esforço de raciocínio';

  @override
  String get this_hermes_gateway_does_not_support_opening_a_project_yet =>
      'Este Gateway do Hermes ainda não oferece suporte a abrir um projeto. Atualize o Hermes no servidor para navegar por um projeto pelo celular.';

  @override
  String get this_hermes_gateway_is_older_than_server_side_projects_so =>
      'Este Gateway do Hermes é mais antigo que os projetos do servidor, então os chats ficam agrupados apenas neste dispositivo. Atualize o Hermes para compartilhar os mesmos projetos entre seus dispositivos.';

  @override
  String get this_project_has_no_folder_to_open_the_chat_in =>
      'Este projeto precisa de uma pasta antes de iniciar um chat nele. Adicione uma pasta e tente novamente.';

  @override
  String get this_chat_has_no_messages_available_in_the_desktop_session =>
      'Este chat ainda não tem mensagens disponíveis na sessão do Desktop.';

  @override
  String get this_creates_a_permanent_rule_in_hermes_review_the_full =>
      'Isto cria uma regra permanente no Hermes. Revise o comando completo antes de confirmar.';

  @override
  String get this_gateway_does_not_host_projects_yet_update_the_gateway =>
      'Este Gateway ainda não hospeda projetos. Atualize o Gateway para organizar chats entre dispositivos.';

  @override
  String get this_permanently_deletes_the_project_chats_will_not_be_deleted =>
      'Isto exclui o projeto permanentemente. Os chats não serão excluídos; voltarão para “Não atribuído”.';

  @override
  String get this_server_doesn_t_offer_background_recovery_chats_run_live =>
      'Este servidor não oferece recuperação em segundo plano — os chats rodam ao vivo';

  @override
  String get this_week => 'Esta semana';

  @override
  String get titles_previews_and_models =>
      'Títulos, pré-visualizações e modelos';

  @override
  String get tool_activity => 'Atividade de ferramentas';

  @override
  String get trigger_now => 'Acionar agora';

  @override
  String get received_outcome_unknown =>
      'Turno encerrado — resultado não confirmado';

  @override
  String get turn_completed => 'Turno concluído';

  @override
  String get turn_failed => 'Turno falhou';

  @override
  String get turn_failed_description =>
      'Um turno em segundo plano terminou com erro.';

  @override
  String get turn_recovery_failed => 'Falha na recuperação do turno';

  @override
  String get unable_to_prepare_this_file_try_another_one =>
      'Não foi possível preparar este arquivo. Tente outro.';

  @override
  String get unable_to_prepare_this_image_try_another_one =>
      'Não foi possível preparar esta imagem. Tente outra.';

  @override
  String unable_to_prepare(Object name) {
    return 'Não foi possível preparar $name.';
  }

  @override
  String get unable_to_read_the_selected_image_the_selection_was_kept =>
      'Não foi possível ler a imagem selecionada. A seleção foi mantida.';

  @override
  String get unassigned => 'Não atribuído';

  @override
  String get unassigned_chats => 'Chats não atribuídos';

  @override
  String get untitled_chat => 'Chat sem título';

  @override
  String get untitled_session => 'Sessão sem título';

  @override
  String get update_api_key => 'Atualizar chave de API';

  @override
  String get upload_failed => 'Falha no envio';

  @override
  String get upload_failed_tap_retry =>
      'Falha no envio • toque para tentar novamente';

  @override
  String uploading(Object index, Object name, Object total) {
    return 'Enviando $index/$total: $name';
  }

  @override
  String get use_as_is => 'Usar como está';

  @override
  String get use_at_least_8_characters => 'Use pelo menos 8 caracteres.';

  @override
  String get use_for_cron_jobs_backed_by_scripts =>
      'Use para tarefas Cron baseadas em scripts.';

  @override
  String get use_on_device => 'Usar no dispositivo';

  @override
  String get use_the_attached_content_to_identify_and_fill_the_relevant =>
      'Use o conteúdo anexado para identificar e preencher os campos relevantes do documento ou formulário. Pergunte antes de enviar qualquer coisa.';

  @override
  String use_this_content_to_identify_and_fill_the_relevant_document(
    Object text,
  ) {
    return 'Use este conteúdo para identificar e preencher os campos relevantes do documento ou formulário. Pergunte antes de enviar qualquer coisa:\n\n$text';
  }

  @override
  String get used_for_hosted_path_prefixes_and_for_the_settings_memory =>
      'Usado para prefixos de caminho hospedados e para as abas Configurações, Memória, Habilidades e Cron. Deixe usuário/senha em branco para um painel aberto, ou ative o modo proxy quando seu proxy reverso injetar a autenticação do painel.';

  @override
  String get username_optional => 'Nome de usuário (opcional)';

  @override
  String using(Object displayName) {
    return 'Usando $displayName…';
  }

  @override
  String get verbose_mode => 'Modo detalhado';

  @override
  String get message_metadata => 'Detalhes da mensagem';

  @override
  String get voice => 'Voz';

  @override
  String voice_setup_failed(Object error) {
    return 'Falha na configuração de voz: $error';
  }

  @override
  String get waiting_for_your_input => 'Aguardando sua entrada';

  @override
  String get what_hermes_knows_how_to_do => 'O que o Hermes sabe fazer';

  @override
  String get what_should_the_agent_do => 'O que o agente deve fazer?';

  @override
  String get whatsapp_messages => 'Mensagens do WhatsApp';

  @override
  String get which_project => 'Qual projeto?';

  @override
  String get workspace => 'Área de trabalho';

  @override
  String get wrap_lines => 'Quebrar linhas';

  @override
  String you_can_attach_up_to_items(Object maxRemoteAttachmentDrafts) {
    return 'Você pode anexar até $maxRemoteAttachmentDrafts itens.';
  }

  @override
  String get your_answer => 'Sua resposta';

  @override
  String get e_g_dashboard => 'ex.: /dashboard';

  @override
  String get e_g_dashboard_proxy_path_before_api =>
      'ex.: /dashboard (caminho do proxy antes de /api/)';

  @override
  String get e_g_profile_peter => 'ex.: /profile/peter';

  @override
  String get e_g_sol => 'ex.: sol';

  @override
  String get e_g_0_9_or_every_2h => 'ex.: 0 9 * * * ou every 2h';

  @override
  String get e_g_daily_backup => 'ex.: Backup diário';

  @override
  String downloaded(Object filename) {
    return '$filename baixado';
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
      '192.168.1.50, 100.x.y.z ou hermes-machine.tailnet.ts.net';

  @override
  String get example_profile_prefix_hint_full =>
      'ex.: /profile/peter (caminho do proxy antes de /api/ e /v1/)';

  @override
  String and_more(Object count) {
    return 'e mais $count';
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
    return '$chats · somente neste dispositivo';
  }

  @override
  String spaces_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count espaços',
      one: '$count espaço',
    );
    return '$_temp0';
  }

  @override
  String get no_new_projects_needed => 'nenhum projeto novo necessário';

  @override
  String projects_to_create(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count projetos a criar',
      one: '$count projeto a criar',
    );
    return '$_temp0';
  }

  @override
  String chats_migrated_projects_created(
    Object createdProjects,
    Object linkedSessions,
  ) {
    return '$linkedSessions chats migrados · $createdProjects projetos criados';
  }

  @override
  String chats_stayed_in_local_spaces(Object unlinkedSessions) {
    return '$unlinkedSessions chats permaneceram em espaços locais e podem ser tentados novamente com segurança.';
  }

  @override
  String model_recommended(Object provider) {
    return '$provider • Recomendado: pequeno e econômico';
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
  String get this_chat => 'este chat';

  @override
  String get profile_default => 'padrão do perfil';

  @override
  String minutes_ago(Object count) {
    return 'há $count min';
  }

  @override
  String hours_ago(Object count) {
    return 'há $count h';
  }

  @override
  String days_ago(Object count) {
    return 'há $count d';
  }

  @override
  String get now_label => 'agora';

  @override
  String get latest_label => 'Mais recente';

  @override
  String new_count_indicator(Object count) {
    return '$count novos';
  }

  @override
  String new_messages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count novas mensagens',
      one: '$count nova mensagem',
    );
    return '$_temp0';
  }

  @override
  String activity_failed_summary(Object failures, Object total) {
    return '$failures com falha • $total no total';
  }

  @override
  String activity_completed_summary(Object count) {
    return '$count concluídos';
  }

  @override
  String tool_start_observed(Object time) {
    return 'Início observado às $time (horário local)';
  }

  @override
  String tool_last_observed(Object time) {
    return 'Última observação às $time (horário local)';
  }

  @override
  String tool_result_recorded(Object time) {
    return 'Resultado registrado às $time (horário local)';
  }

  @override
  String get tool_time_unavailable => 'Horário indisponível';

  @override
  String get hermes_is_using_a_tool => 'O Hermes está usando uma ferramenta';

  @override
  String hermes_is_using_tools(Object count) {
    return 'O Hermes está usando $count ferramentas';
  }

  @override
  String delegated_tasks_completed(Object count) {
    return '$count tarefa(s) delegada(s) concluída(s)';
  }

  @override
  String delegated_tasks_active(Object count) {
    return '$count tarefa(s) delegada(s) ativa(s)';
  }

  @override
  String branch_main(Object label) {
    return '$label · main';
  }

  @override
  String get you_heading => '## Você';

  @override
  String get hermes_heading => '## Hermes';

  @override
  String get action_label => 'Ação';

  @override
  String get destination_label => 'Destino';

  @override
  String get markdown_source => 'Código-fonte';

  @override
  String get preview_label => 'Pré-visualização';

  @override
  String get share_action_summarize => 'Resumir';

  @override
  String get share_action_explain => 'Explicar';

  @override
  String get share_action_research => 'Pesquisar';

  @override
  String get share_action_remember => 'Lembrar';

  @override
  String get text_size_small => 'Pequeno';

  @override
  String get text_size_default => 'Padrão';

  @override
  String get text_size_large => 'Grande';

  @override
  String get text_size_extra_large => 'Muito grande';

  @override
  String get text_size_use_system_description =>
      'Usar exatamente o tamanho de texto de acessibilidade do Android.';

  @override
  String text_size_percent_description(Object percent) {
    return '$percent% do tamanho de texto do Android.';
  }

  @override
  String text_size_label_description(Object description, Object label) {
    return '$label — $description';
  }

  @override
  String files_skipped(Object count) {
    return '$count arquivo(s) ignorado(s): limite, tamanho, ilegível ou nome de arquivo sensível.';
  }

  @override
  String model_scope_applied(Object effort, Object model) {
    return '$model • $effort agora se aplicam somente a este chat.';
  }

  @override
  String get reasoning_minimal => 'Mínimo';

  @override
  String get reasoning_low => 'Baixo';

  @override
  String get reasoning_medium => 'Médio';

  @override
  String get reasoning_high => 'Alto';

  @override
  String get reasoning_max => 'Máximo';

  @override
  String get reasoning_ultra => 'Ultra';

  @override
  String get status_running => 'Em execução';

  @override
  String get status_failed => 'Falhou';

  @override
  String get status_done => 'Concluído';

  @override
  String get status_idle => 'Inativo';

  @override
  String get upload_status_uploading => 'Enviando';

  @override
  String get upload_status_uploaded => 'Enviado';

  @override
  String attachment_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anexos',
      one: '$count anexo',
    );
    return '$_temp0';
  }

  @override
  String get action_create => 'criar';

  @override
  String get action_rename => 'renomear';

  @override
  String get action_archive => 'arquivar';

  @override
  String get action_restore => 'restaurar';

  @override
  String get action_delete => 'excluir';

  @override
  String get migrate => 'Migrar';

  @override
  String assigned_chats(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chats atribuídos',
      one: '$count chat atribuído',
    );
    return '$_temp0';
  }

  @override
  String get date_today => 'Hoje';

  @override
  String get date_yesterday => 'Ontem';

  @override
  String get date_earlier => 'Anterior';

  @override
  String get nav_home => 'Início';

  @override
  String get nav_more => 'Mais';

  @override
  String get status_completed => 'Concluído';

  @override
  String get filter_all => 'Todos';

  @override
  String get filter_recent => 'Recentes';

  @override
  String connection_address_key(Object address, Object status) {
    return '$address  •  Chave: $status';
  }

  @override
  String model_via_provider(Object model, Object provider) {
    return '$model  \nvia `$provider`';
  }

  @override
  String get deny => 'Negar';

  @override
  String get connect => 'Conectar';

  @override
  String get appearance => 'Aparência';

  @override
  String get connection_section => 'Conexão';

  @override
  String get about => 'Sobre';

  @override
  String version_label(Object version) {
    return 'Versão $version';
  }

  @override
  String get matched => 'Correspondência';

  @override
  String get search => 'Pesquisar';

  @override
  String get on => 'Ativado';

  @override
  String get off => 'Desativado';

  @override
  String get reasoning_off => 'Desativado';

  @override
  String get hermes_response_ready => 'Resposta do Hermes pronta';

  @override
  String get admin_password_needed => 'Senha de administrador necessária';

  @override
  String get hermes_needs_a_sudo_password_for_the_pending_terminal_command =>
      'O Hermes precisa de uma senha sudo para o comando de terminal pendente.';

  @override
  String get sudo_password => 'Senha do sudo';

  @override
  String get secret_needed => 'Segredo necessário';

  @override
  String get hermes_needs_a_secret_for_the_pending_skill =>
      'O Hermes precisa de um segredo para a habilidade pendente.';

  @override
  String get secret_value => 'Valor do segredo';

  @override
  String get attached_file => 'Arquivo anexado';

  @override
  String get pin_chat => 'Fixar chat';

  @override
  String get unpin_chat => 'Desafixar chat';

  @override
  String get pinned_chats => 'Fixados';

  @override
  String could_not_update_chat_pin(Object error) {
    return 'Não foi possível alterar a fixação do chat: $error';
  }

  @override
  String get could_not_save_chat_spaces =>
      'Não foi possível salvar os espaços de conversa neste dispositivo';

  @override
  String get chat_density => 'Densidade do chat';

  @override
  String chat_density_2(Object label) {
    return 'Densidade do chat: $label';
  }

  @override
  String get chat_density_comfortable => 'Confortável';

  @override
  String get chat_density_compact => 'Compacta';

  @override
  String get chat_density_comfortable_description =>
      'Balões mais amplos com um rótulo de remetente acima de cada mensagem.';

  @override
  String get chat_density_compact_description =>
      'Balões mais justos e sem rótulo para caberem mais mensagens na tela.';

  @override
  String chat_density_label_description(Object description, Object label) {
    return '$label — $description';
  }

  @override
  String
  get compact_removes_the_you_and_hermes_labels_and_trims_bubble_padding_spacing_and_side_margins =>
      'O modo compacto remove os rótulos You e Hermes e reduz as margens internas, o espaçamento e as margens laterais dos balões.';

  @override
  String get client_certificate_mtls => 'Certificado de cliente (mTLS)';

  @override
  String get client_certificate_mtls_description =>
      'Apresentar um certificado quando um proxy HTTPS exigir TLS mútuo.';

  @override
  String get client_certificate_https_only =>
      'Os certificados de cliente são usados apenas em conexões HTTPS.';

  @override
  String get choose_certificate => 'Escolher certificado';

  @override
  String get certificate_password => 'Senha do certificado';

  @override
  String get this_certificate_is_password_protected =>
      'Este certificado é protegido por senha. Ele é aberto enquanto você digita.';

  @override
  String get enter_the_certificate_password_to_finish_loading_it =>
      'Digite a senha do certificado para concluir o carregamento do certificado escolhido.';

  @override
  String get client_certificate_required =>
      'Carregue um certificado de cliente ou desative a opção de certificado de cliente.';

  @override
  String client_certificate_loaded(String label) {
    return 'Carregado: $label';
  }

  @override
  String get remove_certificate => 'Remover certificado';

  @override
  String get certificate_import_failed =>
      'Não foi possível carregar esse certificado.';

  @override
  String get background_work => 'Trabalho em segundo plano';

  @override
  String get keep_chats_active_in_background =>
      'Manter conversas ativas em segundo plano';

  @override
  String get background_work_description =>
      'Mantém conectadas as conversas iniciadas por você enquanto o app está em segundo plano. Conexões ociosas podem ser desconectadas. Consome mais bateria e dados. Desativar não interrompe o trabalho no servidor.';

  @override
  String get background_work_limits =>
      'O Android ainda pode suspender conexões no modo Doze ou encerrar o processo do app. Notificações após o encerramento do processo exigem uma configuração de push separada. A parada forçada não é suportada.';

  @override
  String get background_work_disclosure =>
      'Uma notificação obrigatória do serviço permanece visível enquanto a proteção em segundo plano está ativa, mesmo com as notificações opcionais de conversa desativadas.';

  @override
  String get battery_optimisation_settings =>
      'Configurações de otimização da bateria';

  @override
  String get battery_optimisation_description =>
      'Abre as configurações do Android para revisar as restrições de bateria. Nenhuma exceção é solicitada automaticamente e alterar as configurações não garante a entrega.';

  @override
  String get battery_settings_unavailable =>
      'Não foi possível abrir as configurações de bateria neste dispositivo.';

  @override
  String get background_work_save_failed =>
      'Não foi possível salvar a configuração de trabalho em segundo plano.';

  @override
  String get ongoing_chat_channel_name => 'Conversas ativas';

  @override
  String get ongoing_chat_channel_description =>
      'Atualizações silenciosas de conversas iniciadas por você ainda não concluídas';

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
  String get activity_status_unconfirmed => 'Status não confirmado';

  @override
  String get activity_recently_updated => 'Atualizado recentemente';

  @override
  String get activity_reconnecting =>
      'Reconectando — verificando o status do turno';

  @override
  String get activity_outcome_unknown =>
      'Não foi possível confirmar o resultado do turno. Abra o chat para verificar.';

  @override
  String get activity_chat_updated_detail =>
      'Atividade do chat registrada pelo Gateway; o status do turno em tempo real não está disponível.';

  @override
  String get activity_updated => 'Atualizado';

  @override
  String get activity_empty_title => 'Nenhuma atividade recente';

  @override
  String get activity_empty_detail =>
      'Aqui aparecem os turnos iniciados neste app e os chats do Gateway atualizados nos últimos 7 dias.';

  @override
  String get activity_read_error =>
      'A Atividade não conseguiu ler os registros dos turnos ou os chats do Gateway. Verifique a conexão e tente novamente.';

  @override
  String get activity_chat_unavailable =>
      'Este chat não está mais disponível ou não foi possível acessar o Gateway.';

  @override
  String get activity_partial_title => 'Atividade parcialmente carregada';

  @override
  String get activity_partial_detail =>
      'Um intervalo limitado da atividade do gateway é exibido. Pode haver mais conversas; puxe para atualizar.';

  @override
  String get provider_usage => 'Uso registrado';

  @override
  String get provider_usage_notice =>
      'Uso do Hermes nos últimos 30 dias, não saldo nem preços. Configure as credenciais no servidor Hermes; este app não armazena chaves API de provedores.';

  @override
  String get provider_usage_failed =>
      'Não foi possível carregar o uso registrado.';

  @override
  String get provider_usage_empty => 'Sem uso registrado para este provedor.';

  @override
  String provider_usage_counts(String sessions, String input, String output) {
    return '$sessions sessões · Entrada: $input · Saída: $output';
  }

  @override
  String provider_usage_costs(String estimated, String actual) {
    return 'Estimado: $estimated · Informado: $actual';
  }

  @override
  String get provider_quota_codex => 'Assinatura do OpenAI Codex';

  @override
  String get provider_quota_claude => 'Assinatura do Claude';

  @override
  String get provider_quota_openai_api => 'Uso registrado da API OpenAI';

  @override
  String get provider_quota_notice =>
      'Períodos da assinatura informados pelo provedor, separados do uso registrado pelo Hermes e da cobrança da API. As contas são exibidas separadamente; os limites de um modelo não significam que toda a cota da conta tenha sido esgotada.';

  @override
  String get provider_quota_windows_notice =>
      'As assinaturas do Codex e do Claude têm limites por sessão de cinco horas e por semana. Apenas os períodos informados pelo provedor são exibidos; os limites e os horários de redefinição não informados continuam indisponíveis. Os limites semanais podem se aplicar à conta ou a modelos específicos.';

  @override
  String get provider_quota_five_hour_session => 'Sessão de 5 horas';

  @override
  String get provider_quota_unavailable => 'Cota da assinatura indisponível.';

  @override
  String get provider_quota_failed =>
      'Não foi possível atualizar a cota da assinatura. Os valores mantidos são da consulta anterior.';

  @override
  String get provider_quota_account => 'Conta';

  @override
  String get provider_quota_unknown => 'desconhecido';

  @override
  String provider_quota_state(String state) {
    return 'Estado da conta: $state';
  }

  @override
  String provider_quota_scope(String scope) {
    return 'Escopo: $scope';
  }

  @override
  String provider_quota_percent(String used, String remaining) {
    return '$used% usado · $remaining% restante';
  }

  @override
  String provider_quota_reset(String reset) {
    return 'Redefinição: $reset';
  }

  @override
  String get provider_quota_reset_unknown =>
      'Horário de redefinição indisponível.';

  @override
  String get auxiliary_models => 'Modelos auxiliares';

  @override
  String get auxiliary_notice =>
      'Escolha modelos por tarefa. Endpoints personalizados são gerenciados no servidor. Auto segue as regras de herança da tarefa.';

  @override
  String get auxiliary_inherit => 'Auto (herdar)';

  @override
  String get auxiliary_unavailable =>
      'As configurações auxiliares estão indisponíveis.';

  @override
  String get provider_oauth_title => 'Login no provedor';

  @override
  String get provider_oauth_more_subtitle =>
      'Gerenciar o login nos provedores no seu servidor Hermes';

  @override
  String get provider_oauth_settings_subtitle =>
      'Entre no seu servidor Hermes; os tokens do provedor não ficam neste dispositivo';

  @override
  String get provider_oauth_intro =>
      'Entre no provedor em um navegador externo. Os tokens são armazenados apenas no seu servidor Hermes, não neste dispositivo. O login não seleciona um modelo de chat neste aplicativo.';

  @override
  String get provider_oauth_defaults_notice =>
      'Alguns processos do servidor, incluindo a substituição de contas gratuitas Nous, podem alterar os padrões do servidor. Revise as configurações do servidor após o login.';

  @override
  String get provider_oauth_transport_init_failed =>
      'Não foi possível inicializar a conexão segura com o painel selecionado. Verifique a identidade TLS e as configurações de conexão.';

  @override
  String get provider_oauth_https_required =>
      'O login no provedor exige uma conexão HTTPS com o painel Hermes.';

  @override
  String get provider_oauth_auth_required =>
      'Configure a autenticação por senha do painel ou um proxy confiável antes de entrar.';

  @override
  String get provider_oauth_catalog_failed =>
      'O login nos provedores não está disponível neste servidor. Verifique a autenticação do painel e atualize o servidor se ele não oferecer suporte ao OAuth de provedores.';

  @override
  String get provider_oauth_expired => 'O login expirou. Comece novamente.';

  @override
  String get provider_oauth_start_failed =>
      'Não foi possível iniciar o login seguro no provedor. Tente novamente.';

  @override
  String get provider_oauth_denied => 'O login foi negado. Comece novamente.';

  @override
  String get provider_oauth_cancelled => 'Login cancelado.';

  @override
  String get provider_oauth_host_failed =>
      'O servidor não conseguiu concluir o login. Comece novamente.';

  @override
  String get provider_oauth_poll_failed =>
      'Não foi possível verificar o status do login. Comece novamente.';

  @override
  String provider_oauth_cancellation_unconfirmed(String message) {
    return '$message Não foi possível confirmar o cancelamento; a sessão do servidor pode continuar até expirar.';
  }

  @override
  String get provider_oauth_browser_failed =>
      'Não foi possível abrir o navegador externo. Tente novamente ou cancele o login.';

  @override
  String get provider_oauth_retry => 'Tentar novamente';

  @override
  String provider_oauth_complete(String provider) {
    return 'Concluir o login em $provider';
  }

  @override
  String get provider_oauth_code_instruction =>
      'Digite este código temporário na página do provedor:';

  @override
  String get provider_oauth_waiting =>
      'Aguardando aprovação. Esta sessão expira automaticamente.';

  @override
  String get provider_oauth_open_browser => 'Abrir provedor no navegador';

  @override
  String get provider_oauth_cancel => 'Cancelar login';

  @override
  String get provider_oauth_signed_out => 'Não conectado no servidor';

  @override
  String get provider_oauth_sign_in_again => 'Entrar novamente';

  @override
  String get provider_oauth_sign_in => 'Entrar';

  @override
  String get provider_oauth_cli_required =>
      'Entre usando a CLI do provedor no seu servidor Hermes. Este servidor não oferece login no aplicativo para este provedor.';

  @override
  String get provider_oauth_checking_account =>
      'Aprovação recebida. Verificando a conta no servidor…';

  @override
  String get provider_oauth_verification_unavailable =>
      'Aprovação recebida; verificação da conta indisponível. Abra Uso para atualizar o uso da conta.';

  @override
  String provider_oauth_verified_account(String email) {
    return 'Conectado ao servidor Hermes como $email. Abra Uso para atualizar o uso da conta.';
  }

  @override
  String get provider_oauth_credentials_unverified =>
      'O servidor informa que há credenciais disponíveis; a identidade da conta não foi verificada.';

  @override
  String get provider_oauth_account_status_unknown =>
      'Status da conta no servidor indisponível.';

  @override
  String get app_language => 'Idioma do app';

  @override
  String get app_language_system => 'Igual ao celular';

  @override
  String get auto_archives_after_72_hours =>
      'Arquiva automaticamente após 72 horas';

  @override
  String get automation => 'Automação';

  @override
  String get voice_recording_start => 'Gravar mensagem de voz';

  @override
  String get voice_recording_pause => 'Pausar gravação';

  @override
  String get voice_recording_preview => 'Reproduzir gravação';

  @override
  String get voice_recording_resume => 'Continuar gravação';

  @override
  String get voice_recording_send => 'Enviar mensagem de voz';

  @override
  String get voice_recording_discard => 'Descartar gravação';

  @override
  String get voice_recording_processing => 'Preparando mensagem de voz…';

  @override
  String voice_recording_elapsed(String time) {
    return 'Gravando $time';
  }

  @override
  String voice_recording_draft(String time) {
    return 'Mensagem de voz $time';
  }

  @override
  String get voice_recording_permission =>
      'Permita o acesso ao microfone para gravar uma mensagem de voz.';

  @override
  String get voice_recording_limit =>
      'Esta gravação atingiu o limite de dez minutos.';

  @override
  String get voice_recording_empty =>
      'Nenhum áudio foi gravado. Tente novamente.';

  @override
  String get voice_recording_failed =>
      'Não foi possível processar a gravação. Os trechos salvos foram mantidos.';

  @override
  String get voice_recording_unconfirmed =>
      'A entrega não foi confirmada. Sua gravação está salva. Verifique o chat antes de tentar novamente.';

  @override
  String get voice_recording_submit_failed =>
      'Não foi possível enviar a mensagem de voz. Sua gravação está salva. Verifique a conexão, o acesso ao painel e as configurações de transcrição do servidor.';

  @override
  String get voice_recording_pause_playback => 'Pausar reprodução';

  @override
  String get projects_root_title => 'Pasta de Projetos no servidor';

  @override
  String get projects_root_more_subtitle =>
      'Onde as novas pastas de Projeto são criadas no servidor';

  @override
  String get projects_root_description =>
      'Os Projetos criados neste telefone recebem a pasta aqui. Aponte para a pasta que o próprio Hermes usa, para que telefone e servidor compartilhem os mesmos Projetos.';

  @override
  String get projects_root_label => 'Caminho raiz dos Projetos';

  @override
  String projects_root_default_hint(String path) {
    return 'Padrão do servidor: $path';
  }

  @override
  String get projects_root_locked_title => 'Definido pelo servidor';

  @override
  String get projects_root_locked_explanation =>
      'Este servidor restringe o acesso a arquivos a uma única raiz, portanto a pasta de Projetos não pode ser alterada pelo aplicativo.';

  @override
  String get projects_root_saved => 'Pasta de Projetos salva.';

  @override
  String get projects_root_reset => 'Usar o padrão do servidor';

  @override
  String get projects_root_invalid_empty => 'Informe um caminho de pasta.';

  @override
  String get projects_root_invalid_absolute =>
      'Informe um caminho absoluto que comece com uma barra.';

  @override
  String get projects_root_invalid_segments =>
      'Remova os segmentos com pontos e os caracteres de controle do caminho.';

  @override
  String get projects_root_unsupported =>
      'Não compatível nesta conexão. É necessária uma conexão Desktop Gateway com acesso ao Painel para ler ou alterar a pasta de Projetos do servidor.';

  @override
  String get projects_root_unavailable =>
      'Não foi possível ler a pasta de Projetos do servidor. Verifique a conexão com o Painel e tente novamente.';

  @override
  String get adopt_folder_action => 'Adicionar uma pasta existente';

  @override
  String adopt_folder_description(String root) {
    return 'Pastas em $root que ainda não estão registradas como Projeto.';
  }

  @override
  String adopt_folder_registered(String name) {
    return 'Já é um Projeto: $name';
  }

  @override
  String get adopt_folder_none =>
      'Todas as pastas neste caminho já são Projetos.';

  @override
  String get adopt_folder_unsupported =>
      'Esta conexão não consegue listar as pastas do servidor. Informe o caminho absoluto de uma pasta existente.';

  @override
  String adopt_folder_failed(String error) {
    return 'Não foi possível listar as pastas do servidor: $error';
  }

  @override
  String get adopt_folder_manual_label => 'Caminho da pasta existente';

  @override
  String get adopt_folder_name_label => 'Nome do Projeto';

  @override
  String get adopt_folder_add => 'Adicionar como Projeto';

  @override
  String adopt_folder_added(String name, String path) {
    return '$name agora usa $path';
  }

  @override
  String adopt_folder_error(String error) {
    return 'Não foi possível adicionar a pasta: $error';
  }

  @override
  String adopt_folder_folderless(String name) {
    return '$name foi criado, mas a pasta não foi anexada. Anexe-a pelo Hermes no servidor.';
  }

  @override
  String get slash_commands => 'Slash commands';

  @override
  String get slash_commands_loading => 'Loading commands…';

  @override
  String get slash_commands_empty => 'No matching commands';

  @override
  String slash_command_info_alias(String alias, String command) {
    return '$alias é um alias de $command';
  }

  @override
  String get slash_command_info_no_description =>
      'Nenhuma descrição disponível.';

  @override
  String get slash_command_info_arguments_options =>
      'Aceita uma opção de uma lista fixa.';

  @override
  String get slash_command_info_arguments_text =>
      'Aceita texto depois do comando.';

  @override
  String get slash_command_info_arguments_mixed =>
      'Aceita uma opção ou texto depois do comando.';

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
      'Este comando não está disponível neste servidor.';

  @override
  String get slash_sessions_inline =>
      'Abra a lista de sessões para escolher uma conversa. Seu rascunho foi mantido.';

  @override
  String get composer_snippets => 'Trechos de prompt';

  @override
  String get composer_snippets_description =>
      'Escolha um prompt inicial para inserir no editor.';

  @override
  String get composer_snippet_review => 'Revisão de código';

  @override
  String get composer_snippet_review_body =>
      'Revise a alteração atual em busca de regressões, casos extremos ignorados e testes ausentes.';

  @override
  String get composer_snippet_review_text =>
      'Por favor, revise isto em busca de bugs, regressões e testes ausentes.';

  @override
  String get composer_snippet_plan => 'Plano de implementação';

  @override
  String get composer_snippet_plan_body =>
      'Defina uma abordagem antes de mexer no código para manter o foco das alterações.';

  @override
  String get composer_snippet_plan_text =>
      'Por favor, faça um plano de implementação conciso antes de alterar o código.';

  @override
  String get composer_snippet_explain => 'Explique isto';

  @override
  String get composer_snippet_explain_body =>
      'Explique como o código selecionado funciona e indique os arquivos principais.';

  @override
  String get composer_snippet_explain_text =>
      'Por favor, explique como isto funciona e indique os arquivos principais.';

  @override
  String get composer_status => 'Status';

  @override
  String get composer_status_context => 'Contexto';

  @override
  String get composer_status_cache => 'Acerto de cache';

  @override
  String get composer_status_throughput => 'Tokens de saída/s';

  @override
  String get composer_status_running => 'Em execução';

  @override
  String get composer_status_session => 'Sessão';

  @override
  String get composer_status_not_reported => 'Não informado';

  @override
  String get composer_status_empty =>
      'Nenhum detalhamento do contexto foi informado.';

  @override
  String get composer_status_loading => 'Carregando detalhamento do contexto';

  @override
  String get composer_status_reset => 'Redefinir barra de status';

  @override
  String get composer_resume_title => 'Retomar um chat';

  @override
  String get composer_resume_search => 'Buscar títulos e IDs';

  @override
  String get composer_resume_empty => 'Nenhum chat corresponde à busca.';

  @override
  String get composer_resume_unavailable =>
      'Este painel não tem uma lista de chats para buscar.';

  @override
  String get composer_failure_retry => 'Tentar novamente';

  @override
  String composer_failure_retry_at(String time) {
    return 'Tentar novamente às $time';
  }

  @override
  String get composer_failure_compress => 'Comprimir';

  @override
  String get composer_failure_switch_model => 'Trocar modelo';

  @override
  String composer_failure_switch_to(String model) {
    return 'Trocar para $model';
  }

  @override
  String get composer_failure_new_chat => 'Novo chat';

  @override
  String get composer_failure_edit => 'Editar mensagem';

  @override
  String get composer_failure_details => 'Detalhes';

  @override
  String get composer_failure_hide_details => 'Ocultar detalhes';

  @override
  String get composer_failure_copy => 'Copiar diagnóstico';

  @override
  String get composer_failure_account =>
      'A outra correção deve ser feita na conta do gateway. Este chat não pode fazer isso.';

  @override
  String get composer_failure_account_only =>
      'Isso precisa ser corrigido na conta do gateway. Este chat não pode fazer isso.';

  @override
  String get composer_failure_confirm_compress =>
      'Comprimir este chat? O gateway encurtará a transcrição.';

  @override
  String composer_failure_confirm_model(String model) {
    return 'Trocar este chat para $model?';
  }

  @override
  String get composer_drop_attach => 'Solte para anexar';

  @override
  String get composer_drop_folder_unsupported =>
      'Não é possível anexar pastas. Solte os arquivos em vez delas.';

  @override
  String get composer_drop_reference => 'Solte para referenciar';

  @override
  String get composer_reference_copy => 'Copiar referência';

  @override
  String get composer_reference_remove => 'Remover referência';

  @override
  String get composer_btw_usage =>
      'Uso: /btw <question> — responde a partir de uma cópia do estado desta conversa, sem interrompê-la.';

  @override
  String get composer_background_usage =>
      'Uso: /background <prompt> — a tarefa é executada separadamente e o resultado volta para cá.';

  @override
  String get composer_handoff_usage =>
      'Uso: /handoff <platform> — transfere este chat para essa plataforma de mensagens.';

  @override
  String get composer_command_needs_session =>
      'Este comando precisa de um chat aberto.';

  @override
  String get composer_retry_not_found =>
      'Este turno não está no histórico salvo, então Tentar novamente não pode substituí-lo. Nada foi reenviado. Edite a mensagem e envie-a para tentar outra vez.';

  @override
  String get composer_retry_unavailable =>
      'Tentar novamente não pode substituir um turno nesta conexão, então nada foi reenviado. Edite a mensagem e envie-a para tentar outra vez.';

  @override
  String get composer_failure_switch_no_retry =>
      'A troca muda só o modelo: esta conexão não consegue executar de novo o turno que falhou. Envie-o novamente depois de trocar.';

  @override
  String get composer_command_needs_gateway_session =>
      'Este chat ainda não tem uma sessão no gateway. Envie uma mensagem primeiro e execute o comando novamente.';

  @override
  String get composer_side_question =>
      'btw — respondendo a partir de uma cópia do estado da conversa';

  @override
  String composer_side_question_id(String id) {
    return 'btw $id — respondendo a partir de uma cópia do estado da conversa';
  }

  @override
  String get composer_background_started =>
      'Tarefa em segundo plano iniciada. Você pode continuar conversando. O resultado aparecerá aqui.';

  @override
  String composer_background_started_id(String id) {
    return 'Tarefa em segundo plano $id iniciada. Você pode continuar conversando. O resultado aparecerá aqui.';
  }

  @override
  String composer_handoff_requested(String platform) {
    return 'Transferência para $platform solicitada.';
  }

  @override
  String composer_handoff_done(String platform) {
    return 'Este chat foi transferido para $platform.';
  }

  @override
  String get composer_handoff_failed => 'Falha na transferência.';

  @override
  String get composer_handoff_timeout =>
      'A transferência não foi concluída. Ela ainda pode estar em andamento no gateway.';

  @override
  String get composer_compress_done => 'Este chat foi comprimido.';

  @override
  String get composer_file_missing =>
      'Esse arquivo não está neste dispositivo.';

  @override
  String get composer_attach_busy =>
      'Os anexos podem ser adicionados quando esta resposta terminar.';

  @override
  String get nextgen_toggle => 'Interface NextGen';

  @override
  String get nextgen_toggle_subtitle =>
      'Um novo design com um único login, conversas ao vivo e descoberta na rede. Seus gateways e conversas são compartilhados com esta interface.';

  @override
  String get nextgen_single_login => 'Entrar com um único login';

  @override
  String get nextgen_single_login_subtitle =>
      'Adicione um gateway apenas com o endereço do painel e um login.';

  @override
  String get ng_allow_this_command => 'Permitir este comando?';

  @override
  String ng_hermes_wants_to_run_this_with(Object tool) {
    return 'O Hermes quer executar isto com $tool.';
  }

  @override
  String get ng_hermes_wants_to_run_this => 'O Hermes quer executar isto.';

  @override
  String get ng_hermes_has_a_question => 'O Hermes tem uma pergunta';

  @override
  String get ng_hermes_has_questions => 'O Hermes tem perguntas';

  @override
  String get ng_password_for_sudo => 'Senha do sudo';

  @override
  String get ng_hermes_needs_your_sudo_password_to =>
      'O Hermes precisa da sua senha do sudo para executar este comando.';

  @override
  String get ng_a_secret_value => 'Um valor secreto';

  @override
  String ng_value_for(Object variable) {
    return 'Valor de $variable';
  }

  @override
  String get ng_your_password_manager => 'seu gerenciador de senhas';

  @override
  String ng_unlock(Object name) {
    return 'Desbloquear $name';
  }

  @override
  String ng_hermes_needs_unlocked_to_sign_in(Object name) {
    return 'O Hermes precisa que $name esteja desbloqueado para fazer login por você.';
  }

  @override
  String get ng_sign_in_code => 'Código de login';

  @override
  String get ng_enter_the_sign_in_code => 'Digite o código de login.';

  @override
  String ng_enter_the_sign_in_code_for(Object site) {
    return 'Digite o código de login de $site.';
  }

  @override
  String get ng_save_a_login => 'Salvar um login?';

  @override
  String ng_save_your_login(Object site) {
    return 'Salvar seu login de $site?';
  }

  @override
  String ng_couldn_t_load_this_chat(Object error) {
    return 'Não foi possível carregar esta conversa: $error';
  }

  @override
  String ng_live_updates_are_unavailable(Object error) {
    return 'As atualizações em tempo real estão indisponíveis: $error';
  }

  @override
  String ng_preparing(Object name) {
    return 'preparando $name…';
  }

  @override
  String get ng_the_turn_failed => 'A resposta falhou.';

  @override
  String get ng_turn_changed =>
      'essa resposta já terminou ou uma mais recente começou';

  @override
  String get ng_steer_rejected => 'a resposta em andamento não aceitou';

  @override
  String get ng_turn_not_known_yet =>
      'a resposta em andamento ainda não é conhecida; tente de novo em instantes';

  @override
  String ng_couldn_t_stop(Object error) {
    return 'Não foi possível parar: $error';
  }

  @override
  String get ng_server_access => 'Acesso ao servidor';

  @override
  String get ng_sign_in => 'Login';

  @override
  String get ng_live_connection => 'Conexão em tempo real';

  @override
  String get ng_check_that_tailscale_is_on_on =>
      'Verifique se o Tailscale está ativado neste celular e no servidor.';

  @override
  String get ng_check_the_address_and_that_the =>
      'Verifique o endereço e se o proxy encaminha para o painel.';

  @override
  String get ng_use_the_same_network_as_the =>
      'Use a mesma rede do servidor e inicie o painel com --host 0.0.0.0 para que outros dispositivos possam acessá-lo.';

  @override
  String get ng_check_the_address_vpn_or_tailscale =>
      'Verifique o endereço e a conexão VPN ou Tailscale.';

  @override
  String get ng_not_checked_yet => 'Ainda não verificado.';

  @override
  String get ng_checking => 'Verificando…';

  @override
  String ng_hermes_answers_at(Object version, Object address) {
    return 'O Hermes $version responde em $address.';
  }

  @override
  String get ng_something_answered_but_not_a_hermes =>
      'Algo respondeu, mas não é um painel do Hermes.';

  @override
  String ng_something_answered_http_but_not_a(Object status) {
    return 'Algo respondeu (HTTP $status), mas não é um painel do Hermes.';
  }

  @override
  String get ng_use_the_dashboard_s_address_and =>
      'Use o endereço e a porta do painel (9119 por padrão), não os do servidor de API.';

  @override
  String get ng_cloudflare_access_turned_the_service_token =>
      'O Cloudflare Access recusou o token de serviço.';

  @override
  String get ng_cloudflare_access_is_in_front_of =>
      'O Cloudflare Access está na frente deste endereço.';

  @override
  String get ng_check_the_service_token_and_its =>
      'Verifique o token de serviço e a política Service Auth.';

  @override
  String get ng_add_a_cloudflare_access_service_token =>
      'Adicione um token de serviço do Cloudflare Access para este endereço.';

  @override
  String get ng_the_server_asks_for_a_client =>
      'O servidor solicita um certificado de cliente.';

  @override
  String get ng_pick_the_client_certificate_for_this =>
      'Selecione o certificado de cliente deste gateway e teste novamente.';

  @override
  String get ng_needs_server_access_first =>
      'É necessário acessar o servidor primeiro.';

  @override
  String get ng_needs_a_sign_in_first => 'É necessário fazer login primeiro.';

  @override
  String ng_signed_in_as(Object name) {
    return 'Conectado como $name.';
  }

  @override
  String get ng_this_dashboard_doesn_t_need_a =>
      'Este painel não precisa de login.';

  @override
  String get ng_the_saved_sign_in_has_expired => 'O login salvo expirou.';

  @override
  String get ng_sign_in_again => 'Faça login novamente.';

  @override
  String get ng_too_many_sign_in_attempts => 'Muitas tentativas de login.';

  @override
  String get ng_wait_a_minute_then_check_again =>
      'Aguarde um minuto e verifique novamente.';

  @override
  String ng_the_gateway_answered(Object message) {
    return 'O gateway respondeu: $message.';
  }

  @override
  String get ng_sign_in_again_or_update_hermes =>
      'Faça login novamente ou atualize o Hermes.';

  @override
  String ng_couldn_t_check_the_sign_in(Object error) {
    return 'Não foi possível verificar o login: $error';
  }

  @override
  String ng_the_gateway_wouldn_t_issue_a(Object message) {
    return 'O gateway não emitiu um ticket de conversa ($message).';
  }

  @override
  String get ng_the_chat_connection_opened_and_the =>
      'A conexão da conversa foi aberta e o gateway informou que está pronto.';

  @override
  String get ng_the_gateway_never_said_it_was =>
      'O gateway não informou que estava pronto.';

  @override
  String get ng_check_that_the_agent_is_running =>
      'Verifique se o agente está em execução no servidor.';

  @override
  String get ng_the_gateway_refused_the_chat_connection =>
      'O gateway recusou a conexão da conversa (HTTP 403).';

  @override
  String get ng_this_dashboard_has_no_chat_endpoint =>
      'Este painel não tem um endpoint de conversa (/api/ws).';

  @override
  String ng_the_chat_connection_failed(Object detail) {
    return 'A conexão da conversa falhou: $detail';
  }

  @override
  String get ng_use_the_exact_address_the_dashboard =>
      'Use o endereço exato configurado para o painel.';

  @override
  String get ng_update_hermes => 'Atualize o Hermes.';

  @override
  String get ng_make_sure_the_proxy_allows_websocket =>
      'Verifique se o proxy permite atualizações de WebSocket em /api/ws.';

  @override
  String get ng_offline => 'Offline';

  @override
  String get ng_connecting => 'Conectando…';

  @override
  String get ng_connected => 'Conectado';

  @override
  String get ng_reconnecting => 'Reconectando…';

  @override
  String get ng_signed_out => 'Sessão encerrada';

  @override
  String get ng_connection_failed => 'Falha na conexão';

  @override
  String get ng_rate_limited_by_gateway =>
      'Limite de requisições imposto pelo gateway';

  @override
  String ng_couldn_t_open_the_chat_connection(Object message) {
    return 'Não foi possível abrir a conexão do chat: $message';
  }

  @override
  String get ng_the_gateway_returned_no_websocket_ticket =>
      'O gateway não retornou um ticket WebSocket.';

  @override
  String get ng_connection_lost => 'Conexão perdida';

  @override
  String get ng_this_dashboard_has_no_chat_endpoint_2 =>
      'Este painel não tem um endpoint de chat (/api/ws). Atualize o Hermes.';

  @override
  String get ng_the_gateway_refused_the_chat_connection_2 =>
      'O gateway recusou a conexão do chat. Confira se o endereço corresponde ao host configurado no painel e se o chat incorporado está ativado.';

  @override
  String ng_the_gateway_refused(Object method) {
    return 'O gateway recusou $method.';
  }

  @override
  String ng_couldn_t_read_your_saved_gateways(Object error) {
    return 'Não foi possível ler seus gateways salvos: $error';
  }

  @override
  String get ng_applies_to_new_chats => 'Aplica-se a novos chats';

  @override
  String ng_couldn_t_change(Object label, Object error) {
    return 'Não foi possível alterar $label: $error';
  }

  @override
  String get ng_capabilities => 'Recursos';

  @override
  String get ng_skills => 'Habilidades';

  @override
  String get ng_toolsets => 'Conjuntos de ferramentas';

  @override
  String get ng_search => 'Buscar';

  @override
  String get ng_couldn_t_load => 'Não foi possível carregar';

  @override
  String get ng_try_again => 'Tentar novamente';

  @override
  String get ng_no_skills => 'Nenhuma habilidade';

  @override
  String get ng_no_toolsets => 'Nenhum conjunto de ferramentas';

  @override
  String get ng_no_mcp_servers => 'Nenhum servidor MCP';

  @override
  String get ng_that_file_is_too_large_to =>
      'Esse arquivo é grande demais para ser um certificado.';

  @override
  String ng_the_certificate_couldn_t_be_imported(Object error) {
    return 'Não foi possível importar o certificado: $error';
  }

  @override
  String get ng_now_pick_its_private_key =>
      'Agora selecione a chave privada correspondente.';

  @override
  String get ng_now_pick_its_certificate =>
      'Agora selecione o certificado correspondente.';

  @override
  String get ng_that_file_isn_t_a_certificate =>
      'Esse arquivo não é um certificado nem uma chave privada.';

  @override
  String get ng_if_a_proxy_in_front_of =>
      'Se um proxy na frente deste endereço solicitar um certificado de cliente, selecione-o aqui para que o teste, o login e o chat o apresentem.';

  @override
  String get ng_client_certificates_are_only_used_with =>
      'Certificados de cliente só são usados com endereços https://.';

  @override
  String get ng_remove => 'Remover';

  @override
  String get ng_certificate_password => 'Senha do certificado';

  @override
  String get ng_importing => 'Importando…';

  @override
  String get ng_pick_certificate => 'Selecionar certificado';

  @override
  String get ng_pick_a_different_certificate => 'Selecionar outro certificado';

  @override
  String get ng_accepts_p12_pfx_or_pem_certificate =>
      'Aceita arquivos .p12/.pfx ou arquivos de certificado e chave PEM. A chave fica no armazenamento privado deste app.';

  @override
  String get ng_photos => 'Fotos';

  @override
  String get ng_camera => 'Câmera';

  @override
  String get ng_files => 'Arquivos';

  @override
  String ng_you_can_attach_up_to_files(Object count) {
    return 'Você pode anexar até $count arquivos.';
  }

  @override
  String ng_couldn_t_read(Object name) {
    return 'Não foi possível ler $name.';
  }

  @override
  String ng_couldn_t_prepare_that_file(Object error) {
    return 'Não foi possível preparar esse arquivo: $error';
  }

  @override
  String get ng_hermes_is_still_working => 'O Hermes ainda está trabalhando';

  @override
  String get ng_steer => 'Orientar';

  @override
  String get ng_adds_this_to_the_running_turn =>
      'Adiciona esta mensagem à etapa seguinte da execução atual';

  @override
  String get ng_queue => 'Fila';

  @override
  String get ng_sends_it_when_the_turn_finishes =>
      'Envia quando a execução terminar';

  @override
  String get ng_stop_and_send => 'Parar e enviar';

  @override
  String get ng_stops_the_turn_then_sends_this =>
      'Interrompe a execução e envia esta mensagem';

  @override
  String ng_dictation_stopped(Object message) {
    return 'Ditado interrompido: $message';
  }

  @override
  String get ng_speech_recognition_isn_t_available =>
      'O reconhecimento de fala não está disponível.';

  @override
  String get ng_working => 'Trabalhando';

  @override
  String get ng_ready => 'Pronto';

  @override
  String get ng_chats => 'Chats';

  @override
  String get ng_new_chat => 'Novo chat';

  @override
  String get ng_usage => 'Uso';

  @override
  String get ng_rename_chat => 'Renomear chat';

  @override
  String ng_couldn_t_rename(Object error) {
    return 'Não foi possível renomear: $error';
  }

  @override
  String get ng_this_chat => 'Este chat';

  @override
  String get ng_input_tokens => 'Tokens de entrada';

  @override
  String get ng_output_tokens => 'Tokens de saída';

  @override
  String get ng_reasoning_tokens => 'Tokens de raciocínio';

  @override
  String get ng_cache_reads => 'Leituras do cache';

  @override
  String get ng_api_calls => 'Chamadas de API';

  @override
  String get ng_cost => 'Custo';

  @override
  String get ng_context => 'Contexto';

  @override
  String get ng_your_sign_in_expired => 'Sua sessão expirou.';

  @override
  String get ng_sign_in_2 => 'Entrar';

  @override
  String get ng_retry => 'Tentar novamente';

  @override
  String get ng_project_home => 'Início';

  @override
  String get ng_choose_project => 'Escolher um projeto';

  @override
  String ng_project_cwd_fallback(String path) {
    return 'A pasta do projeto não estava disponível, então esta conversa é executada em $path.';
  }

  @override
  String get ng_project_create_uncertain =>
      'O gateway pode ter criado esta conversa, mas não a confirmou. Verifique as conversas antes de iniciar outra; esta solicitação não será repetida automaticamente.';

  @override
  String get ng_what_should_we_work_on => 'No que vamos trabalhar?';

  @override
  String get ng_ask_hermes_anything_it_can_run =>
      'Pergunte qualquer coisa ao Hermes. Ele pode usar ferramentas, navegar e trabalhar nos seus arquivos no servidor.';

  @override
  String ng_working_2(Object frame) {
    return 'Trabalhando · $frame';
  }

  @override
  String get ng_default_model => 'Modelo padrão';

  @override
  String get ng_listening => 'Ouvindo…';

  @override
  String get ng_steer_or_queue_a_message =>
      'Oriente ou coloque uma mensagem na fila';

  @override
  String get ng_message_hermes => 'Enviar mensagem ao Hermes';

  @override
  String get ng_attach => 'Anexar';

  @override
  String get ng_stop_dictation => 'Parar ditado';

  @override
  String get ng_dictate => 'Ditado';

  @override
  String get ng_stop => 'Parar';

  @override
  String get ng_send => 'Enviar';

  @override
  String ng_slash_command_alias(String alias, String command) {
    return '$alias é um alias de $command';
  }

  @override
  String get ng_slash_command_no_description => 'Nenhuma descrição disponível.';

  @override
  String get ng_slash_command_arguments_options =>
      'Aceita uma opção de uma lista fixa.';

  @override
  String get ng_slash_command_arguments_text =>
      'Aceita texto depois do comando.';

  @override
  String get ng_slash_command_arguments_mixed =>
      'Aceita uma opção ou texto depois do comando.';

  @override
  String get ng_slash_command_sent_as_message =>
      'O NextGen envia isso ao Hermes como uma mensagem normal; o comando em si não é executado.';

  @override
  String get ng_slash_command_output => 'Saída do comando';

  @override
  String get ng_slash_command_running => 'Executando o comando…';

  @override
  String get ng_slash_command_done => 'Concluído.';

  @override
  String ng_slash_command_failed(Object error) {
    return 'Não foi possível executar o comando: $error';
  }

  @override
  String get ng_slash_command_refused =>
      'O Hermes não consegue executar este comando aqui.';

  @override
  String get ng_slash_command_delivery_unknown =>
      'O comando foi enviado, mas nenhuma resposta chegou. Ele ainda pode estar em execução no gateway, então não foi enviado de novo e seu rascunho foi mantido.';

  @override
  String get ng_slash_command_nothing_running => 'Nada está em execução.';

  @override
  String get ng_steered => 'Orientada';

  @override
  String get ng_copied => 'Copiado';

  @override
  String ng_not_sent(Object reason) {
    return 'Não enviada: $reason';
  }

  @override
  String get ng_thinking => 'Pensando…';

  @override
  String get ng_thought => 'Pensamento';

  @override
  String ng_used(Object name) {
    return 'Usou $name';
  }

  @override
  String ng_used_tools(Object count) {
    return 'Usou $count ferramentas';
  }

  @override
  String get ng_copy => 'Copiar';

  @override
  String get ng_read_aloud => 'Ler em voz alta';

  @override
  String get ng_the_gateway_connection_dropped_try_again =>
      'A conexão com o gateway caiu. Tente novamente.';

  @override
  String get ng_allow_once => 'Permitir uma vez';

  @override
  String get ng_allow_until_sandbox_off => 'Até a sandbox ser desativada';

  @override
  String get ng_folder_access => 'Acesso à pasta';

  @override
  String get ng_folder_access_unspecified =>
      'O gateway não informou se é somente leitura ou leitura e gravação.';

  @override
  String get ng_folder_read_only => 'Somente leitura';

  @override
  String get ng_folder_read_write => 'Leitura e gravação';

  @override
  String get ng_website_access => 'Acesso ao site';

  @override
  String get ng_allow_for_this_chat => 'Permitir neste chat';

  @override
  String get ng_always_allow => 'Permitir sempre';

  @override
  String get ng_deny => 'Não permitir';

  @override
  String get ng_your_answer => 'Sua resposta';

  @override
  String get ng_or_type_an_answer => 'Ou digite uma resposta';

  @override
  String get ng_skip => 'Pular';

  @override
  String get ng_answer => 'Responder';

  @override
  String get ng_cancel => 'Cancelar';

  @override
  String get ng_username_or_email => 'Nome de usuário ou e-mail';

  @override
  String get ng_password => 'Senha';

  @override
  String get ng_not_now => 'Agora não';

  @override
  String get ng_save => 'Salvar';

  @override
  String get ng_enter_both_the_client_id_and =>
      'Informe o Client ID e o Client Secret, ou deixe ambos em branco.';

  @override
  String get ng_enter_your_username_and_password =>
      'Informe seu nome de usuário e senha.';

  @override
  String ng_couldn_t_save_the_sign_in(Object error) {
    return 'Não foi possível salvar os dados de acesso: $error';
  }

  @override
  String get ng_wrong_username_or_password =>
      'Nome de usuário ou senha incorretos.';

  @override
  String get ng_too_many_attempts_wait_a_moment =>
      'Muitas tentativas. Aguarde um momento e tente novamente.';

  @override
  String get ng_welcome_to_hermes => 'Boas-vindas ao Ares';

  @override
  String get ng_add_a_gateway => 'Adicionar gateway';

  @override
  String get ng_connect_to_your_hermes_agent_dashboard =>
      'Conecte-se ao painel do Hermes Agent. Um endereço e um acesso dão acesso aos seus chats, ferramentas e configurações. Nada é enviado até você entrar.';

  @override
  String get ng_connect_to_another_hermes_agent_dashboard =>
      'Conecte-se a outro painel do Hermes Agent. Você continuará conectado aos que já salvou.';

  @override
  String get ng_dashboard_address => 'Endereço do painel';

  @override
  String get ng_testing => 'Testando…';

  @override
  String get ng_test => 'Testar';

  @override
  String get ng_where_your_hermes_dashboard_runs_lan =>
      'Onde seu painel Hermes está hospedado: rede local, Tailscale ou HTTPS.';

  @override
  String get ng_find_on_my_network => 'Encontrar na minha rede';

  @override
  String get ng_which_address_do_i_use => 'Qual endereço devo usar?';

  @override
  String get ng_behind_cloudflare_access => 'Protegido pelo Cloudflare Access?';

  @override
  String get ng_need_a_client_certificate =>
      'Precisa de um certificado de cliente?';

  @override
  String get ng_this_address_isn_t_private_and =>
      'Este endereço não é privado nem usa https://, então sua senha e seus chats seriam transmitidos pela internet sem criptografia. Use https://, Tailscale ou sua própria rede.';

  @override
  String get ng_continue_to_sign_in => 'Continuar para entrar';

  @override
  String get ng_use_the_classic_interface_instead =>
      'Usar a interface clássica';

  @override
  String get ng_if_cloudflare_access_protects_this_address =>
      'Se o Cloudflare Access proteger este endereço, crie um token de serviço no Cloudflare Zero Trust (Access, Service credentials) e adicione uma política Service Auth ao aplicativo do Access.';

  @override
  String get ng_a_service_token_is_saved_for =>
      'Há um token de serviço salvo para este endereço';

  @override
  String get ng_forget => 'Esquecer';

  @override
  String get ng_client_id => 'Client ID';

  @override
  String get ng_client_secret => 'Client Secret';

  @override
  String get ng_stored_encrypted_on_this_phone_and =>
      'Armazenado com criptografia neste celular e enviado somente para este endereço.';

  @override
  String get ng_hermes_is_reachable => 'Hermes está acessível';

  @override
  String ng_hermes_is_reachable_2(Object version) {
    return 'Hermes $version está acessível';
  }

  @override
  String get ng_sign_in_is_tested_next_then =>
      'O login é testado primeiro, depois o chat';

  @override
  String get ng_agent_gateway => 'Gateway do agente';

  @override
  String get ng_running => 'Em execução';

  @override
  String get ng_stopped => 'Parado';

  @override
  String get ng_username_password => 'Usuário e senha';

  @override
  String get ng_browser => 'Navegador';

  @override
  String get ng_in_the_browser_sso => 'No navegador (SSO)';

  @override
  String get ng_profiles => 'Perfis';

  @override
  String get ng_this_dashboard_offers_neither_a_username =>
      'Este painel não oferece login com usuário e senha nem pelo navegador. Atualize o Hermes ou configure o provedor de usuário e senha no servidor.';

  @override
  String get ng_the_auth_gate_is_off_on =>
      'A autenticação está desativada neste painel. Qualquer pessoa que consiga acessá-lo pode usar seu agente.';

  @override
  String get ng_couldn_t_reach_the_dashboard =>
      'Não foi possível acessar o painel';

  @override
  String ng_check_the_address_and_port_9119(Object reason) {
    return '$reason\n\nConfira o endereço e a porta (9119 por padrão). Se o painel ainda não estiver em execução, execute este comando no servidor:\nhermes dashboard --host 0.0.0.0';
  }

  @override
  String get ng_that_isn_t_a_hermes_dashboard => 'Este não é um painel Hermes';

  @override
  String get ng_something_answered_but_not_a_hermes_2 =>
      'Algo respondeu, mas não era um painel Hermes. Use o endereço do painel, não o do servidor de API (porta 8642).';

  @override
  String ng_something_answered_http_but_not_a_2(Object status) {
    return 'Algo respondeu (HTTP $status), mas não era um painel Hermes. Use o endereço do painel, não o do servidor de API (porta 8642).';
  }

  @override
  String get ng_cloudflare_access_stopped_the_request =>
      'O Cloudflare Access bloqueou a solicitação';

  @override
  String ng_cloudflare_access_turned_down_the_service(Object status) {
    return 'O Cloudflare Access rejeitou o token de serviço (HTTP $status). Confira o Client ID, o Secret e a política Service Auth.';
  }

  @override
  String get ng_add_a_cloudflare_access_service_token_2 =>
      'Adicione abaixo um token de serviço do Cloudflare Access e teste novamente.';

  @override
  String get ng_a_client_certificate_is_needed =>
      'É necessário um certificado de cliente';

  @override
  String get ng_this_server_asks_for_a_client =>
      'Este servidor exige um certificado de cliente para se comunicar. Selecione abaixo o certificado que recebeu e teste novamente.';

  @override
  String get ng_this_dashboard_doesn_t_ask_for =>
      'Este painel não exige login.';

  @override
  String ng_use_the_dashboard_username_and_password(Object address) {
    return 'Use o usuário e a senha do painel configurados em $address ou entre pelo navegador.';
  }

  @override
  String ng_use_the_dashboard_username_and_password_2(Object address) {
    return 'Use o usuário e a senha do painel configurados em $address.';
  }

  @override
  String ng_sign_in_to_in_your_browser(Object address) {
    return 'Acesse $address pelo navegador usando a conta do painel.';
  }

  @override
  String ng_gateway(Object address) {
    return 'Gateway $address';
  }

  @override
  String get ng_profile => 'Perfil';

  @override
  String get ng_server_default => 'Padrão do servidor';

  @override
  String get ng_continue => 'Continuar';

  @override
  String get ng_username => 'Usuário';

  @override
  String get ng_signing_in => 'Entrando…';

  @override
  String get ng_waiting_for_the_browser => 'Aguardando o navegador…';

  @override
  String get ng_sign_in_with_browser => 'Entrar pelo navegador';

  @override
  String get ng_finish_signing_in_on_the_page =>
      'Conclua o login na página que foi aberta. O Hermes voltará automaticamente quando terminar.';

  @override
  String get ng_use_a_different_gateway => 'Usar outro gateway';

  @override
  String get ng_same_wi_fi_or_local_network => 'Mesma rede Wi-Fi ou rede local';

  @override
  String get ng_use_the_server_s_local_address =>
      'Use o endereço local e a porta do servidor, como 192.168.1.20:9119. Inicie o painel com --host 0.0.0.0 para que outros dispositivos possam acessá-lo.';

  @override
  String get ng_tailscale => 'Tailscale';

  @override
  String get ng_turn_on_tailscale_on_this_phone =>
      'Ative o Tailscale neste celular e use o endereço Tailscale do servidor, como 100.64.0.1:9119 ou o nome .ts.net. Funciona também fora de casa.';

  @override
  String get ng_use_your_https_address_when_the =>
      'Use seu endereço https:// quando o painel estiver atrás de um proxy com certificado. O proxy também precisa permitir atualizações de WebSocket em /api/ws.';

  @override
  String get ng_start_the_dashboard_on_the_server =>
      'Inicie o painel no servidor:';

  @override
  String get ng_enter_a_port_from_1_to => 'Digite uma porta entre 1 e 65535.';

  @override
  String get ng_looks_for_hermes_dashboards_on_port =>
      'Procura painéis Hermes na porta 9119 desta rede Wi-Fi e verifica os computadores que você já salvou.';

  @override
  String ng_looks_for_hermes_dashboards_on_ports(Object port) {
    return 'Procura painéis Hermes nas portas 9119 e $port desta rede Wi-Fi e verifica os computadores que você já salvou.';
  }

  @override
  String get ng_other_port_optional => 'Outra porta (opcional)';

  @override
  String get ng_no_dashboards_answered_start_one_with =>
      'Nenhum painel respondeu. Inicie um com hermes dashboard --host 0.0.0.0 ou digite o endereço.';

  @override
  String get ng_using_tailscale_or_a_vpn_those =>
      'Está usando Tailscale ou uma VPN? Não é possível buscar nessas redes. Digite o endereço 100.x do computador ou o nome .ts.net.';

  @override
  String get ng_search_again => 'Buscar novamente';

  @override
  String get ng_insights => 'Estatísticas';

  @override
  String get ng_couldn_t_load_insights =>
      'Não foi possível carregar as estatísticas';

  @override
  String get ng_sessions => 'Sessões';

  @override
  String get ng_tokens => 'Tokens';

  @override
  String get ng_est_cost => 'Custo estimado';

  @override
  String get ng_daily_tokens => 'Tokens por dia';

  @override
  String get ng_models => 'Modelos';

  @override
  String get ng_tools => 'Ferramentas';

  @override
  String get ng_hermes_is_waiting_for_you => 'Hermes está esperando por você.';

  @override
  String get ng_hermes_replied => 'Hermes respondeu';

  @override
  String get ng_the_turn_finished => 'A interação foi concluída.';

  @override
  String get ng_off => 'Desativado';

  @override
  String get ng_minimal => 'Mínimo';

  @override
  String get ng_low => 'Baixo';

  @override
  String get ng_medium => 'Médio';

  @override
  String get ng_high => 'Alto';

  @override
  String get ng_extra_high => 'Muito alto';

  @override
  String get ng_max => 'Máximo';

  @override
  String get ng_ultra => 'Ultra';

  @override
  String get ng_default => 'Padrão';

  @override
  String ng_couldn_t_switch_model(Object error) {
    return 'Não foi possível trocar de modelo: $error';
  }

  @override
  String get ng_model => 'Modelo';

  @override
  String get ng_thinking_2 => 'Pensando';

  @override
  String get ng_search_models => 'Buscar modelos';

  @override
  String get ng_no_models_match => 'Nenhum modelo corresponde a estes filtros.';

  @override
  String get privacy_policy => 'Política de privacidade';

  @override
  String get report_ai_output => 'Relatar resposta de IA';

  @override
  String ng_couldn_t_load_models(Object error) {
    return 'Não foi possível carregar os modelos: $error';
  }

  @override
  String get ng_no_providers_are_set_up_on =>
      'Ainda não há provedores configurados neste gateway.';

  @override
  String get ng_starred => 'Favoritos';

  @override
  String get ng_recent => 'Recentes';

  @override
  String get ng_more => 'Mais';

  @override
  String get ng_archived_chats => 'Conversas arquivadas';

  @override
  String get ng_projects => 'Projetos';

  @override
  String get ng_chats_grouped_by_project_and_workspace =>
      'Conversas agrupadas por projeto e espaço de trabalho';

  @override
  String get ng_agent => 'Agente';

  @override
  String get ng_memory => 'Memória';

  @override
  String get ng_what_hermes_remembers_about_you =>
      'O que Hermes lembra sobre você';

  @override
  String get ng_skills_library => 'Biblioteca de habilidades';

  @override
  String get ng_browse_and_read_installed_skills =>
      'Explore e leia as habilidades instaladas';

  @override
  String get ng_cron_editor => 'Editor de cron';

  @override
  String get ng_edit_schedules_prompts_and_delivery =>
      'Edite agendamentos, instruções e entregas';

  @override
  String get ng_config_file => 'Arquivo de configuração';

  @override
  String get ng_edit_config_yaml_on_the_gateway =>
      'Edite config.yaml no gateway';

  @override
  String get ng_models_and_providers => 'Modelos e provedores';

  @override
  String get ng_model_management => 'Gerenciamento de modelos';

  @override
  String get ng_default_fallback_and_auxiliary_models =>
      'Modelos padrão, alternativos e auxiliares';

  @override
  String get ng_provider_sign_in => 'Conectar-se ao provedor';

  @override
  String get ng_connect_provider_accounts_with_oauth =>
      'Conecte contas de provedores com OAuth';

  @override
  String get ng_nous_portal => 'Nous Portal';

  @override
  String get ng_subscription_credits_and_usage => 'Assinatura, créditos e uso';

  @override
  String get ng_interface => 'Interface';

  @override
  String get ng_switch_to_the_classic_interface =>
      'Mudar para a interface clássica';

  @override
  String get ng_turns_nextgen_off_you_can_turn =>
      'Desativa o NextGen. Você pode ativá-lo novamente em Configurações.';

  @override
  String get ng_restored => 'Restaurado';

  @override
  String get ng_archived => 'Arquivado';

  @override
  String get ng_couldn_t_load_archived_chats =>
      'Não foi possível carregar as conversas arquivadas';

  @override
  String get ng_nothing_archived => 'Nenhuma conversa arquivada';

  @override
  String get ng_restore => 'Restaurar';

  @override
  String get ng_saved_new_chats_use_it =>
      'Salvo. Novas conversas usarão esta opção.';

  @override
  String ng_couldn_t_save(Object error) {
    return 'Não foi possível salvar: $error';
  }

  @override
  String get ng_saving => 'Salvando…';

  @override
  String ng_today(Object time) {
    return 'Hoje $time';
  }

  @override
  String get ng_mon => 'Seg';

  @override
  String get ng_tue => 'Ter';

  @override
  String get ng_wed => 'Qua';

  @override
  String get ng_thu => 'Qui';

  @override
  String get ng_fri => 'Sex';

  @override
  String get ng_sat => 'Sáb';

  @override
  String get ng_sun => 'Dom';

  @override
  String get ng_scheduled => 'Agendados';

  @override
  String get ng_new_job => 'Novo agendamento';

  @override
  String get ng_couldn_t_load_scheduled_jobs =>
      'Não foi possível carregar os agendamentos';

  @override
  String get ng_nothing_scheduled => 'Nenhum agendamento';

  @override
  String get ng_ask_hermes_to_do_something_on =>
      'Peça ao Hermes para fazer algo em um horário programado ou adicione um agendamento aqui.';

  @override
  String get ng_active => 'Ativo';

  @override
  String get ng_paused => 'Pausado';

  @override
  String ng_next(Object when) {
    return 'Próximo $when';
  }

  @override
  String ng_last(Object when) {
    return 'Último $when';
  }

  @override
  String ng_last_2(Object when, Object result) {
    return 'Último $when · $result';
  }

  @override
  String ng_job(Object id) {
    return 'Agendamento $id';
  }

  @override
  String get ng_delete => 'Excluir';

  @override
  String get ng_delete_this_job => 'Excluir este agendamento?';

  @override
  String get ng_it_stops_running_past_runs_stay =>
      'Ele deixará de ser executado. As execuções anteriores continuarão nas suas conversas.';

  @override
  String ng_next_run(Object when) {
    return 'Próxima execução $when';
  }

  @override
  String ng_delivers_to(Object target) {
    return 'Envia para $target';
  }

  @override
  String get ng_run_now => 'Executar agora';

  @override
  String get ng_started => 'Iniciado';

  @override
  String get ng_pause => 'Pausar';

  @override
  String get ng_resume => 'Retomar';

  @override
  String get ng_resumed => 'Retomado';

  @override
  String get ng_prompt => 'Prompt';

  @override
  String get ng_runs => 'Execuções';

  @override
  String get ng_no_runs_yet => 'Nenhuma execução ainda.';

  @override
  String get ng_enter_a_schedule_and_a_prompt =>
      'Informe um agendamento e um prompt.';

  @override
  String get ng_name_optional => 'Nome (opcional)';

  @override
  String get ng_schedule => 'Agendamento';

  @override
  String get ng_every_1h_0_9_or_30m => 'every 1h, 0 9 * * *, or 30m';

  @override
  String get ng_create => 'Criar';

  @override
  String get ng_unpin => 'Desafixar';

  @override
  String get ng_pin => 'Fixar';

  @override
  String get ng_rename => 'Renomear';

  @override
  String get ng_archive => 'Arquivar';

  @override
  String get ng_delete_this_chat => 'Excluir esta conversa?';

  @override
  String get ng_it_is_removed_from_the_gateway =>
      'Ela será removida do gateway em todos os dispositivos.';

  @override
  String get ng_search_chats => 'Buscar conversas';

  @override
  String get ng_pinned => 'Fixadas';

  @override
  String get ng_no_chats_match => 'Nenhuma conversa encontrada.';

  @override
  String get ng_no_chats_yet => 'Nenhuma conversa ainda.';

  @override
  String get ng_nothing_is_running => 'Nada em execução.';

  @override
  String get ng_nothing_is_waiting_on_you => 'Nada aguardando você.';

  @override
  String get ng_settings => 'Configurações';

  @override
  String get ng_all => 'Todas';

  @override
  String ng_needs_you(Object count) {
    return 'Precisa de você · $count';
  }

  @override
  String get ng_needs_you_2 => 'Precisa de você';

  @override
  String get ng_gateways => 'Gateways';

  @override
  String ng_classic_connection(Object address) {
    return '$address · conexão clássica';
  }

  @override
  String get ng_gateway_2 => 'Gateway';

  @override
  String get ng_signed_in => 'Conectado';

  @override
  String get ng_classic_connection_2 => 'Conexão clássica';

  @override
  String get ng_in_the_browser => 'No navegador';

  @override
  String ng_in_the_browser_as(Object name) {
    return 'No navegador como $name';
  }

  @override
  String get ng_not_required => 'Não obrigatório';

  @override
  String get ng_test_connection => 'Testar conexão';

  @override
  String get ng_sign_in_again_2 => 'Fazer login novamente';

  @override
  String get ng_sign_out => 'Sair';

  @override
  String get ng_saved_gateways => 'Gateways salvos';

  @override
  String get ng_in_use => 'Em uso';

  @override
  String get ng_appearance => 'Aparência';

  @override
  String get ng_theme => 'Tema';

  @override
  String get ng_system => 'Sistema';

  @override
  String get ng_light => 'Claro';

  @override
  String get ng_dark => 'Escuro';

  @override
  String get ng_accent => 'Cor de destaque';

  @override
  String get ng_pure_black => 'Preto puro';

  @override
  String get ng_dark_theme_uses_true_black_oled =>
      'O tema escuro usa preto verdadeiro (OLED)';

  @override
  String get ng_glow => 'Brilho';

  @override
  String get ng_soft_accent_light_behind_each_screen =>
      'Luz suave na cor de destaque atrás de cada tela';

  @override
  String get ng_the_new_interface_turn_off_to =>
      'A nova interface. Desative para voltar à versão clássica; seus gateways e conversas são compartilhados.';

  @override
  String get ng_more_settings => 'Mais configurações';

  @override
  String get ng_voice_notifications_language_backups_and_the =>
      'Voz, notificações, idioma, backups e configuração do gateway';

  @override
  String get ng_licences => 'Licenças';

  @override
  String ng_sign_out_of(Object name) {
    return 'Sair de $name?';
  }

  @override
  String get ng_this_gateway_and_its_saved_sign =>
      'Este gateway e o login salvo serão removidos deste celular, nas duas interfaces. Suas conversas continuam no gateway.';

  @override
  String get ng_password_or_browser => 'Senha ou navegador';

  @override
  String get ng_unsupported => 'Não compatível';

  @override
  String get ng_background_task_finished => 'Tarefa em segundo plano concluída';

  @override
  String get ng_background_process_finished =>
      'Processo em segundo plano concluído';

  @override
  String get ng_system_message => 'Mensagem do sistema';

  @override
  String get ng_summary => 'Resumo';

  @override
  String get classic_interface_only => 'Somente interface clássica';

  @override
  String get classic_only_settings_hint =>
      'As seções marcadas como Somente interface clássica alteram a aparência e o chat clássicos, não o NextGen. O NextGen tem suas próprias opções de aparência em Configurações.';

  @override
  String get attachment_preview_too_large =>
      'Grande demais para visualizar aqui. Salvar ou Compartilhar faz o download para o seu celular (até 1 GB).';

  @override
  String get attachment_over_phone_limit =>
      'Este arquivo tem mais de 1 GB e excede o limite de download. Abra o painel para baixá-lo.';

  @override
  String attachment_downloading_percent(int percent) {
    return 'Baixando… $percent%';
  }

  @override
  String attachment_downloading_mb(int megabytes) {
    return 'Baixando… $megabytes MB';
  }

  @override
  String ng_attachment_too_large_for_gateway(String name) {
    return '$name é maior que 12 MB, o limite máximo deste gateway. Atualize o Hermes para enviar arquivos de até 100 MB.';
  }

  @override
  String ng_couldn_t_upload(String name) {
    return 'Não foi possível enviar $name.';
  }

  @override
  String ng_uploading_percent(int percent) {
    return 'Enviando… $percent%';
  }

  @override
  String get ng_show_tasks => 'Mostrar tarefas';

  @override
  String get ng_hide_tasks => 'Ocultar tarefas';

  @override
  String get ng_goal => 'Objetivo';

  @override
  String get ng_loop => 'Ciclo';

  @override
  String get ng_heartbeat => 'Pulso';

  @override
  String get ng_goal_working => 'Em andamento';

  @override
  String get ng_goal_waiting => 'Aguardando';

  @override
  String get ng_goal_blocked => 'Bloqueado';

  @override
  String get ng_goal_done => 'Concluído';

  @override
  String ng_goal_turns_of(int used, int max) {
    return '$used de $max turnos';
  }

  @override
  String ng_goal_turn(int used) {
    return 'turno $used';
  }

  @override
  String get ng_loop_held => 'Aguardando o objetivo';

  @override
  String get ng_loop_finished => 'Concluído';

  @override
  String get ng_loop_running => 'Em execução';

  @override
  String ng_loop_runs_of(int fired, int times) {
    return '$fired de $times execuções';
  }

  @override
  String ng_loop_runs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count execuções',
      one: '1 execução',
    );
    return '$_temp0';
  }

  @override
  String ng_loop_next(String time) {
    return 'próximo $time';
  }

  @override
  String get ng_loop_due_now => 'para agora';

  @override
  String ng_every_seconds(int seconds) {
    return 'a cada $seconds s';
  }

  @override
  String ng_every_minutes(int minutes) {
    return 'a cada $minutes min';
  }

  @override
  String ng_every_hours(int hours) {
    return 'a cada $hours h';
  }

  @override
  String ng_every_hours_minutes(int hours, int minutes) {
    return 'a cada $hours h $minutes min';
  }

  @override
  String ng_heartbeat_fired(int count) {
    return '$count disparos';
  }

  @override
  String ng_heartbeat_last_fired(String time) {
    return 'Último disparo às $time';
  }

  @override
  String ng_wait_until(String time) {
    return 'Aguardando até $time';
  }

  @override
  String get ng_wait_resume => 'Aguardando para retomar';

  @override
  String get ng_wait_other_chat => 'Aguardando em outro chat';

  @override
  String ng_wait_process(String pid) {
    return 'Aguardando o processo $pid';
  }

  @override
  String get ng_control_open => 'Abrir objetivo e automação';

  @override
  String get ng_control_title => 'Objetivo e automação';

  @override
  String get ng_control_subtitle =>
      'O que este chat está tentando alcançar e o que é executado automaticamente.';

  @override
  String get ng_contract_outcome => 'Resultado';

  @override
  String get ng_contract_verification => 'Verificação';

  @override
  String get ng_contract_constraints => 'Restrições';

  @override
  String get ng_contract_boundaries => 'Limites';

  @override
  String get ng_contract_stop_when => 'Parar quando';

  @override
  String get ng_subgoals => 'Subobjetivos';

  @override
  String get ng_subgoal_add_placeholder => 'Adicionar um subobjetivo';

  @override
  String get ng_add => 'Adicionar';

  @override
  String get ng_subgoal_remove => 'Remover subobjetivo';

  @override
  String get ng_goal_checks => 'Verificações';

  @override
  String get ng_gate_not_run => 'Ainda não executado';

  @override
  String ng_gate_attempts(int attempts, int tries) {
    return '$attempts de $tries tentativas';
  }

  @override
  String ng_gate_exit(int code) {
    return 'código de saída $code';
  }

  @override
  String get ng_resume_now => 'Retomar agora';

  @override
  String get ng_goal_clear => 'Limpar objetivo';

  @override
  String get ng_goal_clear_title => 'Limpar este objetivo?';

  @override
  String get ng_goal_clear_message =>
      'O agente deixará de trabalhar nele. Os subobjetivos e as verificações também serão removidos.';

  @override
  String get ng_subgoal_remove_title => 'Remover este subobjetivo?';

  @override
  String ng_subgoal_remove_message(String text) {
    return '\"$text\" deixará de fazer parte do objetivo.';
  }

  @override
  String get ng_subgoals_clear_title => 'Limpar todos os subobjetivos?';

  @override
  String get ng_subgoals_clear_message =>
      'O objetivo manterá o título, mas ficará sem subobjetivos.';

  @override
  String get ng_clear_all => 'Limpar tudo';

  @override
  String get ng_clear => 'Limpar';

  @override
  String get ng_dismiss => 'Dispensar';

  @override
  String get ng_loop_stop_title => 'Parar este ciclo?';

  @override
  String get ng_heartbeat_clear_title => 'Limpar este pulso?';

  @override
  String get ng_wont_fire_again => 'Ele não será acionado novamente.';

  @override
  String get ng_loop_self_paced => 'Ritmo próprio';

  @override
  String ng_loop_until(String condition) {
    return 'Até: $condition';
  }

  @override
  String get ng_loop_waits_for_goal =>
      'Aguarda enquanto o objetivo está em andamento.';

  @override
  String get ng_loop_awaiting_reply => 'Aguardando a resposta do agente.';

  @override
  String ng_loop_stopped_reason(String reason) {
    return 'Parado: $reason';
  }

  @override
  String get ng_hide_subagents => 'Ocultar subagentes';

  @override
  String get ng_show_subagents => 'Mostrar subagentes';

  @override
  String get ng_subagent => 'Subagente';

  @override
  String get ng_subagent_queued => 'Na fila';

  @override
  String get ng_subagent_starting => 'Iniciando…';

  @override
  String get ng_subagent_running => 'Em execução';

  @override
  String get ng_subagent_done => 'Concluído';

  @override
  String get ng_subagent_failed => 'Falhou';

  @override
  String get ng_subagent_stopped => 'Interrompido';

  @override
  String get ng_subagent_stop => 'Parar subagente';

  @override
  String ng_subagent_tools(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ferramentas',
      one: '1 ferramenta',
    );
    return '$_temp0';
  }

  @override
  String get ng_mark_as_read => 'Marcar como lida';

  @override
  String get ng_mark_as_unread => 'Marcar como não lida';

  @override
  String ng_chats_unread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Conversas, $count não lidas',
      one: 'Conversas, 1 não lida',
    );
    return '$_temp0';
  }

  @override
  String get ng_unread_finished => 'Concluído, resposta não lida';

  @override
  String get ng_unread_updates => 'Em execução, atualizações não lidas';

  @override
  String get ng_notifications => 'Notificações';

  @override
  String get ng_notifications_hint =>
      'Respostas e solicitações enquanto o Ares está em segundo plano';

  @override
  String get ng_notify_replies => 'Respostas';

  @override
  String get ng_notify_replies_hint =>
      'Quando uma resposta termina ou falha no chat aberto';

  @override
  String get ng_notify_requests => 'Aprovações e perguntas';

  @override
  String get ng_notify_requests_hint =>
      'Um aviso quando o agente estiver aguardando você, com as opções Permitir uma vez e Negar';

  @override
  String get ng_keep_running => 'Manter conexão enquanto uma resposta é gerada';

  @override
  String get ng_keep_running_hint =>
      'Mantém a conexão ativa em segundo plano até a resposta terminar, com uma notificação silenciosa';

  @override
  String get ng_battery_settings => 'Otimização da bateria';

  @override
  String get ng_battery_settings_hint =>
      'Permite que o Ares funcione em segundo plano para que as notificações cheguem no horário certo';

  @override
  String get ng_send_test_notification => 'Enviar notificação de teste';

  @override
  String get ng_test_notification_title =>
      'As notificações do Ares estão funcionando';

  @override
  String get ng_test_notification_body =>
      'As respostas e solicitações aparecerão assim.';

  @override
  String get ng_test_notification_sent => 'Notificação de teste enviada';

  @override
  String get ng_notifications_blocked =>
      'As notificações estão bloqueadas. Permita-as nas configurações do Android.';

  @override
  String get ng_notifications_off_hint =>
      'As notificações estão desativadas, então nada será exibido enquanto o Ares estiver em segundo plano.';

  @override
  String get ng_insights_building =>
      'Gerando o relatório. Um período longo pode levar até um minuto na primeira vez.';

  @override
  String get ng_insights_timed_out =>
      'O gateway demorou demais para gerar este relatório. Tente novamente ou selecione um período mais curto.';

  @override
  String get ng_dock_goal_active => 'Meta ativa';

  @override
  String get ng_dock_goal_paused => 'Meta pausada';

  @override
  String get ng_dock_goal_waiting => 'Meta em espera';

  @override
  String get ng_dock_goal_blocked => 'Meta bloqueada';

  @override
  String get ng_dock_goal_done => 'Meta concluída';

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
    return '$count concluídos';
  }

  @override
  String ng_dock_tasks(int done, int total) {
    return 'Tarefas $done/$total';
  }

  @override
  String ng_dock_previous_tasks(int done, int total) {
    return 'Plano anterior $done/$total';
  }

  @override
  String get ng_dock_manage => 'Gerenciar';

  @override
  String get ng_recent_notifications => 'Notificações recentes';

  @override
  String get ng_recent_notifications_hint =>
      'O que o Ares tentou publicar e se o Android exibiu a notificação';

  @override
  String get ng_recent_notifications_empty =>
      'Ainda nada. As tentativas aparecem aqui quando uma resposta, pergunta ou falha geraria uma notificação.';

  @override
  String get ng_notify_permission_granted => 'Permissão concedida';

  @override
  String get ng_notify_permission_denied => 'Permissão negada';

  @override
  String get ng_notify_master_on => 'Notificações ativadas';

  @override
  String get ng_notify_master_off => 'Notificações desativadas';

  @override
  String get ng_models_default => 'Modelo padrão';

  @override
  String get ng_models_change => 'Alterar';

  @override
  String get ng_models_custom_endpoint =>
      'Usa um endpoint personalizado. Altere-o no gateway.';

  @override
  String get ng_models_context_window => 'Janela de contexto';

  @override
  String ng_models_token_count(String count) {
    return '$count tokens';
  }

  @override
  String ng_models_context_override(String count) {
    return 'Definido no gateway. Detectado automaticamente: $count tokens.';
  }

  @override
  String get ng_models_max_output => 'Saída máxima';

  @override
  String get ng_models_input_price => 'Preço de entrada';

  @override
  String get ng_models_output_price => 'Preço de saída';

  @override
  String get ng_models_cache_price => 'Preço de entrada em cache';

  @override
  String ng_models_per_million(String price) {
    return '$price por 1 M de tokens';
  }

  @override
  String ng_models_price_pair(String input, String output) {
    return '$input entrada · $output saída por 1 M de tokens';
  }

  @override
  String get ng_models_free => 'Gratuito';

  @override
  String get ng_models_vision => 'Visão';

  @override
  String get ng_models_reasoning => 'Raciocínio';

  @override
  String get ng_models_fast => 'Modo rápido';

  @override
  String get ng_models_in_use => 'Em uso';

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
  String get ng_models_rate_limited => 'Limite atingido';

  @override
  String get ng_models_plan_locked => 'Não incluído no seu plano';

  @override
  String get ng_models_unsaved => 'Alterações não salvas';

  @override
  String get ng_models_discard => 'Descartar';

  @override
  String get ng_models_aux_hint =>
      'As tarefas auxiliares usam o modelo padrão, a menos que você atribua um modelo próprio.';

  @override
  String get ng_models_uses_default => 'Usa o modelo padrão';

  @override
  String get ng_models_thinking_level => 'Nível de raciocínio';

  @override
  String get ng_models_providers => 'Provedores';

  @override
  String get ng_models_saved => 'Salvo';

  @override
  String get ng_aux_vision => 'Visão';

  @override
  String get ng_aux_vision_hint => 'Lê imagens e capturas de tela';

  @override
  String get ng_aux_compression => 'Compressão';

  @override
  String get ng_aux_compression_hint =>
      'Resume uma conversa longa para caber na janela de contexto';

  @override
  String get ng_aux_approval => 'Aprovação';

  @override
  String get ng_aux_approval_hint =>
      'Decide se um comando pode ser executado sem perguntar';

  @override
  String get ng_aux_mcp => 'MCP';

  @override
  String get ng_aux_mcp_hint => 'Escolhe quais ferramentas MCP usar';

  @override
  String get ng_aux_title_generation => 'Títulos das conversas';

  @override
  String get ng_aux_title_generation_hint => 'Dá nome às novas conversas';

  @override
  String get ng_aux_review => 'Revisão';

  @override
  String get ng_aux_review_hint =>
      'Revisa o trabalho quando você executa /review';

  @override
  String get ng_aux_voice_chat => 'Chat por voz';

  @override
  String get ng_aux_voice_chat_hint => 'Responde no modo de voz';

  @override
  String get ng_aux_triage_specifier => 'Triagem';

  @override
  String get ng_aux_triage_specifier_hint =>
      'Transforma um cartão Kanban de uma linha em uma especificação';

  @override
  String get ng_aux_kanban_decomposer => 'Decomposição do Kanban';

  @override
  String get ng_aux_kanban_decomposer_hint =>
      'Divide um cartão Kanban em tarefas menores';

  @override
  String get ng_aux_profile_describer => 'Descrições de perfil';

  @override
  String get ng_aux_profile_describer_hint =>
      'Escreve a descrição curta de cada perfil';

  @override
  String get ng_aux_curator => 'Curador';

  @override
  String get ng_aux_curator_hint => 'Analisa como as habilidades são usadas';

  @override
  String get appearance_save_failed =>
      'Não foi possível salvar esta alteração.';

  @override
  String get appearance_keep_which_theme => 'Qual tema manter?';

  @override
  String get appearance_tour_back => 'Voltar';

  @override
  String get appearance_tour_finish => 'Concluir';

  @override
  String get appearance_tour_next => 'Avançar';

  @override
  String get appearance_tour_close => 'Fechar apresentação';

  @override
  String get appearance_dismiss_tip => 'Dispensar dica';

  @override
  String get appearance_search_settings => 'Buscar configurações';

  @override
  String get appearance_search_show => 'Mostrar';

  @override
  String get appearance_no_matching_setting =>
      'Nenhuma configuração corresponde à busca.';

  @override
  String get appearance_replay_tour => 'Rever apresentação';

  @override
  String get appearance_show_tips_again => 'Mostrar dicas novamente';

  @override
  String get appearance_window_translucency_unavailable =>
      'A translucidez da janela não está disponível neste host. O Linux não oferece esse recurso, e os executores Apple e Windows desenham uma visualização Flutter opaca.';

  @override
  String get appearance_imported_themes => 'Temas importados';

  @override
  String get appearance_import_theme_file => 'Importar arquivo de tema';

  @override
  String get appearance_remove_theme => 'Remover tema';

  @override
  String get appearance_chat_font => 'Fonte do chat';

  @override
  String get appearance_terminal_font => 'Fonte do terminal';

  @override
  String get appearance_font_platform => 'Plataforma';

  @override
  String get appearance_automatic => 'Automático';

  @override
  String get appearance_force_left_to_right =>
      'Forçar da esquerda para a direita';

  @override
  String get appearance_force_right_to_left =>
      'Forçar da direita para a esquerda';

  @override
  String get appearance_user_bubble_opacity => 'Opacidade do balão do usuário';

  @override
  String get appearance_inline_embeds => 'Conteúdo incorporado';

  @override
  String get appearance_inline_embeds_hint =>
      'As prévias avançadas são carregadas de sites de terceiros (YouTube, X, …). Perguntar mostra um espaço reservado até você permitir cada uma; Sempre as carrega automaticamente; Desativado mantém links simples.';

  @override
  String get appearance_embeds_ask => 'Perguntar';

  @override
  String get appearance_embeds_always => 'Sempre';

  @override
  String get appearance_embeds_off => 'Desativado';

  @override
  String appearance_embeds_reset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Redefinir $count serviços permitidos',
      one: 'Redefinir 1 serviço permitido',
    );
    return '$_temp0';
  }

  @override
  String get appearance_embed_load => 'Carregar';

  @override
  String appearance_embed_always_allow(String service) {
    return 'Sempre permitir $service';
  }

  @override
  String get appearance_embed_loading => 'Carregando prévia…';

  @override
  String appearance_embed_image_failed(String host) {
    return 'Não foi possível carregar a imagem de $host. Toque para abri-la.';
  }

  @override
  String get appearance_embed_preview_unavailable => 'Prévia indisponível';

  @override
  String get appearance_emoji_reactions => 'Reações com emojis';

  @override
  String get appearance_celebration_hearts => 'Corações de comemoração';

  @override
  String get appearance_celebration_hearts_hint =>
      'Um coração é animado quando uma resposta chega enquanto você está ausente.';

  @override
  String get appearance_pop_out_companion => 'Companheiro em janela separada';

  @override
  String get appearance_mosskip => 'Mosskip';

  @override
  String get appearance_emberbun => 'Emberbun';

  @override
  String get appearance_tideling => 'Tideling';

  @override
  String get appearance_my_hatchling => 'Meu filhote';

  @override
  String get appearance_at_rest => 'Em repouso';

  @override
  String get appearance_working => 'Trabalhando';

  @override
  String get appearance_thinking => 'Pensando';

  @override
  String get appearance_waiting_for_you => 'Esperando por você';

  @override
  String get appearance_reply_ready => 'Resposta pronta';

  @override
  String get appearance_turn_failed => 'Falha no turno';

  @override
  String get appearance_small => 'Pequeno';

  @override
  String get appearance_medium => 'Médio';

  @override
  String get appearance_large => 'Grande';

  @override
  String get appearance_hello => 'Olá!';

  @override
  String get appearance_unread_reply => 'Resposta não lida';

  @override
  String get appearance_compose => 'Escrever';

  @override
  String get appearance_say_hello => 'Dizer olá';

  @override
  String get appearance_pet_image_failed =>
      'Não foi possível abrir essa imagem. Escolha um PNG ou JPEG menor.';

  @override
  String get appearance_pet_companion => 'Mascote companheiro';

  @override
  String get appearance_pet_companion_hint =>
      'Mostre um companheiro enquanto você conversa.';

  @override
  String get appearance_adopt_a_companion => 'Adotar um companheiro';

  @override
  String get appearance_roam_when_idle => 'Passear quando ocioso';

  @override
  String get appearance_pet_size => 'Tamanho do mascote';

  @override
  String get appearance_hatch_from_a_local_picture =>
      'Criar a partir de uma imagem local';

  @override
  String get appearance_pet_image_limits =>
      'Escolha um PNG ou JPEG (até 4 MiB, 4096 px por lado e 8 MP). Veja a prévia primeiro. A criação salva um retrato de 24 × 24 pixels e substitui seu filhote anterior.';

  @override
  String get appearance_choose_picture => 'Escolher imagem';

  @override
  String get appearance_hatchling_preview => 'Prévia do filhote';

  @override
  String get appearance_hatch_and_adopt => 'Criar e adotar';

  @override
  String get appearance_discard_draft => 'Descartar rascunho';

  @override
  String get appearance_forget_saved_hatchling => 'Esquecer filhote salvo';

  @override
  String get appearance_radio => 'Rádio';

  @override
  String appearance_radio_hint(String stations) {
    return 'As transmissões vêm diretamente de $stations e só começam quando você pressiona Reproduzir. A busca de estações fica neste dispositivo.';
  }

  @override
  String get appearance_radio_save_failed =>
      'Não foi possível salvar as configurações do rádio.';

  @override
  String get appearance_choose_a_station => 'Escolher uma estação';

  @override
  String get appearance_pause_radio => 'Pausar rádio';

  @override
  String get appearance_play_radio => 'Reproduzir rádio';

  @override
  String get appearance_next_station => 'Próxima estação';

  @override
  String get appearance_radio_trace_semantics =>
      'Atividade da transmissão. Os níveis de áudio estão indisponíveis, então esta linha fica plana.';

  @override
  String get appearance_radio_is_off => 'O rádio está desligado';

  @override
  String get appearance_paused => 'Pausado';

  @override
  String get appearance_connecting => 'Conectando…';

  @override
  String get appearance_live => 'Ao vivo';

  @override
  String get appearance_stream_unavailable => 'Transmissão indisponível';

  @override
  String appearance_now_playing(String credit) {
    return 'Tocando agora: $credit';
  }

  @override
  String get appearance_audio_only_waveform_unavailable =>
      'Somente áudio · forma de onda indisponível';

  @override
  String get appearance_volume => 'Volume';

  @override
  String get appearance_search_presets => 'Buscar estações predefinidas';

  @override
  String get appearance_no_stations_found => 'Nenhuma estação encontrada';

  @override
  String appearance_unpin_station(String station) {
    return 'Desafixar estação: $station';
  }

  @override
  String appearance_pin_station(String station) {
    return 'Fixar estação: $station';
  }

  @override
  String get appearance_radio_picker_metadata_notice =>
      'Enquanto este seletor estiver aberto, as estações em reprodução podem compartilhar detalhes das faixas diretamente da emissora.';

  @override
  String get appearance_message_from_your_companion =>
      'Mensagem do seu companheiro';

  @override
  String get appearance_send_to_the_open_chat => 'Enviar para o chat aberto';

  @override
  String get appearance_tour_theme_body =>
      'Importe um tema de cores do VS Code de um arquivo neste dispositivo e escolha qual variante manter.';

  @override
  String get appearance_tour_fonts_title => 'Fontes de leitura';

  @override
  String get appearance_tour_fonts_body =>
      'O texto do chat e o código do terminal usam fontes separadas incluídas no Ares.';

  @override
  String get appearance_tour_direction_title => 'Direção da transcrição';

  @override
  String get appearance_tour_direction_body =>
      'Deixe no automático ou force a transcrição da esquerda para a direita ou da direita para a esquerda.';

  @override
  String get appearance_tour_pet_title => 'Companheiro';

  @override
  String get appearance_tour_pet_body =>
      'O companheiro fica desativado até você adotar um. A janela separada adiciona um pequeno editor.';

  @override
  String get appearance_tour_radio_body =>
      'O rádio fica desligado até você ativá-lo. É Reproduzir que abre uma transmissão.';

  @override
  String get appearance_tip_theme =>
      'Os temas importados substituem a paleta integrada até você limpar a seleção. Apenas as cores são mantidas.';

  @override
  String get appearance_tip_pet =>
      'O companheiro armazena um pequeno retrato neste dispositivo. Ele não envia a imagem usada para criar o filhote.';

  @override
  String get appearance_theme_import_failed =>
      'Não foi possível importar esse tema. Escolha um tema de cores do VS Code salvo como arquivo .vsix, .json ou .jsonc.';

  @override
  String get render_widget_file_truncated =>
      'Só o início deste arquivo foi lido, então o widget pode estar incompleto.';

  @override
  String get setup_beat_title => 'Configuração';

  @override
  String setup_beat_use_name(String name) {
    return 'Usar $name';
  }

  @override
  String get setup_beat_name_hint => 'Como o Hermes deve chamar você?';

  @override
  String get setup_beat_on_computer =>
      'Esta etapa é feita no Hermes, no computador onde ele roda. Continuar mantém o que já está configurado lá.';

  @override
  String get setup_beat_not_waiting =>
      'Este cartão de configuração não está mais esperando resposta.';

  @override
  String get catalog_kind_plugin => 'Plugin';

  @override
  String get catalog_kind_skill => 'Habilidade';

  @override
  String get catalog_tier_official => 'Oficial';

  @override
  String get catalog_tier_verified => 'Verificado';

  @override
  String get catalog_tier_community => 'Comunidade';

  @override
  String get catalog_install => 'Instalar';

  @override
  String get catalog_waiting => 'Aguardando sua escolha';

  @override
  String get catalog_installed => 'Instalado';

  @override
  String get catalog_installed_off => 'Instalado, não ativado';

  @override
  String get catalog_skipped => 'Ignorado';

  @override
  String get catalog_not_installed => 'Não instalado';

  @override
  String catalog_target_profile(String profile) {
    return 'É instalado no perfil $profile';
  }

  @override
  String catalog_source(String repo, String sha) {
    return '$repo em $sha';
  }

  @override
  String catalog_scan(String status, String summary) {
    return 'Análise de segurança: $status. $summary';
  }

  @override
  String catalog_requires_hermes(String range) {
    return 'Requer Hermes $range';
  }

  @override
  String catalog_skill_ready(String name) {
    return 'A habilidade $name está pronta';
  }

  @override
  String catalog_missing_env(String names) {
    return 'Ainda precisa de: $names';
  }

  @override
  String catalog_server_error(String name, String error) {
    return '$name não conectou: $error';
  }

  @override
  String get catalog_send_failed =>
      'Sua escolha não foi enviada. Tente novamente.';

  @override
  String get attachment_video_speed => 'Velocidade de reprodução';

  @override
  String get catalog_installing => 'Instalando…';

  @override
  String get catalog_phase_downloading => 'Baixando…';

  @override
  String get catalog_phase_python_packages => 'Instalando pacotes Python…';

  @override
  String get catalog_phase_loading_tools => 'Carregando as ferramentas…';

  @override
  String get setup_beat_send_failed =>
      'Sua resposta não foi enviada. Tente novamente.';

  @override
  String catalog_tool_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ferramentas',
      one: '1 ferramenta',
    );
    return '$_temp0';
  }

  @override
  String get render_svg_not_drawn => 'Este SVG não foi desenhado.';

  @override
  String get render_notes_directive => 'Diretiva de notas';

  @override
  String get render_maths_source => 'Fonte da fórmula';

  @override
  String get render_inline_maths_source => 'Fonte da fórmula inline';

  @override
  String get render_sequence_outline => 'Esquema da sequência';

  @override
  String get render_diagram_outline => 'Esquema do diagrama';

  @override
  String render_revision_of(int index, int count) {
    return 'Revisão $index de $count';
  }

  @override
  String get render_previous_revision => 'Revisão anterior';

  @override
  String get render_next_revision => 'Próxima revisão';

  @override
  String get render_show_rendered => 'Renderizado';

  @override
  String get render_show_source => 'Código-fonte';

  @override
  String render_copied_file(String name) {
    return '$name copiado';
  }

  @override
  String render_copy_file(String name) {
    return 'Copiar $name';
  }

  @override
  String get render_artifact_too_long =>
      'Este artefato é longo demais para ser exibido aqui como página.';

  @override
  String get render_active_content_removed =>
      'Os scripts, frames e endereços externos foram removidos.';

  @override
  String render_widget_file(String file) {
    return 'Arquivo de widget $file';
  }

  @override
  String get render_widget_runs_as_text =>
      'É executado como texto neste chat. Scripts e frames externos são removidos.';

  @override
  String get render_load_widget => 'Carregar widget';

  @override
  String get render_not_html_widget => 'Este arquivo não é um widget HTML.';

  @override
  String get render_widget_sent => 'Enviado para este chat';

  @override
  String get render_widget_not_sent => 'Não enviado para este chat';

  @override
  String get render_widget_throttled =>
      'Aguarde um momento antes de enviar novamente';

  @override
  String get render_widget_too_long =>
      'Esta solicitação é longa demais para ser enviada';

  @override
  String get render_widget_no_gesture =>
      'Toque em um controle do widget para enviar';

  @override
  String get render_widget_invalid =>
      'Não foi possível enviar esta solicitação';

  @override
  String get render_inspected_image => 'Imagem inspecionada';

  @override
  String get render_contributions => 'Contribuições';

  @override
  String get render_contributions_intro =>
      'Somente contribuições compiladas no Ares podem acrescentar algo a uma resposta. O texto do chat não pode registrar nenhuma, e uma permissão vale apenas para esta conexão.';

  @override
  String render_grant_plugin(String name) {
    return 'Permitir $name';
  }

  @override
  String render_revoke_plugin(String name) {
    return 'Revogar $name';
  }

  @override
  String render_plugin_slots(String directive) {
    return 'cartões de resposta para ::$directive';
  }

  @override
  String get render_plugin_notes => 'Notas';

  @override
  String get catalog_scan_passed => 'aprovado';

  @override
  String get catalog_scan_warnings => 'encontrou avisos';

  @override
  String get catalog_scan_failed => 'falhou';

  @override
  String get deployment_token_label => 'Token de implantação (opcional)';

  @override
  String get deployment_token_helper =>
      'Para tokens de sessão do Hermes Dashboard enviados como X-Hermes-Session-Token. Não é salvo em texto simples nas preferências.';

  @override
  String get deployment_token_hint => 'Token de sessão do painel';

  @override
  String get custom_headers_label => 'Cabeçalhos personalizados (opcional)';

  @override
  String get custom_headers_helper =>
      'Um por linha, ex.: X-Custom: valor. Cabeçalhos proibidos são rejeitados.';

  @override
  String get custom_headers_hint => 'ex.: X-Custom-Header: valor';

  @override
  String get desktop_tray_open => 'Abrir o Ares';

  @override
  String get desktop_tray_new_chat => 'Novo chat';

  @override
  String get desktop_tray_quick_entry => 'Entrada rápida…';

  @override
  String get desktop_tray_pause_notifications => 'Pausar notificações';

  @override
  String get desktop_tray_quit => 'Sair do Ares';

  @override
  String get desktop_integration_title => 'Integração com a área de trabalho';

  @override
  String get desktop_tray_setting =>
      'Mostrar o Ares na bandeja do sistema ou na barra de menus';

  @override
  String get desktop_tray_setting_help =>
      'No ícone, abra o Ares, inicie um chat, abra a entrada rápida, pause as notificações ou saia.';

  @override
  String get desktop_close_to_tray_setting =>
      'Continuar em execução na bandeja ao fechar a janela';

  @override
  String get desktop_tray_unsupported =>
      'Esta área de trabalho não tem uma bandeja do sistema que o Ares possa usar.';

  @override
  String get quick_entry_title => 'Entrada rápida';

  @override
  String get quick_entry_hint => 'Digite um prompt para o Ares…';

  @override
  String get quick_entry_submit => 'Colocar no editor';

  @override
  String get quick_entry_never_sends =>
      'Enter coloca o texto no editor do chat. Nada é enviado até você clicar em Enviar.';

  @override
  String get quick_entry_unavailable =>
      'Não foi possível abrir a entrada rápida. Tente novamente.';

  @override
  String get desktop_hotkey_setting => 'Atalho da entrada rápida';

  @override
  String desktop_hotkey_help(String shortcut) {
    return 'Pressione $shortcut em qualquer lugar para abrir a entrada rápida.';
  }

  @override
  String desktop_hotkey_conflict(String shortcut) {
    return 'Outro app já usa $shortcut. Escolha um atalho diferente.';
  }

  @override
  String get desktop_hotkey_unsupported =>
      'Esta área de trabalho não permite que apps registrem um atalho global (por exemplo, no Wayland).';

  @override
  String get desktop_hotkey_no_modifier => 'Inclua Cmd, Ctrl ou Alt.';

  @override
  String get desktop_hotkey_super_key =>
      'A tecla Windows ou Super é reservada ao sistema.';

  @override
  String get desktop_hotkey_reserved => 'O sistema já usa este atalho.';

  @override
  String desktop_hotkey_in_app(String action) {
    return 'O Ares já usa este atalho para $action.';
  }

  @override
  String get desktop_hotkey_change => 'Alterar';

  @override
  String get desktop_hotkey_reset => 'Usar padrão';

  @override
  String get capture_screen_action => 'Capturar tela';

  @override
  String get capture_screen_help =>
      'Adiciona uma captura de tela à mensagem como rascunho. Nada é enviado até você clicar em Enviar.';

  @override
  String get capture_screen_unavailable =>
      'A captura de tela não está disponível nesta área de trabalho.';

  @override
  String get capture_screen_failed =>
      'Não foi possível capturar a tela. Tente novamente.';

  @override
  String get capture_permission_title => 'Permitir gravação de tela';

  @override
  String get capture_permission_body =>
      'Para capturar uma janela, o Ares precisa da permissão de gravação de tela. Ative o Ares em Ajustes do Sistema > Privacidade e Segurança > Gravação de Tela e tente novamente.';

  @override
  String get capture_open_settings => 'Abrir Ajustes do Sistema';

  @override
  String get keep_awake_title => 'Manter o computador ativo';

  @override
  String get keep_awake_title_mobile => 'Manter a tela ligada';

  @override
  String get keep_awake_mode_off => 'Desligado';

  @override
  String get keep_awake_mode_while_working => 'Durante o trabalho';

  @override
  String get keep_awake_mode_always => 'Sempre';

  @override
  String get keep_awake_off_help =>
      'Nunca impedir a suspensão do sistema (padrão).';

  @override
  String get keep_awake_while_working_help =>
      'Impedir a suspensão por inatividade só enquanto um turno do agente estiver em andamento.';

  @override
  String get keep_awake_always_help =>
      'Impedir a suspensão por inatividade enquanto o Ares estiver aberto neste dispositivo.';

  @override
  String get keep_awake_off_help_mobile =>
      'Deixar a tela desligar normalmente (padrão).';

  @override
  String get keep_awake_while_working_help_mobile =>
      'Manter a tela ligada enquanto um turno do agente estiver em andamento e o Ares estiver aberto.';

  @override
  String get keep_awake_always_help_mobile =>
      'Manter a tela ligada enquanto o Ares estiver aberto.';

  @override
  String get ng_token_gateway_has_no_sign_in =>
      'Este gateway não tem login, então não consegue verificar um token de implantação. Ative a autenticação do painel no host (ou atualize o Hermes) e tente novamente.';

  @override
  String get palette_open => 'Paleta de comandos do app';

  @override
  String get palette_no_matches => 'Nenhuma ação correspondente';

  @override
  String get palette_filter_hint => 'Digite para filtrar ações…';

  @override
  String get palette_keys_move => '↑↓ para mover';

  @override
  String get palette_keys_run => 'Enter para executar';

  @override
  String get palette_keys_close => 'Esc para fechar';

  @override
  String get palette_search_sessions => 'Pesquisar sessões';

  @override
  String get palette_scheduled_crons => 'Agendadas / Crons';

  @override
  String get palette_capabilities_skills => 'Recursos e habilidades';

  @override
  String get palette_insights_usage => 'Insights e uso';

  @override
  String get palette_more_projects => 'Mais e projetos';

  @override
  String get deeplink_chat_not_found =>
      'Conversa não encontrada na lista. Ela pode ainda não ter sido carregada.';

  @override
  String get keyboard_shortcuts_title => 'Atalhos de teclado';

  @override
  String get shortcuts_reset_all => 'Redefinir tudo';

  @override
  String get shortcuts_reset_to_default => 'Restaurar padrão';

  @override
  String get shortcut_action_command_palette => 'Paleta de comandos';

  @override
  String get shortcut_action_new_chat => 'Nova conversa';

  @override
  String get shortcut_action_search => 'Pesquisar';

  @override
  String get shortcut_action_settings => 'Configurações';

  @override
  String shortcut_action_go_to_tab(int number) {
    return 'Ir para a aba $number';
  }

  @override
  String shortcuts_conflict(String first, String second, String chord) {
    return 'Conflito: \"$first\" e \"$second\" usam $chord. O atalho personalizado mantém o padrão até você alterar um deles.';
  }

  @override
  String shortcuts_editor_title(String action) {
    return 'Atalho: $action';
  }

  @override
  String get shortcuts_editor_help =>
      'Pressione uma combinação de teclas ou escolha modificadores e uma tecla abaixo:';

  @override
  String get shortcuts_editor_needs_modifier =>
      'Escolha pelo menos Cmd/Meta, Ctrl ou Alt para não afetar a digitação no campo de mensagem.';

  @override
  String shortcuts_text_editing_warning(String chord) {
    return '$chord é um atalho de edição de texto (copiar, colar, recortar, desfazer, refazer ou selecionar tudo). Atribuí-lo aqui o tira dos campos de texto.';
  }

  @override
  String shortcuts_text_editing_in_use(String action, String chord) {
    return '\"$action\" usa $chord, um atalho de edição de texto. Os campos de texto o perdem enquanto ele estiver atribuído aqui.';
  }

  @override
  String custom_headers_problem_format(int line) {
    return 'Linha $line: esperado \"Nome: Valor\"';
  }

  @override
  String custom_headers_problem_missing_name(int line) {
    return 'Linha $line: falta o nome do cabeçalho';
  }

  @override
  String custom_headers_problem_invalid_name(int line, String name) {
    return 'Linha $line: nome de cabeçalho inválido \"$name\"';
  }

  @override
  String custom_headers_problem_reserved(int line, String name) {
    return 'Linha $line: \"$name\" é reservado e não pode ser repassado';
  }

  @override
  String custom_headers_problem_empty_value(int line) {
    return 'Linha $line: valor do cabeçalho vazio';
  }

  @override
  String get ng_enter_a_deployment_token =>
      'Digite um token de sessão de implantação.';

  @override
  String get ng_custom_headers => 'Cabeçalhos personalizados';

  @override
  String get ng_custom_headers_help =>
      'Cabeçalhos HTTP extras para este gateway (Nome: Valor, um por linha), enviados nas chamadas REST e WebSocket. Eles ficam no armazenamento seguro de credenciais. Cabeçalhos de autenticação e hop-by-hop são rejeitados.';

  @override
  String get ng_use_a_deployment_token =>
      'Usar um token de sessão de implantação';

  @override
  String get ng_sign_in_with_deployment_token =>
      'Entrar com token de implantação';

  @override
  String get ng_signed_in_with_deployment_token =>
      'Conectado com o token de implantação.';

  @override
  String get auto_speak_replies_title => 'Ler respostas em voz alta';

  @override
  String get auto_speak_replies_subtitle =>
      'Lê cada nova resposta em voz alta ao concluir um turno. Desativado por padrão; o controle de respostas faladas do chat continua valendo.';

  @override
  String get ng_auto_read_replies_title => 'Ler respostas automaticamente';

  @override
  String get ng_auto_read_replies_subtitle =>
      'Lê cada nova resposta em voz alta ao concluir um turno. Desativado por padrão.';

  @override
  String get barge_in_title => 'Interromper a leitura';

  @override
  String get barge_in_subtitle =>
      'Fale durante uma resposta para interrompê-la. O microfone fica ligado enquanto as respostas são lidas em voz alta.';

  @override
  String get barge_in_mic_live =>
      'Microfone ligado: fale para interromper a resposta';

  @override
  String get ng_barge_in_title => 'Interromper a leitura';

  @override
  String get ng_barge_in_subtitle =>
      'Fale durante uma resposta para interrompê-la. O microfone fica ligado enquanto as respostas são lidas em voz alta.';

  @override
  String get ng_barge_in_mic_live =>
      'Microfone ligado: fale para interromper a resposta';

  @override
  String get wake_word_title => 'Palavra de ativação';

  @override
  String get wake_word_subtitle =>
      'Detecção mãos-livres no gateway. Desativada por padrão; envia áudio apenas quando a captura no dispositivo está ativa.';

  @override
  String wake_word_listening(String phrase) {
    return 'Ouvindo a palavra de ativação \"$phrase\"';
  }

  @override
  String wake_word_paused(String phrase) {
    return 'Palavra de ativação \"$phrase\" — pausada';
  }

  @override
  String wake_word_off(String phrase) {
    return 'Palavra de ativação \"$phrase\" — desligada';
  }

  @override
  String get wake_word_arming => 'Ativando palavra de ativação…';

  @override
  String get wake_word_stop => 'Parar palavra de ativação';

  @override
  String get wake_word_rearm => 'Reativar';

  @override
  String get wake_word_capture_mode => 'Modo de captura';

  @override
  String get wake_word_capture_auto => 'Automático';

  @override
  String get wake_word_capture_client => 'Microfone deste dispositivo';

  @override
  String get wake_word_capture_local => 'Microfone do host do gateway';

  @override
  String get wake_word_capture_unavailable =>
      'Este gateway não permite que os apps alterem o modo de captura. Defina wake_word.capture na configuração do Hermes no host do gateway.';

  @override
  String get wake_word_input_device => 'Microfone de entrada';

  @override
  String get wake_word_default_device => 'Padrão do sistema';

  @override
  String get ng_wake_word_title => 'Palavra de ativação';

  @override
  String get ng_wake_word_subtitle =>
      'Detecção mãos-livres no gateway. Desativada por padrão.';

  @override
  String get voice_engine_title => 'Mecanismo de conversa por voz';

  @override
  String get voice_engine_subtitle =>
      'Escolha como as conversas de voz mãos-livres funcionam neste perfil do gateway.';

  @override
  String get voice_engine_chained =>
      'Encadeado (voz para texto → Hermes → voz)';

  @override
  String get voice_engine_chained_short => 'Encadeado';

  @override
  String get voice_engine_live => 'GPT-Live (voz em tempo real)';

  @override
  String get voice_engine_live_short => 'GPT-Live';

  @override
  String get voice_engine_live_needs_key =>
      'Configure uma chave de API da OpenAI no host do gateway para ativar o GPT-Live.';

  @override
  String voice_engine_fallback_chained(String reason) {
    return 'GPT-Live indisponível ($reason) — usando a voz encadeada.';
  }

  @override
  String get voice_live_start => 'Iniciar conversa por voz';

  @override
  String get voice_live_stop => 'Encerrar conversa por voz';

  @override
  String get voice_live_mute => 'Silenciar microfone';

  @override
  String get voice_live_unmute => 'Ativar microfone';

  @override
  String get voice_live_interrupt => 'Interromper ou responder agora';

  @override
  String get voice_live_listening => 'Ouvindo';

  @override
  String get voice_live_speaking => 'Falando';

  @override
  String get voice_live_thinking => 'Pensando';

  @override
  String get voice_live_muted => 'Silenciado';

  @override
  String get voice_live_ended_connection_lost =>
      'A sessão de voz ao vivo perdeu a conexão.';

  @override
  String get voice_live_ended_closed =>
      'A sessão de voz ao vivo foi encerrada pelo serviço.';

  @override
  String wake_word_other_profile(String profile) {
    return 'Essa palavra de ativação pertence ao perfil \"$profile\". Abra uma conexão com esse perfil para responder.';
  }

  @override
  String get wake_word_reason_disabled => 'Desligada — toque para ativar';

  @override
  String get wake_word_reason_surface =>
      'Restrita a outra superfície (configuração wake_word.surface)';

  @override
  String get wake_word_reason_owned =>
      'Outra superfície controla a escuta da palavra de ativação';

  @override
  String wake_word_reason_owned_by(String surface) {
    return 'Outra superfície ($surface) controla a escuta da palavra de ativação';
  }

  @override
  String get wake_word_reason_unavailable =>
      'Palavra de ativação indisponível neste gateway';

  @override
  String get wake_word_reason_permission_denied =>
      'Permissão do microfone negada';

  @override
  String get wake_word_reason_permission_required =>
      'Permissão do microfone necessária — toque para ativar';

  @override
  String get voice_live_not_enabled =>
      'O GPT-Live não está ativado para este perfil.';

  @override
  String get voice_live_not_available => 'O GPT-Live não está disponível';

  @override
  String voice_live_start_failed(String error) {
    return 'Não foi possível iniciar o GPT-Live: $error';
  }

  @override
  String voice_direct_stt_timeout(String seconds, String provider) {
    return 'A transcrição expirou após $seconds s ($provider não respondeu)';
  }

  @override
  String voice_direct_stt_error(String provider, String status) {
    return 'Erro de STT do $provider (HTTP $status)';
  }

  @override
  String voice_direct_tts_failed(String provider) {
    return 'A solicitação de TTS ao $provider falhou';
  }

  @override
  String voice_direct_tts_error(String provider, String status) {
    return 'Erro de TTS do $provider (HTTP $status)';
  }

  @override
  String ng_wake_status_listening(String phrase) {
    return 'Ouvindo (\"$phrase\")';
  }

  @override
  String ng_wake_status_off(String phrase) {
    return 'Desligada (\"$phrase\")';
  }

  @override
  String ng_wire_setting_unavailable(Object setting) {
    return 'Alterar $setting ainda não está disponível no gateway compartilhado';
  }

  @override
  String ng_wire_method_unavailable(Object method) {
    return '$method ainda não está disponível no gateway compartilhado';
  }

  @override
  String ng_wire_session_options_unsupported(Object options) {
    return 'O gateway canônico não aceita estas opções de sessão explícitas: $options';
  }

  @override
  String get ng_wire_prompt_stale =>
      'A solicitação está desatualizada ou indisponível; reconecte antes de responder';

  @override
  String get ng_wire_revision_unavailable =>
      'A revisão da sessão não está disponível; reabra a sessão antes de editar os metadados';

  @override
  String get ng_wire_generation_unavailable =>
      'A identidade de execução da sessão não está disponível; reconecte antes de usar este comando';

  @override
  String get ng_wire_message_not_saved =>
      'Esta mensagem ainda não foi salva; aguarde até que ela seja concluída e ramifique a partir dela de novo';

  @override
  String get ng_wire_not_available =>
      'Ainda não disponível no gateway compartilhado';

  @override
  String get edit_turn_title => 'Editar este prompt?';

  @override
  String get edit_turn_body =>
      'O prompt será executado novamente a partir daqui. Os turnos seguintes serão arquivados.';

  @override
  String get edit_turn_send => 'Enviar';

  @override
  String get restore_turn_title => 'Restaurar para este ponto de verificação?';

  @override
  String get restore_turn_body =>
      'Tudo após este prompt será removido da conversa e o prompt será executado novamente a partir daqui.';

  @override
  String get restore_turn_confirm => 'Restaurar e reexecutar';

  @override
  String get edit_turn_later_turns_body =>
      'Isso arquivará os turnos seguintes da conversa. Continuar?';

  @override
  String get session_history => 'Histórico da sessão';

  @override
  String get import_claude_or_codex => 'Importar Claude ou Codex';

  @override
  String get ng_session_history => 'Histórico da sessão';

  @override
  String get ng_import_claude_or_codex => 'Importar Claude ou Codex';

  @override
  String get ng_edit_and_resend => 'Editar e reenviar';

  @override
  String get ng_restore_turn_confirm => 'Restaurar e reexecutar';

  @override
  String get rewind_target_unsaved =>
      'Esta mensagem ainda não foi salva. Aguarde a conclusão e edite-a novamente.';

  @override
  String get rewind_turn_busy =>
      'A resposta atual ainda não parou, então nada foi enviado. Tente novamente em instantes.';

  @override
  String get rewind_session_changed =>
      'Esta conversa mudou desde que foi aberta aqui, então nada foi removido nem enviado. Reabra-a e tente novamente.';

  @override
  String get history_lineage => 'Conversas relacionadas';

  @override
  String get history_lineage_none =>
      'Esta conversa não tem ramificações nem ramos irmãos.';

  @override
  String get history_lineage_unavailable =>
      'Não foi possível ler as conversas relacionadas neste gateway.';

  @override
  String get history_lineage_parent => 'Origem';

  @override
  String get history_lineage_sibling => 'Irmão';

  @override
  String get history_lineage_fork => 'Ramificação';

  @override
  String get history_messages => 'Mensagens';

  @override
  String get history_messages_hint =>
      'Selecione uma mensagem guardada para ramificar ou recuar até aí.';

  @override
  String get history_messages_none => 'Ainda não há mensagens guardadas.';

  @override
  String get history_messages_unavailable =>
      'Não foi possível ler as mensagens guardadas. Abra esta conversa e atualize.';

  @override
  String get history_role_user => 'Você';

  @override
  String get history_role_assistant => 'Hermes';

  @override
  String get history_branch_here => 'Ramificar a partir daqui';

  @override
  String get history_rewind_here => 'Recuar até aqui';

  @override
  String get history_branch_title => 'Ramificar a partir desta mensagem';

  @override
  String get history_branch_body =>
      'Isto cria uma nova conversa com o histórico até à mensagem selecionada. A conversa atual fica como está.';

  @override
  String get history_rewind_title => 'Recuar até esta mensagem';

  @override
  String get history_rewind_body =>
      'As mensagens a partir da selecionada são removidas desta conversa. Os ficheiros no computador não são alterados. Restaurá-los é uma ação à parte, por ponto de controlo.';

  @override
  String history_branched(String id) {
    return 'Ramificado como $id';
  }

  @override
  String get history_open_chat => 'Abrir conversa';

  @override
  String get history_mutate_unsupported =>
      'Ramificar e recuar requerem Hermes 0.23 ou mais recente neste gateway.';

  @override
  String get history_checkpoints => 'Pontos de controlo';

  @override
  String get history_checkpoints_none =>
      'Esta sessão não tem pontos de controlo de ficheiros.';

  @override
  String get history_checkpoints_unavailable =>
      'Os pontos de controlo não estão disponíveis neste gateway.';

  @override
  String get history_diff_none => 'Sem diferenças.';

  @override
  String get history_diff_loading => 'A carregar as alterações…';

  @override
  String get history_diff_failed =>
      'Não foi possível carregar as alterações, por isso este ponto de controlo ainda não pode ser restaurado.';

  @override
  String get history_restore_checkpoint => 'Restaurar ponto de controlo';

  @override
  String get history_restore_title => 'Restaurar este ponto de controlo';

  @override
  String get history_restore_body =>
      'Os ficheiros que o agente alterou desde este ponto de controlo voltam a como estavam. As suas próprias alterações são mantidas. Mensagens posteriores da conversa também podem ser removidas. A conversa não é ramificada.';

  @override
  String get history_restore_body_all =>
      'Todos os ficheiros da pasta da sessão voltam a este ponto de controlo, incluindo as suas próprias alterações. Mensagens posteriores da conversa também podem ser removidas. A conversa não é ramificada.';

  @override
  String get history_restore_own_edits =>
      'Reverter também as minhas alterações';

  @override
  String get history_restored => 'Ponto de controlo restaurado.';

  @override
  String history_restored_removed(int count) {
    return 'Ponto de controlo restaurado. Foram removidas $count mensagens da conversa.';
  }

  @override
  String get history_export => 'Exportar';

  @override
  String get history_export_redact => 'Ocultar tokens';

  @override
  String get history_export_action => 'Exportar transcrição';

  @override
  String get history_export_saved => 'Transcrição guardada.';

  @override
  String get history_export_unsupported =>
      'Exportar requer Hermes 0.23 ou mais recente neste gateway.';

  @override
  String get history_import_unsupported =>
      'Este gateway não suporta a importação do Claude e do Codex.';

  @override
  String history_import_destination(String profile) {
    return 'Perfil de destino: $profile.';
  }

  @override
  String history_import_reading(String host, String profile, int count) {
    return 'A ler de $host · Perfil de destino: $profile. Não foi possível ler $count registos.';
  }

  @override
  String get history_import_all => 'Todos';

  @override
  String history_import_scan_failed(String reason) {
    return 'Não foi possível procurar as sessões do anfitrião: $reason';
  }

  @override
  String get history_import_none =>
      'Não foram encontradas sessões do Claude Code ou do Codex neste anfitrião.';

  @override
  String get history_import_no_match =>
      'Nenhuma sessão do anfitrião corresponde.';

  @override
  String history_import_preview_failed(String reason) {
    return 'Não foi possível pré-visualizar a sessão: $reason';
  }

  @override
  String get history_import_open => 'Abrir sessão importada';

  @override
  String get history_import_action => 'Importar sessão selecionada';

  @override
  String get history_import_title => 'Importar esta sessão';

  @override
  String history_import_body(String profile) {
    return 'Copiar esta sessão do Claude ou do Codex para o perfil \"$profile\" neste gateway.';
  }

  @override
  String history_import_body_existing(String profile) {
    return 'Esta sessão já foi importada para \"$profile\". Continue com a cópia existente.';
  }

  @override
  String history_imported(String id) {
    return 'Importado como $id';
  }

  @override
  String history_imported_already(String id) {
    return 'Já importado como $id';
  }

  @override
  String history_import_directory(String path) {
    return 'Diretório: $path';
  }

  @override
  String history_import_preview_partial(int shown, int total) {
    return 'A pré-visualização mostra $shown de $total.';
  }

  @override
  String history_failed(String reason) {
    return 'Não foi possível concluir: $reason';
  }

  @override
  String get history_error_unavailable =>
      'O gateway não conseguiu fazer isto agora. Tente novamente.';

  @override
  String get history_error_unsupported => 'Este gateway não suporta isto.';

  @override
  String get history_error_denied => 'Este gateway recusou o pedido.';

  @override
  String get history_error_changed =>
      'Esta conversa mudou enquanto esta página estava aberta. Atualize e tente novamente.';

  @override
  String get history_error_unbound =>
      'Esta conversa não está aberta no gateway. Abra-a e tente novamente.';

  @override
  String get history_error_invalid =>
      'O gateway enviou uma resposta que esta aplicação não conseguiu ler.';

  @override
  String ng_dock_kanban(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cartões do Kanban',
      one: '1 cartão do Kanban',
    );
    return '$_temp0';
  }

  @override
  String ng_dock_kanban_done(int count) {
    return '$count concluídos';
  }

  @override
  String get ng_show_kanban => 'Mostrar cartões do Kanban';

  @override
  String get ng_hide_kanban => 'Ocultar cartões do Kanban';

  @override
  String get ng_kanban_status_triage => 'Triagem';

  @override
  String get ng_kanban_status_todo => 'A fazer';

  @override
  String get ng_kanban_status_scheduled => 'Agendado';

  @override
  String get ng_kanban_status_ready => 'Pronto';

  @override
  String get ng_kanban_status_running => 'Em execução';

  @override
  String get ng_kanban_status_blocked => 'Bloqueado';

  @override
  String get ng_kanban_status_review => 'Em revisão';

  @override
  String get ng_kanban_status_done => 'Concluído';

  @override
  String get ng_kanban_status_archived => 'Arquivado';

  @override
  String ng_kanban_open_card(String title) {
    return 'Abrir $title no Kanban';
  }

  @override
  String ng_kanban_show_all(int count) {
    return 'Mostrar todos os $count';
  }

  @override
  String ng_kanban_this_chat(int count) {
    return 'Este chat ($count)';
  }

  @override
  String get ng_kanban_close => 'Fechar o Kanban';

  @override
  String get ng_kanban_block_no_dashboard =>
      'Esta conexão não tem acesso ao painel, então o status dos cartões não é em tempo real e o quadro não pode ser aberto.';

  @override
  String get ng_kanban_block_unsupported =>
      'O Kanban não está ativado neste gateway. Ative o plugin kanban para ver o status em tempo real e abrir o quadro.';

  @override
  String get ng_kanban_block_denied =>
      'Entre no painel para ver o status dos cartões em tempo real e abrir o quadro.';

  @override
  String get ng_kanban_block_insecure =>
      'O Kanban precisa de HTTPS ou de uma conexão local, então o status dos cartões não é em tempo real e o quadro não pode ser aberto.';

  @override
  String get ng_kanban_block_unreachable =>
      'Não foi possível acessar o Kanban neste gateway. O status dos cartões pode estar desatualizado.';

  @override
  String get ng_kanban_block_stale =>
      'A conexão mudou. Reabra este chat para ver o status dos cartões em tempo real.';

  @override
  String get ng_bots_tab_roster => 'Equipe';

  @override
  String get ng_bots_tab_rooms => 'Salas';

  @override
  String get ng_bots_tab_screen => 'Tela';

  @override
  String get ng_bots_tab_routines => 'Rotinas';

  @override
  String ng_bots_rooms_load_failed(String error) {
    return 'Não foi possível carregar as salas: $error';
  }

  @override
  String ng_bots_routines_load_failed(String error) {
    return 'Não foi possível carregar as rotinas: $error';
  }

  @override
  String ng_bots_desktop_failed(String error) {
    return 'Bot Desktop: $error';
  }

  @override
  String get ng_bots_install_not_started =>
      'O gateway não iniciou a instalação.';

  @override
  String ng_bots_install_failed_error(String error) {
    return 'Falha na instalação: $error';
  }

  @override
  String get ng_bots_install_cancelled => 'A instalação foi cancelada.';

  @override
  String get ng_bots_install_no_sudo =>
      'O sudo não está disponível no host do gateway. Execute o comando acima nele e depois atualize.';

  @override
  String ng_bots_install_exit_code(String code) {
    return 'A instalação falhou (código de saída $code).';
  }

  @override
  String ng_bots_install_done(String bot) {
    return 'Bot Desktop instalado para $bot';
  }

  @override
  String get ng_bots_start_failed => 'Falha ao iniciar';

  @override
  String ng_bots_stop_title(String bot) {
    return 'Parar o Bot Desktop de $bot?';
  }

  @override
  String get ng_bots_stop_human_held =>
      'Alguém está controlando esta tela. Pará-la encerra a sessão dessa pessoa e fecha tudo o que estiver aberto nela.';

  @override
  String get ng_bots_stop_body =>
      'Tudo o que estiver aberto na tela do bot será fechado.';

  @override
  String get ng_bots_stop_refused => 'Parada recusada';

  @override
  String get ng_bots_take_over_reason => 'Controle assumido pelo Ares';

  @override
  String ng_bots_take_over_failed(String error) {
    return 'Não foi possível assumir o controle: $error';
  }

  @override
  String ng_bots_force_hand_back_title(String bot) {
    return 'Devolver a tela de $bot ao bot?';
  }

  @override
  String get ng_bots_force_hand_back_body =>
      'Uma pessoa está controlando esta tela. Se ainda estiver usando, ela perderá o controle.';

  @override
  String get ng_bots_hand_back => 'Devolver controle';

  @override
  String get ng_bots_hand_back_failed => 'Falha ao devolver o controle';

  @override
  String get ng_bots_adopt_title => 'Adotar a nova imagem de sandbox?';

  @override
  String ng_bots_adopt_body(String bot, String current, String target) {
    return '$bot passa de $current para $target. O contêiner é recriado na próxima chamada de terminal; tudo o que existir apenas no contêiner atual será perdido.';
  }

  @override
  String get ng_bots_adopt_image => 'Adotar imagem';

  @override
  String get ng_bots_image_switch_failed => 'Falha ao trocar de imagem';

  @override
  String get ng_bots_keep_refused =>
      'Solicitação para manter a imagem recusada';

  @override
  String ng_bots_chat_open_failed(String error) {
    return 'Não foi possível abrir o Bot Chat: $error';
  }

  @override
  String ng_bots_title(String connection) {
    return 'Bots · $connection';
  }

  @override
  String get ng_bots_protocol_tooltip =>
      'O próprio gateway injeta o protocolo de mensagens entre colegas — nenhum protocolo SOUL.md adicional é enviado.';

  @override
  String ng_bots_unavailable(String reason) {
    return 'Bots indisponíveis ($reason)';
  }

  @override
  String get ng_bots_account_changed => 'A conta mudou. Reconecte ou atualize.';

  @override
  String get ng_bots_try_refresh =>
      'Tente atualizar. Se o problema persistir, o gateway pode não ter suporte a bots.';

  @override
  String get ng_bots_search => 'Buscar bots';

  @override
  String get ng_bots_none_found => 'Nenhum bot encontrado.';

  @override
  String get ng_bots_no_model => 'sem modelo';

  @override
  String ng_bots_skill_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count habilidades',
      one: '1 habilidade',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_bot_chat => 'Bot Chat';

  @override
  String ng_bots_install_id(String id, String protocol) {
    return 'O gateway informa o ID de instalação $id · bot_mode_protocol: $protocol';
  }

  @override
  String get ng_bots_protocol_note =>
      'O gateway injeta o protocolo de mensagens entre colegas quando bot_mode_protocol está definido. Identificador: default→hermes; caso contrário, o nome do perfil.';

  @override
  String get ng_bots_no_rooms =>
      'Ainda não há salas. Crie uma a partir da sua equipe.';

  @override
  String ng_bots_member_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membros',
      one: '1 membro',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_room_disbanded => 'dissolvida';

  @override
  String get ng_bots_room_adopted => 'adotada';

  @override
  String get ng_bots_rooms_gateway => 'Salas do gateway';

  @override
  String get ng_bots_rooms_desktop => 'Salas gerenciadas pelo Desktop';

  @override
  String ng_bots_rooms_gateway_body(String methods) {
    return 'As salas pertencem ao gateway. Métodos: $methods.';
  }

  @override
  String get ng_bots_rooms_no_seat =>
      'Este gateway talvez não consiga hospedar salas (é necessário um processo persistente).';

  @override
  String get ng_bots_rooms_fallback =>
      'Alternativa clássica: o Desktop conduz as rodadas do grupo (não são criadas aqui).';

  @override
  String get ng_bots_create_room => 'Criar sala';

  @override
  String get ng_bots_refresh_rooms => 'Atualizar salas';

  @override
  String get ng_bots_room_created => 'Sala criada';

  @override
  String ng_bots_room_refused(String reason) {
    return 'Criação da sala recusada ($reason)';
  }

  @override
  String ng_bots_room_failed(String error) {
    return 'Falha ao criar a sala: $error';
  }

  @override
  String get ng_bots_bot => 'Bot';

  @override
  String get ng_bots_screen_unavailable => 'Status da tela indisponível';

  @override
  String get ng_bots_screen_unavailable_body =>
      'Inicie a tela do bot para ver a miniatura ou assuma o controle para usá-la você mesmo.';

  @override
  String get ng_bots_take_over_note =>
      'Assumir o controle abre a tela ao vivo e passa o controle dela para você. O controle volta para o bot quando você fecha a tela ao vivo, sai desta página ou coloca o app em segundo plano.';

  @override
  String get ng_bots_not_installed => 'Não instalado';

  @override
  String get ng_bots_unsupported_host => 'Host sem suporte';

  @override
  String ng_bots_pid(String pid) {
    return 'pid $pid';
  }

  @override
  String ng_bots_missing(String items) {
    return 'faltando: $items';
  }

  @override
  String ng_bots_blocked(String reason) {
    return 'bloqueado: $reason';
  }

  @override
  String get ng_bots_no_switch =>
      'Nenhuma troca de imagem de sandbox pendente.';

  @override
  String ng_bots_switch_image(String current, String target) {
    return 'trocar imagem: $current → $target';
  }

  @override
  String get ng_bots_bot_in_control => 'o bot está no controle';

  @override
  String get ng_bots_person_in_control => 'uma pessoa está no controle';

  @override
  String get ng_bots_installing =>
      'Instalando o Bot Desktop no host do gateway…';

  @override
  String get ng_bots_install_unfinished => 'A instalação não foi concluída';

  @override
  String get ng_bots_install => 'Instalar';

  @override
  String get ng_bots_start => 'Iniciar';

  @override
  String get ng_bots_take_over => 'Assumir controle';

  @override
  String get ng_bots_keep_image => 'Manter imagem atual';

  @override
  String ng_bots_missing_pieces(String items) {
    return 'O gateway informou componentes ausentes: $items';
  }

  @override
  String get ng_bots_install_missing => 'Instalar componentes ausentes';

  @override
  String get ng_bots_thumbnail_unavailable => 'Miniatura indisponível';

  @override
  String get ng_bots_thumbnail_title => 'Miniatura da tela (ao vivo)';

  @override
  String get ng_bots_thumbnail_suppressed =>
      'Miniatura oculta enquanto uma pessoa controla a tela.';

  @override
  String get ng_bots_thumbnail_pending =>
      'A miniatura ainda não está disponível.';

  @override
  String ng_bots_routines_of(String bot) {
    return '$bot · rotinas';
  }

  @override
  String get ng_bots_add_routine => 'Adicionar rotina';

  @override
  String get ng_bots_no_routines => 'Este bot não tem rotinas.';

  @override
  String get ng_bots_routines_note =>
      'As rotinas são tarefas com a tag [bot:<name>] que pertencem ao armazenamento do perfil do bot. Rotinas delegadas legadas são pausadas à força ao carregar.';

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
    return 'erro: $error';
  }

  @override
  String ng_bots_remove_routine_title(String routine) {
    return 'Remover a rotina $routine?';
  }

  @override
  String ng_bots_remove_routine_body(String bot) {
    return 'A rotina será excluída da agenda de $bot. Essa ação não pode ser desfeita.';
  }

  @override
  String ng_bots_routine_action_failed(String action, String error) {
    return 'Falha em “$action”: $error';
  }

  @override
  String get ng_bots_not_connected => 'Não conectado.';

  @override
  String ng_bots_add_failed(String error) {
    return 'Falha ao adicionar: $error';
  }

  @override
  String get ng_bots_routine_added => 'Rotina adicionada';

  @override
  String get ng_bots_routine_enabled => 'ativada';

  @override
  String get ng_bots_routine_paused => 'pausada';

  @override
  String ng_bots_path(String path) {
    return 'Caminho: $path';
  }

  @override
  String get ng_bots_chat_present => 'Bot Chat presente';

  @override
  String get ng_bots_chat_missing => 'Bot Chat ausente';

  @override
  String ng_bots_last_session(String preview) {
    return 'Última sessão: $preview';
  }

  @override
  String get ng_bots_open_chat => 'Abrir Bot Chat';

  @override
  String get ng_bots_desktop => 'Bot Desktop';

  @override
  String get ng_bots_room_name => 'Nome da sala';

  @override
  String get ng_bots_select_member => 'Selecione pelo menos um membro.';

  @override
  String get ng_bots_sudo_title => 'Senha de administrador';

  @override
  String ng_bots_sudo_body(String bot) {
    return 'A instalação do Bot Desktop para $bot exige sudo no host do gateway. A senha é enviada apenas para esse gateway, para esta instalação, e não é salva.';
  }

  @override
  String get ng_bots_sudo_password => 'Senha do sudo';

  @override
  String get ng_bots_new_routine => 'Nova rotina';

  @override
  String get ng_bots_routine_title => 'Título';

  @override
  String get ng_bots_routine_instruction => 'Instrução';

  @override
  String get ng_bots_cron => 'Expressão cron';

  @override
  String get ng_bots_interval => 'Intervalo';

  @override
  String get ng_bots_cron_help => '0 9 * * * executa todos os dias às 09:00';

  @override
  String get ng_bots_every => 'A cada';

  @override
  String get ng_bots_unit_minutes => 'minutos';

  @override
  String get ng_bots_unit_hours => 'horas';

  @override
  String get ng_bots_unit_days => 'dias';

  @override
  String get ng_bots_stop_after => 'Parar após (execuções)';

  @override
  String get ng_bots_stop_after_help =>
      'Deixe em branco para continuar executando';

  @override
  String get ng_bots_send_results => 'Enviar resultados para';

  @override
  String get ng_bots_run_history => 'Somente histórico de execuções';

  @override
  String get ng_bots_continuity => 'Continuar a partir da execução anterior';

  @override
  String get ng_bots_account_changed_refresh =>
      'A conta mudou. Atualize antes de continuar.';

  @override
  String ng_bots_room_load_failed(String error) {
    return 'Não foi possível carregar a sala: $error';
  }

  @override
  String ng_bots_send_failed(String error) {
    return 'Falha ao enviar: $error';
  }

  @override
  String ng_bots_stop_failed(String error) {
    return 'Falha ao parar: $error';
  }

  @override
  String get ng_bots_stop_room => 'Parar sala';

  @override
  String get ng_bots_send_message => 'Enviar uma mensagem';

  @override
  String get ng_bots_room_hint =>
      'Envie uma mensagem para a sala (mencione membros com @handle)';

  @override
  String get ng_bots_history => 'Histórico';

  @override
  String ng_bots_revision(String revision) {
    return 'revisão $revision';
  }

  @override
  String ng_bots_last_error(String error) {
    return 'último erro: $error';
  }

  @override
  String get ng_bots_members => 'Membros';

  @override
  String get ng_bots_room_context => 'Contexto da sala';

  @override
  String ng_bots_purpose(String purpose) {
    return 'Objetivo: $purpose';
  }

  @override
  String ng_bots_notes(String notes) {
    return 'Notas: $notes';
  }

  @override
  String ng_bots_routing(String routing) {
    return 'Roteamento: $routing';
  }

  @override
  String ng_bots_lead(String member) {
    return 'líder $member';
  }

  @override
  String get ng_bots_viewer_you_control =>
      'Você está controlando esta tela. O bot aguarda até você devolver o controle.';

  @override
  String get ng_bots_viewer_handed_back => 'O controle voltou para o bot.';

  @override
  String get ng_bots_viewer_background =>
      'O controle voltou para o bot porque o app saiu do primeiro plano.';

  @override
  String get ng_bots_viewer_taken =>
      'Outra pessoa assumiu o controle desta tela.';

  @override
  String get ng_bots_viewer_lost =>
      'A visualização ao vivo foi perdida, então o controle voltou para o bot.';

  @override
  String ng_bots_viewer_title(String bot) {
    return 'Bot Desktop · $bot';
  }

  @override
  String get ng_bots_viewer_type_hint => 'Digite na tela do bot';

  @override
  String get ng_bots_viewer_type => 'Digitar';

  @override
  String get ng_bots_viewer_enter => 'Enter';

  @override
  String get ng_bots_viewer_backspace => 'Backspace';

  @override
  String get ng_more_kanban => 'Kanban';

  @override
  String get ng_more_kanban_subtitle =>
      'Quadros, dependências de tarefas, atribuição de executores e logs';

  @override
  String get ng_more_bots => 'Bots';

  @override
  String get ng_more_bots_subtitle => 'Equipe, salas, rotinas e Bot Desktop';

  @override
  String get ng_slash_kanban => 'Abrir o quadro Kanban';

  @override
  String get ng_slash_bots => 'Abrir seus bots';

  @override
  String ng_board_card_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cartões',
      one: '1 cartão',
    );
    return '$_temp0';
  }

  @override
  String ng_board_event_toast(String task, String event) {
    return 'Kanban $task: $event';
  }

  @override
  String get ng_board_task => 'tarefa';

  @override
  String ng_board_refused_http(String status) {
    return 'Ação recusada (HTTP $status).';
  }

  @override
  String get ng_board_err_unsupported =>
      'O plugin Kanban não está ativado neste gateway.';

  @override
  String get ng_board_err_denied =>
      'É necessário fazer login ou ter permissão neste gateway.';

  @override
  String get ng_board_err_stale =>
      'O proprietário do gateway mudou. Atualize antes de continuar.';

  @override
  String get ng_board_err_insecure =>
      'É necessário HTTPS (ou loopback) para operações no espaço de trabalho Kanban.';

  @override
  String get ng_board_err_unreachable =>
      'Não foi possível acessar o serviço Kanban neste gateway.';

  @override
  String get ng_board_err_failed =>
      'A operação falhou. Atualize e tente novamente.';

  @override
  String ng_board_block_title(String task) {
    return 'Bloquear $task';
  }

  @override
  String get ng_board_block_reason => 'Motivo do bloqueio';

  @override
  String get ng_board_block_hint => 'O que está bloqueando este cartão?';

  @override
  String ng_board_review_title(String task) {
    return 'Solicitar revisão de $task';
  }

  @override
  String get ng_board_review_summary => 'Resumo para revisão';

  @override
  String get ng_board_review_hint => 'O que foi implementado e verificado?';

  @override
  String ng_board_move_title(String cards, String column) {
    return 'Mover $cards para $column?';
  }

  @override
  String ng_board_move_body(String board) {
    return 'Todos os cartões selecionados em $board mudam de coluna. Um cartão em execução deixa de ser executado.';
  }

  @override
  String get ng_board_move => 'Mover';

  @override
  String ng_board_moved(String column) {
    return 'Cartões movidos para $column';
  }

  @override
  String ng_board_unassign_title(String cards) {
    return 'Remover a atribuição de $cards?';
  }

  @override
  String ng_board_assign_title(String cards, String profile) {
    return 'Atribuir $cards a @$profile?';
  }

  @override
  String get ng_board_assign_body =>
      'Os cartões em execução são recuperados primeiro: seus executores são interrompidos.';

  @override
  String get ng_board_unassign => 'Remover atribuição';

  @override
  String get ng_board_assign => 'Atribuir';

  @override
  String get ng_board_unassigned_done =>
      'Atribuição removida dos cartões selecionados';

  @override
  String ng_board_assigned_done(String profile) {
    return '@$profile atribuído';
  }

  @override
  String ng_board_archive_title(String cards) {
    return 'Arquivar $cards?';
  }

  @override
  String ng_board_archive_body(String board) {
    return 'Os cartões arquivados saem de $board. Ative Arquivados para vê-los novamente.';
  }

  @override
  String get ng_board_archived_done => 'Cartões selecionados arquivados';

  @override
  String ng_board_delete_title(String cards) {
    return 'Excluir $cards?';
  }

  @override
  String ng_board_delete_body(String board) {
    return 'Esta ação exclui permanentemente os cartões selecionados de $board.';
  }

  @override
  String ng_board_deleted(String cards) {
    return 'Exclusão concluída: $cards.';
  }

  @override
  String ng_board_partial_failure(String failed, String total, String reason) {
    return '$failed de $total falharam: $reason';
  }

  @override
  String get ng_board_refused => 'recusado';

  @override
  String ng_board_dispatched(
    String spawned,
    String promoted,
    String reclaimed,
  ) {
    return 'Despachado: $spawned iniciados, $promoted promovidos, $reclaimed recuperados.';
  }

  @override
  String ng_board_board_archived(String board) {
    return 'Quadro $board arquivado';
  }

  @override
  String ng_board_board_archived_to(String path) {
    return 'Arquivado em $path';
  }

  @override
  String ng_board_exported(String board, String archive) {
    return '$board exportado para $archive';
  }

  @override
  String ng_board_imported(String board, String warnings) {
    return 'Quadro $board importado$warnings';
  }

  @override
  String ng_board_created(String task) {
    return 'Tarefa $task criada';
  }

  @override
  String get ng_board_orchestration_saved => 'Orquestração Kanban salva';

  @override
  String get ng_board_auto_describe_unavailable =>
      'Descrição automática indisponível';

  @override
  String ng_board_description_updated(String profile) {
    return 'Descrição de @$profile atualizada';
  }

  @override
  String ng_board_title(String board) {
    return 'Kanban · $board';
  }

  @override
  String ng_board_active(String count) {
    return '$count em andamento';
  }

  @override
  String get ng_board_dispatch => 'Despachar as tarefas prontas agora';

  @override
  String get ng_board_orchestration => 'Orquestração e executores';

  @override
  String get ng_board_new_task => 'Nova tarefa';

  @override
  String get ng_board_enable_plugin =>
      'Ative o plugin “kanban” incluído em Capacidades → Plugins neste gateway para ativar o roteador de quadros dele.';

  @override
  String get ng_board_filter => 'Filtrar tarefas…';

  @override
  String get ng_board_all_assignees => 'Todos os responsáveis';

  @override
  String get ng_board_unassigned => 'Sem responsável';

  @override
  String get ng_board_running_by_profile => 'Em execução por perfil';

  @override
  String get ng_board_select => 'Selecionar';

  @override
  String ng_board_selected_chip(String count) {
    return 'Selecionados ($count)';
  }

  @override
  String get ng_board_locked_column =>
      'Coluna gerenciada — arrastar e soltar desativado';

  @override
  String ng_board_add_to(String column) {
    return 'Adicionar em $column';
  }

  @override
  String ng_board_collapse(String column) {
    return 'Recolher $column';
  }

  @override
  String ng_board_column_empty(String column) {
    return 'Nenhuma tarefa em $column';
  }

  @override
  String get ng_board_drop_here => 'Solte aqui ou + tarefa';

  @override
  String get ng_board_card_actions => 'Ações do cartão';

  @override
  String get ng_board_open_details => 'Abrir detalhes';

  @override
  String get ng_board_select_card => 'Selecionar cartão';

  @override
  String ng_board_move_to(String column) {
    return 'Mover para $column';
  }

  @override
  String get ng_board_parked => 'Em espera';

  @override
  String ng_board_blocked_by(String count) {
    return 'Bloqueado por $count';
  }

  @override
  String get ng_board_goal_loop => 'Ciclo de objetivo';

  @override
  String ng_board_selected(String count) {
    return 'Selecionados: $count';
  }

  @override
  String get ng_board_move_menu => 'Mover…';

  @override
  String get ng_board_assign_menu => 'Atribuir…';

  @override
  String get ng_board_new_board_title => 'Novo quadro Kanban';

  @override
  String get ng_board_slug => 'Slug (minúsculas, ex.: release-v5)';

  @override
  String get ng_board_display_name => 'Nome de exibição';

  @override
  String get ng_board_linked_project => 'Projeto vinculado (opcional)';

  @override
  String get ng_board_none => 'Nenhum';

  @override
  String get ng_board_default_workdir =>
      'Diretório de trabalho padrão no host (opcional)';

  @override
  String get ng_board_import_title => 'Importar arquivo de quadro';

  @override
  String get ng_board_import_path => 'Caminho do arquivo .tar.gz no host';

  @override
  String get ng_board_import => 'Importar';

  @override
  String ng_board_edit_board(String board) {
    return 'Editar $board';
  }

  @override
  String get ng_board_name => 'Nome';

  @override
  String get ng_board_description => 'Descrição';

  @override
  String get ng_board_workdir_clear =>
      'Diretório de trabalho padrão (em branco para limpar)';

  @override
  String get ng_board_boards => 'Quadros Kanban';

  @override
  String get ng_board_new_board => 'Novo quadro';

  @override
  String get ng_board_search_boards => 'Buscar quadros…';

  @override
  String get ng_board_unpin => 'Desafixar aba';

  @override
  String get ng_board_pin => 'Fixar aba';

  @override
  String ng_board_archive_board_title(String board) {
    return 'Arquivar o quadro $board?';
  }

  @override
  String ng_board_archive_board_body(String cards) {
    return 'O quadro e seus cartões ($cards) saem da lista de quadros. O gateway mantém um arquivo no host dele.';
  }

  @override
  String get ng_board_edit_metadata => 'Editar metadados';

  @override
  String get ng_board_export => 'Exportar .tar.gz no host';

  @override
  String get ng_board_move_pin_left => 'Mover aba fixada para a esquerda';

  @override
  String get ng_board_archive_board => 'Arquivar quadro';

  @override
  String get ng_board_new_task_title => 'Nova tarefa Kanban';

  @override
  String get ng_board_title_required => 'Título *';

  @override
  String get ng_board_spec => 'Especificação e critérios de aceitação';

  @override
  String get ng_board_estimate => 'Estimar';

  @override
  String ng_board_estimate_draft(String complexity, String tokens) {
    return 'Complexidade $complexity (~$tokens tok — apenas estimativa de tokens, não de custo em dólares)';
  }

  @override
  String get ng_board_estimate_unavailable => 'Estimativa indisponível';

  @override
  String get ng_board_initial_column => 'Coluna inicial';

  @override
  String get ng_board_worker_assignee => 'Executor atribuído';

  @override
  String get ng_board_parked_unassigned => 'Em espera (sem responsável)';

  @override
  String get ng_board_priority => 'Prioridade';

  @override
  String get ng_board_workspace => 'Espaço de trabalho';

  @override
  String get ng_board_scratch => 'Temporário';

  @override
  String get ng_board_worktree => 'Git worktree';

  @override
  String get ng_board_shared_dir => 'Diretório compartilhado';

  @override
  String get ng_board_workspace_path => 'Caminho do espaço de trabalho no host';

  @override
  String get ng_board_parent => 'Dependência-mãe (opcional)';

  @override
  String get ng_board_skills =>
      'Habilidades fixadas (separadas por vírgula, opcional)';

  @override
  String get ng_board_provider_override => 'Substituição do provedor';

  @override
  String get ng_board_model_override => 'Substituição do modelo';

  @override
  String get ng_board_reasoning => 'Esforço de raciocínio';

  @override
  String get ng_board_profile_default => 'Padrão do perfil';

  @override
  String get ng_board_xhigh => 'Muito alto';

  @override
  String get ng_board_goal_mode => 'Modo de ciclo de objetivo';

  @override
  String get ng_board_goal_turns =>
      'Máximo de turnos do objetivo (em branco = padrão)';

  @override
  String get ng_board_create_task => 'Criar tarefa';

  @override
  String get ng_board_orchestration_title =>
      'Orquestração e perfis de executores';

  @override
  String ng_board_orchestrator(String profile) {
    return 'Perfil do orquestrador (efetivo: $profile)';
  }

  @override
  String get ng_board_inherit_default => 'Herdar o padrão ativo';

  @override
  String ng_board_default_assignee(String profile) {
    return 'Responsável padrão (efetivo: $profile)';
  }

  @override
  String get ng_board_auto_decompose =>
      'Decompor automaticamente cartões de triagem';

  @override
  String get ng_board_auto_decompose_help =>
      'Usa o modelo kanban_decomposer configurado nas tarefas de triagem';

  @override
  String get ng_board_save_orchestration => 'Salvar orquestração';

  @override
  String get ng_board_worker_descriptions =>
      'Descrições da especialização dos executores';

  @override
  String ng_board_worker_label(String profile, String model, String skills) {
    return '@$profile ($model · $skills)';
  }

  @override
  String get ng_board_default_model => 'modelo padrão';

  @override
  String get ng_board_save_description => 'Salvar descrição';

  @override
  String get ng_board_auto_describe =>
      'Descrever automaticamente com base nas habilidades e na persona';

  @override
  String get ng_board_manual_block => 'Bloqueio manual do operador';

  @override
  String get ng_board_requested_review => 'Revisão solicitada';

  @override
  String ng_board_requeue_title(String task) {
    return 'Recolocar $task na fila?';
  }

  @override
  String get ng_board_requeue_body =>
      'O executor que está processando este cartão é interrompido e o cartão volta para a fila.';

  @override
  String get ng_board_requeue => 'Recolocar na fila';

  @override
  String ng_board_reassign_title(String task, String profile) {
    return 'Reatribuir $task a @$profile?';
  }

  @override
  String get ng_board_reassign_body =>
      'Este cartão está em execução: seu executor é interrompido primeiro.';

  @override
  String get ng_board_reassign => 'Reatribuir';

  @override
  String ng_board_saved_task(String task) {
    return 'Tarefa $task salva';
  }

  @override
  String get ng_board_commented_requeued =>
      'Comentário publicado e tarefa recolocada na fila';

  @override
  String get ng_board_commented => 'Comentário publicado';

  @override
  String ng_board_requeued(String task) {
    return 'Tarefa $task recolocada na fila';
  }

  @override
  String get ng_board_decompose_failed => 'Falha na decomposição.';

  @override
  String ng_board_decompose_failed_reason(String reason) {
    return 'Falha na decomposição: $reason';
  }

  @override
  String ng_board_decomposed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Decomposta em $count tarefas-filhas',
      one: 'Decomposta em 1 tarefa-filha',
    );
    return '$_temp0';
  }

  @override
  String get ng_board_no_children => 'Nenhuma tarefa-filha foi criada.';

  @override
  String ng_board_no_children_reason(String reason) {
    return 'Nenhuma tarefa-filha foi criada: $reason';
  }

  @override
  String ng_board_uploaded(String file) {
    return '$file enviado';
  }

  @override
  String ng_board_linked_parent(String task) {
    return 'Tarefa-mãe $task vinculada';
  }

  @override
  String ng_board_unlinked_parent(String task) {
    return 'Vínculo com a tarefa-mãe $task removido';
  }

  @override
  String get ng_board_task_load_failed => 'Não foi possível carregar a tarefa';

  @override
  String get ng_board_refresh_task => 'Atualizar tarefa';

  @override
  String get ng_board_tab_overview => 'Visão geral';

  @override
  String get ng_board_tab_comments => 'Comentários e links';

  @override
  String get ng_board_tab_runs => 'Execuções e log';

  @override
  String get ng_board_tab_events => 'Eventos';

  @override
  String get ng_board_decompose => 'Decompor';

  @override
  String get ng_board_attach => 'Anexar arquivo';

  @override
  String ng_board_estimate_task(
    String complexity,
    String tokens,
    String rationale,
  ) {
    return 'Estimativa: $complexity · ~$tokens tokens ($rationale) — não é uma estimativa de custo em dólares.';
  }

  @override
  String get ng_board_no_rationale => 'sem justificativa';

  @override
  String get ng_board_status => 'Status';

  @override
  String get ng_board_assignee => 'Responsável';

  @override
  String get ng_board_title_label => 'Título';

  @override
  String get ng_board_body => 'Corpo / especificação';

  @override
  String get ng_board_save_changes => 'Salvar alterações';

  @override
  String get ng_board_clear_model => 'Limpar substituição do modelo';

  @override
  String ng_board_blocked_reason(String reason) {
    return 'Motivo do bloqueio: $reason';
  }

  @override
  String ng_board_result(String result) {
    return 'Resultado: $result';
  }

  @override
  String ng_board_parents(String count) {
    return 'Bloqueado por (tarefas-mãe · $count)';
  }

  @override
  String get ng_board_add_parent => '+ Adicionar tarefa-mãe';

  @override
  String ng_board_children(String count) {
    return 'Bloqueia (tarefas-filhas · $count)';
  }

  @override
  String ng_board_attachments(String count) {
    return 'Anexos ($count)';
  }

  @override
  String get ng_board_worker => 'executor';

  @override
  String ng_board_comments(String count) {
    return 'Comentários ($count)';
  }

  @override
  String get ng_board_comment_hint =>
      'Adicionar comentário / orientação para o executor';

  @override
  String get ng_board_post_comment => 'Publicar comentário';

  @override
  String get ng_board_comment_requeue => 'Comentar e recolocar na fila';

  @override
  String ng_board_runs(String count) {
    return 'Execuções ($count)';
  }

  @override
  String get ng_board_no_runs =>
      'Nenhuma execução do executor registrada ainda.';

  @override
  String ng_board_run_error(String error) {
    return 'Erro: $error';
  }

  @override
  String ng_board_log_tail_truncated(String bytes) {
    return 'Final do log do executor ($bytes B, truncado)';
  }

  @override
  String ng_board_log_tail(String bytes) {
    return 'Final do log do executor ($bytes B)';
  }

  @override
  String get ng_board_refresh_log => 'Atualizar log';

  @override
  String get ng_board_no_log => 'Nenhuma saída no log do executor.';

  @override
  String get ng_board_no_events => 'Nenhum evento registrado.';

  @override
  String get ng_bots_room_unknown => 'desconhecido';

  @override
  String get ng_bots_room_blocked => 'bloqueado';

  @override
  String get ng_bots_room_working => 'trabalhando';

  @override
  String get ng_bots_room_running => 'em execução';

  @override
  String get ng_bots_room_idle => 'ocioso';

  @override
  String ng_board_run_title(String id, String profile, String outcome) {
    return 'Execução nº $id · @$profile · $outcome';
  }

  @override
  String get ng_bots_new_bot => 'Novo bot';

  @override
  String get ng_bots_new_bot_hint =>
      'Um colega com nome, com memória, habilidades e chat próprios. Pode mandar mensagens para seus outros agentes.';

  @override
  String get ng_bots_field_name => 'Nome';

  @override
  String get ng_bots_field_title => 'Título';

  @override
  String get ng_bots_field_description => 'Descrição';

  @override
  String get ng_bots_description_hint => 'Com o que este bot deve ajudar?';

  @override
  String get ng_bots_name_invalid =>
      'Use letras minúsculas, números, hífens ou sublinhados, começando por uma letra ou um número (no máximo 64 caracteres).';

  @override
  String ng_bots_name_taken(String name) {
    return 'Já existe um agente chamado “$name”.';
  }

  @override
  String ng_bots_profile_id(String id) {
    return 'ID do perfil: $id';
  }

  @override
  String get ng_bots_advanced =>
      'Avançado — modelo, habilidades, conjuntos de ferramentas, SOUL.md';

  @override
  String get ng_bots_clone_from => 'Clonar do perfil';

  @override
  String get ng_bots_clone_main => 'Perfil principal (default)';

  @override
  String get ng_bots_fresh_profile => 'Perfil novo (habilidades incluídas)';

  @override
  String get ng_bots_create_empty =>
      'Criar vazio (sem as habilidades incluídas)';

  @override
  String get ng_bots_share_keys =>
      'Compartilhar chaves e contas com o perfil principal';

  @override
  String get ng_bots_provider => 'Provedor';

  @override
  String get ng_bots_model => 'Modelo';

  @override
  String get ng_bots_model_pair => 'Informe um provedor e um modelo.';

  @override
  String get ng_bots_soul => 'SOUL.md (opcional — substitui a persona gerada)';

  @override
  String get ng_bots_soul_edit => 'SOUL.md';

  @override
  String get ng_bots_creating => 'Criando…';

  @override
  String get ng_bots_create_bot => 'Criar bot';

  @override
  String ng_bots_created(String name) {
    return 'Bot “$name” criado';
  }

  @override
  String get ng_bots_look_failed =>
      'A aparência não foi salva no gateway; defina-a em Editar perfil.';

  @override
  String ng_bots_request_failed(String reason) {
    return 'O gateway não aceitou ($reason).';
  }

  @override
  String get ng_bots_avatar_shape => 'Forma';

  @override
  String ng_bots_avatar_shape_n(int n) {
    return 'Forma $n';
  }

  @override
  String get ng_bots_avatar_colour => 'Cor';

  @override
  String ng_bots_avatar_colour_n(int n) {
    return 'Cor $n';
  }

  @override
  String get ng_bots_avatar_match_name => 'Conforme o nome';

  @override
  String get ng_bots_avatar_upload => 'Escolher uma imagem…';

  @override
  String get ng_bots_avatar_remove => 'Remover imagem — usar forma';

  @override
  String get ng_bots_avatar_too_large => 'Imagem grande demais (máx. 15 MB).';

  @override
  String get ng_bots_avatar_unreadable => 'Não foi possível ler essa imagem.';

  @override
  String get ng_bots_edit_profile => 'Editar perfil';

  @override
  String ng_bots_edit_description(String name, String profile) {
    return 'Aparência e função de $name ($profile).';
  }

  @override
  String ng_bots_advanced_failed(String reason) {
    return 'Não foi possível carregar as configurações do perfil ($reason).';
  }

  @override
  String get ng_bots_skills => 'Habilidades';

  @override
  String get ng_bots_toolsets => 'Conjuntos de ferramentas';

  @override
  String get ng_bots_toolsets_hint =>
      'Deixar todos (ou nenhum) marcados mantém o comportamento padrão.';

  @override
  String get ng_bots_mcp_servers => 'Servidores MCP';

  @override
  String get ng_bots_saving => 'Salvando…';

  @override
  String get ng_bots_confirm_changes_title => 'Salvar estas alterações?';

  @override
  String get ng_bots_change_remove_image => 'Remover a imagem do bot';

  @override
  String get ng_bots_change_soul => 'Substituir o SOUL.md';

  @override
  String ng_bots_change_turn_off(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Desativar $count habilidades, conjuntos ou servidores MCP',
      one: 'Desativar 1 habilidade, conjunto ou servidor MCP',
    );
    return '$_temp0';
  }

  @override
  String ng_bots_updated(String name) {
    return '$name atualizado';
  }

  @override
  String ng_bots_sections_failed(String sections) {
    return 'Algumas seções falharam: $sections';
  }

  @override
  String get ng_bots_model_confirm_title => 'Trocar o modelo?';

  @override
  String get ng_bots_model_confirm_ok => 'Trocar';

  @override
  String get ng_bots_model_not_switched => 'O modelo não foi trocado.';

  @override
  String get ng_bots_section_new => 'Nova seção';

  @override
  String get ng_bots_section_new_ellipsis => 'Nova seção…';

  @override
  String get ng_bots_section_name => 'Nome da seção';

  @override
  String get ng_bots_section_name_hint => 'ex.: Clientes';

  @override
  String get ng_bots_section_create => 'Criar';

  @override
  String get ng_bots_section_rename => 'Renomear seção';

  @override
  String get ng_bots_section_delete => 'Excluir seção';

  @override
  String get ng_bots_section_move_up => 'Mover para cima';

  @override
  String get ng_bots_section_move_down => 'Mover para baixo';

  @override
  String get ng_bots_section_unassigned => 'Sem seção';

  @override
  String ng_bots_section_options(String name) {
    return 'Opções da seção $name';
  }

  @override
  String get ng_bots_section_empty =>
      'Ainda não há bots aqui. Use Mover para seção em um bot.';

  @override
  String get ng_bots_section_move_to => 'Mover para seção';

  @override
  String get ng_bots_section_remove => 'Remover da seção';

  @override
  String ng_bots_section_deleted(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '“$name” excluída — $count bots movidos para Sem seção',
      one: '“$name” excluída — 1 bot movido para Sem seção',
      zero: '“$name” excluída',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_undo => 'Desfazer';

  @override
  String ng_bots_section_move_failed(String reason) {
    return 'Não foi possível mover o bot ($reason).';
  }

  @override
  String ng_bots_bot_actions(String name) {
    return 'Ações de $name';
  }

  @override
  String ng_bots_section_toggle(String name) {
    return 'Mostrar ou ocultar $name';
  }

  @override
  String
  get release_core_transcript_reader_this_passage_is_no_longer_in_the_loaded =>
      'Este trecho não está mais na janela carregada.';

  @override
  String get release_core_transcript_reader_loaded_prompts =>
      'Prompts carregados';

  @override
  String get release_core_transcript_reader_jump_to_latest =>
      'Ir para o mais recente';

  @override
  String get release_core_transcript_reader_no_prompts_loaded =>
      'Nenhum prompt carregado';

  @override
  String get release_core_transcript_reader_find_in_loaded_messages =>
      'Buscar nas mensagens carregadas';

  @override
  String get release_core_transcript_reader_previous_match =>
      'Resultado anterior';

  @override
  String get release_core_transcript_reader_next_match => 'Próximo resultado';

  @override
  String get release_core_transcript_reader_prompt_timeline =>
      'Linha do tempo dos prompts';

  @override
  String get release_core_transcript_reader_close_find => 'Fechar busca';

  @override
  String get release_core_session_organisation_organise_chats =>
      'Organizar chats';

  @override
  String get release_core_session_organisation_show_model_and_usage =>
      'Mostrar modelo e uso';

  @override
  String
  get release_core_session_files_view_connection_changed_reopen_files_on_the_new_connection =>
      'Conexão alterada. Reabra os arquivos na nova conexão.';

  @override
  String
  get release_core_session_files_view_the_connection_or_session_changed_reopen_this_pane =>
      'A conexão ou a sessão mudou. Reabra este painel.';

  @override
  String
  get release_core_session_files_view_no_verified_host_working_directory_for_this_session =>
      'Nenhum diretório de trabalho verificado no host para esta sessão.';

  @override
  String
  get release_core_session_files_view_the_gateway_denied_this_operation =>
      'O Gateway negou esta operação.';

  @override
  String
  get release_core_session_files_view_this_gateway_does_not_support_this_operation =>
      'Este Gateway não oferece suporte a esta operação.';

  @override
  String
  get release_core_session_files_view_the_file_owner_or_working_directory_changed_reload =>
      'O arquivo, o proprietário ou o diretório de trabalho mudou. Recarregue e revise.';

  @override
  String
  get release_core_session_files_view_the_gateway_returned_an_unsafe_path_or_invalid =>
      'O Gateway retornou um caminho inseguro ou uma resposta de arquivo inválida.';

  @override
  String
  get release_core_session_files_view_workspace_access_requires_a_secure_gateway_connection =>
      'O acesso à área de trabalho exige uma conexão segura com o Gateway.';

  @override
  String
  get release_core_session_files_view_gateway_unavailable_refresh_to_check_the_current_state =>
      'Gateway indisponível. Atualize para verificar o estado atual.';

  @override
  String
  get release_core_session_files_view_gateway_operation_could_not_be_confirmed =>
      'Não foi possível confirmar a operação do Gateway.';

  @override
  String get release_core_session_files_view_git_status_unavailable =>
      'Status do Git indisponível.';

  @override
  String
  get release_core_session_files_view_change_this_chat_s_working_directory =>
      'Alterar o diretório de trabalho deste chat?';

  @override
  String get release_core_session_files_view_absolute_gateway_directory =>
      'Caminho absoluto do diretório no Gateway';

  @override
  String get release_core_session_files_view_change_directory =>
      'Alterar diretório';

  @override
  String get release_core_session_files_view_replace_gateway_file =>
      'Substituir arquivo no Gateway?';

  @override
  String
  release_core_session_files_view_only_if_the_file_still_matches_the_version(
    String path,
  ) {
    return '$path\n\nSomente se o arquivo ainda corresponder à versão que você revisou. Um host compatível mantém o arquivo substituído para recuperação.';
  }

  @override
  String get release_core_session_files_view_save_changes =>
      'Salvar alterações';

  @override
  String
  get release_core_session_files_view_saved_and_verified_on_the_gateway =>
      'Salvo e verificado no Gateway.';

  @override
  String
  get release_core_session_files_view_guarded_saving_is_unavailable_on_this_gateway_your =>
      'O salvamento protegido não está disponível neste Gateway. Seu rascunho continua aqui.';

  @override
  String
  release_core_session_files_view_save_was_not_confirmed_your_draft_is_still(
    String reason,
  ) {
    return '$reason O salvamento não foi confirmado. Seu rascunho continua aqui.';
  }

  @override
  String get release_core_session_files_view_review_current_gateway_version =>
      'Revisar a versão atual no Gateway';

  @override
  String get release_core_session_files_view_discard_draft_and_reload =>
      'Descartar rascunho e recarregar';

  @override
  String get release_core_session_files_view_keep_draft_against_this_version =>
      'Manter rascunho com esta versão como base';

  @override
  String get release_core_session_files_view_discard_unsaved_edits =>
      'Descartar edições não salvas?';

  @override
  String get release_core_session_files_view_keep_editing =>
      'Continuar editando';

  @override
  String get release_core_session_files_view_discard_edits =>
      'Descartar edições';

  @override
  String get release_core_session_files_view_remote_working_directory =>
      'Diretório de trabalho remoto';

  @override
  String get release_core_session_files_view_change_working_directory =>
      'Alterar diretório de trabalho';

  @override
  String get release_core_session_files_view_show_ignored_files =>
      'Mostrar arquivos ignorados';

  @override
  String
  get release_core_session_files_view_gateway_does_not_report_ignored_status =>
      'O Gateway não informa o status de arquivos ignorados.';

  @override
  String get release_core_session_files_view_no_visible_entries =>
      'Nenhum item visível';

  @override
  String get release_core_session_files_view_changed => 'Alterado';

  @override
  String get release_core_session_files_view_ignored => 'Ignorado';

  @override
  String release_core_session_files_view_actions_for(String name) {
    return 'Ações para $name';
  }

  @override
  String get release_core_session_files_view_copy_relative_path =>
      'Copiar caminho relativo';

  @override
  String get release_core_session_files_view_copy_gateway_path =>
      'Copiar caminho no Gateway';

  @override
  String get release_core_session_files_view_attach_folder_reference =>
      'Anexar referência à pasta';

  @override
  String get release_core_session_files_view_attach_file_reference =>
      'Anexar referência ao arquivo';

  @override
  String
  get release_core_session_files_view_preview_truncated_editing_disabled =>
      'Prévia truncada — edição desativada.';

  @override
  String get release_core_session_files_view_select_lines =>
      'Selecionar linhas';

  @override
  String get release_core_session_files_view_review_gateway_version =>
      'Revisar versão no Gateway';

  @override
  String get release_core_session_files_view_attach_selected_lines =>
      'Anexar linhas selecionadas';

  @override
  String get release_core_session_files_view_binary_file_no_text_preview =>
      'Arquivo binário — sem prévia de texto.';

  @override
  String get release_core_session_files_view_file_source => 'Origem do arquivo';

  @override
  String get release_core_session_files_view_close_session_files =>
      'Fechar arquivos da sessão';

  @override
  String get release_core_session_files_view_back_to_tree => 'Voltar à árvore';

  @override
  String get release_core_session_files_view_session_files =>
      'Arquivos da sessão';

  @override
  String get release_core_session_files_view_git_review => 'Revisão do Git';

  @override
  String get release_core_session_files_view_refresh_tree => 'Atualizar árvore';

  @override
  String
  get release_core_gateway_queue_screen_this_connection_changed_reopen_its_chat =>
      'Esta conexão mudou. Reabra o chat dela.';

  @override
  String
  get release_core_gateway_queue_screen_disconnected_reconnect_the_chat_then_refresh =>
      'Desconectado. Reconecte o chat e atualize.';

  @override
  String release_core_gateway_queue_screen_gateway_queue_unavailable(
    String reason,
  ) {
    return 'Fila do Gateway indisponível: $reason.';
  }

  @override
  String release_core_gateway_queue_screen_not_confirmed_nothing_was_resent(
    String reason,
  ) {
    return 'Não confirmado ($reason). Nada foi reenviado.';
  }

  @override
  String get release_core_gateway_queue_screen_gateway_confirmed_admission =>
      'O Gateway confirmou a entrada na fila.';

  @override
  String
  get release_core_gateway_queue_screen_edited_entry_admitted_at_the_end_of_the =>
      'Item editado incluído no fim da fila.';

  @override
  String get release_core_gateway_queue_screen_discard_unknown_outcome =>
      'Descartar item com resultado desconhecido?';

  @override
  String get release_core_gateway_queue_screen_remove_this_entry =>
      'Remover este item?';

  @override
  String
  get release_core_gateway_queue_screen_the_lost_turn_will_not_be_retried_waiting =>
      'O turno perdido não será repetido. Os turnos em espera poderão ser executados agora.';

  @override
  String
  get release_core_gateway_queue_screen_if_the_gateway_has_just_started_this_entry =>
      'Se o Gateway acabou de iniciar este item, removê-lo pode interromper esse turno.';

  @override
  String get release_core_gateway_queue_screen_keep => 'Manter';

  @override
  String get release_core_gateway_queue_screen_discard_and_resume =>
      'Descartar e retomar';

  @override
  String get release_core_gateway_queue_screen_remove_entry => 'Remover item';

  @override
  String
  get release_core_gateway_queue_screen_lost_admission_resolved_it_was_not_resent =>
      'Entrada perdida resolvida; ela não foi reenviada.';

  @override
  String get release_core_gateway_queue_screen_gateway_acknowledged_removal =>
      'O Gateway confirmou a remoção.';

  @override
  String get release_core_gateway_queue_screen_gateway_queue =>
      'Fila do Gateway';

  @override
  String get release_core_gateway_queue_screen_refresh_queue =>
      'Atualizar fila';

  @override
  String get release_core_gateway_queue_screen_queue_paused_unknown_outcome =>
      'Fila pausada: resultado desconhecido';

  @override
  String
  get release_core_gateway_queue_screen_review_the_lost_admission_before_resuming_nothing_is =>
      'Revise a entrada perdida antes de retomar. Nada será enviado novamente.';

  @override
  String get release_core_gateway_queue_screen_no_pending_admissions =>
      'Nenhuma entrada pendente';

  @override
  String get release_core_gateway_queue_screen_discard => 'Descartar…';

  @override
  String
  get release_core_gateway_queue_screen_gateway_acknowledged_the_steering_request =>
      'O Gateway confirmou o pedido de redirecionamento.';

  @override
  String get release_core_gateway_queue_screen_steer_running_turn =>
      'Redirecionar turno em andamento';

  @override
  String get release_core_gateway_queue_screen_remove => 'Remover…';

  @override
  String get release_core_gateway_queue_screen_next_prompt => 'Próximo prompt';

  @override
  String get release_core_gateway_queue_screen_edit_queued_prompt =>
      'Editar prompt na fila';

  @override
  String get release_core_gateway_queue_screen_submit_to_gateway_queue =>
      'Enviar à fila do Gateway';

  @override
  String get release_core_gateway_queue_screen_save_at_queue_end =>
      'Salvar no fim da fila';

  @override
  String get release_core_gateway_queue_screen_cancel_edit => 'Cancelar edição';

  @override
  String get release_core_git_review_pane_the_git_operation_did_not_complete =>
      'A operação do Git não foi concluída.';

  @override
  String get release_core_git_review_pane_close_git_review =>
      'Fechar revisão do Git';

  @override
  String get release_core_git_review_pane_pin_lane => 'Fixar linha de trabalho';

  @override
  String get release_core_git_review_pane_refresh_git_review =>
      'Atualizar revisão do Git';

  @override
  String get release_core_git_review_pane_uncommitted => 'Sem commit';

  @override
  String get release_core_git_review_pane_last_turn => 'Último turno';

  @override
  String
  get release_core_git_review_pane_branch_and_last_turn_views_are_read_only =>
      'As visualizações de branch e do último turno são somente leitura.';

  @override
  String get release_core_git_review_pane_mark_head_as_the_turn_baseline =>
      'Marcar HEAD como base do turno';

  @override
  String get release_core_git_review_pane_stage_all => 'Preparar tudo';

  @override
  String get release_core_git_review_pane_discard_every_uncommitted_change =>
      'Descartar todas as alterações sem commit?';

  @override
  String
  get release_core_git_review_pane_tracked_files_return_to_head_and_untracked_files =>
      'Os arquivos rastreados voltam ao estado de HEAD, e os não rastreados neste diretório de sessão são removidos.';

  @override
  String get release_core_git_review_pane_discard => 'Descartar';

  @override
  String get release_core_git_review_pane_discard_all => 'Descartar tudo';

  @override
  String get release_core_git_review_pane_unstage => 'Retirar da preparação';

  @override
  String get release_core_git_review_pane_stage => 'Preparar';

  @override
  String get release_core_git_review_pane_discard_file => 'Descartar arquivo';

  @override
  String release_core_git_review_pane_discard_2(String path) {
    return 'Descartar $path?';
  }

  @override
  String
  get release_core_git_review_pane_this_restores_the_committed_copy_or_removes_the =>
      'Isso restaura a cópia do commit ou remove o arquivo não rastreado.';

  @override
  String get release_core_git_review_pane_commit_message =>
      'Mensagem do commit';

  @override
  String get release_core_git_review_pane_nothing_in_the_diff_to_summarise =>
      'Nada nas diferenças para resumir.';

  @override
  String get release_core_git_review_pane_generate_message => 'Gerar mensagem';

  @override
  String get release_core_git_review_pane_commit => 'Fazer commit';

  @override
  String get release_core_git_review_pane_commit_and_push =>
      'Fazer commit e enviar';

  @override
  String get release_core_git_review_pane_push => 'Enviar';

  @override
  String get release_core_git_review_pane_create_pull_request =>
      'Criar pull request';

  @override
  String get release_core_git_review_pane_pull_request_ready =>
      'Pull request pronto';

  @override
  String get release_core_git_review_pane_ask_hermes_to_ship =>
      'Pedir ao Hermes para publicar';

  @override
  String get release_core_git_review_pane_gh_is_authenticated_on_this_gateway =>
      'O gh está autenticado neste Gateway.';

  @override
  String
  get release_core_git_review_pane_install_the_github_cli_gh_and_sign_in =>
      'Instale a CLI do GitHub (gh) e entre para abrir PRs';

  @override
  String get release_core_git_review_pane_worktrees => 'Worktrees';

  @override
  String get release_core_git_review_pane_main => 'Principal';

  @override
  String release_core_git_review_pane_follow(String branch) {
    return 'Acompanhar $branch?';
  }

  @override
  String
  get release_core_git_review_pane_the_session_working_directory_becomes_this_worktree_unless =>
      'O diretório de trabalho da sessão passa a ser este worktree, a menos que a linha de trabalho esteja fixada.';

  @override
  String get release_core_git_review_pane_follow_2 => 'Acompanhar';

  @override
  String release_core_git_review_pane_remove(String branch) {
    return 'Remover $branch?';
  }

  @override
  String get release_core_git_review_pane_the_worktree_directory_is_removed =>
      'O diretório do worktree será removido.';

  @override
  String get release_core_git_review_pane_remove_2 => 'Remover';

  @override
  String get release_core_git_review_pane_new_worktree_name =>
      'Nome do novo worktree';

  @override
  String get release_core_git_review_pane_new_branch => 'Novo branch';

  @override
  String get release_core_git_review_pane_base_branch => 'Branch de base';

  @override
  String get release_core_git_review_pane_create_worktree => 'Criar worktree';

  @override
  String get release_core_git_review_pane_existing_branch => 'Branch existente';

  @override
  String get release_core_git_review_pane_convert_branch_to_worktree =>
      'Converter branch em worktree';

  @override
  String get release_core_git_review_pane_switch_branch => 'Trocar de branch';

  @override
  String
  get release_core_git_review_pane_this_gateway_does_not_support_that_git_operation =>
      'Este Gateway não oferece suporte a essa operação do Git.';

  @override
  String
  get release_core_git_review_pane_git_needs_the_session_directory_on_the_local =>
      'O Git precisa do diretório da sessão no backend do terminal local.';

  @override
  String
  get release_core_git_review_pane_the_gateway_refused_the_git_operation =>
      'O Gateway recusou a operação do Git.';

  @override
  String
  get release_core_git_review_pane_the_session_changed_refresh_and_try_again =>
      'A sessão mudou. Atualize e tente novamente.';

  @override
  String
  get release_core_git_review_pane_this_review_is_no_longer_the_selected_session =>
      'Esta revisão não corresponde mais à sessão selecionada.';

  @override
  String
  get release_core_git_review_pane_the_gateway_returned_an_unexpected_git_result =>
      'O Gateway retornou um resultado inesperado do Git.';

  @override
  String
  get release_core_git_review_pane_git_review_requires_the_gateway_transport =>
      'A revisão do Git exige o transporte do Gateway.';

  @override
  String get release_core_client_held_queue_bar_resume => 'Retomar';

  @override
  String get release_core_client_held_queue_bar_send_queued_prompt =>
      'Enviar prompt da fila';

  @override
  String get release_core_client_held_queue_bar_edit_unsent_prompt =>
      'Editar prompt não enviado';

  @override
  String get release_core_client_held_queue_bar_remove_unsent_prompt =>
      'Remover prompt não enviado';

  @override
  String get release_core_workspace_discovery_view_repository_discovery =>
      'Descoberta de repositórios';

  @override
  String get release_core_workspace_discovery_view_refresh_results =>
      'Atualizar resultados';

  @override
  String release_core_workspace_discovery_view_hide(String path) {
    return 'Ocultar $path';
  }

  @override
  String
  get release_core_workspace_discovery_view_invalid_path_or_discovery_data_use_absolute_server =>
      'Caminho ou dados de descoberta inválidos. Use caminhos absolutos do servidor sem os componentes “.” ou “..”.';

  @override
  String
  get release_core_workspace_discovery_view_this_gateway_does_not_support_repository_discovery =>
      'Este Gateway não oferece suporte à descoberta de repositórios.';

  @override
  String
  get release_core_workspace_discovery_view_the_gateway_denied_access_to_repository_discovery =>
      'O Gateway negou acesso à descoberta de repositórios.';

  @override
  String
  get release_core_workspace_discovery_view_the_connection_changed_reopen_discovery_on_the_current =>
      'A conexão mudou. Reabra a descoberta no Gateway atual.';

  @override
  String
  get release_core_workspace_discovery_view_the_displayed_settings_have_changed_refresh_before_trying =>
      'As configurações exibidas mudaram. Atualize antes de tentar novamente.';

  @override
  String
  get release_core_workspace_discovery_view_could_not_load_or_verify_discovery_settings_refresh =>
      'Não foi possível carregar ou verificar as configurações de descoberta. Atualize para tentar novamente.';

  @override
  String release_core_workspace_discovery_view_repositories_shown_of(
    int visible,
    int total,
  ) {
    return 'Repositórios exibidos: $visible de $total';
  }

  @override
  String
  get release_core_workspace_discovery_view_the_gateway_returned_no_repositories =>
      'O Gateway não retornou nenhum repositório.';

  @override
  String
  get release_core_workspace_discovery_view_no_repositories_match_your_device_filters =>
      'Nenhum repositório corresponde aos filtros do seu dispositivo.';

  @override
  String get release_core_workspace_discovery_view_gateway_scan_policy =>
      'Política de varredura do Gateway';

  @override
  String
  get release_core_workspace_discovery_view_this_gateway_did_not_report_a_scan_policy =>
      'Este Gateway não informou uma política de varredura.';

  @override
  String
  get release_core_workspace_discovery_view_to_scan_folders_configure_repository_scanning_in_the =>
      'Para examinar pastas, configure a varredura de repositórios nas configurações do Desktop do perfil do Gateway.';

  @override
  String
  get release_core_workspace_discovery_view_results_can_include_cached_repositories_and_repositories_with =>
      'Os resultados podem incluir repositórios em cache e repositórios com sessões. Uma varredura não garante que todas as pastas foram alcançadas.';

  @override
  String get release_core_workspace_discovery_view_scan_gateway_roots =>
      'Examinar diretórios raiz do Gateway';

  @override
  String
  get release_core_workspace_discovery_view_filter_results_on_this_device =>
      'Filtrar resultados neste dispositivo';

  @override
  String
  get release_core_workspace_discovery_view_only_this_discovery_list_changes_not_the_gateway =>
      'Somente esta lista de descoberta muda, não a varredura do Gateway.';

  @override
  String get release_core_workspace_discovery_view_include_subtrees_empty_all =>
      'Incluir subárvores (vazio = todas)';

  @override
  String get release_core_workspace_discovery_view_exclude_subtrees =>
      'Excluir subárvores da varredura';

  @override
  String get release_core_workspace_discovery_view_apply_filters =>
      'Aplicar filtros';

  @override
  String release_core_workspace_discovery_view_hidden_repositories(int count) {
    return 'Repositórios ocultos ($count)';
  }

  @override
  String get release_core_workspace_discovery_view_undo_hide =>
      'Desfazer ocultação';

  @override
  String
  get release_core_workspace_discovery_view_one_absolute_server_path_per_line =>
      'Um caminho absoluto do servidor por linha';

  @override
  String get release_core_project_settings_view_project_settings =>
      'Configurações do projeto';

  @override
  String
  get release_core_project_settings_view_the_gateway_did_not_confirm_the_selected_project =>
      'O Gateway não confirmou o projeto selecionado ou a alteração. Revise as configurações antes de tentar novamente.';

  @override
  String
  get release_core_project_settings_view_could_not_verify_these_settings_use_one_absolute =>
      'Não foi possível verificar estas configurações. Use um caminho absoluto de pasta do servidor por linha, sem os componentes “.” ou “..”.';

  @override
  String get release_core_project_settings_view_set_active =>
      'Definir como ativo';

  @override
  String get release_core_project_settings_view_icon => 'Ícone';

  @override
  String get release_core_project_settings_view_folder => 'Pasta';

  @override
  String get release_core_project_settings_view_repository => 'Repositório';

  @override
  String get release_core_project_settings_view_rocket => 'Foguete';

  @override
  String get release_core_project_settings_view_star => 'Estrela';

  @override
  String get release_core_project_settings_view_book => 'Livro';

  @override
  String get release_core_project_settings_view_terminal => 'Terminal';

  @override
  String get release_core_project_settings_view_colour => 'Cor';

  @override
  String get release_core_project_settings_view_primary_folder =>
      'Pasta principal';

  @override
  String get release_core_project_settings_view_server_folder_paths =>
      'Caminhos de pastas do servidor';

  @override
  String
  get release_core_project_settings_view_one_absolute_path_per_line_existing_folders_are =>
      'Um caminho absoluto por linha. As pastas existentes são mantidas.';

  @override
  String get release_core_project_settings_view_add_folders =>
      'Adicionar pastas';

  @override
  String release_core_project_settings_view_choose(String label) {
    return 'Escolher $label';
  }

  @override
  String
  get release_core_prepared_image_recovery_wait_for_an_empty_draft_before_restoring =>
      'Aguarde até o rascunho estar vazio antes de restaurar.';

  @override
  String
  get release_core_prepared_image_recovery_no_unacknowledged_image_drafts_in_this_chat =>
      'Nenhum rascunho de imagem sem confirmação neste chat.';

  @override
  String get release_core_prepared_image_recovery_unacknowledged_image_drafts =>
      'Rascunhos de imagem sem confirmação';

  @override
  String
  get release_core_prepared_image_recovery_the_gateway_may_already_have_received_these_restore =>
      'O Gateway pode já ter recebido estes itens. Restaure para revisar; nada será enviado.';

  @override
  String get release_core_prepared_image_recovery_image_draft =>
      'Rascunho de imagem';

  @override
  String get release_core_prepared_image_recovery_discard_local_copy =>
      'Descartar cópia local';

  @override
  String
  get release_core_prepared_image_recovery_discard_this_local_image_draft =>
      'Descartar este rascunho de imagem local?';

  @override
  String
  get release_core_prepared_image_recovery_image_draft_recovery_is_unavailable =>
      'A recuperação de rascunhos de imagem está indisponível.';

  @override
  String get release_core_prepared_image_recovery_recover_image_draft =>
      'Recuperar rascunho de imagem…';

  @override
  String get release_core_session_search_mode_menu_could_not_save_search_mode =>
      'Não foi possível salvar o modo de busca.';

  @override
  String get release_core_projects_pane_discover_repositories =>
      'Descobrir repositórios';

  @override
  String
  get release_core_projects_pane_project_created_but_the_gateway_did_not_confirm =>
      'Projeto criado, mas o Gateway não confirmou a ideia dele.';

  @override
  String get release_core_projects_pane_project_idea_optional =>
      'Ideia do projeto (opcional)';

  @override
  String
  get release_core_projects_pane_saved_in_the_project_description_not_a_file =>
      'Salvo na descrição do projeto, não em um arquivo.';

  @override
  String get release_core_project_detail_screen_new_chat_in_this_lane =>
      'Novo chat nesta linha de trabalho';

  @override
  String get release_core_project_detail_screen_review_git => 'Revisar Git';

  @override
  String get release_core_more_pane_gateway_fleet => 'Frota de Gateways';

  @override
  String
  get release_core_more_pane_connected_sessions_hermes_cloud_and_desktop_webapp =>
      'Sessões conectadas, Hermes Cloud e aplicativo web do Desktop';

  @override
  String get release_core_more_pane_use_dashboard_sign_in_for_a_named_profile =>
      'Entre pelo painel para usar um perfil nomeado. Esta API legada não pode confirmar a qual perfil pertence o histórico de chats.';

  @override
  String get release_core_more_pane_capabilities => 'Recursos';

  @override
  String
  get release_core_more_pane_install_and_govern_skills_plugins_connectors_and_tool =>
      'Instale e gerencie habilidades, plugins, conectores e backends de ferramentas';

  @override
  String get release_core_more_pane_browser_vault => 'Cofre do navegador';

  @override
  String
  get release_core_more_pane_site_logins_addresses_cards_and_credential_sources =>
      'Logins de sites, endereços, cartões e fontes de credenciais';

  @override
  String get release_core_more_pane_agent_policy => 'Política do agente';

  @override
  String
  get release_core_more_pane_approvals_checkpoints_browser_access_and_shared_metrics =>
      'Aprovações, pontos de verificação, acesso ao navegador e métricas compartilhadas';

  @override
  String get release_core_more_pane_remote_logs_health_maintenance_and_update =>
      'Logs remotos, integridade, manutenção e atualização';

  @override
  String get release_core_more_pane_schedules => 'Agendamentos';

  @override
  String get release_core_more_pane_all_profiles_blueprints_catch_up_and_stop =>
      'Todos os perfis, modelos de tarefa, recuperação de execuções perdidas e parada';

  @override
  String get release_core_more_pane_memory_graph => 'Grafo de memória';

  @override
  String get release_core_more_pane_timeline_edits_and_memory_providers =>
      'Linha do tempo, edições e provedores de memória';

  @override
  String get release_core_more_pane_providers_and_routes =>
      'Provedores e rotas';

  @override
  String get release_core_more_pane_keys_endpoints_delegation_and_mixtures =>
      'Chaves, endpoints, delegação e combinações';

  @override
  String get release_core_more_pane_credits_and_plans => 'Créditos e planos';

  @override
  String
  get release_core_more_pane_consented_nous_billing_when_the_account_allows_it =>
      'Cobrança da Nous com seu consentimento, quando permitida pela conta';

  @override
  String
  get release_core_fleet_screen_this_gateway_does_not_offer_this_service =>
      'Este Gateway não oferece este serviço.';

  @override
  String
  get release_core_fleet_screen_sign_in_or_permission_required_on_this_gateway =>
      'É necessário entrar ou ter permissão neste Gateway.';

  @override
  String get release_core_fleet_screen_a_secure_gateway_address_is_required =>
      'É necessário um endereço seguro do Gateway.';

  @override
  String
  get release_core_fleet_screen_the_owner_changed_refresh_before_continuing =>
      'O proprietário mudou. Atualize antes de continuar.';

  @override
  String
  get release_core_fleet_screen_could_not_verify_the_operation_check_the_gateway =>
      'Não foi possível verificar a operação. Verifique o Gateway e atualize.';

  @override
  String get release_core_fleet_screen_verified_ssh => 'SSH verificado';

  @override
  String
  get release_core_fleet_screen_confirm_a_host_key_inspect_a_remote_service =>
      'Confirme uma chave de host, inspecione um serviço remoto ou abra seu shell';

  @override
  String get release_core_fleet_screen_cloud_and_desktop_webapp =>
      'Cloud e aplicativo web do Desktop';

  @override
  String get release_core_fleet_screen_register_an_existing_gateway_or_webapp =>
      'Cadastrar um Gateway ou aplicativo web existente';

  @override
  String
  get release_core_fleet_screen_sign_in_to_its_address_nothing_is_hosted =>
      'Entre pelo endereço dele. Nada é hospedado neste dispositivo.';

  @override
  String get release_core_fleet_screen_fleet_updates => 'Atualizações da frota';

  @override
  String get release_core_fleet_screen_refresh_roster => 'Atualizar lista';

  @override
  String release_core_fleet_screen_disconnect(String gateway) {
    return 'Desconectar $gateway';
  }

  @override
  String get release_core_fleet_screen_open_this_gateway_on_launch =>
      'Abrir este Gateway ao iniciar';

  @override
  String
  get release_core_fleet_screen_primary_for_ares_does_not_change_the_last =>
      'Principal para o Ares; não altera o último Gateway usado.';

  @override
  String get release_core_fleet_screen_reconnect_in_fleet_on_launch =>
      'Reconectar à frota ao iniciar';

  @override
  String get release_core_fleet_screen_no_sessions_for_this_profile =>
      'Nenhuma sessão para este perfil.';

  @override
  String get release_core_fleet_screen_more_sessions => 'Mais sessões';

  @override
  String get release_core_fleet_screen_this_gateway_was_disconnected =>
      'Este Gateway foi desconectado.';

  @override
  String
  get release_core_fleet_screen_some_conversation_data_could_not_be_loaded =>
      'Não foi possível carregar alguns dados da conversa.';

  @override
  String get release_core_fleet_screen_message_this_session =>
      'Enviar mensagem a esta sessão';

  @override
  String get release_core_fleet_screen_send_to_this_session =>
      'Enviar a esta sessão';

  @override
  String get release_core_fleet_updates_screen_update_these_remote_gateways =>
      'Atualizar estes Gateways remotos?';

  @override
  String
  release_core_fleet_updates_screen_this_can_restart_the_backend_and_interrupt_other(
    String gateways,
  ) {
    return 'Isso pode reiniciar o backend e interromper outros usuários. Não atualizará o Ares.\n\n$gateways';
  }

  @override
  String get release_core_fleet_updates_screen_update_listed_gateways =>
      'Atualizar Gateways listados';

  @override
  String
  get release_core_fleet_updates_screen_checks_connected_gateways_cloud_is_platform_managed_entries =>
      'Verifica os Gateways conectados. O Cloud é gerenciado pela plataforma; entradas sem comprovação de origem do cadastro são excluídas.';

  @override
  String get release_core_fleet_updates_screen_check_connected_gateways =>
      'Verificar Gateways conectados';

  @override
  String get release_core_fleet_updates_screen_read_update_receipt =>
      'Ler comprovante de atualização';

  @override
  String get release_core_fleet_updates_screen_review_eligible_updates =>
      'Revisar atualizações elegíveis';

  @override
  String
  get release_core_fleet_webapp_screen_account_changed_reopen_this_page =>
      'Conta alterada. Reabra esta página.';

  @override
  String
  get release_core_fleet_webapp_screen_set_the_webapp_s_primary_gateway =>
      'Definir o Gateway principal do aplicativo web?';

  @override
  String
  release_core_fleet_webapp_screen_this_changes_the_shared_registry_not_the_last(
    String webapp,
    String gateway,
    String id,
  ) {
    return '$webapp → $gateway ($id)\nIsso altera o registro compartilhado, não o último Gateway usado.';
  }

  @override
  String get release_core_fleet_webapp_screen_set_primary =>
      'Definir como principal';

  @override
  String get release_core_fleet_webapp_screen_serving_profile =>
      'Perfil que atende às solicitações';

  @override
  String get release_core_fleet_webapp_screen_hermes_cloud => 'Hermes Cloud';

  @override
  String get release_core_fleet_webapp_screen_discover_signed_in_agents =>
      'Descobrir agentes conectados à conta';

  @override
  String release_core_fleet_webapp_screen_organisation(String organisation) {
    return 'Organização: $organisation';
  }

  @override
  String get release_core_fleet_webapp_screen_no_agents_available =>
      'Nenhum agente disponível.';

  @override
  String get release_core_fleet_webapp_screen_existing_desktop_webapp =>
      'Aplicativo web do Desktop existente';

  @override
  String
  get release_core_fleet_webapp_screen_check_gateway_and_web_access_status =>
      'Verificar status do Gateway e do acesso web';

  @override
  String
  get release_core_fleet_webapp_screen_these_settings_belong_to_the_machine_serving_this =>
      'Estas configurações pertencem à máquina que hospeda este aplicativo web. Publicações e reinicializações não são ações remotas.';

  @override
  String get release_core_fleet_webapp_screen_read_webapp_gateway_registry =>
      'Ler registro de Gateways do aplicativo web';

  @override
  String get release_core_fleet_webapp_screen_last_used => 'Último usado';

  @override
  String get release_core_fleet_webapp_screen_primary => 'Principal';

  @override
  String release_core_fleet_webapp_screen_set_primary_2(String gateway) {
    return 'Definir como principal: $gateway';
  }

  @override
  String get release_core_fleet_webapp_screen_read_shared_display_preferences =>
      'Ler preferências de exibição compartilhadas';

  @override
  String
  get release_core_fleet_webapp_screen_chat_text_direction_on_this_webapp_and_desktop =>
      'Direção do texto do chat neste aplicativo web e no Desktop';

  @override
  String release_core_schedule_desk_screen_created_on(
    String job,
    String profile,
  ) {
    return '$job criado em $profile.';
  }

  @override
  String
  get release_core_schedule_desk_screen_the_list_covers_every_profile_on_this_gateway =>
      'A lista abrange todos os perfis deste Gateway. Parada, pausa, recuperação de execuções perdidas, entrega e modelos de tarefa são enviados ao perfil proprietário da tarefa.';

  @override
  String get release_core_schedule_desk_screen_a_run_is_in_progress =>
      'Há uma execução em andamento';

  @override
  String get release_core_schedule_desk_screen_no_current_run =>
      'Nenhuma execução em andamento';

  @override
  String release_core_schedule_desk_screen_stop_requested_for(String job) {
    return 'Parada solicitada para $job.';
  }

  @override
  String release_core_schedule_desk_screen_no_run_was_in_flight_for(
    String job,
  ) {
    return 'Não havia execução em andamento para $job.';
  }

  @override
  String get release_core_schedule_desk_screen_stop_current_run =>
      'Parar execução atual';

  @override
  String get release_core_schedule_desk_screen_pause_future_runs =>
      'Pausar execuções futuras';

  @override
  String get release_core_schedule_desk_screen_resume_future_runs =>
      'Retomar execuções futuras';

  @override
  String get release_core_schedule_desk_screen_catch_up_default =>
      'Padrão para execuções perdidas';

  @override
  String get release_core_schedule_desk_screen_run_one_missed =>
      'Executar uma tarefa perdida';

  @override
  String get release_core_schedule_desk_screen_skip_missed =>
      'Ignorar execuções perdidas';

  @override
  String get release_core_schedule_desk_screen_blueprint_recipes =>
      'Receitas de modelos de tarefa';

  @override
  String get release_core_schedule_desk_screen_profile_for_the_new_job =>
      'Perfil para a nova tarefa';

  @override
  String release_core_schedule_desk_screen_create(String blueprint) {
    return 'Criar $blueprint';
  }

  @override
  String get release_core_schedule_desk_screen_loading_delivery_targets =>
      'Carregando destinos de entrega';

  @override
  String release_core_schedule_desk_screen_no_home_channel(String target) {
    return '$target (sem canal principal)';
  }

  @override
  String release_core_memory_graph_screen_edit(String label) {
    return 'Editar $label';
  }

  @override
  String get release_core_memory_graph_screen_content => 'Conteúdo';

  @override
  String get release_core_memory_graph_screen_archive_skill =>
      'Arquivar habilidade';

  @override
  String get release_core_memory_graph_screen_delete_memory =>
      'Excluir memória';

  @override
  String release_core_memory_graph_screen_archive_on_it_can_be_restored_on_the(
    String label,
    String profile,
  ) {
    return 'Arquivar $label em $profile? É possível restaurar no host com o Curator.';
  }

  @override
  String release_core_memory_graph_screen_delete_from_this_removes_that_memory(
    String label,
    String profile,
  ) {
    return 'Excluir $label de $profile? Isso remove essa memória.';
  }

  @override
  String get release_core_memory_graph_screen_filter => 'Filtro';

  @override
  String get release_core_memory_graph_screen_timeline => 'Linha do tempo';

  @override
  String get release_core_memory_graph_screen_play_timeline =>
      'Reproduzir linha do tempo';

  @override
  String get release_core_memory_graph_screen_layout_code => 'Código do layout';

  @override
  String get release_core_memory_graph_screen_external_memory_providers =>
      'Provedores externos de memória';

  @override
  String
  get release_core_memory_graph_screen_a_value_is_stored_leave_blank_to_keep =>
      'Há um valor armazenado. Deixe em branco para mantê-lo.';

  @override
  String get release_core_memory_graph_screen_save_provider =>
      'Salvar provedor';

  @override
  String release_core_workspace_profiles_screen_applies_to(String profile) {
    return 'Aplica-se a: $profile';
  }

  @override
  String get release_core_workspace_profiles_screen_choose_another_profile =>
      'Escolher outro perfil';

  @override
  String
  get release_core_workspace_profiles_screen_could_not_verify_the_selected_profile_on_this =>
      'Não foi possível verificar o perfil selecionado neste Gateway.';

  @override
  String get release_core_workspace_profiles_screen_create_profile =>
      'Criar perfil';

  @override
  String get release_core_workspace_profiles_screen_new_profile_id =>
      'ID do novo perfil';

  @override
  String get release_core_assets_screen_links => 'Links';

  @override
  String get release_core_workspace_picker_no_matching_items =>
      'Nenhum item correspondente.';

  @override
  String get release_core_workspace_picker_save_layout => 'Salvar layout';

  @override
  String get release_core_workspace_picker_layout_name => 'Nome do layout';

  @override
  String
  get release_core_workspace_popout_this_chat_already_has_a_pop_out_window =>
      'Este chat já tem uma janela separada.';

  @override
  String
  get release_core_workspace_popout_could_not_open_this_saved_chat_check_the =>
      'Não foi possível abrir este chat salvo. Verifique a conexão e tente novamente.';

  @override
  String
  get release_core_popout_bootstrap_use_the_main_window_to_change_your_connection =>
      'Use a janela principal para alterar sua conexão.';

  @override
  String get release_core_guarded_save_refused =>
      'Este arquivo não pode ser salvo pelo Gateway';

  @override
  String get release_core_guarded_save_unavailable =>
      'O salvamento protegido não está disponível neste Gateway';

  @override
  String release_core_git_files_changed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos alterados neste turno',
      one: '1 arquivo alterado neste turno',
    );
    return '$_temp0';
  }

  @override
  String release_core_git_entries_omitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count itens do Git foram omitidos porque não era seguro exibi-los.',
      one: '1 item do Git foi omitido porque não era seguro exibi-lo.',
    );
    return '$_temp0';
  }

  @override
  String get release_core_git_staged => 'Preparado';

  @override
  String get release_core_session_sort_recent => 'Atividade recente';

  @override
  String get release_core_session_sort_created => 'Criados mais recentemente';

  @override
  String get release_core_session_sort_status => 'Em execução primeiro';

  @override
  String get release_core_session_sort_tokens => 'Mais tokens';

  @override
  String get release_core_session_sort_cost => 'Maior custo';

  @override
  String get release_core_session_group_standard => 'Agrupamento padrão';

  @override
  String get release_core_session_group_status => 'Agrupar por status';

  @override
  String get release_core_session_group_project => 'Agrupar por projeto';

  @override
  String release_core_session_tokens(int count) {
    return '$count tokens';
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
      'O envio cria um novo turno';

  @override
  String release_core_image_recovery_metadata(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imagens · $date',
      one: '1 imagem · $date',
    );
    return '$_temp0';
  }

  @override
  String release_core_discovery_scanning(String state) {
    return 'Varredura: $state';
  }

  @override
  String get release_core_discovery_enabled => 'ativada';

  @override
  String get release_core_discovery_disabled => 'desativada';

  @override
  String get release_core_discovery_none => 'nenhum';

  @override
  String release_core_discovery_roots(String paths) {
    return 'Diretórios raiz da varredura: $paths';
  }

  @override
  String release_core_discovery_excluded(String paths) {
    return 'Subárvores excluídas: $paths';
  }

  @override
  String release_core_discovery_repository_sessions(String path, int count) {
    return '$path\nSessões: $count';
  }

  @override
  String get release_core_projects_local_only =>
      'Este Gateway do Hermes é mais antigo que os projetos do servidor, então os chats ficam agrupados apenas neste dispositivo. Atualize o Hermes para compartilhar os mesmos projetos entre seus dispositivos.';

  @override
  String get release_core_fleet_no_address =>
      'Ainda não há endereço do Gateway';

  @override
  String release_core_fleet_diagnostics(String version, String access) {
    return 'Gateway $version · $access';
  }

  @override
  String get release_core_schedule_builtin => 'integrado';

  @override
  String get release_core_memory_gateway_profile => 'Gateway';

  @override
  String release_core_memory_profile_summary(String profile, String gateway) {
    return 'Perfil $profile em $gateway. O código de compartilhamento armazena apenas zoom, tempo e filtros.';
  }

  @override
  String release_core_memory_layers_summary(
    int memoryBytes,
    int userBytes,
    String provider,
  ) {
    return 'Memória integrada: $memoryBytes bytes; do usuário: $userBytes bytes. Provedor ativo: $provider.';
  }

  @override
  String get release_core_memory_kind_all => 'Todos';

  @override
  String get release_core_memory_kind_skill => 'Habilidades';

  @override
  String get release_core_memory_kind_memory => 'Memória';

  @override
  String get release_core_workspace_failure_stale => 'conexão alterada';

  @override
  String get release_core_workspace_failure_unbound =>
      'nenhum diretório de trabalho verificado';

  @override
  String get release_core_workspace_failure_denied => 'permissão negada';

  @override
  String get release_core_workspace_failure_ineligible =>
      'operação não permitida para este arquivo';

  @override
  String get release_core_workspace_failure_unsupported =>
      'não compatível com este Gateway';

  @override
  String get release_core_workspace_failure_mismatch =>
      'estado remoto alterado';

  @override
  String get release_core_workspace_failure_invalid =>
      'resposta inválida do Gateway';

  @override
  String get release_core_workspace_failure_insecure =>
      'conexão segura necessária';

  @override
  String get release_core_workspace_failure_unavailable =>
      'Gateway indisponível';

  @override
  String get release_core_queue_state_queued => 'Na fila';

  @override
  String get release_core_queue_state_started => 'Iniciado';

  @override
  String get release_core_queue_state_unknown => 'Resultado desconhecido';

  @override
  String get release_core_unknown_state => 'Desconhecido';

  @override
  String get release_core_fleet_state_idle => 'Offline';

  @override
  String get release_core_fleet_state_connected => 'Conectado';

  @override
  String get release_core_fleet_state_reconnecting => 'Reconectando…';

  @override
  String get release_core_fleet_state_sessionExpired => 'Desconectado da conta';

  @override
  String get release_core_fleet_state_failed => 'Falha na conexão';

  @override
  String release_core_workspace_operation_failed(String reason) {
    return 'Não foi possível confirmar a operação do Gateway: $reason.';
  }

  @override
  String get release_core_workspace_invalid_data =>
      'Não foi possível verificar os dados ou a entrada. Revise e tente novamente.';

  @override
  String
  get release_core_parallel_workspace_layout_changed_in_this_window_but_could_not =>
      'O layout foi alterado nesta janela, mas não pôde ser salvo.';

  @override
  String get release_core_parallel_workspace_first_pane => 'Primeiro painel';

  @override
  String get release_core_parallel_workspace_second_pane => 'Segundo painel';

  @override
  String get release_core_parallel_workspace_unavailable_page =>
      'Página indisponível';

  @override
  String release_core_parallel_workspace_close_a_tab_first_maximum(
    String maximum,
  ) {
    return 'Feche uma aba primeiro (máximo de $maximum).';
  }

  @override
  String get release_core_parallel_workspace_dock_beside_current_pane =>
      'Encaixar ao lado do painel atual';

  @override
  String get release_core_parallel_workspace_add_chat => 'Adicionar chat';

  @override
  String
  get release_core_parallel_workspace_action_failed_check_the_connection_and_try_again =>
      'A ação falhou. Verifique a conexão e tente novamente.';

  @override
  String
  get release_core_parallel_workspace_close_a_tab_before_reopening_another =>
      'Feche uma aba antes de reabrir outra.';

  @override
  String release_core_parallel_workspace_replace_layout(String name) {
    return 'Substituir o layout “$name”?';
  }

  @override
  String
  get release_core_parallel_workspace_layout_limit_reached_replace_an_existing_layout =>
      'Limite de layouts atingido. Substitua um layout existente.';

  @override
  String get release_core_parallel_workspace_restore_layout =>
      'Restaurar layout';

  @override
  String get release_core_parallel_workspace_workspace_options =>
      'Opções da área de trabalho';

  @override
  String get release_core_parallel_workspace_dock_another_pane =>
      'Encaixar outro painel';

  @override
  String get release_core_parallel_workspace_swap_panes =>
      'Trocar painéis de lugar';

  @override
  String get release_core_parallel_workspace_undock_second_pane =>
      'Desencaixar segundo painel';

  @override
  String get release_core_parallel_workspace_arrange_side_by_side =>
      'Organizar lado a lado';

  @override
  String get release_core_parallel_workspace_arrange_top_to_bottom =>
      'Organizar de cima para baixo';

  @override
  String release_core_parallel_workspace_change_split_size(String percent) {
    return 'Alterar proporção da divisão ($percent%)';
  }

  @override
  String get release_core_parallel_workspace_focus_pane_full_screen =>
      'Focar painel em tela cheia';

  @override
  String get release_core_parallel_workspace_open_chat_in_new_window =>
      'Abrir chat em nova janela';

  @override
  String get release_core_parallel_workspace_hide_pane_keep_running =>
      'Ocultar painel (manter em execução)';

  @override
  String get release_core_parallel_workspace_previous_tab => 'Aba anterior';

  @override
  String get release_core_parallel_workspace_next_tab => 'Próxima aba';

  @override
  String get release_core_parallel_workspace_move_tab_left =>
      'Mover aba para a esquerda';

  @override
  String get release_core_parallel_workspace_move_tab_right =>
      'Mover aba para a direita';

  @override
  String get release_core_parallel_workspace_reload_current_tab =>
      'Recarregar aba atual';

  @override
  String get release_core_parallel_workspace_close_tab => 'Fechar aba';

  @override
  String get release_core_parallel_workspace_close_other_tabs =>
      'Fechar outras abas';

  @override
  String get release_core_parallel_workspace_close_tabs_to_the_right =>
      'Fechar abas à direita';

  @override
  String get release_core_parallel_workspace_close_all_tabs =>
      'Fechar todas as abas';

  @override
  String get release_core_parallel_workspace_reopen_closed_tab =>
      'Reabrir aba fechada';

  @override
  String get release_core_parallel_workspace_save_named_layout =>
      'Salvar layout com nome';

  @override
  String get release_core_parallel_workspace_restore_named_layout =>
      'Restaurar layout com nome';

  @override
  String get release_core_parallel_workspace_refresh_chat_list =>
      'Atualizar lista de chats';

  @override
  String get release_core_parallel_workspace_workspace_tools =>
      'Ferramentas da área de trabalho';

  @override
  String get release_core_parallel_workspace_choose_a_chat_for_this_pane =>
      'Escolha um chat para este painel';

  @override
  String release_core_parallel_workspace_choose_chat_for(String pane) {
    return 'Escolher chat para $pane';
  }

  @override
  String get release_core_parallel_workspace_add_a_chat_to_start_a_workspace =>
      'Adicione um chat para iniciar uma área de trabalho.';

  @override
  String get release_core_parallel_workspace_select_a_tab_to_show_its_pane =>
      'Selecione uma aba para mostrar seu painel.';

  @override
  String get release_core_parallel_workspace_parallel_workspace =>
      'Área de trabalho paralela';

  @override
  String get release_core_parallel_workspace_show_workspace =>
      'Mostrar área de trabalho';

  @override
  String get release_core_parallel_workspace_could_not_load_chats_retry =>
      'Não foi possível carregar os chats. Tentar novamente';

  @override
  String release_core_parallel_workspace_close(String pane) {
    return 'Fechar $pane';
  }

  @override
  String release_core_parallel_workspace_switch_pane(String pane) {
    return 'Trocar painel: $pane';
  }

  @override
  String get release_core_workspace_registry_session_id_copied =>
      'ID da sessão copiado.';

  @override
  String get release_core_workspace_registry_chat_details => 'Detalhes do chat';

  @override
  String get release_core_workspace_registry_server_default =>
      'Padrão do servidor';

  @override
  String get release_core_workspace_registry_session_id => 'ID da sessão';

  @override
  String get release_core_workspace_registry_title => 'Título';

  @override
  String get release_core_workspace_label_terminals => 'Terminais';

  @override
  String get release_core_workspace_label_copy_id => 'Copiar ID da sessão';

  @override
  String get release_core_workspace_label_contributions => 'Contribuições';

  @override
  String get release_core_workspace_owner_inactive =>
      'O proprietário desta área de trabalho não está mais ativo.';

  @override
  String get release_core_workspace_select_chat =>
      'Selecione um chat primeiro.';

  @override
  String get release_core_workspace_chat_unavailable =>
      'Este chat não está disponível para esta conexão.';

  @override
  String get release_core_workspace_page_unavailable =>
      'Esta página não está disponível para esta conexão.';

  @override
  String release_core_client_queue_count(int count) {
    return '$count na fila';
  }

  @override
  String release_core_client_queue_paused_count(int count) {
    return '$count na fila — pausada';
  }

  @override
  String release_core_git_diff_truncated(String diff) {
    return '$diff\n… truncado';
  }

  @override
  String get release_core_search_no_models =>
      'O Hermes não retornou nenhum modelo configurado e selecionável.';

  @override
  String get release_core_chat_archive_unavailable =>
      'A ação de arquivar chat está indisponível.';

  @override
  String get release_core_chat_pin_unconfirmed =>
      'O estado de fixação não foi confirmado.';

  @override
  String get release_core_chat_archive_unconfirmed =>
      'O estado de arquivamento não foi confirmado.';

  @override
  String get release_core_chat_archive_history_unavailable =>
      'Histórico arquivado indisponível';

  @override
  String get release_core_quick_chat_history_unavailable =>
      'Histórico de chats rápidos indisponível';

  @override
  String get release_core_chat_project_ownership_unavailable =>
      'Propriedade do projeto indisponível';

  @override
  String get release_core_chat_unknown_project => 'Projeto desconhecido';

  @override
  String get release_core_chat_local_search_fallback =>
      'Busca de mensagens indisponível. Exibindo resultados locais.';

  @override
  String release_core_fleet_update_eligible(String version) {
    return 'Elegível · $version';
  }

  @override
  String get release_core_fleet_update_state_1 => 'Ignorado: mesma instalação';

  @override
  String get release_core_fleet_update_state_2 => 'Não verificado';

  @override
  String get release_core_fleet_update_state_3 =>
      'Ignorado: gerenciado pelo Cloud';

  @override
  String get release_core_fleet_update_state_4 =>
      'Ignorado: não cadastrado como Gateway direto';

  @override
  String get release_core_fleet_update_state_5 =>
      'Ignorado: desconectado ou ocupado';

  @override
  String get release_core_fleet_update_state_6 =>
      'Nenhuma atualização aplicável';

  @override
  String get release_core_fleet_update_state_7 =>
      'Não foi possível verificar a elegibilidade';

  @override
  String get release_core_fleet_update_state_8 =>
      'Ignorado: desatualizado, ocupado ou já solicitado';

  @override
  String get release_core_fleet_update_state_9 => 'Solicitando';

  @override
  String get release_core_fleet_update_state_10 =>
      'Aceito; comprovante indisponível';

  @override
  String get release_core_fleet_update_state_11 =>
      'Aceito; aguardando comprovante';

  @override
  String get release_core_fleet_update_state_12 =>
      'Ignorado: há um chat em execução nesta instalação';

  @override
  String get release_core_fleet_update_state_13 =>
      'Não confirmado; não reenviar automaticamente';

  @override
  String get release_core_fleet_update_state_14 =>
      'Reconecte para verificar o comprovante';

  @override
  String get release_core_fleet_update_state_15 => 'Comprovante indisponível';

  @override
  String get release_core_fleet_update_state_16 =>
      'Aguardando comprovante correspondente';

  @override
  String get release_core_fleet_update_state_17 =>
      'Atualizado; acompanhamento necessário';

  @override
  String get release_core_fleet_update_state_19 => 'Parcialmente atualizado';

  @override
  String get release_core_fleet_update_state_20 => 'A atualização falhou';

  @override
  String get release_core_fleet_update_state_21 => 'Não confirmado';

  @override
  String get release_core_cloud_status_ready => 'Pronto';

  @override
  String get release_core_cloud_status_online => 'Online';

  @override
  String get release_core_cloud_status_stopped => 'Parado';

  @override
  String get release_core_cloud_status_error => 'Erro';

  @override
  String get ng_release_more_contributions_subtitle =>
      'Cartões de resposta revisados para esta conexão';

  @override
  String get ng_release_more_gateway_fleet => 'Frota de Gateways';

  @override
  String get ng_release_more_memory_graph => 'Grafo de memória';

  @override
  String get ng_release_more_memory_graph_subtitle =>
      'Linha do tempo, edições e provedores de memória';

  @override
  String get ng_release_more_capabilities_subtitle =>
      'Instale e gerencie habilidades, plugins, conectores e backends de ferramentas';

  @override
  String get ng_release_more_browser_vault => 'Cofre do navegador';

  @override
  String get ng_release_more_browser_vault_subtitle =>
      'Logins de sites, endereços, cartões e fontes de credenciais';

  @override
  String get ng_release_more_agent_policy => 'Política do agente';

  @override
  String get ng_release_more_agent_policy_subtitle =>
      'Aprovações, pontos de verificação, acesso ao navegador e métricas compartilhadas';

  @override
  String get ng_release_more_schedules => 'Agendamentos';

  @override
  String get ng_release_more_schedules_subtitle =>
      'Todos os perfis, modelos de tarefa, recuperação de execuções perdidas e parada';

  @override
  String get ng_release_more_host_subtitle =>
      'Logs remotos, integridade, manutenção e atualização';

  @override
  String get ng_release_more_providers_routes => 'Provedores e rotas';

  @override
  String get ng_release_more_providers_routes_subtitle =>
      'Chaves, endpoints, delegação e combinações';

  @override
  String get ng_release_more_credits_plans => 'Créditos e planos';

  @override
  String get ng_release_more_credits_plans_subtitle =>
      'Cobrança da Nous com seu consentimento, quando permitida pela conta';

  @override
  String get ng_release_sign_in_or => 'ou';

  @override
  String ng_release_deployment_sign_in_hint(String message) {
    return '$message Você ainda pode entrar com um token de sessão da implantação na próxima etapa.';
  }

  @override
  String get ng_release_message_search_unavailable =>
      'Busca de mensagens indisponível. Exibindo resultados locais.';

  @override
  String ng_release_insights_days(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias',
      one: '$days dia',
    );
    return '$_temp0';
  }

  @override
  String get ng_release_signed_in_you => 'você';

  @override
  String get release_chat_unsent_prompt_gone =>
      'Aquele prompt não enviado não está mais na fila.';

  @override
  String ng_release_attachment_not_attached(String name) {
    return 'O Gateway não anexou $name.';
  }

  @override
  String get ng_release_gateway_not_connected =>
      'Ainda não conectado ao Gateway.';

  @override
  String get ng_release_gateway_unreachable =>
      'Não foi possível acessar o Gateway.';

  @override
  String get ng_release_projects_scope_changed =>
      'O escopo de projetos não está mais selecionado';

  @override
  String get ng_release_missing_providers => 'Provedores ausentes';

  @override
  String get ng_release_missing_tasks => 'Tarefas ausentes';

  @override
  String ng_release_age_minutes(int count) {
    return '${count}min';
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
    return '$count bi';
  }

  @override
  String ng_release_compact_millions(String count) {
    return '$count mi';
  }

  @override
  String ng_release_compact_thousands(String count) {
    return '$count mil';
  }

  @override
  String ng_release_token_thousands(String count) {
    return '$count mil';
  }

  @override
  String ng_release_elapsed_minutes_seconds(int minutes, int seconds) {
    return '${minutes}min ${seconds}s';
  }

  @override
  String ng_release_elapsed_seconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String get ng_release_notification_foreground => 'O Ares estava na tela';

  @override
  String get ng_release_notification_stopped => 'o turno foi interrompido';

  @override
  String get ng_release_more_parallel_workspace => 'Área de trabalho paralela';

  @override
  String get ng_release_more_parallel_workspace_subtitle =>
      'Abra vários chats em abas ou lado a lado.';

  @override
  String get release_chat_unknown_model => 'desconhecido';

  @override
  String release_chat_profile_default(String model) {
    return 'Padrão do perfil: $model';
  }

  @override
  String release_chat_profile_default_provider(String model, String provider) {
    return 'Padrão do perfil: $model • $provider';
  }

  @override
  String get release_chat_choose_provider =>
      'Este modelo está disponível em vários provedores. Escolha um provedor para continuar.';

  @override
  String get release_chat_slash_needs_gateway =>
      'Comandos de barra precisam do Gateway do Desktop';

  @override
  String get release_chat_recovering_without_resending =>
      'Recuperando sem reenviar';

  @override
  String get release_chat_live_request_unreachable =>
      'Desculpe, não consegui acessar o Hermes para essa solicitação.';

  @override
  String release_chat_live_working(String tool) {
    return 'O Hermes está trabalhando: $tool. Ainda não terminou.';
  }

  @override
  String get release_chat_live_finished_without_spoken_result =>
      'O Hermes concluiu essa solicitação sem um resultado falado.';

  @override
  String get release_chat_reply_language_unavailable =>
      'O idioma de resposta selecionado está indisponível';

  @override
  String get release_chat_reply_voice_unavailable =>
      'A voz de resposta selecionada está indisponível';

  @override
  String get release_chat_reply_voice_configuration_unavailable =>
      'A configuração de voz de resposta está indisponível';

  @override
  String get release_chat_notification_review_action =>
      'Abra o chat para revisar a ação solicitada.';

  @override
  String get release_chat_notification_respond => 'Abra o chat para responder.';

  @override
  String get release_chat_start_new_main_window =>
      'Inicie um novo chat na janela principal.';

  @override
  String get release_chat_no_desktop_gateway => 'Sem Gateway do Desktop';

  @override
  String get release_chat_attachment_preparation_cancelled =>
      'A preparação do anexo foi cancelada.';

  @override
  String get release_chat_approval_authority_revoked =>
      'A autoridade de aprovação foi revogada.';

  @override
  String get release_chat_gateway_session_disconnected =>
      'A sessão do Gateway do Desktop não está mais conectada';

  @override
  String get release_chat_stop_requested =>
      'Parada solicitada. Aguardando o Hermes terminar.';

  @override
  String release_chat_stop_request_failed(String error) {
    return 'Não foi possível solicitar a parada: $error';
  }

  @override
  String get release_chat_queued_prompt_not_sent =>
      'O prompt da fila não foi enviado.';

  @override
  String get release_chat_running_turn_unreachable =>
      'Não foi possível acessar o turno em andamento. Reconectando sem reenviar.';

  @override
  String get release_chat_wait_for_composer =>
      'Aguarde o campo de mensagem ficar disponível.';

  @override
  String get release_chat_find_in_transcript => 'Buscar na transcrição';

  @override
  String get release_chat_open_browser_preview => 'Abrir prévia do navegador';

  @override
  String get release_chat_more_tools => 'Mais ferramentas do chat';

  @override
  String get release_chat_queue_until_finished =>
      'Colocar na fila até este turno terminar';

  @override
  String get release_chat_format_bold => 'Negrito';

  @override
  String get release_chat_format_italic => 'Itálico';

  @override
  String get ng_release_chat_gateway_queue_requirements =>
      'A fila do Gateway precisa de um chat vinculado e de um prompt somente de texto.';

  @override
  String get ng_release_chat_start_new_main_screen =>
      'Inicie um novo chat pela tela principal de chats.';

  @override
  String get ng_release_chat_image => 'imagem';

  @override
  String ng_release_chat_tool_seconds(String seconds) {
    return '${seconds}s';
  }

  @override
  String get release_preview_chat_changed =>
      'O chat mudou. Reconecte a prévia para continuar.';

  @override
  String get release_preview_authenticating_chat => 'Autenticando chat…';

  @override
  String release_preview_unavailable_reason(String reason) {
    return 'Prévia indisponível: $reason';
  }

  @override
  String get release_preview_operation_failed => 'A operação da prévia falhou.';

  @override
  String get release_preview_added_to_draft =>
      'Adicionado ao rascunho. Nada foi enviado.';

  @override
  String get release_preview_open_site_title => 'Abrir este site?';

  @override
  String release_preview_open_site_body(String origin) {
    return '$origin\n\nO modo de leitura carrega apenas este documento. Ele não compartilha cookies, dados de login nem a página com o Hermes.';
  }

  @override
  String get release_preview_open_site => 'Abrir site';

  @override
  String get release_preview_discard_pins_title =>
      'Descartar marcações não adicionadas ao rascunho?';

  @override
  String get release_preview_keep_pins => 'Manter marcações';

  @override
  String get release_preview_share_page_title =>
      'Compartilhar esta página com este chat?';

  @override
  String release_preview_share_page_body(String origin) {
    return 'O Hermes poderá ler o texto exibido e a lista de elementos de $origin, além de rolar este painel. A navegação encerra o compartilhamento. Formulários e credenciais não são compartilhados.';
  }

  @override
  String get release_preview_share_page => 'Compartilhar página';

  @override
  String release_preview_comment_number(int number) {
    return 'Comentário nº $number';
  }

  @override
  String get release_preview_note => 'Nota';

  @override
  String get release_preview_keep_pin => 'Manter marcação';

  @override
  String get release_preview_title => 'Prévia do navegador';

  @override
  String get release_preview_hide => 'Ocultar prévia';

  @override
  String get release_preview_close_and_forget => 'Fechar e esquecer página';

  @override
  String get release_preview_site_address => 'Endereço do site';

  @override
  String get release_preview_go_to_address => 'Ir para o endereço';

  @override
  String get release_preview_forward => 'Avançar';

  @override
  String get release_preview_reload => 'Recarregar';

  @override
  String get release_preview_share_with_hermes =>
      'Compartilhar página com o Hermes';

  @override
  String get release_preview_stop_sharing => 'Parar de compartilhar página';

  @override
  String get release_preview_annotate => 'Anotar elemento ou região';

  @override
  String get release_preview_reader_console => 'Console do modo de leitura';

  @override
  String get release_preview_reconnect => 'Reconectar prévia';

  @override
  String get release_preview_reader_mode_help =>
      'Modo de leitura: HTML e texto. Sem scripts, recursos incorporados nem perfil de navegador conectado à conta.';

  @override
  String release_preview_sharing_origin(String origin) {
    return 'Compartilhando modo de leitura com este chat: $origin';
  }

  @override
  String get release_preview_annotation_help =>
      'Toque em um elemento ou arraste para marcar uma região e comentar.';

  @override
  String get release_preview_reader_requests =>
      'Requisições do modo de leitura (JavaScript desativado)';

  @override
  String release_preview_selected_requests(int count) {
    return '$count selecionados · JavaScript desativado';
  }

  @override
  String get release_preview_copy_all => 'Copiar tudo';

  @override
  String get release_preview_copy_selected => 'Copiar selecionados';

  @override
  String get release_preview_add_log_to_draft => 'Adicionar log ao rascunho';

  @override
  String release_preview_requests_draft(String log) {
    return 'Requisições do modo de leitura:\n$log';
  }

  @override
  String release_preview_add_pins_to_draft(int count) {
    return 'Adicionar $count ao rascunho';
  }

  @override
  String release_preview_request_loaded(String origin, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos do modo de leitura',
      one: '$count elemento do modo de leitura',
    );
    return 'HTTP 200 · $origin · $_temp0';
  }

  @override
  String release_preview_annotation_intro(String origin) {
    return 'Revise estes comentários sobre a prévia de $origin. Os recortes anexados são numerados na mesma ordem.';
  }

  @override
  String get release_preview_reader_region => 'região do modo de leitura';

  @override
  String get release_preview_capture_failed =>
      'Não foi possível capturar estes pixels.';

  @override
  String get release_preview_address_not_approved =>
      'Este endereço está fora da origem aprovada para a prévia.';

  @override
  String get release_preview_page_limit =>
      'A página excede o limite do modo de leitura.';

  @override
  String get release_preview_page_unreadable =>
      'Não foi possível ler a página.';

  @override
  String get release_preview_page_complex =>
      'Esta página é complexa demais para o modo de leitura.';

  @override
  String release_preview_http_failed(int statusCode) {
    return 'HTTP $statusCode. Nenhum redirecionamento ou login foi seguido.';
  }

  @override
  String get release_preview_unsupported_type =>
      'Somente HTML e texto simples podem ser abertos no modo de leitura.';

  @override
  String get release_preview_load_insecure =>
      'Não foi possível carregar o site com segurança.';

  @override
  String get release_preview_crop_limit =>
      'O recorte da prévia excede o limite.';

  @override
  String get release_preview_image_unreadable =>
      'A imagem selecionada está vazia ou ilegível.';

  @override
  String get release_preview_image_budget =>
      'A imagem selecionada excede o limite de 64 MiB do rascunho.';

  @override
  String get release_preview_image_format =>
      'Formato de imagem não compatível. Escolha uma imagem JPEG, PNG ou WebP.';

  @override
  String get release_preview_image_decode =>
      'Não foi possível decodificar com segurança a imagem JPEG, PNG ou WebP selecionada.';

  @override
  String get release_preview_image_sanitize =>
      'Não foi possível remover os metadados desta imagem com segurança. Escolha uma imagem JPEG, PNG ou WebP válida.';

  @override
  String get release_preview_draft_budget =>
      'Os anexos estão limitados a 64 MiB no total por rascunho.';

  @override
  String get release_preview_generic_file_limit =>
      'Arquivos genéricos estão limitados a 16 MiB cada.';

  @override
  String get release_preview_image_not_sanitized =>
      'Os metadados de imagens remotas precisam ser removidos antes do envio.';

  @override
  String get release_preview_stage_failed =>
      'Não foi possível adicionar as evidências da prévia ao rascunho. Tente novamente.';

  @override
  String get release_misc_find_hermes_on_lan => 'Encontrar o Hermes na LAN';

  @override
  String release_misc_discovery_failed(String error) {
    return 'A descoberta falhou: $error';
  }

  @override
  String get release_misc_no_lan_servers =>
      'Nenhum servidor do Hermes encontrado na rede local.';

  @override
  String release_misc_api_key_rejected(String endpoint, int statusCode) {
    return 'A chave de API foi rejeitada por $endpoint (HTTP $statusCode).';
  }

  @override
  String get release_misc_api_key_required =>
      'O servidor exige uma chave de API. Informe sua API_SERVER_KEY.';

  @override
  String release_misc_gateway_not_found(String endpoint) {
    return 'O endpoint $endpoint do Gateway retornou HTTP 404. Verifique o prefixo de caminho do Gateway e as rotas do proxy reverso.';
  }

  @override
  String release_misc_gateway_http_error(String endpoint, int statusCode) {
    return 'O endpoint $endpoint do Gateway retornou HTTP $statusCode.';
  }

  @override
  String release_misc_gateway_unreachable(String endpoint) {
    return 'Não foi possível acessar o endpoint $endpoint do Gateway.';
  }

  @override
  String get release_core_schedule_invalid_delivery_target =>
      'Destino de entrega inválido';

  @override
  String get release_core_file_save_direct_only =>
      'Só é possível salvar um arquivo diretamente no diretório de trabalho.';

  @override
  String get release_core_file_save_hidden =>
      'O gateway não pode salvar arquivos ocultos.';

  @override
  String get rel_admin_choose_provider => 'Escolha um provedor e um modelo.';

  @override
  String get rel_admin_known_effort => 'Escolha um nível de esforço conhecido.';

  @override
  String get rel_admin_endpoint_name_required =>
      'Insira um nome para este endpoint.';

  @override
  String get rel_admin_endpoint_model_required =>
      'Insira o modelo oferecido por este endpoint.';

  @override
  String get rel_admin_known_api_mode =>
      'Escolha Automático ou um modo de API conhecido.';

  @override
  String get rel_admin_endpoint_id_invalid =>
      'Este identificador de endpoint não pode ser usado.';

  @override
  String get rel_admin_endpoint_https =>
      'Use HTTPS para um endpoint remoto ou HTTP em localhost.';

  @override
  String get rel_admin_key_invalid =>
      'Não é possível salvar essa chave de API.';

  @override
  String get rel_admin_response_shape =>
      'A resposta do gateway não correspondeu à estrutura esperada.';

  @override
  String get rel_admin_limits_required =>
      'Insira os limites de iterações, simultaneidade e tempo limite antes de salvar.';

  @override
  String get rel_admin_route_required =>
      'Cada rota precisa de um nome e de um modelo antes de ser salva.';

  @override
  String get rel_admin_route_unique => 'Os nomes das rotas devem ser únicos.';

  @override
  String get rel_admin_route_default_invalid =>
      'A rota padrão deve ser uma das rotas salvas.';

  @override
  String get rel_admin_policy_required =>
      'Escolha uma política com aviso ou silenciosa para referências degradadas.';

  @override
  String get rel_admin_mixture_missing =>
      'O gateway não retornou uma mistura ativa.';

  @override
  String get rel_admin_mixture_slots_required =>
      'Indique um provedor e um modelo para o agregador e para cada referência.';

  @override
  String get rel_admin_chat_id_required =>
      'Insira o ID da conversa à qual esta alteração se aplica.';

  @override
  String rel_admin_http_error(String status) {
    return 'O gateway retornou HTTP $status.';
  }

  @override
  String get rel_admin_response_unreadable =>
      'Não foi possível ler a resposta do gateway.';

  @override
  String get rel_admin_connect_before_change =>
      'Conecte a sessão ativa do gateway antes de alterar o faturamento ou uma conversa.';

  @override
  String get rel_admin_operation_unavailable =>
      'Este gateway não oferece essa operação.';

  @override
  String get rel_admin_key_required => 'Insira a chave a salvar.';

  @override
  String get rel_admin_key_save_failed => 'O gateway não salvou essa chave.';

  @override
  String get rel_admin_key_clear_required =>
      'Escolha uma chave de provedor para apagar.';

  @override
  String get rel_admin_key_clear_failed => 'O gateway não apagou essa chave.';

  @override
  String get rel_admin_endpoint_save_failed =>
      'O gateway não salvou esse endpoint.';

  @override
  String get rel_admin_endpoint_activate_failed =>
      'O gateway não ativou esse endpoint.';

  @override
  String get rel_admin_accounts_secure_required =>
      'As contas de provedores exigem um gateway HTTPS autenticado ou localhost.';

  @override
  String get rel_admin_accounts_read_failed =>
      'Não foi possível ler as contas de provedores.';

  @override
  String get rel_admin_account_disconnect_failed =>
      'O gateway não desconectou essa conta.';

  @override
  String get rel_admin_account_not_disconnectable =>
      'Não é possível desconectar essa conta de provedor.';

  @override
  String get rel_admin_backend_required =>
      'Escolha um dos backends de delegação disponíveis.';

  @override
  String get rel_admin_backend_save_failed =>
      'O gateway não selecionou esse backend.';

  @override
  String get rel_admin_routes_save_failed =>
      'O gateway não salvou essas rotas.';

  @override
  String get rel_admin_profile_route_required =>
      'Cada rota de perfil precisa de um nome de perfil.';

  @override
  String get rel_admin_profile_route_unique =>
      'As rotas de perfil devem ser únicas.';

  @override
  String get rel_admin_profile_route_default_invalid =>
      'A rota de perfil padrão deve ser um dos perfis permitidos.';

  @override
  String get rel_admin_profile_routes_save_failed =>
      'O gateway não salvou essas rotas de perfil.';

  @override
  String get rel_admin_limits_save_failed =>
      'O gateway não salvou esses limites.';

  @override
  String get rel_admin_mixture_save_failed =>
      'O gateway não salvou essa mistura.';

  @override
  String get rel_admin_credit_amount_required =>
      'Escolha um dos valores de crédito oferecidos.';

  @override
  String get rel_admin_charge_check_failed =>
      'Não foi possível verificar essa cobrança.';

  @override
  String get rel_admin_reload_amounts_missing =>
      'Os valores de recarga automática não foram fornecidos, portanto não foram alterados.';

  @override
  String get rel_admin_plan_required => 'Escolha um plano primeiro.';

  @override
  String get rel_admin_plan_scheduled_only =>
      'Só é possível confirmar aqui uma alteração de plano agendada.';

  @override
  String get rel_admin_billing_refused =>
      'O gateway recusou esta solicitação de faturamento.';

  @override
  String get rel_admin_request_refused => 'O gateway recusou esta solicitação.';

  @override
  String get rel_admin_endpoint_answered => 'O endpoint respondeu.';

  @override
  String get rel_admin_endpoint_no_answer => 'O endpoint não respondeu.';

  @override
  String get rel_admin_charge_unknown =>
      'O resultado da cobrança é desconhecido. Ela ainda pode ser liquidada. Consulte o portal antes de tentar novamente.';

  @override
  String get rel_admin_connect_before_billing =>
      'Conecte a sessão ativa do gateway antes de consultar o faturamento. Nada é cobrado nesta página.';

  @override
  String get rel_admin_preset_required =>
      'Salve uma predefinição antes de aplicá-la.';

  @override
  String get rel_admin_cancel => 'Cancelar';

  @override
  String get rel_admin_refresh => 'Atualizar';

  @override
  String get rel_admin_credits_and_plans => 'Créditos e planos';

  @override
  String get rel_admin_saved => 'Salvo';

  @override
  String get rel_admin_name => 'Nome';

  @override
  String get rel_admin_base_url => 'URL base';

  @override
  String get rel_admin_model => 'Modelo';

  @override
  String get rel_admin_signed_in => 'Conectado';

  @override
  String get rel_admin_not_signed_in => 'Não conectado';

  @override
  String get rel_admin_provider => 'Provedor';

  @override
  String get rel_admin_apply_to_this_chat => 'Aplicar a este chat';

  @override
  String get rel_admin_auto => 'Automático';

  @override
  String get rel_admin_chat_completions => 'Conclusões de conversa';

  @override
  String get rel_admin_codex_responses => 'Respostas Codex';

  @override
  String get rel_admin_anthropic_messages => 'Mensagens Anthropic';

  @override
  String get rel_admin_could_not_complete_that_request =>
      'Não foi possível concluir essa solicitação.';

  @override
  String get rel_admin_confirm => 'Confirmar';

  @override
  String get rel_admin_providers_and_billing => 'Provedores e faturamento';

  @override
  String get rel_admin_api_keys => 'Chaves de API';

  @override
  String get rel_admin_custom_endpoints => 'Endpoints personalizados';

  @override
  String get rel_admin_provider_accounts => 'Contas de provedores';

  @override
  String get rel_admin_effort_and_speed_presets =>
      'Predefinições de esforço e velocidade';

  @override
  String get rel_admin_delegation => 'Delegação';

  @override
  String get rel_admin_mixture_of_agents => 'Mistura de agentes';

  @override
  String get rel_admin_no_provider_keys_were_reported_for_this_profile =>
      'Nenhuma chave de provedor foi informada para este perfil.';

  @override
  String get rel_admin_not_saved => 'Não salvo';

  @override
  String get rel_admin_new_key_value => 'Novo valor da chave';

  @override
  String get rel_admin_provider_key_saved => 'Chave do provedor salva.';

  @override
  String get rel_admin_save_key => 'Salvar chave';

  @override
  String get rel_admin_clear_provider_key => 'Apagar chave do provedor';

  @override
  String get rel_admin_provider_key_cleared => 'Chave do provedor apagada.';

  @override
  String get rel_admin_clear_key => 'Apagar chave';

  @override
  String get rel_admin_new_endpoint => 'Novo endpoint';

  @override
  String get rel_admin_api_key => 'Chave de API';

  @override
  String get rel_admin_leave_blank_to_keep_a_key_this_endpoint_already_has =>
      'Deixe em branco para manter a chave existente deste endpoint.';

  @override
  String get rel_admin_reachable => 'Acessível';

  @override
  String get rel_admin_unreachable => 'Inacessível';

  @override
  String get rel_admin_test_endpoint => 'Testar endpoint';

  @override
  String get rel_admin_endpoint_saved => 'Endpoint salvo.';

  @override
  String get rel_admin_save_endpoint => 'Salvar endpoint';

  @override
  String get rel_admin_use_this_endpoint => 'Usar este endpoint';

  @override
  String
  get rel_admin_make_this_named_endpoint_the_current_model_for_this_profile =>
      'Tornar este endpoint nomeado o modelo atual deste perfil?';

  @override
  String get rel_admin_endpoint_is_now_current => 'O endpoint agora é o atual.';

  @override
  String get rel_admin_use_endpoint => 'Usar endpoint';

  @override
  String get rel_admin_delete_endpoint => 'Excluir endpoint';

  @override
  String get rel_admin_delete_this_named_endpoint_from_the_profile =>
      'Excluir este endpoint nomeado do perfil?';

  @override
  String get rel_admin_endpoint_deleted => 'Endpoint excluído.';

  @override
  String get rel_admin_signing_in_stays_on_the_provider_sign_in_screen =>
      'O login continua na tela do provedor. A conta só é desconectada quando este gateway indicar que pode ser removida.';

  @override
  String get rel_admin_disconnect_this_provider_account_on_the_gateway =>
      'Desconectar esta conta de provedor no gateway?';

  @override
  String get rel_admin_provider_account_disconnected =>
      'Conta do provedor desconectada.';

  @override
  String get rel_admin_disconnect => 'Desconectar';

  @override
  String get rel_admin_not_disconnectable => 'Não pode ser desconectado';

  @override
  String get rel_admin_fast => 'Rápido';

  @override
  String get rel_admin_preset_saved_for_this_model =>
      'Predefinição salva para este modelo.';

  @override
  String get rel_admin_save_preset => 'Salvar predefinição';

  @override
  String get rel_admin_chat_id => 'ID da conversa';

  @override
  String get rel_admin_apply_preset => 'Aplicar predefinição';

  @override
  String get rel_admin_set_this_chat_s_effort_and_speed_from_the_saved_preset =>
      'Definir o esforço e a velocidade desta conversa a partir da predefinição salva?';

  @override
  String get rel_admin_preset_applied_to_this_chat =>
      'Predefinição aplicada a esta conversa.';

  @override
  String get rel_admin_this_route_sends_the_picked_effort_unchanged =>
      'Esta rota envia o esforço escolhido sem alterações.';

  @override
  String get rel_admin_show_route_clamp => 'Mostrar limite da rota';

  @override
  String get rel_admin_delegation_backend => 'Backend de delegação';

  @override
  String get rel_admin_delegation_backend_saved =>
      'Backend de delegação salvo.';

  @override
  String get rel_admin_save_backend => 'Salvar backend';

  @override
  String get rel_admin_max_iterations => 'Máximo de iterações';

  @override
  String get rel_admin_max_concurrent_children =>
      'Máximo de agentes filhos simultâneos';

  @override
  String get rel_admin_child_timeout_seconds =>
      'Tempo limite dos agentes filhos em segundos';

  @override
  String get rel_admin_delegation_effort_leave_unchanged =>
      'Esforço de delegação, manter inalterado';

  @override
  String get rel_admin_delegation_limits_saved =>
      'Limites de delegação salvos.';

  @override
  String get rel_admin_save_limits => 'Salvar limites';

  @override
  String get rel_admin_remove_route => 'Remover rota';

  @override
  String get rel_admin_route_name => 'Nome da rota';

  @override
  String get rel_admin_route_provider => 'Provedor da rota';

  @override
  String get rel_admin_route_model => 'Modelo da rota';

  @override
  String get rel_admin_route_effort_unchanged => 'Esforço da rota inalterado';

  @override
  String get rel_admin_add_route => 'Adicionar rota';

  @override
  String get rel_admin_default_route => 'Rota padrão';

  @override
  String get rel_admin_delegation_routes_saved => 'Rotas de delegação salvas.';

  @override
  String get rel_admin_save_routes => 'Salvar rotas';

  @override
  String get rel_admin_profile_routes_saved => 'Rotas de perfil salvas.';

  @override
  String get rel_admin_save_profile_routes => 'Salvar rotas de perfil';

  @override
  String get rel_admin_no_mixture_is_loaded =>
      'Nenhuma mistura está carregada.';

  @override
  String get rel_admin_mixture_enabled => 'Mistura ativada';

  @override
  String get rel_admin_loud_degraded_references =>
      'Referências degradadas com aviso';

  @override
  String get rel_admin_silent_degraded_references =>
      'Referências degradadas silenciosas';

  @override
  String get rel_admin_aggregator => 'Agregador';

  @override
  String get rel_admin_aggregator_provider => 'Provedor do agregador';

  @override
  String get rel_admin_aggregator_model => 'Modelo do agregador';

  @override
  String get rel_admin_reference_provider => 'Provedor de referência';

  @override
  String get rel_admin_reference_model => 'Modelo de referência';

  @override
  String get rel_admin_add_reference_model => 'Adicionar modelo de referência';

  @override
  String get rel_admin_mixture_saved => 'Mistura salva.';

  @override
  String get rel_admin_save_mixture => 'Salvar mistura';

  @override
  String get rel_admin_credit_purchase_submitted =>
      'Compra de créditos enviada.';

  @override
  String get rel_admin_credit_purchase_settled =>
      'Compra de créditos liquidada.';

  @override
  String get rel_admin_credit_and_plan_changes_wait_for_confirmation_a_plan =>
      'As alterações de créditos e planos aguardam confirmação. Um plano com cobrança imediata é exibido, mas não confirmado aqui.';

  @override
  String get rel_admin_buy_credits => 'Comprar créditos';

  @override
  String get rel_admin_retry_same_charge => 'Repetir a mesma cobrança';

  @override
  String get rel_admin_retry_the_same_credit_charge_this_does_not_start =>
      'Repita a mesma cobrança de créditos. Isso não inicia uma segunda compra.';

  @override
  String get rel_admin_credit_purchases_are_not_available_for_this_account =>
      'A compra de créditos não está disponível para esta conta.';

  @override
  String get rel_admin_auto_reload => 'Recarga automática';

  @override
  String get rel_admin_read_only_until_this_account_can_charge =>
      'Somente leitura até esta conta poder efetuar cobranças.';

  @override
  String get rel_admin_auto_reload_updated => 'Recarga automática atualizada.';

  @override
  String get rel_admin_keep_going_on_credits => 'Continuar com créditos';

  @override
  String get rel_admin_continue_on_credits_when_the_plan_window_is_used_up =>
      'Continuar com créditos quando a cota do período do plano se esgotar?';

  @override
  String
  get rel_admin_stop_continuing_on_credits_when_the_plan_window_is_used_up =>
      'Parar de continuar com créditos quando a cota do período do plano se esgotar?';

  @override
  String get rel_admin_credit_continuation_updated =>
      'Continuação com créditos atualizada.';

  @override
  String get rel_admin_this_plan_change_is_not_confirmed_from_ares =>
      'Esta alteração de plano não é confirmada pelo Ares.';

  @override
  String get rel_admin_this_change_is_scheduled_confirm_to_apply_it =>
      'Esta alteração está agendada. Confirme para aplicá-la.';

  @override
  String get rel_admin_preview_plan => 'Visualizar plano';

  @override
  String get rel_admin_schedule_plan_change => 'Agendar alteração de plano';

  @override
  String get rel_admin_plan_change_scheduled => 'Alteração de plano agendada.';

  @override
  String get rel_admin_confirm_scheduled_plan_change =>
      'Confirmar alteração de plano agendada';

  @override
  String rel_admin_remove_key_confirm(String key) {
    return 'Remover o valor salvo de $key deste perfil?';
  }

  @override
  String rel_admin_current_endpoint(String name) {
    return '$name · atual';
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
    return 'A delegação está bloqueada: $reason';
  }

  @override
  String rel_admin_backend_unavailable(String name) {
    return '$name · indisponível';
  }

  @override
  String rel_admin_reference_number(String number) {
    return 'Referência $number';
  }

  @override
  String rel_admin_reload_enable_confirm(String amount, String threshold) {
    return 'Ativar a recarga automática e cobrar $amount quando o saldo cair abaixo de $threshold?';
  }

  @override
  String rel_admin_reload_disable_confirm(String amount, String threshold) {
    return 'Desativar a recarga automática? Atualmente cobra $amount quando o saldo cai abaixo de $threshold.';
  }

  @override
  String get rel_admin_this_plan => 'este plano';

  @override
  String rel_admin_plan_confirm(String name) {
    return 'Agendar $name. Está previsto para o fim do período atual. Nenhuma cobrança é feita agora.';
  }

  @override
  String rel_admin_plan_confirm_price(String name, String price) {
    return 'Agendar $name por $price. Está previsto para o fim do período atual. Nenhuma cobrança é feita agora.';
  }

  @override
  String rel_admin_plan_confirm_when(String name, String when) {
    return 'Agendar $name. Entra em vigor $when. Nenhuma cobrança é feita agora.';
  }

  @override
  String rel_admin_plan_confirm_price_when(
    String name,
    String price,
    String when,
  ) {
    return 'Agendar $name por $price. Entra em vigor $when. Nenhuma cobrança é feita agora.';
  }

  @override
  String rel_admin_balance(String amount) {
    return 'Saldo $amount';
  }

  @override
  String rel_admin_buy_confirm(String amount) {
    return 'Cobrar \$$amount na forma de pagamento desta conta Nous. Isso gasta dinheiro real.';
  }

  @override
  String rel_admin_reload_portal(String url) {
    return 'Altere a recarga automática no portal: $url';
  }

  @override
  String rel_admin_team_portal(String url) {
    return 'As assinaturas de equipe são alteradas no portal: $url';
  }

  @override
  String get rel_admin_effort_none => 'nenhum';

  @override
  String get rel_admin_effort_minimal => 'mínimo';

  @override
  String get rel_admin_effort_low => 'baixo';

  @override
  String get rel_admin_effort_medium => 'médio';

  @override
  String get rel_admin_effort_high => 'alto';

  @override
  String get rel_admin_effort_xhigh => 'muito alto';

  @override
  String get rel_admin_effort_max => 'máximo';

  @override
  String get rel_admin_effort_ultra => 'ultraelevado';

  @override
  String get rel_admin_auto_lower => 'Automático';

  @override
  String get rel_admin_create => 'Criar';

  @override
  String get rel_admin_prompt => 'Prompt';

  @override
  String get rel_admin_new_profile_id => 'ID do novo perfil';

  @override
  String get rel_admin_this_operation_is_unavailable_on_this_gateway =>
      'Esta operação não está disponível neste gateway.';

  @override
  String get rel_admin_access_denied_by_the_gateway =>
      'Acesso negado pelo gateway.';

  @override
  String get rel_admin_connection_changed_reopen_profiles =>
      'A conexão mudou. Abra Perfis novamente.';

  @override
  String
  get rel_admin_invalid_input_or_gateway_response_check_the_target_before =>
      'Entrada ou resposta do gateway inválida. Verifique o destino antes de tentar novamente.';

  @override
  String get rel_admin_could_not_verify_the_result_refresh_the_target_before =>
      'Não foi possível verificar o resultado. Atualize o destino antes de tentar novamente.';

  @override
  String get rel_admin_edit_soul_md => 'Editar SOUL.md';

  @override
  String get rel_admin_persona => 'Personalidade';

  @override
  String get rel_admin_persona_saved => 'Personalidade salva.';

  @override
  String get rel_admin_not_set => 'não definido';

  @override
  String get rel_admin_enabled => 'Ativado';

  @override
  String get rel_admin_keys_to_remove_comma_separated =>
      'Chaves a remover (separadas por vírgulas)';

  @override
  String get rel_admin_saved_and_applied_by_the_gateway =>
      'Salvo e aplicado pelo gateway.';

  @override
  String get rel_admin_saved_a_gateway_restart_may_be_required =>
      'Salvo. Pode ser necessário reiniciar o gateway.';

  @override
  String get rel_admin_create_signed_route => 'Criar rota assinada';

  @override
  String get rel_admin_route_id => 'ID da rota';

  @override
  String get rel_admin_signature => 'Assinatura';

  @override
  String get rel_admin_events_comma_separated =>
      'Eventos (separados por vírgulas)';

  @override
  String get rel_admin_delivery_target => 'Destino de entrega';

  @override
  String get rel_admin_skills_comma_separated =>
      'Habilidades (separadas por vírgulas)';

  @override
  String get rel_admin_delivery_mode => 'Modo de entrega';

  @override
  String get rel_admin_delivery_chat_id_optional =>
      'ID da conversa de entrega (opcional)';

  @override
  String get rel_admin_hide_signing_secret => 'Ocultar segredo de assinatura';

  @override
  String get rel_admin_reveal_signing_secret => 'Mostrar segredo de assinatura';

  @override
  String get rel_admin_edit_persona => 'Editar personalidade';

  @override
  String get rel_admin_portable_profile_bundle => 'Pacote de perfil portátil';

  @override
  String get rel_admin_clone_profile => 'Clonar perfil';

  @override
  String get rel_admin_rename_display_label => 'Renomear rótulo de exibição';

  @override
  String get rel_admin_rename_profile => 'Renomear perfil';

  @override
  String get rel_admin_new_name => 'Novo nome';

  @override
  String get rel_admin_rename_verified => 'Renomeação verificada.';

  @override
  String get rel_admin_delete_profile => 'Excluir perfil';

  @override
  String get rel_admin_profile_id_to_delete => 'ID do perfil a excluir';

  @override
  String get rel_admin_profile_deleted => 'Perfil excluído.';

  @override
  String
  get rel_admin_profile_deleted_server_identity_cleanup_is_still_pending =>
      'Perfil excluído. A limpeza da identidade do servidor ainda está pendente.';

  @override
  String get rel_admin_export_profile_archive => 'Exportar arquivo de perfil';

  @override
  String get rel_admin_import_profile_archive => 'Importar arquivo de perfil';

  @override
  String get rel_admin_import_a_trusted_profile =>
      'Importar um perfil confiável';

  @override
  String get rel_admin_absolute_archive_path_on_gateway =>
      'Caminho absoluto do arquivo no gateway';

  @override
  String get rel_admin_messaging_channels => 'Canais de mensagens';

  @override
  String get rel_admin_dm_pairing_requests =>
      'Solicitações de pareamento por mensagem direta';

  @override
  String get rel_admin_no_pending_or_approved_users =>
      'Não há usuários pendentes ou aprovados.';

  @override
  String get rel_admin_legacy_pairing_no_verifiable_request_id_ask_the_user =>
      'Pareamento antigo: sem ID de solicitação verificável. Peça ao usuário que faça o pareamento novamente.';

  @override
  String get rel_admin_pairing_change_verified =>
      'Alteração de pareamento verificada.';

  @override
  String get rel_admin_create_telegram_bot_by_qr =>
      'Criar bot do Telegram por QR';

  @override
  String get rel_admin_create_telegram_bot => 'Criar bot do Telegram';

  @override
  String get rel_admin_bot_name => 'Nome do bot';

  @override
  String get rel_admin_telegram_bot_creation_qr_code =>
      'Código QR para criar um bot do Telegram';

  @override
  String get rel_admin_check_telegram_pairing =>
      'Verificar pareamento do Telegram';

  @override
  String get rel_admin_waiting_for_telegram => 'Aguardando o Telegram.';

  @override
  String get rel_admin_apply_telegram_bot => 'Aplicar bot do Telegram';

  @override
  String get rel_admin_allowed_numeric_user_ids =>
      'IDs numéricos dos usuários permitidos';

  @override
  String get rel_admin_saved_restart_still_required =>
      'Salvo. Ainda é necessário reiniciar.';

  @override
  String get rel_admin_saved_gateway_restart_requested =>
      'Salvo; reinicialização do gateway solicitada.';

  @override
  String get rel_admin_cancel_telegram_setup =>
      'Cancelar configuração do Telegram';

  @override
  String get rel_admin_inbound_webhooks => 'Webhooks de entrada';

  @override
  String get rel_admin_enable_webhook_service => 'Ativar serviço de webhooks';

  @override
  String get rel_admin_enable_webhooks => 'Ativar webhooks';

  @override
  String get rel_admin_enabled_restart_still_required =>
      'Ativado. Ainda é necessário reiniciar.';

  @override
  String get rel_admin_enabled_restart_requested =>
      'Ativado; reinicialização solicitada.';

  @override
  String get rel_admin_route_change_verified => 'Alteração de rota verificada.';

  @override
  String get rel_admin_delete_route => 'Excluir rota';

  @override
  String get rel_admin_disable_route => 'Desativar rota';

  @override
  String get rel_admin_enable_route => 'Ativar rota';

  @override
  String get rel_admin_back_up_entire_agent_home =>
      'Fazer backup de toda a pasta pessoal do agente';

  @override
  String get rel_admin_transfer_to_a_cloud_agent =>
      'Transferir para um agente Cloud';

  @override
  String get rel_admin_check_backup_progress => 'Verificar progresso do backup';

  @override
  String get rel_admin_save_backup_to_this_device =>
      'Salvar backup neste dispositivo';

  @override
  String get rel_admin_save_sensitive_full_home_archive =>
      'Salvar arquivo sensível de toda a pasta pessoal';

  @override
  String get rel_admin_save_cancelled => 'Salvamento cancelado.';

  @override
  String get rel_admin_backup_saved => 'Backup salvo.';

  @override
  String get rel_admin_up_to_32_mib_larger_archives_remain_on_the_gateway =>
      'Até 32 MiB. Os arquivos maiores permanecem no gateway.';

  @override
  String rel_admin_persona_scope(String scope) {
    return 'Salve a personalidade de $scope.';
  }

  @override
  String rel_admin_configure_channel(String name) {
    return 'Configurar $name';
  }

  @override
  String rel_admin_channel_warning(String scope) {
    return 'Aplica-se a $scope. Em branco mantém o valor existente. Para remover um valor, liste a chave abaixo.';
  }

  @override
  String rel_admin_hook_warning(String scope) {
    return 'Aplica-se a $scope. Use um nome único. O gateway cria um segredo de assinatura. Se outro operador criar o nome simultaneamente, o host poderá substituir essa rota.';
  }

  @override
  String rel_admin_hook_created(String url) {
    return 'Criado $url. Guarde o segredo de assinatura antes de sair.';
  }

  @override
  String rel_admin_clone_warning(String scope) {
    return 'Copie configurações, habilidades, personalidade e possivelmente credenciais de provedores de $scope. Os tokens de mensagens não são solicitados.';
  }

  @override
  String rel_admin_cloned(String source, String destination) {
    return '$source clonado para $destination.';
  }

  @override
  String rel_admin_rename_target(String name) {
    return 'Renomear $name';
  }

  @override
  String rel_admin_rename_label_warning(String scope) {
    return 'Altere o rótulo de exibição de $scope. O ID permanece default.';
  }

  @override
  String rel_admin_rename_warning(String scope) {
    return 'Renomeie $scope no servidor. Um gateway em execução pode parar.';
  }

  @override
  String rel_admin_delete_target(String name) {
    return 'Excluir $name';
  }

  @override
  String rel_admin_delete_profile_warning(String scope) {
    return 'Exclua permanentemente $scope, incluindo sessões e credenciais. Digite o ID exato do perfil.';
  }

  @override
  String rel_admin_export_target(String name) {
    return 'Exportar $name';
  }

  @override
  String rel_admin_export_warning(String scope) {
    return 'Crie um .tar.gz em $scope. Os repositórios de credenciais conhecidos são excluídos, mas podem restar dados privados. Revise antes de compartilhar.';
  }

  @override
  String rel_admin_archive_on(String gateway, String path) {
    return 'Arquivo em $gateway: $path';
  }

  @override
  String rel_admin_import_warning(String gateway) {
    return 'Use um .tar.gz revisado que já esteja em $gateway. Pode conter plugins, scripts e agendamentos. É necessário um novo ID de perfil.';
  }

  @override
  String rel_admin_imported(String name) {
    return '$name importado.';
  }

  @override
  String rel_admin_approve_user(String user) {
    return 'Aprovar $user';
  }

  @override
  String rel_admin_revoke_user(String user) {
    return 'Revogar $user';
  }

  @override
  String rel_admin_allow_pair(String platform, String scope) {
    return '$platform em $scope: permitir o acesso deste usuário às mensagens.';
  }

  @override
  String rel_admin_remove_pair(String platform, String scope) {
    return '$platform em $scope: remover o acesso deste usuário às mensagens.';
  }

  @override
  String rel_admin_telegram_start(String scope) {
    return 'Inicie um pareamento do Telegram em $scope com o serviço de configuração do gateway.';
  }

  @override
  String rel_admin_expires(String time) {
    return 'Expira: $time';
  }

  @override
  String rel_admin_telegram_apply(String bot, String scope) {
    return 'Ative @$bot em $scope e tente reiniciar o gateway. Somente os usuários listados podem enviar mensagens a ele.';
  }

  @override
  String rel_admin_hooks_enable(String scope) {
    return 'Ative os webhooks de entrada em $scope e tente reiniciar o gateway.';
  }

  @override
  String rel_admin_disable_target(String name) {
    return 'Desativar $name';
  }

  @override
  String rel_admin_enable_target(String name) {
    return 'Ativar $name';
  }

  @override
  String rel_admin_hook_change(String name, String scope) {
    return 'Altere exatamente $name em $scope.';
  }

  @override
  String rel_admin_backup_warning(String gateway) {
    return 'Este não é um backup das configurações do Ares. Salve todos os perfis, sessões e credenciais em $gateway. O arquivo é sensível.';
  }

  @override
  String rel_admin_backup_started(String gateway) {
    return 'Backup iniciado em $gateway.';
  }

  @override
  String rel_admin_backup_verified(String gateway, String path) {
    return 'Backup verificado em $gateway: $path';
  }

  @override
  String rel_admin_backup_running(String gateway) {
    return 'O backup ainda está em andamento em $gateway.';
  }

  @override
  String get rel_admin_choice_yes => 'sim';

  @override
  String get rel_admin_choice_no => 'não';

  @override
  String get rel_admin_choice_generic => 'genérico';

  @override
  String get rel_admin_choice_log => 'registro';

  @override
  String get rel_admin_choice_email => 'e-mail';

  @override
  String get rel_admin_choice_github_comment => 'comentário no GitHub';

  @override
  String get rel_admin_choice_agent => 'O agente processa o evento';

  @override
  String get rel_admin_choice_direct => 'Entrega direta';

  @override
  String get rel_admin_configured => 'configurado';

  @override
  String get rel_admin_state_pending_restart => 'reinicialização pendente';

  @override
  String get rel_admin_state_unknown => 'desconhecido';

  @override
  String get rel_admin_state_connected => 'conectado';

  @override
  String get rel_admin_state_disconnected => 'desconectado';

  @override
  String get rel_admin_state_disabled => 'desativado';

  @override
  String get rel_admin_state_enabled => 'ativado';

  @override
  String get rel_admin_state_running => 'em execução';

  @override
  String get rel_admin_state_stopped => 'parado';

  @override
  String get rel_admin_state_error => 'erro';

  @override
  String get rel_admin_state_not_configured => 'não configurado';

  @override
  String get rel_admin_state_startup_failed => 'falha na inicialização';

  @override
  String get rel_admin_state_gateway_stopped => 'gateway parado';

  @override
  String get rel_admin_state_connecting => 'conectando';

  @override
  String get rel_admin_state_retrying => 'tentando novamente';

  @override
  String get rel_admin_state_fatal => 'erro fatal';

  @override
  String get rel_admin_unsupported_or_oversized_profile_archive =>
      'Arquivo de perfil não suportado ou grande demais.';

  @override
  String get rel_admin_current_layout => 'Layout atual';

  @override
  String get rel_admin_one_pane => 'Um painel';

  @override
  String get rel_admin_stacked => 'Empilhado';

  @override
  String get rel_admin_side_by_side => 'Lado a lado';

  @override
  String get rel_admin_no_supported_appearance_in_this_profile =>
      'Não há aparência suportada neste perfil.';

  @override
  String get rel_admin_review_appearance_saved_with_this_profile =>
      'Revisar a aparência salva com este perfil';

  @override
  String get rel_admin_applies_only_to_this_named_profile_on_this_device =>
      'Aplica-se apenas a este perfil nomeado neste dispositivo. Um layout importado começa com painéis vazios; escolha as conversas.';

  @override
  String get rel_admin_apply_to_this_profile_on_this_device =>
      'Aplicar a este perfil neste dispositivo';

  @override
  String get rel_admin_export_prepares_a_tar_gz_on_the_gateway_review =>
      'A exportação prepara um .tar.gz no gateway. Revise os arquivos portáteis antes de salvar uma cópia aqui. A importação abre um arquivo local para revisão; apenas abrir não envia nada.';

  @override
  String get rel_admin_prepare_profile_export =>
      'Preparar exportação de perfil';

  @override
  String get rel_admin_open_tar_gz_from_this_device =>
      'Abrir .tar.gz deste dispositivo';

  @override
  String get rel_admin_only_selected_text_files_travel_review_for_secrets_and =>
      'Somente os arquivos de texto selecionados são transferidos. Verifique se contêm segredos e informações privadas. A configuração, as habilidades e os agendamentos podem alterar o comportamento do novo perfil.';

  @override
  String get rel_admin_include_this_reviewed_file =>
      'Incluir este arquivo revisado';

  @override
  String get rel_admin_apply_appearance_to_the_new_profile_on_this_device =>
      'Aplicar a aparência ao novo perfil neste dispositivo';

  @override
  String
  get rel_admin_imports_colours_and_pane_sizes_never_chats_tools_or_session_ids =>
      'Importa cores e tamanhos dos painéis, nunca conversas, ferramentas ou IDs de sessão.';

  @override
  String
  get rel_admin_the_gateway_retains_a_private_staged_copy_import_creates =>
      'O gateway mantém uma cópia privada preparada. A importação cria um novo perfil; não substitui um existente.';

  @override
  String get rel_admin_appearance_not_applied_the_gateway_did_not_confirm_the =>
      ' Aparência não aplicada: o gateway não confirmou a sobreposição revisada.';

  @override
  String get rel_admin_appearance_applied_on_this_device =>
      ' Aparência aplicada neste dispositivo.';

  @override
  String get rel_admin_appearance_was_not_saved_on_this_device =>
      ' A aparência não foi salva neste dispositivo.';

  @override
  String get rel_admin_save_reviewed_profile_bundle =>
      'Salvar pacote de perfil revisado';

  @override
  String get rel_admin_profile_bundle_saved => 'Pacote de perfil salvo.';

  @override
  String get rel_admin_import_selected_files =>
      'Importar arquivos selecionados';

  @override
  String get rel_admin_save_selected_files_to_device =>
      'Salvar arquivos selecionados no dispositivo';

  @override
  String rel_admin_layout_first_pane(String layout, String percent) {
    return '$layout · $percent% primeiro painel';
  }

  @override
  String rel_admin_appearance_summary(String skin, String mode, String layout) {
    return 'Tema: $skin · Modo: $mode · $layout';
  }

  @override
  String rel_admin_appearance_applied(String gateway, String profile) {
    return 'Aparência aplicada a $gateway / $profile.';
  }

  @override
  String rel_admin_bundle_summary(
    String profile,
    String count,
    String omitted,
  ) {
    return 'Pacote: $profile · $count arquivos para revisão · $omitted omitidos';
  }

  @override
  String rel_admin_imported_on(String name, String gateway) {
    return '$name importado em $gateway.';
  }

  @override
  String get rel_admin_unchanged => 'inalterado';

  @override
  String get rel_admin_mode_system => 'sistema';

  @override
  String get rel_admin_mode_light => 'claro';

  @override
  String get rel_admin_mode_dark => 'escuro';

  @override
  String get rel_admin_skin_classic => 'clássico';

  @override
  String get rel_admin_skin_midnight => 'meia-noite';

  @override
  String get rel_admin_skin_ember => 'brasa';

  @override
  String get rel_admin_skin_mono => 'monocromático';

  @override
  String get rel_admin_skin_cyberpunk => 'cyberpunk';

  @override
  String get rel_admin_skin_slate => 'ardósia';

  @override
  String get rel_admin_no_available_cloud_agents_in_this_account =>
      'Não há agentes Cloud disponíveis nesta conta.';

  @override
  String get rel_admin_the_previous_undo_receipt_could_not_be_verified_no =>
      'Não foi possível verificar o recibo de desfazer anterior. Nenhuma alteração foi feita.';

  @override
  String get rel_admin_transfer_to_cloud => 'Transferir para Cloud';

  @override
  String
  get rel_admin_connection_changed_leave_this_page_a_restore_already_submitted =>
      'A conexão mudou. Saia desta página. Uma restauração já enviada pode continuar.';

  @override
  String get rel_admin_find_my_cloud_agents => 'Encontrar meus agentes Cloud';

  @override
  String
  get rel_admin_undo_replaces_the_destination_with_its_pre_transfer_backup =>
      'Desfazer substitui o destino pelo backup anterior à transferência.';

  @override
  String get rel_admin_replace_this_cloud_agent_with_the_entire_source_home =>
      'Substitua este agente Cloud por toda a pasta pessoal de origem, incluindo credenciais, conversas e arquivos. A origem não é excluída. Os bots de mensagens recebidas são desativados.';

  @override
  String get rel_admin_type_destination_agent_id =>
      'Digite o ID do agente de destino';

  @override
  String
  get rel_admin_could_not_retain_the_local_undo_receipt_keep_this_page_open =>
      'Não foi possível guardar o recibo local de desfazer. Mantenha esta página aberta.';

  @override
  String get rel_admin_undo_transfer => 'Desfazer transferência';

  @override
  String get rel_admin_replace_cloud_agent => 'Substituir agente Cloud';

  @override
  String
  get rel_admin_local_undo_receipt_forgotten_no_remote_backup_was_removed =>
      'Recibo local de desfazer esquecido. Nenhum backup remoto foi removido.';

  @override
  String get rel_admin_forget_local_undo_receipt_only =>
      'Esquecer apenas o recibo local de desfazer';

  @override
  String get rel_admin_stop_before_restore => 'Parar antes de restaurar';

  @override
  String get rel_admin_do_not_close_this_page_restore_runs_on_the =>
      'Não feche esta página. A restauração é executada no destino e não pode ser cancelada.';

  @override
  String get rel_admin_files_restored_destination_gateway_needs_attention =>
      'Arquivos restaurados; o gateway de destino requer atenção.';

  @override
  String rel_admin_transfer_sign_in(String origin) {
    return 'Entre em exatamente uma conexão Ares salva para $origin e volte aqui.';
  }

  @override
  String rel_admin_transfer_source(String gateway, String profile) {
    return 'Origem: $gateway / $profile';
  }

  @override
  String rel_admin_transfer_destination(String name, String origin) {
    return 'Destino: $name · $origin / default';
  }

  @override
  String rel_admin_agent_id(String id) {
    return 'ID do agente: $id';
  }

  @override
  String rel_admin_transfer_status(String phase) {
    return 'Status: $phase';
  }

  @override
  String rel_admin_copied_percent(String percent) {
    return 'Copiado $percent%';
  }

  @override
  String rel_admin_undo_point(String path) {
    return 'Ponto de desfazer no destino: $path';
  }

  @override
  String rel_admin_messaging_disabled(String channels) {
    return 'Mensagens desativadas: $channels';
  }

  @override
  String get rel_admin_phase_prepared => 'preparado';

  @override
  String get rel_admin_phase_backup => 'backup';

  @override
  String get rel_admin_phase_upload => 'envio';

  @override
  String get rel_admin_phase_restore => 'restauração';

  @override
  String get rel_admin_phase_finished => 'concluído';

  @override
  String get rel_admin_phase_failed => 'falhou';

  @override
  String get rel_admin_phase_undo => 'desfazer';

  @override
  String get rel_admin_phase_undone => 'desfeito';

  @override
  String rel_ops_cap_install_blocked(String verdict, String detail) {
    return 'Instalação bloqueada ($verdict): $detail';
  }

  @override
  String rel_ops_cap_scan_confirm(String verdict, String requested) {
    return 'Resultado da análise: $verdict. Confirme $requested antes de instalar.';
  }

  @override
  String rel_ops_cap_install_unconfirmed(String requested) {
    return 'O gateway não confirmou que $requested está instalado.';
  }

  @override
  String rel_ops_cap_edit_skill(String name) {
    return 'Editar $name';
  }

  @override
  String rel_ops_cap_archive_skill(String name) {
    return 'Arquivar $name?';
  }

  @override
  String rel_ops_cap_archive_explanation(String command) {
    return 'A habilidade será arquivada e poderá ser restaurada com $command.';
  }

  @override
  String rel_ops_cap_install_anyway(String name) {
    return 'Instalar $name mesmo assim';
  }

  @override
  String rel_ops_cap_install_despite_scan(String name) {
    return 'Instalar $name apesar da análise?';
  }

  @override
  String rel_ops_cap_scan_warning(String name) {
    return 'A análise de segurança bloqueou $name. Esta confirmação se aplica apenas a $name.';
  }

  @override
  String rel_ops_cap_accept_scan_warning(String name) {
    return 'Aceitar recursos não ignora a análise de $name.';
  }

  @override
  String rel_ops_cap_review_scan(String name) {
    return 'Revisar a análise de $name';
  }

  @override
  String rel_ops_cap_desktop_grants(String description) {
    return '$description\nAs permissões de pastas e de scripts de prévia permanecem no aplicativo Desktop daquele computador. Remover o plugin aqui não revoga essas permissões locais.';
  }

  @override
  String rel_ops_cap_remove_plugin(String name) {
    return 'Remover $name?';
  }

  @override
  String rel_ops_cap_probe_result(String name, String tools) {
    return 'Teste de $name: $tools';
  }

  @override
  String rel_ops_cap_save_tool_grants_for(String connector) {
    return 'Salvar permissões de ferramentas para $connector';
  }

  @override
  String rel_ops_cap_backends_for(String name) {
    return 'Mecanismos para $name';
  }

  @override
  String rel_ops_cap_use_backend_confirmation(String name) {
    return 'Usar $name?';
  }

  @override
  String rel_ops_cap_unlock_source(String name) {
    return 'Desbloquear $name';
  }

  @override
  String get rel_ops_cap_capabilities => 'Recursos';

  @override
  String get rel_ops_cap_plugins => 'Plugins';

  @override
  String get rel_ops_cap_connectors => 'Conectores';

  @override
  String get rel_ops_cap_backends => 'Mecanismos';

  @override
  String get rel_ops_cap_save_skill => 'Salvar habilidade';

  @override
  String get rel_ops_cap_archive => 'Arquivar';

  @override
  String get rel_ops_cap_hub_identifier => 'Identificador do Hub';

  @override
  String get rel_ops_cap_install => 'Instalar';

  @override
  String get rel_ops_cap_update_all => 'Atualizar tudo';

  @override
  String get rel_ops_cap_unlock => 'Desbloquear';

  @override
  String get rel_ops_cap_lock => 'Bloquear';

  @override
  String get rel_ops_cap_this_update_adds_capabilities_nothing_changed_yet =>
      'Esta atualização adiciona recursos. Nada foi alterado ainda.';

  @override
  String get rel_ops_cap_the_scan_blocked_this_plugin =>
      'A análise bloqueou este plugin.';

  @override
  String get rel_ops_cap_the_plugin_was_not_changed =>
      'O plugin não foi alterado.';

  @override
  String get rel_ops_cap_repository => 'Repositório';

  @override
  String get rel_ops_cap_install_plugin => 'Instalar plugin';

  @override
  String get rel_ops_cap_update_plugins => 'Atualizar plugins';

  @override
  String get rel_ops_cap_accept_capabilities => 'Aceitar recursos';

  @override
  String get rel_ops_cap_update => 'Atualizar';

  @override
  String get rel_ops_cap_remove_desktop_half =>
      'Remover o componente de desktop';

  @override
  String get rel_ops_cap_server_name => 'Nome do servidor';

  @override
  String get rel_ops_cap_command => 'Comando';

  @override
  String get rel_ops_cap_http_url => 'URL HTTP';

  @override
  String get rel_ops_cap_add_server => 'Adicionar servidor';

  @override
  String get rel_ops_cap_probe => 'Testar';

  @override
  String get rel_ops_cap_probe_failed => 'O teste falhou.';

  @override
  String get rel_ops_cap_logs => 'Registros';

  @override
  String get rel_ops_cap_mcp_log => 'Registro MCP';

  @override
  String get rel_ops_cap_connector => 'Conector';

  @override
  String get rel_ops_cap_account_alias => 'Apelido da conta';

  @override
  String get rel_ops_cap_link_account => 'Vincular conta';

  @override
  String get rel_ops_cap_remove_account => 'Remover conta';

  @override
  String get rel_ops_cap_tool_connector => 'Conector de ferramentas';

  @override
  String get rel_ops_cap_load_tools => 'Carregar ferramentas';

  @override
  String get rel_ops_cap_save_tool_grants => 'Salvar permissões de ferramentas';

  @override
  String
  get rel_ops_cap_this_policy_has_no_member_revision_so_tool_grants_stay_unchanged =>
      'Esta política não tem uma revisão de membro, portanto as permissões de ferramentas permanecem inalteradas.';

  @override
  String get rel_ops_cap_active => 'Ativo';

  @override
  String get rel_ops_cap_use => 'Usar';

  @override
  String get rel_ops_cap_run_setup => 'Iniciar configuração';

  @override
  String get rel_ops_cap_terminal_backends => 'Mecanismos de terminal';

  @override
  String get rel_ops_cap_this_changes_the_terminal_backend_for_this_profile =>
      'Isso altera o mecanismo de terminal deste perfil.';

  @override
  String get rel_ops_cap_use_backend => 'Usar mecanismo';

  @override
  String get rel_ops_cap_select => 'Selecionar';

  @override
  String get rel_ops_cap_browser_vault => 'Cofre do navegador';

  @override
  String
  get rel_ops_cap_saved_site_logins_addresses_and_cards_passwords_stay_in_the_secure_fields_and_are_not_listed_here =>
      'Logins de sites, endereços e cartões salvos. As senhas permanecem nos campos seguros e não são listadas aqui.';

  @override
  String get rel_ops_cap_remove_saved_item => 'Remover item salvo';

  @override
  String get rel_ops_cap_delete_this_item => 'Excluir este item?';

  @override
  String get rel_ops_cap_unlocked => 'Desbloqueado';

  @override
  String get rel_ops_cap_locked => 'Bloqueado';

  @override
  String get rel_ops_cap_not_detected => 'Não detectado';

  @override
  String get rel_ops_cap_master_password => 'Senha mestra';

  @override
  String get rel_ops_cap_login => 'Dados de login';

  @override
  String get rel_ops_cap_address => 'Endereço';

  @override
  String get rel_ops_cap_card => 'Cartão';

  @override
  String get rel_ops_cap_label => 'Rótulo';

  @override
  String get rel_ops_cap_site_origin => 'Origem do site';

  @override
  String get rel_ops_cap_identifier => 'Identificador';

  @override
  String get rel_ops_cap_password => 'Senha';

  @override
  String get rel_ops_cap_authenticator_key => 'Chave de autenticação';

  @override
  String get rel_ops_cap_street => 'Rua';

  @override
  String get rel_ops_cap_city => 'Cidade';

  @override
  String get rel_ops_cap_postal_code => 'CEP';

  @override
  String get rel_ops_cap_country => 'País';

  @override
  String get rel_ops_cap_name_on_card => 'Nome no cartão';

  @override
  String get rel_ops_cap_card_number => 'Número do cartão';

  @override
  String get rel_ops_cap_expiry_month => 'Mês de validade';

  @override
  String get rel_ops_cap_expiry_year => 'Ano de validade';

  @override
  String get rel_ops_cap_security_code => 'Código de segurança';

  @override
  String get rel_ops_cap_this_gateway_has_no_shared_metrics_consent_method =>
      'Este gateway não tem um método de consentimento para compartilhar métricas.';

  @override
  String get rel_ops_cap_agent_policy => 'Política do agente';

  @override
  String get rel_ops_cap_loading_policy => 'Carregando política';

  @override
  String get rel_ops_cap_approval_timeout => 'Tempo limite de aprovação';

  @override
  String get rel_ops_cap_confirm_mcp_reloads => 'Confirmar recarregamentos MCP';

  @override
  String get rel_ops_cap_command_allowlist => 'Lista de comandos permitidos';

  @override
  String get rel_ops_cap_file_checkpoints =>
      'Pontos de restauração de arquivos';

  @override
  String get rel_ops_cap_checkpoint_limit => 'Limite de pontos de restauração';

  @override
  String get rel_ops_cap_browser_private_urls => 'URLs privadas no navegador';

  @override
  String get rel_ops_cap_use_my_real_browser_profile =>
      'Usar meu perfil real do navegador';

  @override
  String get rel_ops_cap_save_policy => 'Salvar política';

  @override
  String get rel_ops_cap_shared_metrics_for_this_profile =>
      'Métricas compartilhadas deste perfil';

  @override
  String get rel_ops_cap_send_shared_metrics =>
      'Enviar métricas compartilhadas';

  @override
  String get rel_ops_cap_error_enter_a_label => 'Digite um rótulo.';

  @override
  String get rel_ops_cap_error_enter_a_valid_url_like_https_example_com =>
      'Digite uma URL válida, como https://example.com.';

  @override
  String get rel_ops_cap_error_enter_the_identifier_and_password =>
      'Digite o identificador e a senha.';

  @override
  String
  get rel_ops_cap_error_enter_the_card_name_number_expiry_and_security_code =>
      'Digite o nome no cartão, o número, a validade e o código de segurança.';

  @override
  String get rel_ops_cap_error_enter_the_street_city_postal_code_and_country =>
      'Digite a rua, a cidade, o CEP e o país.';

  @override
  String
  get rel_ops_cap_error_the_gateway_returned_a_response_that_could_not_be_read =>
      'O gateway retornou uma resposta que não pôde ser lida.';

  @override
  String rel_ops_cap_error_the_gateway_refused_the_request_status(
    int statusCode,
  ) {
    return 'O gateway recusou a solicitação ($statusCode).';
  }

  @override
  String
  rel_ops_cap_error_this_connection_has_no_gateway_socket_so_method_is_unavailable(
    String method,
  ) {
    return 'Esta conexão não tem um socket de gateway, portanto $method está indisponível.';
  }

  @override
  String get rel_ops_cap_error_choose_a_skill => 'Escolha uma habilidade.';

  @override
  String get rel_ops_cap_error_the_skill_text_was_not_returned =>
      'O texto da habilidade não foi retornado.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_saved =>
      'A habilidade não foi salva.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_archived =>
      'A habilidade não foi arquivada.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_installed =>
      'A habilidade não foi instalada.';

  @override
  String get rel_ops_cap_error_skill_updates_did_not_start =>
      'As atualizações das habilidades não foram iniciadas.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_removed =>
      'A habilidade não foi removida.';

  @override
  String get rel_ops_cap_error_enter_a_skill_or_plugin_identifier =>
      'Digite um identificador de habilidade ou plugin.';

  @override
  String get rel_ops_cap_error_choose_a_plugin => 'Escolha um plugin.';

  @override
  String get rel_ops_cap_error_the_plugin_was_not_removed =>
      'O plugin não foi removido.';

  @override
  String get rel_ops_cap_error_the_desktop_half_was_not_removed =>
      'O componente de desktop não foi removido.';

  @override
  String
  get rel_ops_cap_error_this_gateway_did_not_give_the_plugin_a_stable_key =>
      'Este gateway não atribuiu uma chave estável ao plugin.';

  @override
  String get rel_ops_cap_error_the_plugin_was_not_changed =>
      'O plugin não foi alterado.';

  @override
  String get rel_ops_cap_error_choose_a_server => 'Escolha um servidor.';

  @override
  String get rel_ops_cap_error_name_the_server => 'Dê um nome ao servidor.';

  @override
  String get rel_ops_cap_error_give_the_server_a_command_or_an_http_s_url =>
      'Informe um comando ou uma URL http(s) para o servidor.';

  @override
  String get rel_ops_cap_error_choose_a_toolset =>
      'Escolha um conjunto de ferramentas.';

  @override
  String get rel_ops_cap_error_tool_backend_status_was_not_returned =>
      'O status do mecanismo de ferramentas não foi retornado.';

  @override
  String get rel_ops_cap_error_choose_a_provider => 'Escolha um provedor.';

  @override
  String get rel_ops_cap_error_this_provider_has_no_setup_action =>
      'Este provedor não tem uma ação de configuração.';

  @override
  String get rel_ops_cap_error_setup_did_not_start =>
      'A configuração não foi iniciada.';

  @override
  String get rel_ops_cap_error_choose_a_terminal_backend =>
      'Escolha um mecanismo de terminal.';

  @override
  String get rel_ops_cap_error_name_the_connector => 'Dê um nome ao conector.';

  @override
  String get rel_ops_cap_error_choose_an_account => 'Escolha uma conta.';

  @override
  String
  get rel_ops_cap_error_reload_the_connector_policy_before_changing_tool_grants =>
      'Recarregue a política do conector antes de alterar as permissões de ferramentas.';

  @override
  String get rel_ops_cap_error_choose_an_item => 'Escolha um item.';

  @override
  String get rel_ops_cap_error_choose_a_source => 'Escolha uma fonte.';

  @override
  String get rel_ops_cap_error_enter_the_master_password =>
      'Digite a senha mestra.';

  @override
  String get rel_ops_cap_error_gateway_config_was_not_returned =>
      'A configuração do gateway não foi retornada.';

  @override
  String get rel_ops_cap_error_choose_a_known_approval_mode =>
      'Escolha um modo de aprovação conhecido.';

  @override
  String get rel_ops_cap_error_use_a_positive_limit =>
      'Use um limite positivo.';

  @override
  String get rel_ops_cap_error_the_policy_was_not_saved =>
      'A política não foi salva.';

  @override
  String get rel_ops_cap_value_manual => 'manual';

  @override
  String get rel_ops_cap_value_smart => 'inteligente';

  @override
  String get rel_ops_cap_value_off => 'desligado';

  @override
  String get rel_ops_cap_value_safe => 'seguro';

  @override
  String get rel_ops_cap_value_caution => 'cuidado';

  @override
  String get rel_ops_cap_value_dangerous => 'perigoso';

  @override
  String get rel_ops_cap_value_blocked => 'bloqueado';

  @override
  String get rel_ops_cap_value_clean => 'sem ameaças';

  @override
  String get rel_ops_cap_value_ready => 'pronto';

  @override
  String get rel_ops_cap_value_available => 'disponível';

  @override
  String get rel_ops_cap_value_unavailable => 'indisponível';

  @override
  String get rel_ops_cap_value_enabled => 'ativado';

  @override
  String get rel_ops_cap_value_disabled => 'desativado';

  @override
  String get rel_ops_cap_value_active => 'ativo';

  @override
  String get rel_ops_cap_value_inactive => 'inativo';

  @override
  String get rel_ops_cap_value_installed => 'instalado';

  @override
  String get rel_ops_cap_value_missing => 'ausente';

  @override
  String get rel_ops_cap_value_configured => 'configurado';

  @override
  String get rel_ops_cap_value_not_configured => 'não configurado';

  @override
  String get rel_ops_cap_value_error => 'erro';

  @override
  String get rel_ops_cap_value_unknown => 'desconhecido';

  @override
  String get rel_ops_cap_value_login => 'login';

  @override
  String get rel_ops_cap_value_address => 'endereço';

  @override
  String get rel_ops_cap_value_payment => 'pagamento';

  @override
  String get rel_ops_term_connecting => 'Conectando…';

  @override
  String get rel_ops_term_unbound =>
      'Não há nenhuma sessão ativa ou diretório de trabalho do host correspondente. Abra primeiro a conversa associada.';

  @override
  String get rel_ops_term_unsupported =>
      'Este Gateway não oferece este recurso de terminal. Nenhum interpretador de comandos local foi iniciado.';

  @override
  String get rel_ops_term_local_pty_unavailable =>
      'O pseudoterminal local (PTY) incluído não está disponível neste dispositivo.';

  @override
  String get rel_ops_term_operation_failed =>
      'Não foi possível abrir ou controlar o terminal. Verifique o host, as credenciais e a impressão digital. Nenhum interpretador de comandos alternativo foi iniciado.';

  @override
  String get rel_ops_term_input_refused =>
      'Entrada recusada. Abra novamente a conversa de origem.';

  @override
  String get rel_ops_term_cancel => 'Cancelar';

  @override
  String get rel_ops_term_confirm => 'Confirmar';

  @override
  String get rel_ops_term_open_device_title =>
      'Abrir um interpretador de comandos neste dispositivo?';

  @override
  String get rel_ops_term_ssh_shell => 'Interpretador de comandos SSH';

  @override
  String get rel_ops_term_local_shell => 'Interpretador de comandos local';

  @override
  String get rel_ops_term_connection_lost => 'Conexão perdida';

  @override
  String get rel_ops_term_shell_ended => 'Interpretador de comandos encerrado';

  @override
  String get rel_ops_term_no_owner =>
      'Esta conversa não tem um proprietário autenticado do terminal do Gateway. Uma URL ou um login na nuvem, por si só, não dá acesso a um interpretador de comandos.';

  @override
  String get rel_ops_term_open_gateway_title =>
      'Abrir um interpretador de comandos no Gateway?';

  @override
  String get rel_ops_term_shell_expired =>
      'Interpretador de comandos encerrado ou expirado';

  @override
  String get rel_ops_term_disconnected => 'Desconectado';

  @override
  String get rel_ops_term_gateway_shell =>
      'Interpretador de comandos do Gateway';

  @override
  String get rel_ops_term_close_body =>
      'Encerre este interpretador de comandos. Para mantê-lo em execução, oculte o painel em vez de fechá-lo.';

  @override
  String get rel_ops_term_closing => 'Fechando…';

  @override
  String get rel_ops_term_close_unconfirmed => 'Fechamento não confirmado';

  @override
  String get rel_ops_term_processes_require_chat =>
      'Os processos do agente exigem a conversa autenticada à qual pertencem.';

  @override
  String get rel_ops_term_watching_processes =>
      'Monitorando os processos do agente desta conversa. Fechar uma visualização espelhada nunca interrompe seu processo.';

  @override
  String get rel_ops_term_paste_limit => 'A colagem é limitada a 16 KiB.';

  @override
  String get rel_ops_term_paste => 'Colar';

  @override
  String get rel_ops_term_select_first =>
      'Selecione primeiro a saída do terminal.';

  @override
  String get rel_ops_term_open_chat_to_insert =>
      'Abra a conversa de origem antes de inserir a saída.';

  @override
  String get rel_ops_term_added_to_draft =>
      'Adicionado ao rascunho da conversa de origem. Nada foi enviado.';

  @override
  String get rel_ops_term_close => 'Fechar';

  @override
  String get rel_ops_term_add_selection =>
      'Adicionar seleção ao rascunho da conversa';

  @override
  String get rel_ops_term_new_terminal => 'Novo terminal';

  @override
  String get rel_ops_term_gateway_terminal => 'Terminal do host do Gateway';

  @override
  String get rel_ops_term_verified_ssh_terminal => 'Terminal SSH verificado';

  @override
  String get rel_ops_term_device_local_shell =>
      'Este dispositivo (interpretador de comandos local)';

  @override
  String get rel_ops_term_local_unavailable_mobile =>
      'Interpretador de comandos local indisponível em dispositivos móveis';

  @override
  String get rel_ops_term_watch_processes => 'Monitorar processos do agente';

  @override
  String get rel_ops_term_select_output => 'Selecionar ou copiar a saída';

  @override
  String get rel_ops_term_add_selected_output =>
      'Adicionar a saída selecionada ao rascunho da conversa';

  @override
  String get rel_ops_term_review_paste =>
      'Revisar a colagem da área de transferência';

  @override
  String get rel_ops_term_reconnect =>
      'Reconectar ao mesmo interpretador de comandos';

  @override
  String get rel_ops_term_close_mirror => 'Fechar visualização espelhada';

  @override
  String get rel_ops_term_close_shell => 'Fechar interpretador de comandos';

  @override
  String get rel_ops_term_empty =>
      'Selecione + para abrir um terminal. Nenhum interpretador de comandos é iniciado automaticamente.';

  @override
  String get rel_ops_term_reason_stale => 'desatualizado';

  @override
  String get rel_ops_term_reason_mismatch => 'não correspondente';

  @override
  String get rel_ops_term_reason_unbound => 'não vinculado';

  @override
  String get rel_ops_term_reason_unsupported => 'não compatível';

  @override
  String get rel_ops_term_reason_denied => 'negado';

  @override
  String get rel_ops_term_reason_ineligible => 'não elegível';

  @override
  String get rel_ops_term_reason_unavailable => 'indisponível';

  @override
  String get rel_ops_term_reason_invalid => 'inválido';

  @override
  String get rel_ops_term_reason_insecure => 'inseguro';

  @override
  String rel_ops_term_refused(String reason) {
    return 'O Gateway recusou esta operação de terminal ($reason).';
  }

  @override
  String rel_ops_term_open_device_body(String connection) {
    return 'Este é o dispositivo do Ares, não $connection. O interpretador de comandos usa as permissões do aplicativo e é iniciado no armazenamento do aplicativo.';
  }

  @override
  String rel_ops_term_open_gateway_body(String host) {
    return 'Inicie um interpretador de comandos em $host, no diretório de trabalho verificado da conversa. Não se trata de um interpretador de comandos do dispositivo.';
  }

  @override
  String rel_ops_term_close_tab_title(String label) {
    return 'Fechar $label?';
  }

  @override
  String rel_ops_term_read_only_status(String status) {
    return 'Somente leitura · $status';
  }

  @override
  String rel_ops_term_paste_title(String label) {
    return 'Colar em $label?';
  }

  @override
  String rel_ops_term_output_title(String label) {
    return 'Saída · $label';
  }

  @override
  String rel_ops_term_mirror_status(String label) {
    return 'Visualização espelhada do processo somente leitura · $label';
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
  String get rel_ops_term_earlier_output_trimmed => '[Saída anterior truncada]';

  @override
  String get rel_ops_term_ssh_dialog_title =>
      'Abrir um terminal SSH verificado';

  @override
  String get rel_ops_term_ssh_dialog_body =>
      'Use uma impressão digital obtida de forma independente com o administrador do host. Isso abre uma nova sessão remota, não o Gateway nem um interpretador de comandos local.';

  @override
  String get rel_ops_term_ssh_host => 'Host SSH';

  @override
  String get rel_ops_term_ssh_port => 'Porta';

  @override
  String get rel_ops_term_ssh_user => 'Usuário';

  @override
  String get rel_ops_term_ssh_fingerprint =>
      'Impressão digital da chave do host (SHA256:…)';

  @override
  String get rel_ops_term_ssh_password => 'Senha SSH (não é salva)';

  @override
  String get rel_ops_term_connect => 'Conectar';

  @override
  String get rel_ops_ssh_invalid_destination =>
      'Host, porta ou usuário SSH inválido.';

  @override
  String get rel_ops_ssh_public_key_required =>
      'É necessária uma chave pública do host OpenSSH Ed25519.';

  @override
  String get rel_ops_ssh_invalid_public_key =>
      'Chave do host Ed25519 inválida.';

  @override
  String get rel_ops_ssh_invalid_saved_key =>
      'A chave do host salva é inválida.';

  @override
  String get rel_ops_ssh_enrollment_unverified =>
      'Não foi possível verificar o cadastro da chave do host.';

  @override
  String get rel_ops_ssh_different_key_pinned =>
      'Já existe outra chave fixada. Verifique a alteração separadamente.';

  @override
  String get rel_ops_ssh_open_ssh_unavailable =>
      'O OpenSSH do sistema não está disponível.';

  @override
  String get rel_ops_ssh_confirm_host_key =>
      'Confirme a chave do host antes de conectar.';

  @override
  String get rel_ops_ssh_absolute_identity_required =>
      'Selecione um arquivo de identidade com um caminho absoluto.';

  @override
  String get rel_ops_ssh_invalid_remote_port => 'Porta remota inválida.';

  @override
  String get rel_ops_ssh_preview_too_large =>
      'A prévia excede o limite de 64 KiB.';

  @override
  String get rel_ops_ssh_connection_refused =>
      'Conexão SSH recusada. Verifique a chave do host cadastrada, a identidade e o serviço.';

  @override
  String get rel_ops_ssh_http_not_ok =>
      'O serviço remoto não retornou HTTP 200.';

  @override
  String get rel_ops_ssh_encoded_response =>
      'Esta prévia não oferece suporte a respostas codificadas.';

  @override
  String get rel_ops_ssh_preview_type_unsupported =>
      'Só é possível visualizar texto e código-fonte HTML.';

  @override
  String get rel_ops_ssh_health_unconfirmed =>
      'O serviço não confirmou o bom funcionamento do Gateway.';

  @override
  String get rel_ops_ssh_enroll_host_key_first =>
      'Cadastre primeiro a chave pública do host.';

  @override
  String get rel_ops_ssh_cancel => 'Cancelar';

  @override
  String get rel_ops_ssh_confirm => 'Confirmar';

  @override
  String get rel_ops_ssh_pin_title => 'Fixar esta chave do host SSH?';

  @override
  String rel_ops_ssh_pin_detail(String destination, String fingerprint) {
    return '$destination\n$fingerprint\nCompare esta impressão digital com o administrador do host por um canal independente. Nenhuma conexão será estabelecida.';
  }

  @override
  String get rel_ops_ssh_host_key_pinned => 'Chave do host fixada.';

  @override
  String get rel_ops_ssh_shell_detail => 'Abrir um shell de login interativo.';

  @override
  String rel_ops_ssh_read_detail(String path, int port) {
    return 'Ler $path em 127.0.0.1:$port da máquina remota por um canal SSH.';
  }

  @override
  String rel_ops_ssh_connect_title(String destination) {
    return 'Conectar a $destination?';
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
  String get rel_ops_ssh_agent_auth => 'Autentique-se com seu agente SSH.';

  @override
  String get rel_ops_ssh_identity_auth =>
      'Usar o arquivo de identidade selecionado.';

  @override
  String rel_ops_ssh_gateway_responding(int port) {
    return 'O Gateway está respondendo na porta de loopback remota $port.';
  }

  @override
  String get rel_ops_ssh_session_closed => 'Sessão SSH fechada.';

  @override
  String get rel_ops_ssh_session_unclean =>
      'A sessão SSH terminou sem uma saída normal.';

  @override
  String get rel_ops_ssh_operation_failed =>
      'A operação SSH falhou. Verifique o destino e a identidade.';

  @override
  String get rel_ops_ssh_title => 'SSH verificado';

  @override
  String get rel_ops_ssh_unsupported =>
      'Este dispositivo não tem um transporte OpenSSH do sistema compatível. O retransmissor do Gateway fixado aceita novas chaves automaticamente e não pode ser usado para um cadastro verificado.';

  @override
  String get rel_ops_ssh_host => 'Host SSH';

  @override
  String get rel_ops_ssh_port => 'Porta SSH';

  @override
  String get rel_ops_ssh_user => 'Usuário SSH';

  @override
  String get rel_ops_ssh_identity =>
      'Arquivo de identidade (opcional; caso contrário, usar o agente SSH)';

  @override
  String get rel_ops_ssh_public_key =>
      'Chave pública do host fornecida pelo administrador (ssh-ed25519)';

  @override
  String get rel_ops_ssh_review_key => 'Revisar chave do host';

  @override
  String get rel_ops_ssh_remote_port => 'Porta do serviço de loopback remoto';

  @override
  String get rel_ops_ssh_check_gateway => 'Verificar Gateway por SSH';

  @override
  String get rel_ops_ssh_preview_source => 'Visualizar código-fonte por SSH';

  @override
  String get rel_ops_ssh_open_shell => 'Abrir shell SSH';

  @override
  String get rel_ops_ssh_shell_line => 'Linha para o shell remoto';

  @override
  String get rel_ops_ssh_disconnect => 'Desconectar shell';

  @override
  String get rel_ops_host_cancel => 'Cancelar';

  @override
  String get rel_ops_host_confirm => 'Confirmar';

  @override
  String get rel_ops_host_title => 'Host';

  @override
  String get rel_ops_host_refresh => 'Atualizar';

  @override
  String get rel_ops_host_update => 'Atualizar o Hermes remoto';

  @override
  String rel_ops_host_update_confirmation(String profile) {
    return 'Isso inicia uma atualização da instalação existente no host do gateway para $profile. Não atualiza o Ares neste dispositivo. O sucesso é comprovado pelo comprovante de atualização correspondente, e não pelo fato de o host continuar acessível.';
  }

  @override
  String get rel_ops_host_update_awaiting =>
      'Aguardando o comprovante correspondente. A atualização ainda está em andamento.';

  @override
  String get rel_ops_host_receipt_success =>
      'O comprovante de atualização indica sucesso.';

  @override
  String get rel_ops_host_receipt_partial =>
      'Atualização aplicada, mas ainda há etapas de acompanhamento pendentes.';

  @override
  String get rel_ops_host_receipt_failed =>
      'O comprovante de atualização indica falha.';

  @override
  String get rel_ops_host_receipt_refused =>
      'O comprovante de atualização indica recusa.';

  @override
  String get rel_ops_host_update_running =>
      'A atualização ainda está em andamento.';

  @override
  String get rel_ops_host_update_unknown =>
      'O resultado da atualização é desconhecido. Um gateway ativo não significa que a atualização foi bem-sucedida.';

  @override
  String get rel_ops_host_default_profile => 'o perfil padrão do gateway';

  @override
  String get rel_ops_host_restart => 'Reiniciar o gateway remoto';

  @override
  String rel_ops_host_restart_shared_confirmation(String profiles) {
    return 'Isso reinicia o gateway compartilhado por $profiles. Os turnos em andamento neste gateway serão interrompidos. Reconecte-se depois. Estar acessível não comprova que a reinicialização terminou.';
  }

  @override
  String rel_ops_host_restart_confirmation(String profile) {
    return 'Isso reinicia o gateway remoto para $profile. Os turnos em andamento neste gateway serão interrompidos. Reconecte-se depois.';
  }

  @override
  String get rel_ops_host_restart_running =>
      'O comando de reinicialização ainda está em execução.';

  @override
  String get rel_ops_host_restart_finished =>
      'O comando de reinicialização terminou. Reconecte-se ao host manualmente.';

  @override
  String get rel_ops_host_restart_failed =>
      'O comando de reinicialização falhou.';

  @override
  String rel_ops_host_maintenance_running(String name) {
    return '$name ainda está em execução';
  }

  @override
  String rel_ops_host_maintenance_finished(String name) {
    return '$name terminou';
  }

  @override
  String rel_ops_host_maintenance_failed(String name) {
    return '$name falhou';
  }

  @override
  String get rel_ops_host_curator_paused_result => 'Curador pausado.';

  @override
  String get rel_ops_host_curator_resumed_result => 'Curador retomado.';

  @override
  String get rel_ops_host_reset => 'Redefinir arquivos de memória remotos';

  @override
  String rel_ops_host_reset_confirmation(String targetName, String profile) {
    return 'Excluir o arquivo de memória $targetName em $profile? Não é possível desfazer esta ação pelo Ares.';
  }

  @override
  String rel_ops_host_reset_result(String targetName, int count) {
    return '$targetName redefinido. Foram removidos $count arquivo(s) remoto(s).';
  }

  @override
  String get rel_ops_host_share_not_redacted =>
      'O host não confirmou que os dados sensíveis do pacote foram ocultados. Nenhum link é exibido.';

  @override
  String rel_ops_host_scope(String connection, String profile) {
    return 'Estes controles operam o gateway remoto $connection para $profile, não este dispositivo nem a atualização do cliente Ares.';
  }

  @override
  String rel_ops_host_health_running(String version, int count) {
    return 'Processo do gateway em execução $version · $count sessões';
  }

  @override
  String rel_ops_host_health_stopped(String version, int count) {
    return 'Processo do gateway parado $version · $count sessões';
  }

  @override
  String rel_ops_host_heartbeat_stale(num seconds) {
    return 'O sinal de atividade do host está desatualizado ($seconds s).';
  }

  @override
  String get rel_ops_host_doctor => 'Executar Doctor';

  @override
  String get rel_ops_host_security_audit => 'Auditoria de segurança';

  @override
  String get rel_ops_host_check_receipt =>
      'Verificar comprovante de atualização';

  @override
  String get rel_ops_host_logs => 'Logs do host remoto';

  @override
  String get rel_ops_host_search_logs => 'Pesquisar logs do host';

  @override
  String get rel_ops_host_driver => 'Driver do host remoto';

  @override
  String get rel_ops_host_driver_scope =>
      'A prontidão do controle do computador depende do driver e das permissões do sistema operacional da máquina do gateway, não deste dispositivo.';

  @override
  String rel_ops_host_computer_status(
    String platform,
    String installed,
    String ready,
  ) {
    return '$platform · instalado $installed · pronto $ready';
  }

  @override
  String get rel_ops_host_null => 'indisponível';

  @override
  String get rel_ops_host_true => 'sim';

  @override
  String get rel_ops_host_false => 'não';

  @override
  String get rel_ops_host_curator => 'Curador';

  @override
  String get rel_ops_host_curator_paused => 'Curador pausado';

  @override
  String get rel_ops_host_curator_running => 'Curador em execução';

  @override
  String get rel_ops_host_no_run => 'Nenhuma execução concluída';

  @override
  String get rel_ops_host_run_curator => 'Executar Curador agora';

  @override
  String get rel_ops_host_reset_memory => 'Redefinir arquivo de memória';

  @override
  String get rel_ops_host_reset_user => 'Redefinir arquivo do usuário';

  @override
  String get rel_ops_host_reset_both => 'Redefinir ambos os arquivos';

  @override
  String get rel_ops_host_share_consent =>
      'Concordo em enviar um pacote de diagnóstico do host remoto com os dados sensíveis ocultados';

  @override
  String get rel_ops_host_share =>
      'Compartilhar diagnósticos com dados sensíveis ocultados';

  @override
  String get rel_ops_host_update_unknown_installation =>
      'Esta instalação é desconhecida, por isso a atualização não foi enviada';

  @override
  String get rel_ops_host_update_busy_installation =>
      'Há uma conversa em andamento nesta instalação';

  @override
  String get rel_ops_host_update_refused => 'Atualização remota recusada';

  @override
  String get rel_ops_host_error_stale =>
      'Área de trabalho remota: desatualizada';

  @override
  String get rel_ops_host_error_mismatch =>
      'Área de trabalho remota: não corresponde';

  @override
  String get rel_ops_host_error_unbound =>
      'Área de trabalho remota: sem vínculo';

  @override
  String get rel_ops_host_error_unsupported =>
      'Área de trabalho remota: não compatível';

  @override
  String get rel_ops_host_error_denied =>
      'Área de trabalho remota: acesso negado';

  @override
  String get rel_ops_host_error_ineligible =>
      'Área de trabalho remota: não elegível';

  @override
  String get rel_ops_host_error_unavailable =>
      'Área de trabalho remota: indisponível';

  @override
  String get rel_ops_host_error_invalid => 'Área de trabalho remota: inválida';

  @override
  String get rel_ops_host_error_insecure => 'Área de trabalho remota: insegura';

  @override
  String get rel_ops_host_error_request =>
      'Não foi possível concluir a solicitação.';

  @override
  String get rel_svc_push_api_select_sessions =>
      'Selecione de 1 a 128 IDs de sessão duráveis, cada um com 1–200 caracteres ASCII, usando apenas letras, números, _ . : @ ou -. Remova IDs vazios e espaços em branco.';

  @override
  String get rel_svc_push_api_unavailable =>
      'As notificações push móveis não estão disponíveis neste servidor.';

  @override
  String get rel_svc_push_api_invalid_vapid =>
      'A chave pública VAPID do servidor é inválida.';

  @override
  String get rel_svc_push_api_update_plugin =>
      'Este servidor precisa de um plugin mobile-push atualizado para assinaturas automáticas.';

  @override
  String get rel_svc_push_status_android_only => 'Somente Android';

  @override
  String get rel_svc_push_native_prefs_sync_failed =>
      'Não foi possível sincronizar as preferências de notificações nativas.';

  @override
  String get rel_svc_push_choose_android_connection =>
      'Escolha primeiro uma conexão salva no Android.';

  @override
  String get rel_svc_push_status_checking_authorization =>
      'Verificando a autorização do servidor';

  @override
  String get rel_svc_push_revoke_persist_failed =>
      'Não foi possível salvar a revogação. Tente desativar novamente antes de sair do app.';

  @override
  String get rel_svc_push_status_off_api_ready =>
      'Desativado; API do servidor pronta';

  @override
  String get rel_svc_push_status_off_revoke_pending =>
      'Desativado; revogação no servidor pendente';

  @override
  String get rel_svc_push_status_off_connection_changed =>
      'Desativado; a conexão salva foi alterada';

  @override
  String get rel_svc_push_status_pending_endpoint =>
      'Aguardando endpoint do distribuidor';

  @override
  String get rel_svc_push_status_registering => 'Registrando';

  @override
  String get rel_svc_push_status_pending_challenge =>
      'Desafio criptografado pendente (aguardando um push silencioso de verificação do servidor)';

  @override
  String get rel_svc_push_allow_android_notifications_retry =>
      'Permita as notificações do Android nas configurações do sistema e tente novamente.';

  @override
  String get rel_svc_push_plugin_invalid =>
      'O plugin mobile-push do servidor está indisponível, desatualizado ou retornou uma resposta de assinatura inválida. Peça ao operador para atualizá-lo e tente novamente.';

  @override
  String get rel_svc_push_transport_unavailable =>
      'Nenhum transporte push está disponível. A entrega integrada requer o Google Play Services funcionando; como alternativa, instale um distribuidor UnifiedPush e tente novamente.';

  @override
  String get rel_svc_push_transport_choice =>
      'Há vários distribuidores UnifiedPush disponíveis. Escolha um em Transporte avançado e tente novamente.';

  @override
  String get rel_svc_push_transport_missing =>
      'O distribuidor UnifiedPush selecionado não está disponível. Restaure-o ou escolha outro em Transporte avançado.';

  @override
  String get rel_svc_push_companion_unavailable =>
      'O componente mobile-push do servidor não está disponível. Ele pode estar ausente ou desativado, ou esta conexão pode apontar para o painel errado. Instale ou ative o componente no servidor, confira a conexão do painel e atualize. Consulte o guia de configuração do servidor acima.';

  @override
  String get rel_svc_push_server_denied =>
      'O servidor recusou as notificações push móveis. Peça ao operador para autorizar esta identidade e estas sessões.';

  @override
  String get rel_svc_push_not_ready =>
      'As notificações push móveis não estão prontas. Verifique a autorização do plugin do servidor, o distribuidor e a rede e tente novamente.';

  @override
  String get rel_svc_push_availability_read_failed =>
      'Não foi possível verificar a disponibilidade de push no Android. Tente novamente abaixo.';

  @override
  String get rel_svc_push_setup_failed =>
      'A configuração de push falhou. Verifique a permissão do Android, a autorização do servidor e o transporte e tente novamente.';

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
    return 'Status: vinculado a $bound (não ativo para $connection; handshake: $status)';
  }

  @override
  String get rel_svc_push_another_saved_connection => 'outra conexão salva';

  @override
  String get rel_svc_push_background_notifications =>
      'Notificações em segundo plano';

  @override
  String rel_svc_push_bound_subtitle(String bound, String connection) {
    return 'Vinculado a $bound — revogue esse vínculo abaixo antes de ativar para $connection';
  }

  @override
  String rel_svc_push_private_activity(String connection) {
    return 'Atividade privada do servidor para $connection';
  }

  @override
  String rel_svc_push_bound_warning_named(String bound) {
    return 'Vinculado a outra conexão salva ($bound). Desative e revogue esse vínculo antes de ativar para esta conexão.';
  }

  @override
  String get rel_svc_push_bound_warning =>
      'Vinculado a outra conexão salva. Desative e revogue esse vínculo antes de ativar para esta conexão.';

  @override
  String get rel_svc_push_local_notifications_muted =>
      'As notificações locais estão desativadas acima. O consentimento para notificações em segundo plano não muda, mas os avisos de atividade comuns ficam silenciados até ativar \"Ativar notificações\".';

  @override
  String rel_svc_push_legacy_subscription(int count) {
    return 'Assinatura legada: somente $count sessão(ões) selecionada(s). Ela não será ampliada automaticamente. Desative e ative para aceitar sessões autorizadas pelo servidor.';
  }

  @override
  String get rel_svc_push_authorized_binding =>
      'Vinculado somente a esta conexão salva e perfil. O acesso às sessões segue a autorização atual do servidor.';

  @override
  String get rel_svc_push_revocation_pending =>
      'Revogação no servidor pendente. A entrega local está desativada; tente novamente enquanto o login salvo original estiver disponível.';

  @override
  String get rel_svc_push_refresh_retry => 'Atualizar / tentar novamente';

  @override
  String rel_svc_push_disable_named(String bound) {
    return 'Desativar e revogar $bound';
  }

  @override
  String get rel_svc_push_other_connection => 'outra conexão';

  @override
  String get rel_svc_push_disable => 'Desativar e revogar';

  @override
  String get rel_svc_push_refresh_explanation =>
      'Atualizar / tentar novamente verifica de novo a disponibilidade após configurar o servidor; não instala o componente. Ativar notificações continua sendo uma escolha separada.';

  @override
  String get rel_svc_push_companion_required =>
      'As notificações em segundo plano exigem um componente mobile-push do servidor instalado e ativado separadamente. O Android não pode instalá-lo. Atualizar apenas o APK não configura o servidor.';

  @override
  String get rel_svc_push_server_setup_guide =>
      'Guia de configuração do servidor';

  @override
  String get rel_svc_push_enable_disclosure =>
      'Ative para solicitar permissão de notificações do Android e compartilhar com este servidor o endpoint e as chaves de criptografia desta instalação. Os avisos de atividade criptografados não contêm conteúdo de chats. Somente sessões autorizadas pelo seu login no servidor são incluídas.';

  @override
  String get rel_svc_push_transport_disclosure =>
      'A entrega integrada usa o transporte push do Google e requer o Google Play Services, mas não inclui o SDK do Firebase. Um distribuidor UnifiedPush opcional pode ser usado. A entrega é por melhor esforço; reabra o Hermes para reconciliar.';

  @override
  String get rel_svc_push_advanced_transport => 'Transporte avançado';

  @override
  String get rel_svc_push_automatic_explanation =>
      'Automático mantém a escolha de distribuidor existente; caso contrário, usa a entrega integrada do Google quando disponível. Desative antes de mudar o transporte.';

  @override
  String get rel_svc_push_transport_label => 'Transporte push';

  @override
  String get rel_svc_push_automatic_recommended => 'Automático (recomendado)';

  @override
  String get rel_svc_push_selected_unavailable =>
      'Distribuidor selecionado (indisponível)';

  @override
  String get rel_svc_push_no_transport_detected =>
      'Nenhum transporte disponível foi detectado. A entrega integrada requer o Google Play Services; sem ele, instale e configure um distribuidor UnifiedPush e atualize.';

  @override
  String get rel_svc_push_channel_turns_name => 'Turnos do Ares';

  @override
  String get rel_svc_push_channel_turns_description =>
      'Notificações de turnos concluídos em segundo plano';

  @override
  String get rel_svc_push_channel_attention_name => 'Atenção do Ares';

  @override
  String get rel_svc_push_channel_attention_description =>
      'Aprovações e solicitações de entrada que precisam de você';

  @override
  String get rel_svc_push_channel_background_name => 'Ares em segundo plano';

  @override
  String get rel_svc_push_channel_background_description =>
      'Conclusões de tarefas em segundo plano';

  @override
  String get rel_svc_push_channel_notices_name => 'Avisos do Ares';

  @override
  String get rel_svc_push_channel_notices_description =>
      'Avisos de créditos e plugins';

  @override
  String get rel_svc_push_diag_not_initialised => 'não inicializado';

  @override
  String get rel_svc_push_diag_replies_off => 'as respostas estão desativadas';

  @override
  String get rel_svc_push_diag_conversation => 'conversa';

  @override
  String get rel_svc_push_diag_conversation_permission_denied =>
      'conversa; permissão negada';

  @override
  String rel_svc_push_diag_conversation_error(String error) {
    return 'conversa: $error';
  }

  @override
  String get rel_svc_push_diag_failures_off => 'as falhas estão desativadas';

  @override
  String rel_svc_push_diag_kind_off(String kind) {
    return '$kind está desativado';
  }

  @override
  String get rel_svc_push_diag_windows_setting_unknown =>
      'O Windows não informou a configuração de notificações';

  @override
  String get rel_svc_backup_not_hermes_configuration_backup =>
      'Este arquivo não é um backup da configuração do Hermes.';

  @override
  String get rel_svc_backup_newer_version_cannot_import =>
      'Este backup foi criado por uma versão mais recente do aplicativo e não pode ser importado.';

  @override
  String get rel_svc_backup_missing_client_certificate =>
      'Este backup declara um certificado de cliente para uma conexão, mas não o contém; portanto, não é possível fazer uma restauração completa.';

  @override
  String get rel_svc_backup_damaged_unreadable =>
      'Este arquivo de backup está danificado e não pôde ser lido.';

  @override
  String get rel_svc_backup_unsupported_preference_type =>
      'Uma preferência salva tem um tipo incompatível e não pode ser exportada.';

  @override
  String get rel_svc_backup_choose_passphrase_api_keys =>
      'Escolha uma frase secreta — o backup contém suas chaves de API.';

  @override
  String get rel_svc_backup_could_not_protect_safely =>
      'Não foi possível proteger o backup com segurança.';

  @override
  String get rel_svc_backup_unsupported_encryption =>
      'Este backup usa um esquema de criptografia incompatível.';

  @override
  String get rel_svc_backup_wrong_passphrase_or_altered =>
      'A frase secreta está errada ou este arquivo de backup foi alterado.';

  @override
  String get rel_svc_backup_share_subject => 'Backup da configuração do Hermes';

  @override
  String get rel_svc_backup_selected_file_unreadable =>
      'Não foi possível ler esse arquivo.';

  @override
  String rel_svc_backup_connections_added(int count) {
    return '$count adicionadas';
  }

  @override
  String rel_svc_backup_connections_updated(int count) {
    return '$count atualizadas';
  }

  @override
  String rel_svc_backup_connections_removed(int count) {
    return '$count removidas';
  }

  @override
  String get rel_svc_backup_no_connection_changes =>
      'Nenhuma alteração nas conexões';

  @override
  String rel_svc_backup_connections_summary(String changes) {
    return 'Conexões: $changes';
  }

  @override
  String rel_svc_backup_restore_summary(String connections, int count) {
    return '$connections · $count configurações restauradas';
  }

  @override
  String rel_svc_backup_certificate_not_included(String label, String error) {
    return 'Não foi possível incluir o certificado de cliente de \"$label\" neste backup: $error';
  }

  @override
  String get rel_svc_backup_certificate_password_needed =>
      'Este certificado precisa da senha. Digite-a abaixo para abri-lo automaticamente.';

  @override
  String get rel_svc_backup_certificate_password_or_corrupt =>
      'A senha do certificado está incorreta ou o arquivo está corrompido.';

  @override
  String get rel_svc_backup_certificate_password_incorrect =>
      'A senha do certificado está incorreta.';

  @override
  String get rel_svc_backup_certificate_unsupported_encryption =>
      'Este certificado usa um método de criptografia que o aplicativo não consegue ler.';

  @override
  String get rel_svc_backup_certificate_unreadable_pkcs12 =>
      'O arquivo selecionado não é um certificado PKCS#12 (.p12/.pfx) legível.';

  @override
  String get rel_svc_backup_certificate_unreadable =>
      'Não foi possível ler o certificado selecionado.';

  @override
  String get rel_svc_backup_not_certificate_file =>
      'Esse arquivo não é um certificado: escolha um contêiner .p12/.pfx ou arquivos de certificado e chave PEM.';

  @override
  String get rel_svc_backup_not_pem_certificate =>
      'O certificado selecionado não é um certificado PEM.';

  @override
  String get rel_svc_backup_not_pem_private_key =>
      'A chave privada selecionada não é uma chave privada PEM.';

  @override
  String get rel_svc_backup_certificate_pair_unloadable =>
      'Não foi possível carregar o certificado e a chave privada selecionados.';

  @override
  String get rel_svc_backup_saved_certificate_files_unreadable =>
      'Não foi possível ler os arquivos salvos do certificado de cliente.';

  @override
  String get rel_svc_backup_client_certificate_storage_failed =>
      'Não foi possível armazenar o certificado de cliente com segurança neste dispositivo.';

  @override
  String get rel_svc_backup_certificate_storage_failed =>
      'Não foi possível armazenar o certificado com segurança neste dispositivo.';

  @override
  String get rel_svc_backup_client_certificate_label =>
      'Certificado de cliente';

  @override
  String rel_svc_backup_search_dashboard_unreachable(String error) {
    return 'Não foi possível acessar o painel: $error';
  }

  @override
  String get rel_svc_backup_search_credentials_rejected =>
      'O painel rejeitou as credenciais salvas. Verifique o nome de usuário e a senha do painel para esta conexão.';

  @override
  String get rel_svc_backup_search_not_supported =>
      'Este painel não oferece pesquisa de sessões. Atualize o Hermes no host ou volte para a pesquisa no dispositivo.';

  @override
  String rel_svc_backup_search_redirected(int statusCode) {
    return 'O painel redirecionou a pesquisa de sessões (HTTP $statusCode). O Ares não segue redirecionamentos com credenciais salvas; verifique o endereço da conexão.';
  }

  @override
  String rel_svc_backup_search_http_failed(int statusCode) {
    return 'A pesquisa de sessões falhou com HTTP $statusCode.';
  }

  @override
  String get rel_svc_backup_search_malformed_response =>
      'O painel retornou uma resposta de pesquisa malformada.';

  @override
  String get rel_svc_backup_search_unexpected_response =>
      'O painel retornou uma resposta de pesquisa inesperada.';

  @override
  String get rel_svc_backup_search_too_many_results =>
      'O painel retornou mais resultados de pesquisa do que o solicitado.';

  @override
  String get rel_svc_backup_message_search_unexpected_response =>
      'Resposta inesperada da pesquisa de mensagens.';

  @override
  String get rel_svc_backup_message_search_unexpected_result =>
      'Resultado inesperado da pesquisa de mensagens.';

  @override
  String get rel_svc_backup_ai_search_api_key_rejected =>
      'A API do Hermes rejeitou a chave de API salva.';

  @override
  String rel_svc_backup_ai_search_http_failed(int statusCode) {
    return 'A reformulação da consulta por IA falhou com HTTP $statusCode.';
  }

  @override
  String get rel_svc_backup_ai_search_no_usable_query =>
      'O modelo selecionado não retornou uma consulta de pesquisa utilizável.';

  @override
  String get rel_svc_backup_ai_search_malformed_response =>
      'O Hermes retornou uma resposta de reformulação por IA malformada.';

  @override
  String get rel_svc_backup_space_name_already_exists =>
      'Já existe um espaço com este nome';

  @override
  String get rel_svc_backup_space_name_length_invalid =>
      'O nome do espaço deve ter de 1 a 80 caracteres';

  @override
  String get ng_rel_svc_backup_gateway_address_required =>
      'Digite o endereço do seu painel do Hermes.';

  @override
  String ng_rel_svc_backup_gateway_address_scheme(String scheme) {
    return 'O endereço deve começar com http:// ou https:// (recebido: $scheme).';
  }

  @override
  String get ng_rel_svc_backup_gateway_address_invalid =>
      'Esse endereço não é válido.';

  @override
  String get ng_rel_svc_backup_gateway_address_no_host =>
      'O endereço não tem nome de host.';

  @override
  String get ng_rel_svc_backup_sign_in_main_window =>
      'Entre na janela principal.';

  @override
  String get rel_svc_backup_sign_in_renewal_failed =>
      'O gateway não conseguiu renovar o login agora.';

  @override
  String get rel_svc_backup_sign_in_provider_unreachable =>
      'O gateway não conseguiu renovar o login: o provedor de login está inacessível.';

  @override
  String get rel_svc_backup_sign_in_renewal_timed_out =>
      'O tempo limite para renovar o login foi excedido.';

  @override
  String get rel_svc_backup_sign_in_no_tokens =>
      'O gateway não retornou tokens de login.';

  @override
  String get ng_rel_svc_backup_probe_timed_out =>
      'O tempo limite foi excedido. Verifique o endereço e a conexão VPN ou Tailscale.';

  @override
  String ng_rel_svc_backup_probe_tls_failed(String error) {
    return 'A negociação TLS falhou: $error';
  }

  @override
  String ng_rel_svc_backup_gateway_answered_http(int statusCode) {
    return 'O gateway respondeu com HTTP $statusCode.';
  }

  @override
  String get ng_rel_svc_backup_gateway_answer_timed_out =>
      'O gateway demorou demais para responder.';

  @override
  String ng_rel_svc_backup_browser_callback_not_ready(String error) {
    return 'Não foi possível preparar o retorno do navegador: $error';
  }

  @override
  String get ng_rel_svc_backup_browser_signed_in_body =>
      'Agora você pode voltar ao Hermes.';

  @override
  String get ng_rel_svc_backup_browser_waiting_title => 'Aguardando login';

  @override
  String get ng_rel_svc_backup_browser_not_current =>
      'Esta página não faz parte do login atual.';

  @override
  String get ng_rel_svc_backup_browser_open_failed =>
      'Não foi possível abrir o navegador para entrar.';

  @override
  String get ng_rel_svc_backup_browser_sign_in_timed_out =>
      'O login demorou demais. Tente novamente.';

  @override
  String ng_rel_svc_backup_gateway_refused_sign_in(int statusCode) {
    return 'O gateway recusou o login (HTTP $statusCode).';
  }

  @override
  String get rel_svc_misc_alert_caution => 'Cuidado';

  @override
  String get rel_svc_misc_alert_important => 'Importante';

  @override
  String get rel_svc_misc_alert_tip => 'Dica';

  @override
  String get rel_svc_misc_alert_warning => 'Aviso';

  @override
  String get rel_svc_misc_allow_folder_session =>
      'Permitir esta pasta até o fim da sessão.';

  @override
  String get rel_svc_misc_allow_website_session =>
      'Permitir este site até o fim da sessão.';

  @override
  String rel_svc_misc_approval_needed_title(String title) {
    return 'Aprovação necessária — $title';
  }

  @override
  String get rel_svc_misc_attach_file_reference =>
      'Anexar uma referência de arquivo';

  @override
  String get rel_svc_misc_attach_folder_reference =>
      'Anexar uma referência de pasta';

  @override
  String get rel_svc_misc_attach_git_context => 'Anexar contexto do git';

  @override
  String get rel_svc_misc_attach_image_reference =>
      'Anexar uma referência de imagem';

  @override
  String get rel_svc_misc_attach_staged_diff => 'Anexar o diff preparado';

  @override
  String get rel_svc_misc_attach_tool_reference =>
      'Anexar uma referência de ferramenta';

  @override
  String get rel_svc_misc_attach_unstaged_diff => 'Anexar o diff não preparado';

  @override
  String get rel_svc_misc_attach_url_reference =>
      'Anexar uma referência de URL';

  @override
  String get rel_svc_misc_background_task_completed =>
      'Tarefa em segundo plano concluída';

  @override
  String rel_svc_misc_background_task_named_completed(String taskId) {
    return 'Tarefa em segundo plano $taskId concluída';
  }

  @override
  String get rel_svc_misc_chat => 'Chat';

  @override
  String get rel_svc_misc_compacting_context =>
      'Compactando o contexto da conversa…';

  @override
  String rel_svc_misc_completed_in(String duration) {
    return 'Concluído em $duration';
  }

  @override
  String get rel_svc_misc_context_compacted =>
      'Contexto da conversa compactado';

  @override
  String get rel_svc_misc_cron_readback_mismatch =>
      'A releitura do modelo Cron não correspondeu';

  @override
  String get rel_svc_misc_cron_update_rejected =>
      'Atualização do Cron rejeitada';

  @override
  String get rel_svc_misc_deny_folder_grant =>
      'Não conceder acesso a esta pasta.';

  @override
  String get rel_svc_misc_deny_website_grant =>
      'Não conceder acesso a este site.';

  @override
  String rel_svc_misc_failed_after(String duration) {
    return 'Falhou após $duration';
  }

  @override
  String get rel_svc_misc_gateway_folder_unnamed =>
      'O gateway não informou uma pasta.';

  @override
  String get rel_svc_misc_gateway_idle_unconfirmed =>
      'O gateway está ocioso. Não foi possível confirmar o resultado do turno anterior.';

  @override
  String get rel_svc_misc_gateway_turn_failed => 'Falha no turno do gateway';

  @override
  String rel_svc_misc_gateway_turn_status(String status) {
    return 'Turno do gateway: $status';
  }

  @override
  String get rel_svc_misc_gateway_website_unnamed =>
      'O gateway não informou um site.';

  @override
  String get rel_svc_misc_hermes_review => 'Revisão do Hermes';

  @override
  String get rel_svc_misc_hermes_turn_failed => 'Falha no turno do Hermes';

  @override
  String get rel_svc_misc_image_recovery_companion_gap =>
      'A recuperação de imagens e texto não está disponível na recuperação complementar. Um envio de imagem não confirmado não pode ser restaurado nesta conexão, e nada é reenviado automaticamente.';

  @override
  String get rel_svc_misc_image_recovery_rest_gap =>
      'A recuperação de imagens e texto não está disponível no Classic REST/SSE. Um envio de imagem não confirmado não pode ser restaurado nesta conexão, e nada é reenviado automaticamente.';

  @override
  String rel_svc_misc_input_needed_title(String title) {
    return 'Resposta necessária — $title';
  }

  @override
  String get rel_svc_misc_parallel_workspace_connection_changed =>
      'A conexão foi alterada. Abra-a novamente para usar o espaço de trabalho.';

  @override
  String get rel_svc_misc_preparing => 'Preparando';

  @override
  String get rel_svc_misc_save_folder_grant =>
      'Salvar esta permissão de pasta para solicitações futuras.';

  @override
  String get rel_svc_misc_save_website_grant =>
      'Salvar esta permissão do site para solicitações futuras.';

  @override
  String get rel_svc_misc_stored_identity_turn_conflict =>
      'Este chat foi aberto pela identidade armazenada enquanto outro turno estava admitido. O prompt não enviado não foi enviado; tente novamente de forma explícita após o término desse turno.';

  @override
  String get rel_svc_misc_untitled => 'Sem título';

  @override
  String get rel_svc_misc_wake_capture_silent =>
      'A captura de ativação do cliente detecta apenas silêncio — verifique o acesso do sistema operacional ao microfone e reative a palavra de ativação.';

  @override
  String get rel_svc_misc_wake_capture_stalled =>
      'A captura de ativação do cliente parou: nenhum retorno de áudio do microfone foi recebido.';

  @override
  String rel_svc_misc_wake_feed_refused(int count, String detail) {
    return 'O fluxo da palavra de ativação recusou $count quadros consecutivos$detail — reative a palavra de ativação.';
  }

  @override
  String rel_svc_misc_wake_microphone_failed(String error) {
    return 'Falha no fluxo do microfone de ativação do cliente: $error';
  }

  @override
  String get rel_svc_misc_wake_track_ended =>
      'A faixa do microfone terminou durante a captura da palavra de ativação — reative a palavra de ativação.';

  @override
  String get rel_svc_misc_website => 'Site';

  @override
  String get rel_svc_lan_timeout =>
      'O tempo limite da descoberta na LAN foi excedido';

  @override
  String get rel_svc_notification_permission_denied => 'permissão negada';

  @override
  String get rel_svc_notifications_off => 'as notificações estão desativadas';

  @override
  String rel_chat_preview_pin_label(int number, String note) {
    return 'nº $number $note';
  }

  @override
  String rel_chat_preview_pin_number(int number) {
    return 'nº $number';
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
  String get fleet_managed_ssh_title => 'SSH gerenciado pelo gateway';

  @override
  String get fleet_managed_ssh_intro =>
      'Gerencie os hosts SSH já salvos neste gateway a partir de qualquer dispositivo. O Hermes já deve estar instalado no host remoto. Esta operação inicia um serviço remoto pertencente ao gateway ou se conecta a esse serviço, não estabelece uma conexão de chat do Ares. Atualizações gerenciadas e recuperação estão disponíveis apenas no aplicativo nativo para desktop.';

  @override
  String get fleet_managed_ssh_read => 'Ler hosts SSH salvos';

  @override
  String get fleet_managed_ssh_trust =>
      'Nesta primeira conexão, o gateway confiará na chave SSH deste host e a memorizará. Qualquer alteração posterior da chave será sinalizada e bloqueada. O gateway não informa a impressão digital da chave, então o Ares não pode exibi-la nem armazená-la. Continue apenas se confiar nesta primeira conexão.';

  @override
  String get fleet_managed_ssh_changed =>
      'A chave SSH deste host mudou. Conexão bloqueada. Alguém com acesso ao host do gateway deve verificar de forma independente a impressão digital da nova chave e remover a antiga chave confiável nesse host. Tente novamente apenas após essa verificação e correção. O Ares não substitui a chave confiável.';

  @override
  String get fleet_managed_ssh_disconnect_warning =>
      'Desconectar o túnel SSH e parar o serviço remoto pertencente a este gateway? Isso pode interromper outros clientes que usam esse serviço.';

  @override
  String get fleet_managed_ssh_verify =>
      'Verificar a chave pessoalmente em vez disso';

  @override
  String fleet_managed_ssh_pending(int seconds) {
    return 'Aguardando o gateway: $seconds s. Sair desta página não cancela a inicialização. Se a solicitação falhar, verifique o status antes de tentar novamente.';
  }

  @override
  String fleet_managed_ssh_status(
    String host,
    int localPort,
    int remotePort,
    String version,
    String reused,
  ) {
    return 'Host: $host\nPorta de loopback do gateway: $localPort\nPorta de loopback remota: $remotePort\nHermes: $version\nReutilizado: $reused';
  }

  @override
  String get fleet_managed_ssh_disconnect => 'Desconectar';

  @override
  String get ng_slash_suggestions_loading => 'Carregando comandos…';

  @override
  String get ng_slash_suggestions_empty => 'Nenhum comando correspondente';

  @override
  String get ng_slash_suggestions_label => 'Sugestões de comandos';

  @override
  String get ng_slash_suggestions_skill => 'Habilidade';

  @override
  String get settings_classic_title => 'Configurações Classic';

  @override
  String get settings_nextgen_title => 'Configurações NextGen';

  @override
  String get settings_category_general => 'Geral e idioma';

  @override
  String get settings_category_chat => 'Conversa e sessões';

  @override
  String get settings_category_device => 'Dispositivo e atalhos';

  @override
  String get settings_category_connections => 'Conexões e modelos';

  @override
  String get settings_category_security => 'Privacidade e backup';

  @override
  String get settings_category_about => 'Sobre e ajuda';

  @override
  String get settings_reopen_chat =>
      'Restaurar a última conversa ao voltar a um gateway';

  @override
  String get settings_reopen_chat_hint =>
      'Uma inicialização a frio abre a tela de boas-vindas. Links e notificações abrem a conversa solicitada.';

  @override
  String get settings_danger => 'Zona de perigo';
}
