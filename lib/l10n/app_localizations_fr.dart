// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get attachment_audio_failed =>
      'Impossible de lire cet audio. Le format ou le codec peut être incompatible, ou la taille limite de l’aperçu a été dépassée. Réessayez, enregistrez ou partagez le fichier original.';

  @override
  String get attachment_audio_seek => 'Position audio';

  @override
  String get workspace_workers => 'Sous-agents actifs';

  @override
  String get workers_unattached =>
      'Seul le nombre est affiché. Pour guider un sous-agent, choisissez Sous-agents actifs dans la conversation parente connectée.';

  @override
  String get slash_local_arguments =>
      'Ce raccourci n’accepte pas d’arguments ici. Utilisez les commandes de l’application ; votre brouillon a été conservé.';

  @override
  String get fallback_title => 'Modèles de secours';

  @override
  String get fallback_notice =>
      'Essayés dans cet ordre si le modèle principal est indisponible. Les modifications concernent uniquement ce profil ; enregistrez explicitement la liste complète.';

  @override
  String get fallback_unavailable =>
      'La configuration de secours est indisponible ou invalide. Vérifiez la connexion, le profil sélectionné et la version de l’hôte, puis réessayez.';

  @override
  String get fallback_discovery_unavailable =>
      'La liste des fournisseurs est indisponible. Les entrées existantes sont conservées ; réessayez pour choisir fournisseurs et modèles.';

  @override
  String get fallback_empty => 'Aucune entrée dans cette liste de secours.';

  @override
  String get fallback_incomplete =>
      'Choisissez un fournisseur et un modèle pour chaque entrée, ou supprimez les entrées incomplètes avant d’enregistrer.';

  @override
  String get fallback_add => 'Ajouter un secours';

  @override
  String get fallback_save => 'Enregistrer la liste de secours';

  @override
  String get fallback_save_failed =>
      'Impossible de vérifier la liste enregistrée. Votre brouillon est conservé. Réessayez d’enregistrer ou actualisez les paramètres de l’hôte.';

  @override
  String get fallback_saved => 'Liste de secours enregistrée et vérifiée.';

  @override
  String get fallback_legacy_title => 'Anciens secours (lecture seule)';

  @override
  String get fallback_legacy_notice =>
      'L’hôte utilise aussi fallback_model après cette liste, en ignorant les routes en double. Ces anciennes entrées sont conservées même si la liste ci-dessus est vide. Modifiez-les sur l’hôte.';

  @override
  String fallback_priority(String position) {
    return 'Priorité $position';
  }

  @override
  String get fallback_move_up => 'Monter';

  @override
  String get fallback_move_down => 'Descendre';

  @override
  String get fallback_routing_read_only =>
      'Les détails de routage ou un fournisseur non répertorié sont conservés. Modifiez ce fournisseur/modèle sur l’hôte ; vous pouvez toujours déplacer ou supprimer l’entrée ici.';

  @override
  String get cron_model_default => 'Suivre le réglage par défaut';

  @override
  String get cron_model_notice =>
      'S’applique uniquement à cette tâche cron. Sans modèle fixé, Hermes utilise le modèle cron par défaut, puis le modèle principal. Gérez les modèles personnalisés sur l’hôte.';

  @override
  String get model_management_unavailable =>
      'Impossible de charger ou d’enregistrer les paramètres du modèle. Actualisez et réessayez.';

  @override
  String get model_management_subtitle =>
      'Modèles principal, de secours et auxiliaires de ce profil';

  @override
  String get usage => 'Utilisation';

  @override
  String get nous_portal => 'Nous Portal';

  @override
  String get portal_menu_subtitle =>
      'État de la passerelle et utilisation enregistrée';

  @override
  String get portal_read_only =>
      'Données en lecture seule de la passerelle. Gérez l’authentification Nous sur l’hôte Hermes. Ces points d’accès ne fournissent ni solde d’abonnement ni crédits.';

  @override
  String get portal_status => 'État du Portal sur la passerelle';

  @override
  String get portal_free_tier => 'Accès gratuit (sans compte connecté)';

  @override
  String get portal_signed_in => 'Connecté';

  @override
  String get portal_signed_out => 'Non connecté';

  @override
  String get portal_account_tier => 'Niveau du compte';

  @override
  String get portal_recorded_usage => 'Utilisation enregistrée';

  @override
  String get portal_all_providers =>
      'Tous les fournisseurs du profil de passerelle sélectionné. Un coût enregistré nul ne signifie pas que le modèle est gratuit.';

  @override
  String portal_period(String days) {
    return '$days derniers jours';
  }

  @override
  String get portal_sessions => 'Sessions';

  @override
  String get portal_input => 'Tokens d’entrée';

  @override
  String get portal_output => 'Tokens de sortie';

  @override
  String get portal_estimated => 'Coût estimé enregistré';

  @override
  String get portal_actual => 'Coût réel enregistré';

  @override
  String get portal_recorded_models => 'Modèles enregistrés';

  @override
  String get portal_no_models => 'Aucun modèle enregistré.';

  @override
  String get portal_unavailable =>
      'Indisponible. Vérifiez la connexion, le profil sélectionné et la version de la passerelle, puis réessayez.';

  @override
  String get paste_attachment_failed_text_kept =>
      'Impossible de joindre le texte collé. Il a été conservé dans le message.';

  @override
  String get background_task_report => 'Tâche en arrière-plan';

  @override
  String get background_process_report => 'Processus en arrière-plan';

  @override
  String get background_report_issues =>
      'Des problèmes ont été signalés — développez pour les détails.';

  @override
  String get background_report_expand => 'Développer le rapport';

  @override
  String get background_report_collapse => 'Réduire le rapport';

  @override
  String get ng_brand_open_chat => 'Ouvrir un chat';

  @override
  String get ng_brand_recent => 'Récents';

  @override
  String get ng_brand_sidebar_hint =>
      'ou choisissez un chat dans la barre latérale';

  @override
  String get copy_session_id => 'Copier l’identifiant de session';

  @override
  String get copy_session_id_failed =>
      'Impossible de copier l’identifiant de session.';

  @override
  String get setup_interface_title => 'Choisissez votre interface';

  @override
  String get setup_interface_classic => 'Classic';

  @override
  String get setup_interface_nextgen => 'NextGen';

  @override
  String get setup_interface_classic_description =>
      'L’espace de travail Ares d’origine, avec tous les contrôles de connexion et les réglages Classic.';

  @override
  String get setup_interface_nextgen_description =>
      'Une nouvelle présentation avec une seule connexion au tableau de bord, des plans en direct, des sous-agents et des notifications.';

  @override
  String get setup_interface_switch_later =>
      'Vous pouvez changer à tout moment dans Réglages.';

  @override
  String get ng_confirm_model_switch => 'Changer de modèle ?';

  @override
  String get ng_switch => 'Changer';

  @override
  String get ng_model_confirmation_required =>
      'Ce modèle doit être confirmé avant de pouvoir être sélectionné.';

  @override
  String ng_model_switches_next_turn(String model) {
    return 'Passage à $model au prochain tour.';
  }

  @override
  String get ng_model_switch_not_connected =>
      'La discussion n’est pas prête pour un changement de modèle. Rouvrez-la et réessayez.';

  @override
  String ng_gateway_kept_default_model(String model) {
    return 'La passerelle a conservé $model pour cette discussion. Choisissez de nouveau le modèle avant l’envoi.';
  }

  @override
  String get hands_free_title => 'Mains libres';

  @override
  String get hands_free_start => 'Démarrer mains libres';

  @override
  String get hands_free_stop => 'Arrêter mains libres';

  @override
  String get hands_free_preparing => 'Préparation vocale — patientez';

  @override
  String get hands_free_listening => 'Dites Hey Hermes';

  @override
  String get hands_free_recording => 'Prêt — parlez maintenant';

  @override
  String get hands_free_waiting => 'En attente de Hermes';

  @override
  String get hands_free_speaking => 'Lecture — microphone coupé';

  @override
  String hands_free_followup(int seconds) {
    return 'Écouter jusqu’à $seconds secondes';
  }

  @override
  String get hands_free_error => 'Mains libres arrêté';

  @override
  String get hands_free_setup => 'Configurer mains libres';

  @override
  String hands_free_preview(String transcript) {
    return 'Aperçu vocal : $transcript';
  }

  @override
  String get hands_free_short_disclosure =>
      'Uniquement avec ce chat ouvert au premier plan. Activation hors ligne ; la voix peut utiliser le réseau. Consomme la batterie.';

  @override
  String get hands_free_error_action =>
      'Vérifiez le microphone, le service vocal, la voix et la connexion, puis Arrêter et Démarrer. Aucun renvoi automatique.';

  @override
  String get hands_free_disclosure =>
      'La détection fonctionne hors ligne sur le processeur. La reconnaissance Android, la voix choisie et la passerelle peuvent utiliser des réseaux. L’écoute consomme la batterie et peut se déclencher à tort. Elle s’arrête si le chat est couvert, fermé ou quitte le premier plan, sans reprise automatique. La dictée manuelle reste un brouillon modifiable.';

  @override
  String get hands_free_ready_cue =>
      'Dites « Hey Hermes », attendez « Prêt », puis parlez. Pas de capture d’un seul souffle ni d’audio préalable. Après une autorisation qui quitte l’app, appuyez à nouveau sur Démarrer.';

  @override
  String get hands_free_settings_title => 'Voix mains libres';

  @override
  String get hands_free_settings_subtitle =>
      'Affiche la commande de démarrage « Hey Hermes » dans les discussions. La désactiver arrête toute session mains libres en cours.';

  @override
  String get hands_free_timing_limit =>
      'La fenêtre de suivi est une durée maximale, non minimale. Android peut s’arrêter plus tôt. Le silence ramène à l’activation locale sans redémarrages répétés de reconnaissance.';

  @override
  String get hands_free_followup_off =>
      'Suivi désactivé — dites Hey Hermes pour chaque message';

  @override
  String get hands_free_start_blocked =>
      'Brouillon vide, aucun fichier joint, chat connecté au repos et réponses vocales activées requis. Terminez d’abord les actions vocales manuelles.';

  @override
  String get hands_free_setup_complete =>
      'Configuration du microphone terminée. Appuyez à nouveau sur Démarrer.';

  @override
  String message_time_recorded(String time) {
    return 'Enregistré par le serveur : $time (heure locale)';
  }

  @override
  String message_time_sent(String time) {
    return 'Envoi observé sur cet appareil : $time (heure locale)';
  }

  @override
  String message_time_received(String time) {
    return 'Première réception sur cet appareil : $time (heure locale)';
  }

  @override
  String get stop_and_send => 'Arrêter et envoyer';

  @override
  String get message_queued_for_running_turn =>
      'Message mis en attente pour l’exécution en cours.';

  @override
  String get running_message_not_accepted =>
      'Hermes n’a pas pu accepter ce message. Votre brouillon est conservé ; arrêtez la réponse ou attendez, puis renvoyez-le.';

  @override
  String get running_message_delivery_unknown =>
      'L’envoi n’a pas pu être confirmé. Votre brouillon est conservé. Vérifiez la conversation avant de réessayer.';

  @override
  String get attachment_tap_to_preview => 'Appuyer pour afficher un aperçu';

  @override
  String get attachment_save => 'Enregistrer';

  @override
  String get attachment_share => 'Partager';

  @override
  String get attachment_saved => 'Fichier enregistré';

  @override
  String get attachment_save_cancelled => 'Enregistrement annulé';

  @override
  String get attachment_save_failed =>
      'Impossible d’enregistrer ce fichier. Veuillez réessayer.';

  @override
  String get attachment_share_failed =>
      'Impossible de partager ce fichier. Veuillez réessayer.';

  @override
  String get attachment_download_failed =>
      'Impossible de charger ce fichier. Vérifiez la connexion et réessayez.';

  @override
  String get attachment_no_inline_preview =>
      'Aucun aperçu n’est disponible pour ce type de fichier. Enregistrez ou partagez le fichier original pour l’ouvrir dans une autre application.';

  @override
  String get attachment_image_failed =>
      'Impossible de décoder cette image. Vous pouvez toujours enregistrer ou partager le fichier original.';

  @override
  String get attachment_text_truncated =>
      'Aperçu raccourci. Enregistrez ou partagez le fichier pour le lire en entier.';

  @override
  String get attachment_text_unavailable =>
      'Impossible d’afficher ce fichier sous forme de texte. Enregistrez ou partagez le fichier original.';

  @override
  String get attachment_pdf_failed =>
      'Impossible d’afficher un aperçu de ce PDF. Enregistrez ou partagez le fichier original.';

  @override
  String get attachment_pdf_unavailable =>
      'Les aperçus PDF sont disponibles sur Android. Vous pouvez toujours enregistrer ou partager ce fichier.';

  @override
  String attachment_pdf_page(int page, int total) {
    return 'Page $page sur $total';
  }

  @override
  String get attachment_previous_page => 'Page précédente';

  @override
  String get attachment_next_page => 'Page suivante';

  @override
  String get attachment_loading => 'Chargement de l’aperçu…';

  @override
  String get attachment_document_text_notice =>
      'Aperçu du texte. La mise en page, les images et la mise en forme peuvent différer de l’original.';

  @override
  String get attachment_document_failed =>
      'Impossible d’afficher un aperçu de ce document. Enregistrez ou partagez le fichier original.';

  @override
  String get attachment_document_empty =>
      'Aucun texte lisible n’a été trouvé dans ce document.';

  @override
  String get attachment_video_failed =>
      'Impossible de lire cette vidéo. Son format ou son codec n’est peut-être pas pris en charge. Enregistrez ou partagez le fichier original.';

  @override
  String get attachment_video_play => 'Lire';

  @override
  String get attachment_video_pause => 'Pause';

  @override
  String get attachment_video_mute => 'Couper le son';

  @override
  String get attachment_video_unmute => 'Activer le son';

  @override
  String get attachment_video_seek => 'Position de la vidéo';

  @override
  String get attachment_close => 'Fermer l’aperçu';

  @override
  String get attachment_retry => 'Réessayer';

  @override
  String get saved_history_heading => 'Historique enregistré';

  @override
  String get received_output_heading =>
      'Sortie reçue — correspondance avec l’historique enregistré non confirmée';

  @override
  String get received_output_details => 'À propos de la sortie reçue';

  @override
  String get received_output_explanation =>
      'Ceci peut aussi apparaître dans l’historique enregistré. L’application ne peut pas confirmer de correspondance.';

  @override
  String get local_prompt_context => 'Contexte local du prompt';

  @override
  String get received_output_badge => 'Reçu · correspondance non confirmée';

  @override
  String get received_output_lifetime =>
      'Les sorties reçues sont conservées temporairement dans cette session de l’application et peuvent être raccourcies ou supprimées lorsque les limites sont atteintes. Elles peuvent ne plus être disponibles après la fermeture de l’application ou de la connexion.';

  @override
  String get theme_palette => 'Thème de couleur';

  @override
  String get theme_palette_gold => 'Or';

  @override
  String get theme_palette_purple => 'Violet';

  @override
  String get theme_palette_orange => 'Orange';

  @override
  String get theme_palette_green => 'Vert';

  @override
  String get theme_palette_blue => 'Bleu';

  @override
  String get theme_palette_red => 'Rouge';

  @override
  String get theme_palette_teal => 'Bleu sarcelle';

  @override
  String get theme_palette_pink => 'Rose';

  @override
  String get theme_palette_indigo => 'Indigo';

  @override
  String get theme_palette_cyan => 'Cyan';

  @override
  String get assets_recent_subtitle =>
      'Retrouvez les fichiers partagés par Hermes dans les discussions enregistrées';

  @override
  String get assets_scope_notice =>
      'Fichiers générés explicitement partagés par Hermes dans les réponses enregistrées. Il s’agit d’une vue partielle de l’historique des discussions, et non d’un catalogue complet des fichiers ou pièces jointes. Les fichiers référencés peuvent ne plus exister.';

  @override
  String get assets_download_limit =>
      'Les fichiers ne sont chargés que lorsque vous appuyez dessus. Les aperçus et les téléchargements sont limités à 25 MiB par fichier ; utilisez le tableau de bord pour les fichiers plus volumineux.';

  @override
  String get assets_search_hint =>
      'Rechercher parmi les fichiers trouvés ou les discussions d’origine';

  @override
  String get assets_all => 'Tous';

  @override
  String get assets_images => 'Images';

  @override
  String get assets_audio => 'Audio';

  @override
  String get assets_video => 'Vidéo';

  @override
  String get assets_documents => 'Documents et autres fichiers';

  @override
  String get assets_empty =>
      'Aucune ressource trouvée dans les messages analysés';

  @override
  String get assets_empty_detail =>
      'Analysez davantage de discussions ou des messages plus anciens pour remonter plus loin dans l’historique. Les pièces jointes ordinaires et les fichiers sans lien ne sont pas indexés ici.';

  @override
  String get assets_no_matches => 'Aucune ressource correspondante';

  @override
  String get assets_load_more_chats => 'Analyser plus de discussions';

  @override
  String get assets_load_older_messages => 'Analyser les messages plus anciens';

  @override
  String get assets_load_failed =>
      'Une partie de l’historique n’a pas pu être lue. Les résultats sont incomplets. Vérifiez la connexion au tableau de bord, puis réessayez.';

  @override
  String get assets_retry_failed =>
      'Réessayer les lectures de l’historique qui ont échoué';

  @override
  String get assets_partial =>
      'Le serveur a signalé un historique incomplet. Vérifiez le tableau de bord, puis actualisez.';

  @override
  String assets_scan_summary(int files, int chats) {
    return 'Références de fichiers trouvées : $files · Discussions analysées : $chats';
  }

  @override
  String assets_open_chat(String title) {
    return 'Ouvrir la discussion : $title';
  }

  @override
  String get assets_file_too_large =>
      'Ce fichier dépasse la limite de téléchargement. Ouvrez le tableau de bord pour le télécharger.';

  @override
  String get a_one_off_question_archives_itself_after_72_hours_anything =>
      'Une question ponctuelle. S\'archive automatiquement après 72 heures ; tout ce qui mérite d\'être conservé reste en mémoire.';

  @override
  String get archive_chat => 'Archiver la discussion';

  @override
  String get unarchive_chat => 'Désarchiver la discussion';

  @override
  String get chat_archived => 'Discussion archivée';

  @override
  String get chat_unarchived => 'Discussion désarchivée';

  @override
  String could_not_update_chat_archive(Object error) {
    return 'Impossible de modifier l’archivage de la discussion : $error';
  }

  @override
  String get quick_chat_description => 'Une question ponctuelle.';

  @override
  String get ai_full_text => 'IA + texte intégral';

  @override
  String get ai_search_model => 'Modèle de recherche IA';

  @override
  String ai_searched_for(Object aiRewrittenQuery) {
    return 'L\'IA a recherché : $aiRewrittenQuery';
  }

  @override
  String get ai_assisted_filing => 'Classement assisté par IA';

  @override
  String get api_key => 'Clé API';

  @override
  String get api_server_key_from_hermes_env =>
      'API_SERVER_KEY depuis ~/.hermes/.env';

  @override
  String get active => 'Actif';

  @override
  String get activity => 'Activité';

  @override
  String get activity_reads_the_durable_turn_journal_to_know_what_hermes =>
      'L\'activité lit le journal durable des tours pour savoir ce que fait Hermes. Vérifiez que la passerelle est accessible, puis réessayez.';

  @override
  String get add => 'Ajouter';

  @override
  String get add_connection => 'Ajouter une connexion';

  @override
  String get add_cron_job => 'Ajouter une tâche Cron';

  @override
  String get add_gateway_connection => 'Ajouter une connexion passerelle';

  @override
  String get add_and_update_connections_from_the_backup_keep_the_rest =>
      'Ajouter et mettre à jour les connexions depuis la sauvegarde, conserver les autres.';

  @override
  String get add_attachment => 'Ajouter une pièce jointe';

  @override
  String get add_new_cron_job => 'Ajouter une nouvelle tâche Cron';

  @override
  String get add_to_chat => 'Ajouter à la discussion';

  @override
  String get all_chats => 'Toutes les discussions';

  @override
  String get all_stored_message_content =>
      'Tout le contenu des messages stocké';

  @override
  String get allow_for_this_session => 'Autoriser pour cette session';

  @override
  String get allow_matching_commands_until_this_hermes_session_ends =>
      'Autoriser les commandes correspondantes jusqu\'à la fin de cette session Hermes.';

  @override
  String get allow_folder_until_sandbox_off =>
      'Autoriser ce dossier jusqu’à la désactivation du bac à sable.';

  @override
  String get allow_once => 'Autoriser une fois';

  @override
  String get allow_website_until_sandbox_off =>
      'Autoriser ce site web jusqu’à la désactivation du bac à sable.';

  @override
  String get always_allow => 'Toujours autoriser';

  @override
  String get apply_to_this_chat => 'Appliquer à cette discussion';

  @override
  String get approval_needed => 'Approbation requise';

  @override
  String get approval_needed_description =>
      'Une commande attend votre approbation ou votre refus.';

  @override
  String get approve => 'Approuver';

  @override
  String get archive => 'Archiver';

  @override
  String get archive_project => 'Archiver le projet';

  @override
  String archive_2(Object projectName) {
    return 'Archiver $projectName ?';
  }

  @override
  String archive_3(Object name) {
    return 'Archiver $name ?';
  }

  @override
  String get archived => 'Archivé';

  @override
  String get archived_conversations_appear_here =>
      'Seules les discussions archivées apparaissent ici. Les anciennes restent dans Toutes les discussions.';

  @override
  String get archived_quick_chats => 'Discussions rapides archivées';

  @override
  String get artifacts_attachments_and_generated_media =>
      'Artefacts, pièces jointes et médias générés';

  @override
  String get ask_ai_to_find_a_conversation =>
      'Demander à l\'IA de trouver une discussion';

  @override
  String get assets => 'Ressources';

  @override
  String get assets_need_a_server_authoritative_assets_index_in_the_hermes =>
      'Les ressources nécessitent un index faisant autorité côté serveur dans la passerelle Hermes avant de pouvoir être affichées par projet.';

  @override
  String get assets_unavailable => 'Ressources indisponibles';

  @override
  String get attach_image_or_file => 'Joindre une image ou un fichier';

  @override
  String get attachment_drafts => 'Brouillons de pièces jointes';

  @override
  String get recover_text_draft => 'Récupérer un brouillon';

  @override
  String get undo_draft_recovery => 'Annuler';

  @override
  String get draft_session_exists =>
      'Cette discussion existe toujours. Ouvrez-la pour reprendre votre brouillon.';

  @override
  String get draft_recovery_unavailable =>
      'Impossible de vérifier le brouillon. Aucune modification effectuée.';

  @override
  String attachment_of(Object index, Object total) {
    return 'Pièce jointe $index sur $total';
  }

  @override
  String get auto_device_default => 'Automatique (par défaut de l\'appareil)';

  @override
  String get agent => 'Agent';

  @override
  String get autonomous_agents => 'Agents autonomes';

  @override
  String get background_recovery_unavailable_legacy_transport =>
      'Récupération en arrière-plan indisponible — transport hérité';

  @override
  String get background_task_completed => 'Tâche en arrière-plan terminée';

  @override
  String get background_task_completed_description =>
      'Une commande de terminal en arrière-plan est terminée.';

  @override
  String get backup_restore => 'Sauvegarde et restauration';

  @override
  String backup_exported(Object destination) {
    return 'Sauvegarde exportée — $destination';
  }

  @override
  String get base_url => 'URL de base';

  @override
  String get binary_preview_is_unavailable_download_the_file_to_open_it =>
      'L\'aperçu binaire n\'est pas disponible. Téléchargez le fichier pour l\'ouvrir.';

  @override
  String get branch => 'Branche';

  @override
  String get branch_chat => 'Créer une branche de la discussion';

  @override
  String get branch_created_in_hermes_history =>
      'Branche créée dans l\'historique Hermes.';

  @override
  String get browse_and_manage_your_hermes_agent_sessions_from_your_phone =>
      'Parcourez et gérez vos sessions Hermes Agent depuis votre téléphone. Se connecte à un tableau de bord Hermes exécuté sur votre réseau local.';

  @override
  String get browse_server_files => 'Parcourir les fichiers du serveur';

  @override
  String get browse_the_miniserver_folders_behind_your_projects =>
      'Parcourez les dossiers miniserver derrière vos projets';

  @override
  String get cancel => 'Annuler';

  @override
  String get cancel_voice_input => 'Annuler la saisie vocale';

  @override
  String cannot_reach(Object host, Object port) {
    return 'Impossible d\'atteindre $host:$port.';
  }

  @override
  String cannot_reach_check_the_host_and_port(Object host, Object port) {
    return 'Impossible d\'atteindre $host:$port. Vérifiez l\'hôte et le port.';
  }

  @override
  String get change_ai_search_model => 'Changer le modèle de recherche IA';

  @override
  String changes_the_default_for_use_the_selector_in_a_chat(Object label) {
    return 'Modifie la valeur par défaut de $label. Utilisez le sélecteur dans une discussion pour ne remplacer que celle-ci.';
  }

  @override
  String get chat_actions => 'Actions de la discussion';

  @override
  String get chats => 'Discussions';

  @override
  String get chats_from_this_gateway_are_not_grouped_yet_grouping_stays =>
      'Les discussions de cette passerelle ne sont pas encore regroupées. Le regroupement reste sur ce téléphone tant que la passerelle ne peut pas héberger de projets.';

  @override
  String get chats_in_this_project_will_show_their_state_and_last =>
      'Les discussions de ce projet afficheront ici leur état et leur dernière activité.';

  @override
  String get chats_that_are_not_assigned_to_a_project =>
      'Discussions non affectées à un projet';

  @override
  String get chats_you_start_in_this_project_will_appear_here_on =>
      'Les discussions que vous démarrez dans ce projet apparaîtront ici, sur tous les appareils connectés à ce Hermes.';

  @override
  String get check_that_the_gateway_is_running_and_reachable_then_try =>
      'Vérifiez que la passerelle est en cours d\'exécution et accessible, puis réessayez.';

  @override
  String get check_the_dashboard_connection_and_try_again =>
      'Vérifiez la connexion au tableau de bord, puis réessayez.';

  @override
  String get check_the_connection_and_try_again =>
      'Vérifiez la connexion, puis réessayez.';

  @override
  String get choose_a_small_model_to_rewrite_queries =>
      'Choisissez un petit modèle pour reformuler les requêtes';

  @override
  String get choose_an_ai_search_model_before_using_ai_search =>
      'Choisissez un modèle de recherche IA avant d\'utiliser la recherche IA.';

  @override
  String get choose_an_active_project_next =>
      'Choisissez ensuite un projet actif';

  @override
  String get choose_chat_model => 'Choisir le modèle de discussion';

  @override
  String get choose_files => 'Choisir des fichiers';

  @override
  String get choose_image => 'Choisir une image';

  @override
  String get choose_images => 'Choisir des images';

  @override
  String get choose_its_destination_space =>
      'Choisissez son espace de destination';

  @override
  String get clear_search => 'Effacer la recherche';

  @override
  String get close => 'Fermer';

  @override
  String get code_copied => 'Code copié';

  @override
  String get code_format => 'Code';

  @override
  String get coming_next => 'Bientôt disponible';

  @override
  String get command => 'Commande';

  @override
  String get command_palette => 'Palette de commandes';

  @override
  String get command_palette_hint => 'Saisir une commande';

  @override
  String get command_palette_no_results => 'Aucune commande trouvée';

  @override
  String get command_palette_new_chat => 'Nouvelle discussion';

  @override
  String get command_palette_search_chats => 'Rechercher des discussions';

  @override
  String get command_palette_toggle_theme => 'Changer de thème';

  @override
  String get command_palette_copy_last_code => 'Copier le dernier bloc de code';

  @override
  String get command_line_chats => 'Discussions en ligne de commande';

  @override
  String get compatibility_mode => 'Mode de compatibilité';

  @override
  String get configure_a_valid_desktop_gateway_url_before_attaching_files =>
      'Configurez une URL de Desktop Gateway valide avant de joindre des fichiers.';

  @override
  String get confirm_always_allow => 'Confirmer « Toujours autoriser »';

  @override
  String get confirm_passphrase => 'Confirmer la phrase de passe';

  @override
  String connecting_to(Object baseUrl) {
    return 'Connexion à $baseUrl...';
  }

  @override
  String get connection_issue => 'Problème de connexion';

  @override
  String
  get connection_switched_the_running_reply_continues_on_the_server_and =>
      'Connexion basculée — la réponse en cours continue sur le serveur et se rattachera automatiquement.';

  @override
  String get connection_appearance_and_device_preferences =>
      'Connexion, apparence et préférences de l\'appareil';

  @override
  String context_tokens(Object effectiveContextLength) {
    return 'Contexte : $effectiveContextLength tokens';
  }

  @override
  String get continue_label => 'Continuer';

  @override
  String get continue_working => 'Continuer le travail';

  @override
  String get conversations_in_this_project => 'Discussions de ce projet';

  @override
  String get copy_code => 'Copier le code';

  @override
  String get copy_message => 'Copier le message';

  @override
  String could_not_branch_chat(Object error) {
    return 'Impossible de créer une branche de la discussion : $error';
  }

  @override
  String could_not_delete_session(Object error) {
    return 'Impossible de supprimer la session : $error';
  }

  @override
  String could_not_deny_the_command(Object error) {
    return 'Impossible de refuser la commande : $error';
  }

  @override
  String could_not_load_ai_search_models(Object error) {
    return 'Impossible de charger les modèles de recherche IA : $error';
  }

  @override
  String get could_not_load_conversations =>
      'Impossible de charger les discussions';

  @override
  String get could_not_load_files => 'Impossible de charger les fichiers';

  @override
  String could_not_load_models_for_this_profile(Object error) {
    return 'Impossible de charger les modèles de ce profil : $error';
  }

  @override
  String could_not_load_more_chats(Object error) {
    return 'Impossible de charger plus de discussions : $error';
  }

  @override
  String get could_not_open_link => 'Impossible d’ouvrir ce lien.';

  @override
  String get could_not_open_the_hermes_dashboard =>
      'Impossible d\'ouvrir le tableau de bord Hermes.';

  @override
  String get could_not_open_this_project => 'Impossible d\'ouvrir ce projet';

  @override
  String get could_not_preview_file => 'Impossible de prévisualiser le fichier';

  @override
  String get could_not_reach_hermes => 'Impossible d\'atteindre Hermes';

  @override
  String could_not_reach_authenticate_the_dashboard_at_check_the_port(
    Object dashboardPort,
    Object host,
  ) {
    return 'Impossible d\'atteindre ou d\'authentifier le tableau de bord sur $host:$dashboardPort. Vérifiez le port et les identifiants.';
  }

  @override
  String get could_not_read_activity => 'Impossible de lire l\'activité';

  @override
  String could_not_rename_chat(Object error) {
    return 'Impossible de renommer la discussion : $error';
  }

  @override
  String could_not_send_the_approval(Object error) {
    return 'Impossible d\'envoyer l\'approbation : $error';
  }

  @override
  String get could_not_skip_the_hermes_question =>
      'Impossible d\'ignorer la question de Hermes.';

  @override
  String could_not_the_project(Object action, Object error) {
    return 'Impossible de $action le projet : $error';
  }

  @override
  String get couldn_t_delete_project => 'Impossible de supprimer le projet';

  @override
  String couldn_t_load_runs(Object error) {
    return 'Impossible de charger les exécutions : $error';
  }

  @override
  String get couldn_t_move_conversation =>
      'Impossible de déplacer la discussion';

  @override
  String couldn_t_move_to(Object label, Object reason) {
    return 'Impossible de déplacer vers $label : $reason';
  }

  @override
  String get couldn_t_prepare_the_shared_files =>
      'Impossible de préparer les fichiers partagés.';

  @override
  String get couldn_t_promote_conversation =>
      'Impossible de promouvoir la discussion';

  @override
  String couldn_t_project(Object action) {
    return 'Impossible de $action le projet';
  }

  @override
  String get create => 'Créer';

  @override
  String get create_a_project => 'Créer un projet';

  @override
  String get create_a_project_first_then_chats_can_live_inside_it =>
      'Créez d\'abord un projet ; les discussions pourront y vivre.';

  @override
  String get create_a_space_to_separate_related_conversations =>
      'Créez un espace pour séparer les discussions liées.';

  @override
  String get create_branch => 'Créer une branche';

  @override
  String get credit_notifications => 'Notifications de crédit';

  @override
  String get credit_notifications_description =>
      'L’utilisation du crédit a été arrêtée ou rétablie.';

  @override
  String get cron => 'Cron';

  @override
  String get crons => 'Tâches cron';

  @override
  String get cron_conversations_empty =>
      'Les conversations des tâches planifiées apparaissent ici, y compris celles des anciennes exécutions.';

  @override
  String get search_cron_conversations => 'Rechercher des conversations cron';

  @override
  String get cron_jobs => 'Tâches Cron';

  @override
  String cron_schedule_timezone(Object zone) {
    return 'Fuseau horaire de la planification : $zone';
  }

  @override
  String get crons_upcoming => 'À venir';

  @override
  String get crons_history => 'Historique';

  @override
  String cron_time_with_zone(Object time, Object zone) {
    return '$time ($zone)';
  }

  @override
  String cron_time_zone_unknown(Object time) {
    return '$time (fuseau horaire inconnu)';
  }

  @override
  String get cron_no_next_run => 'Aucune prochaine exécution planifiée';

  @override
  String get cron_status_scheduled => 'Planifiée';

  @override
  String get cron_status_paused => 'En pause';

  @override
  String cron_delivers_to(Object target) {
    return 'Livraison vers $target';
  }

  @override
  String get cron_upcoming_empty_title => 'Aucune tâche planifiée';

  @override
  String get cron_upcoming_empty_message =>
      'Rien n’est planifié. Créez une tâche dans Tâches Cron, ou demandez à l’agent d’en planifier une.';

  @override
  String get cron_upcoming_unavailable => 'Tâches planifiées indisponibles';

  @override
  String get cron_upcoming_needs_dashboard =>
      'Les tâches planifiées nécessitent une connexion au tableau de bord. Cette adresse n’expose pas la planification Cron. Vérifiez l’adresse du tableau de bord et la prise en charge par l’hôte.';

  @override
  String get cron_upcoming_needs_dashboard_auth =>
      'Les tâches planifiées nécessitent une authentification au tableau de bord. Ajoutez le nom d’utilisateur et le mot de passe du tableau de bord à cette connexion, ou activez le mode proxy.';

  @override
  String get cron_upcoming_dashboard_unreachable =>
      'Le tableau de bord est injoignable. Vérifiez l’hôte, le port du tableau de bord et le réseau, puis réessayez.';

  @override
  String get cron_upcoming_load_failed =>
      'Impossible de lire les tâches planifiées. Vérifiez la connexion au tableau de bord, puis réessayez.';

  @override
  String get cron_upcoming_refresh_failed =>
      'Impossible d’actualiser la planification. La dernière lecture réussie est affichée.';

  @override
  String get cron_job_added => 'Tâche Cron ajoutée';

  @override
  String get cron_job_updated => 'Tâche Cron mise à jour';

  @override
  String get cron_run => 'Exécution Cron';

  @override
  String get cross_device_ordering_and_reversible_bulk_organization =>
      'Ordre entre appareils et organisation en masse réversible';

  @override
  String get current_profile_default => 'Valeur par défaut du profil actuel';

  @override
  String get custom_proxy_and_dashboard_details =>
      'Détails personnalisés du proxy et du tableau de bord';

  @override
  String get dark => 'Sombre';

  @override
  String get dashboard_proxy_settings =>
      'Paramètres du tableau de bord / proxy';

  @override
  String get dashboard_password_optional =>
      'Mot de passe du tableau de bord (facultatif)';

  @override
  String get dashboard_port => 'Port du tableau de bord';

  @override
  String get dashboard_username_optional =>
      'Nom d\'utilisateur du tableau de bord (facultatif)';

  @override
  String get dashboard_behind_proxy => 'Tableau de bord derrière un proxy';

  @override
  String get dashboard_path_prefix => 'Préfixe de chemin du tableau de bord';

  @override
  String delegated_task(Object goal) {
    return 'Tâche déléguée : $goal';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String delete_2(Object name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String delete_from_the_remote_hermes_history_this_cannot_be_undone(
    Object title,
  ) {
    return 'Supprimer « $title » de l\'historique Hermes distant ? Cette action est irréversible.';
  }

  @override
  String get delete_cron_job => 'Supprimer la tâche Cron';

  @override
  String get delete_connections_that_are_not_in_the_backup =>
      'Supprimer les connexions absentes de la sauvegarde.';

  @override
  String delete_failed(Object error) {
    return 'Échec de la suppression : $error';
  }

  @override
  String get delete_project => 'Supprimer le projet';

  @override
  String get delete_session => 'Supprimer la session ?';

  @override
  String delete_3(Object projectName) {
    return 'Supprimer $projectName ?';
  }

  @override
  String deleted(Object name) {
    return '« $name » supprimé';
  }

  @override
  String get delivery_is_uncertain_recovering_without_resending =>
      'La livraison est incertaine ; récupération sans renvoi…';

  @override
  String get desktop_gateway_url_optional =>
      'URL de Desktop Gateway (facultatif)';

  @override
  String get desktop_gateway_is_not_configured_for_this_connection =>
      'Desktop Gateway n\'est pas configuré pour cette connexion.';

  @override
  String get desktop_app => 'Application de bureau';

  @override
  String get developer_tool_calls => 'Appels d\'outils du développeur';

  @override
  String get discord_chats => 'Discussions Discord';

  @override
  String get dismiss => 'Ignorer';

  @override
  String get do_not_run_this_command => 'N\'exécutez pas cette commande.';

  @override
  String get documents_archives_audio_video_or_data =>
      'Documents, archives, audio, vidéo ou données';

  @override
  String get download => 'Télécharger';

  @override
  String download_failed(Object error) {
    return 'Échec du téléchargement : $error';
  }

  @override
  String get durable_facts_hermes_keeps_about_you =>
      'Faits durables que Hermes conserve à votre sujet';

  @override
  String get durable_work_inside_one_of_your_projects_shared_with_desktop =>
      'Travail durable au sein de l\'un de vos projets, partagé avec Desktop.';

  @override
  String get edit => 'Modifier';

  @override
  String get edit_connection => 'Modifier la connexion';

  @override
  String get edit_cron_job => 'Modifier la tâche Cron';

  @override
  String get edit_gateway_connection => 'Modifier la connexion passerelle';

  @override
  String get edit_and_resend => 'Modifier et renvoyer';

  @override
  String get enable_notifications => 'Activer les notifications';

  @override
  String get enable_notifications_description =>
      'Désactiver ceci désactive toutes les notifications ci-dessous.';

  @override
  String get enables_file_attachments_through_the_desktop_remote_gateway =>
      'Active les pièces jointes via la passerelle distante Desktop.';

  @override
  String get enter_a_name => 'Saisissez un nom';

  @override
  String get enter_a_passphrase => 'Saisissez une phrase de passe.';

  @override
  String get enter_the_passphrase_for_this_backup =>
      'Saisissez la phrase de passe de cette sauvegarde.';

  @override
  String get every_conversation_is_already_assigned_to_a_project =>
      'Chaque discussion est déjà affectée à un projet.';

  @override
  String get everything_not_yet_native_in_the_authenticated_web_dashboard =>
      'Tout ce qui n\'est pas encore natif, dans le tableau de bord web authentifié';

  @override
  String get explain_the_attached_content_clearly =>
      'Expliquez clairement le contenu joint.';

  @override
  String explain_this_content_clearly(Object text) {
    return 'Expliquez clairement ce contenu :\n\n$text';
  }

  @override
  String
  get explicit_choices_adjust_android_accessibility_text_size_system_leaves_it =>
      'Les choix explicites ajustent la taille de texte d\'accessibilité Android ; « Système » la laisse inchangée.';

  @override
  String get export_label => 'Exporter';

  @override
  String get export_share => 'Exporter / partager';

  @override
  String get external_api_clients => 'Clients API externes';

  @override
  String get extra_high => 'Très élevé';

  @override
  String get extract_tasks => 'Extraire les tâches';

  @override
  String
  get extract_the_decisions_deadlines_owners_and_actionable_action_items_from =>
      'Extrayez du contenu joint les décisions, les échéances, les responsables et les actions concrètes.';

  @override
  String
  extract_the_decisions_deadlines_owners_and_actionable_action_items_from_2(
    Object text,
  ) {
    return 'Extrayez de ce contenu les décisions, les échéances, les responsables et les actions concrètes :\n\n$text';
  }

  @override
  String failed_to_add_job(Object error) {
    return 'Échec de l\'ajout de la tâche : $error';
  }

  @override
  String get failed_to_load_cron_jobs => 'Échec du chargement des tâches Cron';

  @override
  String get failed_to_load_memory => 'Échec du chargement de la mémoire';

  @override
  String get failed_to_load_messages => 'Échec du chargement des messages';

  @override
  String get failed_to_load_settings => 'Échec du chargement des paramètres';

  @override
  String get failed_to_load_skills => 'Échec du chargement des compétences';

  @override
  String failed_to_update_job(Object error) {
    return 'Échec de la mise à jour de la tâche : $error';
  }

  @override
  String failed(Object error) {
    return 'Échec : $error';
  }

  @override
  String get file_attached_document_catalog_registration_is_pending =>
      'Fichier joint ; l\'enregistrement au catalogue de documents est en attente.';

  @override
  String get file_reference_added_to_chat =>
      'Référence de fichier ajoutée à la discussion';

  @override
  String get files => 'Fichiers';

  @override
  String get fill_from_document => 'Remplir depuis le document';

  @override
  String get folder_is_empty => 'Le dossier est vide';

  @override
  String get folders => 'Dossiers';

  @override
  String get full_text => 'Texte intégral';

  @override
  String get gateway_api_access => 'Accès à l\'API de la passerelle';

  @override
  String get gateway_connected_but_the_dashboard_could_not_be_reached_or =>
      'Passerelle connectée, mais le tableau de bord est inaccessible ou non authentifié. Vérifiez les détails du tableau de bord, ou effacez-les pour ignorer.';

  @override
  String get gateway_path_prefix => 'Préfixe de chemin de la passerelle';

  @override
  String get go_to_end => 'Aller à la fin';

  @override
  String get hermes_agent => 'Ares - formerly Hermes Android';

  @override
  String get hermes_agent_for_android => 'Ares - formerly Hermes Android';

  @override
  String get hermes_could_not_accept_the_answer_please_try_again =>
      'Hermes n\'a pas pu accepter la réponse. Veuillez réessayer.';

  @override
  String get hermes_could_not_load_your_saved_connections =>
      'Hermes n\'a pas pu charger vos connexions enregistrées';

  @override
  String get hermes_did_not_accept_the_response_please_try_again =>
      'Hermes n\'a pas accepté la réponse. Veuillez réessayer.';

  @override
  String get hermes_is_responding => 'Hermes répond…';

  @override
  String get hermes_is_waiting_for_input => 'Hermes attend votre saisie…';

  @override
  String get hermes_keeps_android_accessibility_text_scaling_active =>
      'Ares maintient la mise à l\'échelle du texte d\'accessibilité Android active.';

  @override
  String get hermes_needs_your_input => 'Hermes a besoin de votre saisie';

  @override
  String get hermes_profile_optional => 'Profil Hermes (facultatif)';

  @override
  String get hermes_profile_must_be_a_plain_profile_name_such_as =>
      'Le profil Hermes doit être un simple nom de profil tel que « sol », pas un chemin.';

  @override
  String get hermes_reasoning_details => 'Détails du raisonnement de Hermes';

  @override
  String hermes_recovery_is_unavailable(Object error) {
    return 'La récupération Hermes est indisponible : $error';
  }

  @override
  String get hermes_stopped_recovery_safely_no_prompt_was_resent =>
      'Hermes a arrêté la récupération en toute sécurité. Aucun prompt n\'a été renvoyé.';

  @override
  String get hide_passphrase => 'Masquer la phrase de passe';

  @override
  String get home_needs_your_recent_chats_to_know_what_deserves_your =>
      'L\'accueil a besoin de vos discussions récentes pour savoir ce qui mérite votre attention. Vérifiez que la passerelle est accessible, puis réessayez.';

  @override
  String get host => 'Hôte';

  @override
  String get image_selection_was_interrupted_try_again =>
      'La sélection d\'image a été interrompue. Réessayez.';

  @override
  String get import_label => 'Importer';

  @override
  String get inbox => 'Boîte de réception';

  @override
  String get inbox_is_clear => 'La boîte de réception est vide';

  @override
  String get input_needed => 'Réponse requise';

  @override
  String get input_needed_description =>
      'Hermes a posé une question ou a besoin d’un mot de passe ou d’un secret.';

  @override
  String get insert_a_remote_file_reference =>
      'Insérer une référence @file distante';

  @override
  String get invalid_port_number => 'Numéro de port invalide.';

  @override
  String get job_paused => 'Tâche en pause';

  @override
  String get job_resumed => 'Tâche reprise';

  @override
  String get job_triggered => 'Tâche déclenchée';

  @override
  String get label => 'Libellé';

  @override
  String last_activity(Object day, Object month, Object year) {
    return 'Dernière activité $day/$month/$year';
  }

  @override
  String last(Object lastRun) {
    return 'Dernière : $lastRun';
  }

  @override
  String get leave_blank_for_default_8642_443_with_https =>
      'Laissez vide pour la valeur par défaut (8642 ; 443 avec https)';

  @override
  String get leave_blank_for_default_9119 =>
      'Laissez vide pour la valeur par défaut (9119)';

  @override
  String get light => 'Clair';

  @override
  String listening(Object elapsed) {
    return 'Écoute • $elapsed';
  }

  @override
  String listening_elapsed(Object elapsed) {
    return 'Écoute, écoulé : $elapsed';
  }

  @override
  String get load_more => 'Charger plus…';

  @override
  String get loading => 'Chargement';

  @override
  String get location => 'Emplacement';

  @override
  String get make_sure_the_gateway_api_server_is_running_hermes_gateway =>
      'Assurez-vous que le serveur API de la passerelle est en cours d\'exécution\n(hermes gateway status)';

  @override
  String matches(Object assigned, Object name) {
    return 'Correspond à $name · $assigned';
  }

  @override
  String get memory => 'Mémoire';

  @override
  String get memory_about_you => 'À votre sujet';

  @override
  String get memory_agent_notes => 'Notes de l’agent';

  @override
  String get memory_builtin_scope =>
      'Faits enregistrés dans USER.md et MEMORY.md de ce profil. Les fournisseurs de mémoire externes (dont MemPalace) ne sont pas affichés ici.';

  @override
  String get memory_read_only =>
      'Lecture seule. Demandez à Hermes dans le chat de corriger ou d’oublier un fait.';

  @override
  String get memory_unavailable =>
      'Cette passerelle ou ce profil ne peut pas fournir les faits enregistrés. Vérifiez le profil sélectionné et mettez Hermes à jour si nécessaire.';

  @override
  String get memory_load_error =>
      'Vérifiez la connexion et l’authentification du tableau de bord, puis réessayez.';

  @override
  String get memory_read_full_fact => 'Lire le fait complet';

  @override
  String get memory_full_fact_requires_update =>
      'Les faits complets nécessitent une passerelle Hermes plus récente. Mettez Hermes à jour et actualisez la liste.';

  @override
  String get memory_fact_detail_error =>
      'Impossible de charger le fait complet. Il a peut-être changé ; actualisez la liste et réessayez.';

  @override
  String get memory_entries_are_cross_session_facts_the_agent_remembers_they =>
      'Les faits enregistrés apparaîtront ici quand Hermes les aura mémorisés.';

  @override
  String get merge => 'Fusionner';

  @override
  String get message => 'Message';

  @override
  String get message_hermes => 'Écrire à Hermes…';

  @override
  String get message_actions => 'Actions du message';

  @override
  String get message_copied => 'Message copié';

  @override
  String get migrating => 'Migration…';

  @override
  String get migration_complete => 'Migration terminée';

  @override
  String get migration_failed_local_spaces_were_kept_unchanged =>
      'La migration a échoué. Les espaces locaux n\'ont pas été modifiés.';

  @override
  String get migration_incomplete => 'Migration incomplète';

  @override
  String get migration_preview => 'Aperçu de la migration';

  @override
  String get model => 'Modèle';

  @override
  String get model_and_thinking_for_this_chat =>
      'Modèle et raisonnement pour cette discussion';

  @override
  String model_was_not_changed(Object error) {
    return 'Le modèle n\'a pas été modifié : $error';
  }

  @override
  String get move_attachment_next =>
      'Déplacer la pièce jointe vers la suivante';

  @override
  String get move_attachment_previous =>
      'Déplacer la pièce jointe vers la précédente';

  @override
  String get move_chat => 'Déplacer la discussion';

  @override
  String get move_conversation => 'Déplacer la discussion';

  @override
  String get move_to_project => 'Déplacer vers un projet';

  @override
  String get move_to_space => 'Déplacer vers un espace';

  @override
  String get moved_to_a_project => 'Déplacé vers un projet';

  @override
  String moved_to(Object label) {
    return 'Déplacé vers $label';
  }

  @override
  String get name => 'Nom';

  @override
  String get name_prompt_and_schedule_are_required =>
      'Le nom, le prompt et la planification sont obligatoires';

  @override
  String get nav_activity => 'Activité';

  @override
  String get nav_projects => 'Projets';

  @override
  String get needs_a_correction_aware_filing_contract_in_the_hermes_gateway =>
      'Nécessite un contrat de classement tenant compte des corrections dans la passerelle Hermes.';

  @override
  String get needs_a_reachable_hermes_dashboard_check_the_host_port_and =>
      'Nécessite un tableau de bord Hermes accessible. Vérifiez l\'hôte, le port et les identifiants de cette connexion.';

  @override
  String get needs_a_server_authoritative_assets_index_in_the_hermes_gateway =>
      'Nécessite un index de ressources faisant autorité côté serveur dans la passerelle Hermes.';

  @override
  String get needs_durable_pin_ordering_batch_mutation_and_undo_contracts_in =>
      'Nécessite des contrats d\'ordre d\'épinglage durable, de mutation par lots et d\'annulation dans la passerelle Hermes.';

  @override
  String get needs_you => 'Nécessite votre attention';

  @override
  String get new_label => 'Nouveau';

  @override
  String get new_chat => 'Nouvelle discussion';

  @override
  String get new_chat_2 => 'Nouvelle discussion';

  @override
  String new_chat_3(Object projectName) {
    return 'Nouvelle discussion · $projectName';
  }

  @override
  String get new_project => 'Nouveau projet';

  @override
  String get new_space => 'Nouvel espace';

  @override
  String next(Object nextRun) {
    return 'Prochaine : $nextRun';
  }

  @override
  String get nginx_injects_auth_app_sends_clean_requests =>
      'Nginx injecte l\'authentification — l\'application envoie des requêtes propres';

  @override
  String get no_tts_voices_found_ninstall_google_text_to_speech_and =>
      'Aucune voix TTS trouvée.\nInstallez Google Text-to-Speech et téléchargez les données vocales.';

  @override
  String get no_active_projects_on_this_gateway =>
      'Aucun projet actif sur cette passerelle';

  @override
  String get no_activity_yet => 'Aucune activité pour l\'instant';

  @override
  String get no_chat_is_blocked_running_or_waiting_to_be_resumed =>
      'Aucune discussion bloquée, en cours ou en attente de reprise. Lancez-en une nouvelle quand vous voulez.';

  @override
  String no_chats_in_this_project_match(Object searchQuery) {
    return 'Aucune discussion de ce projet ne correspond à « $searchQuery ».';
  }

  @override
  String get no_chats_in_this_space_yet_tap_to_start_one =>
      'Aucune discussion dans cet espace pour l\'instant. Touchez + pour en lancer une.';

  @override
  String get no_chats_yet => 'Aucune discussion pour l\'instant';

  @override
  String get no_connections => 'Aucune connexion';

  @override
  String get no_conversation_matches_this_view =>
      'Aucune discussion ne correspond à cette vue.';

  @override
  String get no_cron_jobs => 'Aucune tâche Cron';

  @override
  String get no_folders_yet => 'Aucun dossier pour l\'instant';

  @override
  String get no_local_spaces_were_found_for_this_connection_so_projects =>
      'Aucun espace local n\'a été trouvé pour cette connexion ; les projets sont donc déjà la seule organisation utilisée ici.';

  @override
  String get no_matches => 'Aucune correspondance';

  @override
  String get no_memory_entries => 'Aucune entrée de mémoire';

  @override
  String get no_message_content_matches =>
      'Aucune correspondance dans le contenu des messages';

  @override
  String get no_new_messages => 'Aucun nouveau message';

  @override
  String get no_projects_yet => 'Aucun projet pour l\'instant';

  @override
  String get no_runs_yet => 'Aucune exécution pour l\'instant.';

  @override
  String no_server_project_matches_this_name(Object assigned) {
    return 'Aucun projet serveur ne correspond à ce nom · $assigned';
  }

  @override
  String get no_sessions_yet => 'Aucune session pour l\'instant';

  @override
  String get no_skills_found => 'Aucune compétence trouvée';

  @override
  String get no_spaces_on_this_device => 'Aucun espace sur cet appareil';

  @override
  String get no_text_shared => 'Aucun texte partagé';

  @override
  String get no_turn_is_blocked_in_flight_or_recently_finished_work =>
      'Aucun tour bloqué, en cours ou récemment terminé. Le travail que vous lancez apparaîtra ici.';

  @override
  String get no_turn_needs_your_input_or_has_failed =>
      'Aucun tour n\'attend votre saisie ni n\'a échoué.';

  @override
  String get no_unassigned_chats => 'Aucune discussion non affectée.';

  @override
  String get nothing_changed_in_the_last_seven_days =>
      'Rien n\'a changé ces sept derniers jours.';

  @override
  String get nothing_has_moved_yet_this_is_only_what_a_migration =>
      'Rien n\'a encore été déplacé — ceci n\'est que ce que ferait une migration.';

  @override
  String get nothing_here => 'Rien ici';

  @override
  String get nothing_is_running => 'Rien en cours d\'exécution';

  @override
  String get nothing_needs_you => 'Rien ne nécessite votre attention';

  @override
  String get nothing_to_migrate => 'Rien à migrer';

  @override
  String get notifications => 'Notifications';

  @override
  String get windows_notifications_blocked =>
      'Les notifications sont indisponibles. Utilisez l’application Ares installée et vérifiez Paramètres → Système → Notifications dans Windows.';

  @override
  String get windows_notification_diagnostics =>
      'Ce qu’Ares a transmis à Windows';

  @override
  String get chat_activity_share => 'Partager l’activité de la discussion';

  @override
  String get chat_activity_share_hint =>
      'Indiquer à une passerelle connectée compatible quand vous utilisez cette discussion, afin que son extension de notifications sur téléphone puisse éviter les alertes en double. Aucune clé ni aucun texte de message n’est envoyé.';

  @override
  String get completion_sound => 'Son de fin de réponse';

  @override
  String get completion_sound_system => 'Par défaut du système';

  @override
  String get completion_sound_mail => 'Courrier';

  @override
  String get completion_sound_reminder => 'Rappel';

  @override
  String get completion_sound_silent => 'Silencieux';

  @override
  String get completion_sound_scope =>
      'Joué pour les réponses terminées, la notification de test et dans l’application. Les approbations et autres alertes conservent leur son habituel.';

  @override
  String get completion_sound_scope_android =>
      'Joué pour les réponses terminées, la notification de test et dans l’application. Les approbations, les autres alertes, les notifications en arrière-plan du serveur et les messages Android Auto conservent leur son habituel.';

  @override
  String get notification_open_action => 'Ouvrir';

  @override
  String get app_sounds_mute => 'Couper les sons de l’application';

  @override
  String get app_sounds_mute_hint =>
      'Coupe le son de fin de réponse qu’Ares joue lorsqu’il est ouvert. Les notifications conservent leur propre son.';

  @override
  String get notifications_permission_denied =>
      'Les notifications sont bloquées par le système. Activez-les pour cette application dans les réglages Android.';

  @override
  String get off_no_thinking => 'Désactivé (sans raisonnement)';

  @override
  String get offline_showing_the_last_known_activity =>
      'Hors ligne — affichage de la dernière activité connue.';

  @override
  String get offline_showing_the_last_known_chats =>
      'Hors ligne — affichage des dernières discussions connues';

  @override
  String get offline_showing_the_last_known_projects =>
      'Hors ligne — affichage des derniers projets connus.';

  @override
  String get on_this_device => 'Sur cet appareil';

  @override
  String get on_device => 'Sur l\'appareil';

  @override
  String get open_inbox => 'Ouvrir la boîte de réception';

  @override
  String open_inbox_2(Object count) {
    return 'Ouvrir la boîte de réception ($count)';
  }

  @override
  String get open_the_hermes_dashboard => 'Ouvrir le tableau de bord Hermes';

  @override
  String get optional_for_the_memory_cron_skills_settings_tabs_leave_blank =>
      'Facultatif. Pour les onglets Mémoire/Cron/Compétences/Paramètres. Laissez vide pour utiliser le port par défaut du tableau de bord (9119) sans connexion.';

  @override
  String get organization => 'Organisation';

  @override
  String get other_answer => 'Autre réponse';

  @override
  String get overview => 'Vue d\'ensemble';

  @override
  String get passphrase => 'Phrase de passe';

  @override
  String get password_optional => 'Mot de passe (facultatif)';

  @override
  String get phone_or_tablet => 'Téléphone ou tablette';

  @override
  String get pin_batch_and_undo => 'Épingler, par lots et annuler';

  @override
  String get plugin_notifications => 'Notifications d’extensions';

  @override
  String get plugin_notifications_description =>
      'La passerelle a envoyé une notification pendant que l’application était en arrière-plan.';

  @override
  String get port => 'Port';

  @override
  String get preparing_attachments => 'Préparation des pièces jointes…';

  @override
  String get preview_truncated => 'Aperçu tronqué';

  @override
  String get preview_unavailable => 'Aperçu indisponible';

  @override
  String get profile => 'Profil';

  @override
  String get profile_default_model => 'Modèle par défaut du profil';

  @override
  String profile_default_set_to_chats_with_their_own_model_keep(
    Object selectedModel,
  ) {
    return 'Valeur par défaut du profil définie sur $selectedModel. Les discussions avec leur propre modèle conservent ce remplacement.';
  }

  @override
  String
  get profile_this_connection_chats_as_when_the_dashboard_serves_several =>
      'Profil avec lequel cette connexion discute lorsque le tableau de bord sert plusieurs profils. Laissez vide pour un tableau de bord isolé par profil.';

  @override
  String get project => 'Projet';

  @override
  String get project_actions => 'Actions du projet';

  @override
  String get project_chat => 'Discussion de projet';

  @override
  String get project_chats_unavailable => 'Discussions de projet indisponibles';

  @override
  String get projects => 'Projets';

  @override
  String get projects_group_related_chats_files_and_activity_and_stay_in =>
      'Les projets regroupent les discussions, fichiers et activités liés, et restent synchronisés avec Hermes sur votre ordinateur.';

  @override
  String
  get projects_need_a_desktop_gateway_connection_add_the_desktop_gateway =>
      'Les projets nécessitent une connexion Desktop Gateway. Ajoutez l\'URL de Desktop Gateway à cette connexion pour organiser les discussions sur tous vos appareils.';

  @override
  String get projects_unavailable => 'Projets indisponibles';

  @override
  String get projects_activity_new_navigation =>
      'Projets, Activité — nouvelle navigation';

  @override
  String get promote_to_project => 'Promouvoir en projet';

  @override
  String get prompt => 'Prompt';

  @override
  String get protect_this_backup => 'Protéger cette sauvegarde';

  @override
  String get provider => 'Fournisseur';

  @override
  String get proxy_injects_auth_app_sends_clean_requests =>
      'Le proxy injecte l\'authentification ; l\'application envoie des requêtes propres';

  @override
  String get quick_chat => 'Discussion rapide';

  @override
  String get quick_chats_appear_here_after_their_retention_period =>
      'Les discussions rapides apparaissent ici après leur période de conservation.';

  @override
  String get read_aloud => 'Lire à voix haute';

  @override
  String get read_aloud_is_unavailable_on_this_device =>
      'La lecture à voix haute est indisponible sur cet appareil';

  @override
  String get reading_response_aloud => 'Lecture de la réponse à voix haute';

  @override
  String get ready_to_upload => 'Prêt à envoyer';

  @override
  String get reasoning => 'Raisonnement';

  @override
  String get recently_completed => 'Terminé récemment';

  @override
  String get recently_active => 'Actif récemment';

  @override
  String get recovering_hermes => 'Récupération de Hermes…';

  @override
  String get refresh => 'Actualiser';

  @override
  String get regenerate_response => 'Régénérer la réponse';

  @override
  String get remove_attachment => 'Retirer la pièce jointe';

  @override
  String get rename => 'Renommer';

  @override
  String get rename_chat => 'Renommer la discussion';

  @override
  String get rename_project => 'Renommer le projet';

  @override
  String get rename_space => 'Renommer l\'espace';

  @override
  String rename_2(Object projectName) {
    return 'Renommer $projectName';
  }

  @override
  String rename_3(Object name) {
    return 'Renommer $name';
  }

  @override
  String get replace => 'Remplacer';

  @override
  String get repositories => 'Dépôts';

  @override
  String
  get research_the_attached_content_verify_the_important_claims_and_cite =>
      'Analysez le contenu joint, vérifiez les affirmations importantes et citez vos sources.';

  @override
  String research_this_content_verify_the_important_claims_and_cite_sources(
    Object text,
  ) {
    return 'Analysez ce contenu, vérifiez les affirmations importantes et citez vos sources :\n\n$text';
  }

  @override
  String reset_failed_the_secure_storage_may_need_reinstall(Object retryError) {
    return 'Échec de la réinitialisation : $retryError. Le stockage sécurisé devra peut-être être réinstallé.';
  }

  @override
  String get reset_saved_connections =>
      'Réinitialiser les connexions enregistrées';

  @override
  String get responding => 'Réponse en cours…';

  @override
  String response_closed_locally_gateway_stop_failed(Object error) {
    return 'Réponse fermée localement ; échec de l\'arrêt de la passerelle : $error';
  }

  @override
  String get response_closed_locally_no_active_gateway_turn_was_found =>
      'Réponse fermée localement ; aucun tour de passerelle actif trouvé.';

  @override
  String get response_complete => 'Réponse terminée';

  @override
  String get response_complete_description =>
      'Un tour s’est terminé pendant que l’application était en arrière-plan.';

  @override
  String get response_ready => 'Réponse prête';

  @override
  String get response_stopped => 'Réponse arrêtée.';

  @override
  String get restore => 'Restaurer';

  @override
  String get restore_configuration => 'Restaurer la configuration';

  @override
  String get restore_project => 'Restaurer le projet';

  @override
  String get retry => 'Réessayer';

  @override
  String retry_failed_for_the_draft_and_prompt_were_kept(Object name) {
    return 'Échec de la nouvelle tentative pour $name. Le brouillon et le prompt ont été conservés.';
  }

  @override
  String get retry_upload => 'Réessayer l\'envoi';

  @override
  String retrying(Object name) {
    return 'Nouvelle tentative pour $name…';
  }

  @override
  String get review_local_spaces => 'Examiner les espaces locaux';

  @override
  String get review_or_promote_quick_chats_past_their_retention_period =>
      'Examiner ou promouvoir les discussions rapides au-delà de leur période de conservation';

  @override
  String get review_the_attached_content => 'Examinez le contenu joint.';

  @override
  String get run_only_this_command => 'N\'exécutez que cette commande.';

  @override
  String get running_now => 'En cours d\'exécution';

  @override
  String get save => 'Enregistrer';

  @override
  String get save_changes => 'Enregistrer les modifications';

  @override
  String get save_a_permanent_rule_in_the_hermes_configuration =>
      'Enregistrez une règle permanente dans la configuration Hermes.';

  @override
  String get save_the_durable_facts_from_the_attached_content_to_memory =>
      'Enregistrez les faits durables du contenu joint en mémoire, puis confirmez ce qui a été conservé.';

  @override
  String save_the_durable_facts_from_this_content_to_memory_then(Object text) {
    return 'Enregistrez les faits durables de ce contenu en mémoire, puis confirmez ce qui a été conservé :\n\n$text';
  }

  @override
  String get save_your_connections_and_settings_to_an_encrypted_file_then =>
      'Enregistrez vos connexions et paramètres dans un fichier chiffré, puis restaurez-les après une réinstallation ou sur un autre appareil.';

  @override
  String save_2(Object filename) {
    return 'Enregistrer $filename';
  }

  @override
  String get schedule => 'Planification';

  @override
  String get scheduled_jobs_and_their_last_runs =>
      'Tâches planifiées et leurs dernières exécutions';

  @override
  String get scheduled_tasks => 'Tâches planifiées';

  @override
  String get script_only_no_agent => 'Script uniquement (sans agent)';

  @override
  String get scroll_horizontally => 'Défiler horizontalement';

  @override
  String get search_all_chats => 'Rechercher dans toutes les discussions';

  @override
  String get search_all_message_content =>
      'Rechercher dans tout le contenu des messages';

  @override
  String get search_chats => 'Rechercher des discussions';

  @override
  String get search_conversations => 'Rechercher des discussions';

  @override
  String get search_loaded_chats => 'Rechercher dans les discussions chargées';

  @override
  String get search_mode => 'Mode de recherche';

  @override
  String get select_one_option_or_enter_another_answer =>
      'Sélectionnez une option ou saisissez une autre réponse.';

  @override
  String get select_one_or_more_options_then_continue =>
      'Sélectionnez une ou plusieurs options, puis continuez.';

  @override
  String get select_text => 'Sélectionner le texte';

  @override
  String get send => 'Envoyer';

  @override
  String send_failed(Object error) {
    return 'Échec de l\'envoi : $error';
  }

  @override
  String send_failed_api_only_permission_denied(Object error) {
    return 'Échec de l\'envoi : $error. Le serveur a refusé cette écriture pour le principal de la clé API. Si cette conversation appartient au Dashboard, renseigner le nom d\'utilisateur et le mot de passe Dashboard de cette connexion peut autoriser l\'envoi ; le serveur peut aussi refuser délibérément.';
  }

  @override
  String get send_message => 'Envoyer le message';

  @override
  String get send_test_notification => 'Envoyer une notification de test';

  @override
  String get session_sources => 'Sources des sessions';

  @override
  String get session_deleted_from_remote_hermes =>
      'Session supprimée du Hermes distant.';

  @override
  String session_search_failed(Object error) {
    return 'Échec de la recherche de sessions : $error';
  }

  @override
  String get set_profile_default => 'Définir par défaut du profil';

  @override
  String get settings => 'Paramètres';

  @override
  String get share_to_hermes => 'Partager avec Hermes';

  @override
  String get show_passphrase => 'Afficher la phrase de passe';

  @override
  String get show_tool_calls_thinking_and_message_metadata =>
      'Afficher les appels d\'outils, le raisonnement et les métadonnées des messages';

  @override
  String get signal_messages => 'Messages Signal';

  @override
  String get skills => 'Compétences';

  @override
  String skills_2(Object count) {
    return 'Compétences ($count)';
  }

  @override
  String get skills_and_tools => 'Compétences et outils';

  @override
  String get skip => 'Ignorer';

  @override
  String get slack_chats => 'Discussions Slack';

  @override
  String source(Object source) {
    return 'Source : $source';
  }

  @override
  String get space_actions => 'Actions de l\'espace';

  @override
  String get spaces => 'Espaces';

  @override
  String get speak_to_hermes => 'Parler à Hermes';

  @override
  String get speech_recognition_is_unavailable =>
      'La reconnaissance vocale est indisponible';

  @override
  String get spoken_replies => 'Réponses vocales';

  @override
  String get spoken_replies_off => 'Réponses vocales désactivées';

  @override
  String get spoken_replies_on => 'Réponses vocales activées';

  @override
  String get stalled_no_update_from_hermes =>
      'Bloqué — aucune mise à jour de Hermes';

  @override
  String get start_something_new => 'Lancer quelque chose de nouveau';

  @override
  String get start_voice_input => 'Démarrer la saisie vocale';

  @override
  String get starting_hermes => 'Démarrage de Hermes…';

  @override
  String get media_card_download => 'Télécharger le fichier';

  @override
  String get media_card_tap_to_download => 'Appuyer pour télécharger';

  @override
  String get still_loading_your_projects =>
      'Chargement de vos projets en cours.';

  @override
  String get stop => 'Arrêter';

  @override
  String get stop_response => 'Arrêter la réponse';

  @override
  String get stop_voice_input => 'Arrêter la saisie vocale';

  @override
  String get submitted_waiting_for_hermes => 'Envoyé, en attente de Hermes';

  @override
  String get suggest_projects_and_learn_from_your_corrections =>
      'Suggérer des projets et apprendre de vos corrections';

  @override
  String get summarize_the_attached_content => 'Résumez le contenu joint.';

  @override
  String summarize_this_content(Object text) {
    return 'Résumez ce contenu :\n\n$text';
  }

  @override
  String get switch_profile => 'Changer de profil';

  @override
  String get system => 'Système';

  @override
  String get take_photo => 'Prendre une photo';

  @override
  String get tap_to_add_a_remote_hermes_gateway_api_server_port =>
      'Touchez + pour ajouter une passerelle Hermes distante\n(serveur API, port 8642)';

  @override
  String get tap_the_button_to_start_a_new_chat =>
      'Touchez le bouton + pour démarrer une nouvelle discussion';

  @override
  String get telegram_messages => 'Messages Telegram';

  @override
  String get terminal_sessions => 'Sessions de terminal';

  @override
  String get test_notification_body =>
      'Si vous voyez ceci, les notifications fonctionnent.';

  @override
  String get test_notification_sent => 'Notification de test envoyée.';

  @override
  String get test_notification_title => 'Test des notifications Hermes';

  @override
  String get test_notification_unsupported =>
      'Impossible d’envoyer la notification — vérifiez que le système autorise les notifications.';

  @override
  String get text_size => 'Taille du texte';

  @override
  String get text_size_preview => 'Aperçu de la taille du texte';

  @override
  String text_size_2(Object label) {
    return 'Taille du texte : $label';
  }

  @override
  String get the_api_key_could_not_be_stored_securely =>
      'La clé API n\'a pas pu être stockée en toute sécurité.';

  @override
  String get the_project_will_move_to_archived_its_chats_and_files =>
      'Le projet passera dans « Archivé ». Ses discussions et fichiers restent intacts, et vous pourrez le restaurer à tout moment.';

  @override
  String get the_project_will_move_to_archived_its_chats_and_files_2 =>
      'Le projet passera dans « Archivé ». Ses discussions et fichiers restent intacts, et vous pourrez le restaurer plus tard.';

  @override
  String get the_active_profile_did_not_return_any_selectable_models =>
      'Le profil actif n\'a renvoyé aucun modèle sélectionnable.';

  @override
  String get the_backup_could_not_be_exported =>
      'La sauvegarde n\'a pas pu être exportée.';

  @override
  String get the_backup_could_not_be_restored =>
      'La sauvegarde n\'a pas pu être restaurée.';

  @override
  String get the_connection_could_not_be_deleted_safely =>
      'La connexion n\'a pas pu être supprimée en toute sécurité.';

  @override
  String get the_connection_could_not_be_stored_securely =>
      'La connexion n\'a pas pu être stockée en toute sécurité.';

  @override
  String get the_dashboard_credentials_could_not_be_stored_securely =>
      'Les identifiants du tableau de bord n\'ont pas pu être stockés en toute sécurité.';

  @override
  String get the_detached_reply_failed => 'La réponse détachée a échoué.';

  @override
  String the_detached_reply_failed_2(Object error) {
    return 'La réponse détachée a échoué : $error';
  }

  @override
  String get the_file_contains_your_api_keys_and_dashboard_password_so =>
      'Le fichier contient vos clés API et le mot de passe du tableau de bord ; il est donc chiffré. Sans cette phrase de passe, la sauvegarde ne peut pas être restaurée.';

  @override
  String get the_last_turn_failed => 'Le dernier tour a échoué';

  @override
  String the_local_connection_store_looks_damaged_you_can_reset_the(
    Object errorType,
  ) {
    return 'Le stockage local des connexions semble endommagé ($errorType). Vous pouvez réinitialiser les connexions enregistrées et repartir de zéro. Les discussions de votre passerelle ne sont pas affectées.';
  }

  @override
  String get the_model_only_rewrites_your_question_into_a_short_full =>
      'Le modèle ne fait que reformuler votre question en une courte requête de texte intégral. Hermes utilise les identifiants du fournisseur déjà configurés sur l\'hôte.';

  @override
  String get the_server_has_not_reported_folders_for_this_project_yet =>
      'Le serveur n\'a pas encore signalé de dossiers pour ce projet. Fichiers globaux reste disponible depuis Plus.';

  @override
  String get the_turn_failed => 'Le tour a échoué';

  @override
  String get the_two_passphrases_do_not_match =>
      'Les deux phrases de passe ne correspondent pas.';

  @override
  String get the_value_is_sent_directly_to_the_active_hermes_gateway =>
      'La valeur est envoyée directement à la passerelle Hermes active et n\'est pas enregistrée par cette application Android.';

  @override
  String get there_are_no_visible_files_in_this_server_folder =>
      'Aucun fichier visible dans ce dossier du serveur.';

  @override
  String get thinking_effort => 'Effort de raisonnement';

  @override
  String get this_hermes_gateway_does_not_support_opening_a_project_yet =>
      'Cette passerelle Hermes ne prend pas encore en charge l\'ouverture d\'un projet. Mettez à jour Hermes sur le serveur pour parcourir un projet depuis votre téléphone.';

  @override
  String get this_hermes_gateway_is_older_than_server_side_projects_so =>
      'Cette passerelle Hermes est antérieure aux projets côté serveur ; les discussions ne sont donc regroupées que sur cet appareil. Mettez à jour Hermes pour partager les mêmes projets entre vos appareils.';

  @override
  String get this_project_has_no_folder_to_open_the_chat_in =>
      'Ce projet a besoin d\'un dossier avant de pouvoir y démarrer une discussion. Ajoutez un dossier, puis réessayez.';

  @override
  String get this_chat_has_no_messages_available_in_the_desktop_session =>
      'Cette discussion n\'a pas encore de messages disponibles dans la session Desktop.';

  @override
  String get this_creates_a_permanent_rule_in_hermes_review_the_full =>
      'Cela crée une règle permanente dans Hermes. Examinez la commande complète avant de confirmer.';

  @override
  String get this_gateway_does_not_host_projects_yet_update_the_gateway =>
      'Cette passerelle n\'héberge pas encore de projets. Mettez à jour la passerelle pour organiser les discussions sur tous vos appareils.';

  @override
  String get this_permanently_deletes_the_project_chats_will_not_be_deleted =>
      'Cela supprime définitivement le projet. Les discussions ne seront pas supprimées ; elles reviendront dans « Non affecté ».';

  @override
  String get this_server_doesn_t_offer_background_recovery_chats_run_live =>
      'Ce serveur n\'offre pas de récupération en arrière-plan — les discussions s\'exécutent en direct';

  @override
  String get this_week => 'Cette semaine';

  @override
  String get titles_previews_and_models => 'Titres, aperçus et modèles';

  @override
  String get tool_activity => 'Activité des outils';

  @override
  String get trigger_now => 'Déclencher maintenant';

  @override
  String get received_outcome_unknown => 'Tour terminé — résultat non confirmé';

  @override
  String get turn_completed => 'Tour terminé';

  @override
  String get turn_failed => 'Échec du tour';

  @override
  String get turn_failed_description =>
      'Un tour en arrière-plan s’est terminé par une erreur.';

  @override
  String get turn_recovery_failed => 'Échec de la récupération du tour';

  @override
  String get unable_to_prepare_this_file_try_another_one =>
      'Impossible de préparer ce fichier. Essayez-en un autre.';

  @override
  String get unable_to_prepare_this_image_try_another_one =>
      'Impossible de préparer cette image. Essayez-en une autre.';

  @override
  String unable_to_prepare(Object name) {
    return 'Impossible de préparer $name.';
  }

  @override
  String get unable_to_read_the_selected_image_the_selection_was_kept =>
      'Impossible de lire l\'image sélectionnée. La sélection a été conservée.';

  @override
  String get unassigned => 'Non affecté';

  @override
  String get unassigned_chats => 'Discussions non affectées';

  @override
  String get untitled_chat => 'Discussion sans titre';

  @override
  String get untitled_session => 'Session sans titre';

  @override
  String get update_api_key => 'Mettre à jour la clé API';

  @override
  String get upload_failed => 'Échec de l\'envoi';

  @override
  String get upload_failed_tap_retry =>
      'Échec de l\'envoi • touchez pour réessayer';

  @override
  String uploading(Object index, Object name, Object total) {
    return 'Envoi de $index/$total : $name';
  }

  @override
  String get use_as_is => 'Utiliser tel quel';

  @override
  String get use_at_least_8_characters => 'Utilisez au moins 8 caractères.';

  @override
  String get use_for_cron_jobs_backed_by_scripts =>
      'À utiliser pour les tâches Cron basées sur des scripts.';

  @override
  String get use_on_device => 'Utiliser sur l\'appareil';

  @override
  String get use_the_attached_content_to_identify_and_fill_the_relevant =>
      'Utilisez le contenu joint pour identifier et remplir les champs pertinents du document ou du formulaire. Demandez avant d\'envoyer quoi que ce soit.';

  @override
  String use_this_content_to_identify_and_fill_the_relevant_document(
    Object text,
  ) {
    return 'Utilisez ce contenu pour identifier et remplir les champs pertinents du document ou du formulaire. Demandez avant d\'envoyer quoi que ce soit :\n\n$text';
  }

  @override
  String get used_for_hosted_path_prefixes_and_for_the_settings_memory =>
      'Utilisé pour les préfixes de chemins hébergés et pour les onglets Paramètres, Mémoire, Compétences et Cron. Laissez le nom d\'utilisateur et le mot de passe vides pour un tableau de bord ouvert, ou activez le mode proxy lorsque votre reverse proxy injecte l\'authentification du tableau de bord.';

  @override
  String get username_optional => 'Nom d\'utilisateur (facultatif)';

  @override
  String using(Object displayName) {
    return 'Utilisation de $displayName…';
  }

  @override
  String get verbose_mode => 'Mode détaillé';

  @override
  String get message_metadata => 'Détails du message';

  @override
  String get voice => 'Voix';

  @override
  String voice_setup_failed(Object error) {
    return 'Échec de la configuration vocale : $error';
  }

  @override
  String get waiting_for_your_input => 'En attente de votre saisie';

  @override
  String get what_hermes_knows_how_to_do => 'Ce que Hermes sait faire';

  @override
  String get what_should_the_agent_do => 'Que doit faire l\'agent ?';

  @override
  String get whatsapp_messages => 'Messages WhatsApp';

  @override
  String get which_project => 'Quel projet ?';

  @override
  String get workspace => 'Espace de travail';

  @override
  String get wrap_lines => 'Renvoi à la ligne';

  @override
  String you_can_attach_up_to_items(Object maxRemoteAttachmentDrafts) {
    return 'Vous pouvez joindre jusqu\'à $maxRemoteAttachmentDrafts éléments.';
  }

  @override
  String get your_answer => 'Votre réponse';

  @override
  String get e_g_dashboard => 'p. ex. /dashboard';

  @override
  String get e_g_dashboard_proxy_path_before_api =>
      'p. ex. /dashboard (chemin proxy avant /api/)';

  @override
  String get e_g_profile_peter => 'p. ex. /profile/peter';

  @override
  String get e_g_sol => 'p. ex. sol';

  @override
  String get e_g_0_9_or_every_2h => 'p. ex. 0 9 * * * ou every 2h';

  @override
  String get e_g_daily_backup => 'p. ex. Sauvegarde quotidienne';

  @override
  String downloaded(Object filename) {
    return '$filename téléchargé';
  }

  @override
  String activity_name_status(Object displayName, Object statusLabel) {
    return '$displayName : $statusLabel';
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
      'p. ex. /profile/peter (chemin proxy avant /api/ et /v1/)';

  @override
  String and_more(Object count) {
    return 'et $count de plus';
  }

  @override
  String chats_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count discussions',
      one: '$count discussion',
    );
    return '$_temp0';
  }

  @override
  String on_this_device_only(Object chats) {
    return '$chats · sur cet appareil uniquement';
  }

  @override
  String spaces_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count espaces',
      one: '$count espace',
    );
    return '$_temp0';
  }

  @override
  String get no_new_projects_needed => 'aucun nouveau projet nécessaire';

  @override
  String projects_to_create(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count projets à créer',
      one: '$count projet à créer',
    );
    return '$_temp0';
  }

  @override
  String chats_migrated_projects_created(
    Object createdProjects,
    Object linkedSessions,
  ) {
    return '$linkedSessions discussions migrées · $createdProjects projets créés';
  }

  @override
  String chats_stayed_in_local_spaces(Object unlinkedSessions) {
    return '$unlinkedSessions discussions sont restées dans les espaces locaux et peuvent être réessayées sans risque.';
  }

  @override
  String model_recommended(Object provider) {
    return '$provider • Recommandé : petit et économique';
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
  String get this_chat => 'cette discussion';

  @override
  String get profile_default => 'par défaut du profil';

  @override
  String minutes_ago(Object count) {
    return 'il y a $count min';
  }

  @override
  String hours_ago(Object count) {
    return 'il y a $count h';
  }

  @override
  String days_ago(Object count) {
    return 'il y a $count j';
  }

  @override
  String get now_label => 'maintenant';

  @override
  String get latest_label => 'Dernier';

  @override
  String new_count_indicator(Object count) {
    return '$count nouveaux';
  }

  @override
  String new_messages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nouveaux messages',
      one: '$count nouveau message',
    );
    return '$_temp0';
  }

  @override
  String activity_failed_summary(Object failures, Object total) {
    return '$failures échoués • $total au total';
  }

  @override
  String activity_completed_summary(Object count) {
    return '$count terminés';
  }

  @override
  String tool_start_observed(Object time) {
    return 'Début observé à $time (heure locale)';
  }

  @override
  String tool_last_observed(Object time) {
    return 'Dernière observation à $time (heure locale)';
  }

  @override
  String tool_result_recorded(Object time) {
    return 'Résultat enregistré à $time (heure locale)';
  }

  @override
  String get tool_time_unavailable => 'Heure indisponible';

  @override
  String get hermes_is_using_a_tool => 'Hermes utilise un outil';

  @override
  String hermes_is_using_tools(Object count) {
    return 'Hermes utilise $count outils';
  }

  @override
  String delegated_tasks_completed(Object count) {
    return '$count tâche(s) déléguée(s) terminée(s)';
  }

  @override
  String delegated_tasks_active(Object count) {
    return '$count tâche(s) déléguée(s) active(s)';
  }

  @override
  String branch_main(Object label) {
    return '$label · main';
  }

  @override
  String get you_heading => '## Vous';

  @override
  String get hermes_heading => '## Hermes';

  @override
  String get action_label => 'Action';

  @override
  String get destination_label => 'Destination';

  @override
  String get markdown_source => 'Source';

  @override
  String get preview_label => 'Aperçu';

  @override
  String get share_action_summarize => 'Résumer';

  @override
  String get share_action_explain => 'Expliquer';

  @override
  String get share_action_research => 'Rechercher';

  @override
  String get share_action_remember => 'Mémoriser';

  @override
  String get text_size_small => 'Petit';

  @override
  String get text_size_default => 'Par défaut';

  @override
  String get text_size_large => 'Grand';

  @override
  String get text_size_extra_large => 'Très grand';

  @override
  String get text_size_use_system_description =>
      'Utiliser exactement la taille de texte d\'accessibilité Android.';

  @override
  String text_size_percent_description(Object percent) {
    return '$percent % de la taille de texte Android.';
  }

  @override
  String text_size_label_description(Object description, Object label) {
    return '$label — $description';
  }

  @override
  String files_skipped(Object count) {
    return '$count fichier(s) ignoré(s) : limite, taille, illisible ou nom de fichier sensible.';
  }

  @override
  String model_scope_applied(Object effort, Object model) {
    return '$model • $effort ne s\'appliquent désormais qu\'à cette discussion.';
  }

  @override
  String get reasoning_minimal => 'Minimal';

  @override
  String get reasoning_low => 'Faible';

  @override
  String get reasoning_medium => 'Moyen';

  @override
  String get reasoning_high => 'Élevé';

  @override
  String get reasoning_max => 'Maximal';

  @override
  String get reasoning_ultra => 'Ultra';

  @override
  String get status_running => 'En cours';

  @override
  String get status_failed => 'Échec';

  @override
  String get status_done => 'Terminé';

  @override
  String get status_idle => 'Inactif';

  @override
  String get upload_status_uploading => 'Envoi en cours';

  @override
  String get upload_status_uploaded => 'Envoyé';

  @override
  String attachment_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pièces jointes',
      one: '$count pièce jointe',
    );
    return '$_temp0';
  }

  @override
  String get action_create => 'créer';

  @override
  String get action_rename => 'renommer';

  @override
  String get action_archive => 'archiver';

  @override
  String get action_restore => 'restaurer';

  @override
  String get action_delete => 'supprimer';

  @override
  String get migrate => 'Migrer';

  @override
  String assigned_chats(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count discussions affectées',
      one: '$count discussion affectée',
    );
    return '$_temp0';
  }

  @override
  String get date_today => 'Aujourd\'hui';

  @override
  String get date_yesterday => 'Hier';

  @override
  String get date_earlier => 'Plus tôt';

  @override
  String get nav_home => 'Accueil';

  @override
  String get nav_more => 'Plus';

  @override
  String get status_completed => 'Terminé';

  @override
  String get filter_all => 'Tout';

  @override
  String get filter_recent => 'Récent';

  @override
  String connection_address_key(Object address, Object status) {
    return '$address  •  Clé : $status';
  }

  @override
  String model_via_provider(Object model, Object provider) {
    return '$model  \nvia `$provider`';
  }

  @override
  String get deny => 'Refuser';

  @override
  String get connect => 'Se connecter';

  @override
  String get appearance => 'Apparence';

  @override
  String get connection_section => 'Connexion';

  @override
  String get about => 'À propos';

  @override
  String version_label(Object version) {
    return 'Version $version';
  }

  @override
  String get matched => 'Correspondance';

  @override
  String get search => 'Rechercher';

  @override
  String get on => 'Activé';

  @override
  String get off => 'Désactivé';

  @override
  String get reasoning_off => 'Désactivé';

  @override
  String get hermes_response_ready => 'Réponse de Hermes prête';

  @override
  String get admin_password_needed => 'Mot de passe administrateur requis';

  @override
  String get hermes_needs_a_sudo_password_for_the_pending_terminal_command =>
      'Hermes a besoin d\'un mot de passe sudo pour la commande de terminal en attente.';

  @override
  String get sudo_password => 'Mot de passe sudo';

  @override
  String get secret_needed => 'Secret requis';

  @override
  String get hermes_needs_a_secret_for_the_pending_skill =>
      'Hermes a besoin d\'un secret pour la compétence en attente.';

  @override
  String get secret_value => 'Valeur du secret';

  @override
  String get attached_file => 'Fichier joint';

  @override
  String get pin_chat => 'Épingler la discussion';

  @override
  String get unpin_chat => 'Désépingler la discussion';

  @override
  String get pinned_chats => 'Épinglées';

  @override
  String could_not_update_chat_pin(Object error) {
    return 'Impossible de modifier l’épinglage de la discussion : $error';
  }

  @override
  String get could_not_save_chat_spaces =>
      'Impossible d’enregistrer les espaces de discussion sur cet appareil';

  @override
  String get chat_density => 'Densité de la conversation';

  @override
  String chat_density_2(Object label) {
    return 'Densité de la conversation : $label';
  }

  @override
  String get chat_density_comfortable => 'Confortable';

  @override
  String get chat_density_compact => 'Compacte';

  @override
  String get chat_density_comfortable_description =>
      'Bulles plus spacieuses avec une étiquette d’expéditeur au-dessus de chaque message.';

  @override
  String get chat_density_compact_description =>
      'Bulles plus serrées et sans étiquette pour afficher plus de messages à l’écran.';

  @override
  String chat_density_label_description(Object description, Object label) {
    return '$label — $description';
  }

  @override
  String
  get compact_removes_the_you_and_hermes_labels_and_trims_bubble_padding_spacing_and_side_margins =>
      'Le mode compacte supprime les étiquettes « You » et « Hermes » et réduit les marges internes, l’espacement et les marges latérales des bulles.';

  @override
  String get client_certificate_mtls => 'Certificat client (mTLS)';

  @override
  String get client_certificate_mtls_description =>
      'Présenter un certificat lorsqu’un proxy HTTPS exige une authentification TLS mutuelle.';

  @override
  String get client_certificate_https_only =>
      'Les certificats clients sont utilisés uniquement pour les connexions HTTPS.';

  @override
  String get choose_certificate => 'Choisir un certificat';

  @override
  String get certificate_password => 'Mot de passe du certificat';

  @override
  String get this_certificate_is_password_protected =>
      'Ce certificat est protégé par un mot de passe. Il s’ouvre pendant la saisie.';

  @override
  String get enter_the_certificate_password_to_finish_loading_it =>
      'Saisissez le mot de passe du certificat pour terminer le chargement du certificat choisi.';

  @override
  String get client_certificate_required =>
      'Chargez un certificat client ou désactivez l’option de certificat client.';

  @override
  String client_certificate_loaded(String label) {
    return 'Chargé : $label';
  }

  @override
  String get remove_certificate => 'Retirer le certificat';

  @override
  String get certificate_import_failed =>
      'Ce certificat n’a pas pu être chargé.';

  @override
  String get background_work => 'Activité en arrière-plan';

  @override
  String get keep_chats_active_in_background =>
      'Garder les discussions actives en arrière-plan';

  @override
  String get background_work_description =>
      'Maintient la connexion des discussions lancées par vous lorsque cette app est en arrière-plan. Les connexions inactives peuvent être coupées. Consomme plus de batterie et de données. Désactiver cette option n’arrête pas le travail sur le serveur.';

  @override
  String get background_work_limits =>
      'Android peut malgré tout suspendre les connexions en mode Doze ou terminer le processus de l’app. Les notifications après la fin du processus nécessitent une configuration push séparée. L’arrêt forcé n’est pas pris en charge.';

  @override
  String get background_work_disclosure =>
      'Une notification de service obligatoire reste visible lorsque la protection en arrière-plan est active, même si les notifications de discussion facultatives sont désactivées.';

  @override
  String get battery_optimisation_settings =>
      'Paramètres d’optimisation de la batterie';

  @override
  String get battery_optimisation_description =>
      'Ouvre les paramètres Android pour consulter les restrictions de batterie. Aucune exemption n’est demandée automatiquement et modifier les paramètres ne garantit pas la réception.';

  @override
  String get battery_settings_unavailable =>
      'Impossible d’ouvrir les paramètres de batterie sur cet appareil.';

  @override
  String get background_work_save_failed =>
      'Impossible d’enregistrer le réglage d’activité en arrière-plan.';

  @override
  String get ongoing_chat_channel_name => 'Discussions actives';

  @override
  String get ongoing_chat_channel_description =>
      'Mises à jour silencieuses des discussions lancées par vous et non terminées';

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
  String get activity_status_unconfirmed => 'Statut non confirmé';

  @override
  String get activity_recently_updated => 'Mis à jour récemment';

  @override
  String get activity_reconnecting =>
      'Reconnexion — vérification de l’état du tour';

  @override
  String get activity_outcome_unknown =>
      'Le résultat du tour n’a pas pu être confirmé. Ouvrez la discussion pour le vérifier.';

  @override
  String get activity_chat_updated_detail =>
      'Activité de la discussion enregistrée par la passerelle ; l’état du tour en temps réel n’est pas disponible.';

  @override
  String get activity_updated => 'Mis à jour';

  @override
  String get activity_empty_title => 'Aucune activité récente';

  @override
  String get activity_empty_detail =>
      'Les tours lancés dans cette application et les discussions de la passerelle mises à jour au cours des 7 derniers jours apparaissent ici.';

  @override
  String get activity_read_error =>
      'La vue Activité n’a pas pu lire ses enregistrements de tours ou les discussions de la passerelle. Vérifiez la connexion et réessayez.';

  @override
  String get activity_chat_unavailable =>
      'Cette discussion n’est plus disponible ou la passerelle n’a pas pu être jointe.';

  @override
  String get activity_partial_title => 'Activité partiellement chargée';

  @override
  String get activity_partial_detail =>
      'Une période limitée de l’activité de la passerelle est affichée. D’autres discussions peuvent exister ; tirez vers le bas pour actualiser.';

  @override
  String get provider_usage => 'Utilisation enregistrée';

  @override
  String get provider_usage_notice =>
      'Utilisation de Hermes sur 30 jours, pas le solde ni les tarifs. Configurez les identifiants sur le serveur Hermes ; cette application ne stocke aucune clé API de fournisseur.';

  @override
  String get provider_usage_failed =>
      'Impossible de charger l’utilisation enregistrée.';

  @override
  String get provider_usage_empty =>
      'Aucune utilisation enregistrée pour ce fournisseur.';

  @override
  String provider_usage_counts(String sessions, String input, String output) {
    return '$sessions sessions · Entrée : $input · Sortie : $output';
  }

  @override
  String provider_usage_costs(String estimated, String actual) {
    return 'Estimé : $estimated · Déclaré : $actual';
  }

  @override
  String get provider_quota_codex => 'Abonnement OpenAI Codex';

  @override
  String get provider_quota_claude => 'Abonnement Claude';

  @override
  String get provider_quota_openai_api =>
      'Utilisation enregistrée de l’API OpenAI';

  @override
  String get provider_quota_notice =>
      'Périodes de l’abonnement indiquées par le fournisseur, distinctes de l’utilisation enregistrée par Hermes et de la facturation de l’API. Les comptes sont affichés séparément ; les limites d’un modèle ne signifient pas que tout le quota du compte est épuisé.';

  @override
  String get provider_quota_windows_notice =>
      'Les abonnements Codex et Claude ont des limites par session de cinq heures et par semaine. Seules les périodes indiquées par le fournisseur sont affichées ; les limites et les heures de réinitialisation non communiquées restent indisponibles. Les limites hebdomadaires peuvent s’appliquer au compte ou à certains modèles.';

  @override
  String get provider_quota_five_hour_session => 'Session de 5 heures';

  @override
  String get provider_quota_unavailable =>
      'Quota de l’abonnement indisponible.';

  @override
  String get provider_quota_failed =>
      'Impossible d’actualiser le quota de l’abonnement. Les valeurs conservées proviennent de la consultation précédente.';

  @override
  String get provider_quota_account => 'Compte';

  @override
  String get provider_quota_unknown => 'inconnu';

  @override
  String provider_quota_state(String state) {
    return 'État du compte : $state';
  }

  @override
  String provider_quota_scope(String scope) {
    return 'Portée : $scope';
  }

  @override
  String provider_quota_percent(String used, String remaining) {
    return '$used% utilisé · $remaining% restant';
  }

  @override
  String provider_quota_reset(String reset) {
    return 'Réinitialisation : $reset';
  }

  @override
  String get provider_quota_reset_unknown =>
      'Heure de réinitialisation indisponible.';

  @override
  String get auxiliary_models => 'Modèles auxiliaires';

  @override
  String get auxiliary_notice =>
      'Choisissez un modèle par tâche. Gérez les points de terminaison personnalisés sur le serveur. Auto suit les règles d’héritage de la tâche.';

  @override
  String get auxiliary_inherit => 'Auto (hériter)';

  @override
  String get auxiliary_unavailable =>
      'Les paramètres auxiliaires sont indisponibles.';

  @override
  String get provider_oauth_title => 'Connexion aux fournisseurs';

  @override
  String get provider_oauth_more_subtitle =>
      'Gérer la connexion aux fournisseurs sur votre hôte Hermes';

  @override
  String get provider_oauth_settings_subtitle =>
      'Connectez-vous sur votre hôte Hermes ; les jetons du fournisseur restent hors de cet appareil';

  @override
  String get provider_oauth_intro =>
      'Connectez-vous à votre fournisseur dans un navigateur externe. Les jetons sont stockés uniquement sur votre hôte Hermes, pas sur cet appareil. La connexion ne sélectionne pas de modèle de discussion dans cette application.';

  @override
  String get provider_oauth_defaults_notice =>
      'Certaines procédures de l’hôte, dont le remplacement d’un compte gratuit Nous, peuvent modifier ses paramètres par défaut. Vérifiez les paramètres de votre hôte après la connexion.';

  @override
  String get provider_oauth_transport_init_failed =>
      'Impossible d’initialiser la connexion sécurisée au tableau de bord sélectionné. Vérifiez son identité TLS et ses paramètres de connexion.';

  @override
  String get provider_oauth_https_required =>
      'La connexion aux fournisseurs nécessite une connexion HTTPS au tableau de bord Hermes.';

  @override
  String get provider_oauth_auth_required =>
      'Configurez l’authentification par mot de passe du tableau de bord ou un proxy de confiance avant de vous connecter.';

  @override
  String get provider_oauth_catalog_failed =>
      'La connexion aux fournisseurs est indisponible sur cet hôte. Vérifiez l’authentification du tableau de bord et mettez l’hôte à jour s’il ne prend pas en charge OAuth pour les fournisseurs.';

  @override
  String get provider_oauth_expired => 'La connexion a expiré. Recommencez.';

  @override
  String get provider_oauth_start_failed =>
      'Impossible de démarrer la connexion sécurisée au fournisseur. Réessayez.';

  @override
  String get provider_oauth_denied =>
      'La connexion a été refusée. Recommencez.';

  @override
  String get provider_oauth_cancelled => 'Connexion annulée.';

  @override
  String get provider_oauth_host_failed =>
      'L’hôte n’a pas pu terminer la connexion. Recommencez.';

  @override
  String get provider_oauth_poll_failed =>
      'Impossible de vérifier l’état de la connexion. Recommencez.';

  @override
  String provider_oauth_cancellation_unconfirmed(String message) {
    return '$message L’annulation n’a pas pu être confirmée ; la session de l’hôte peut se poursuivre jusqu’à son expiration.';
  }

  @override
  String get provider_oauth_browser_failed =>
      'Impossible d’ouvrir le navigateur externe. Réessayez ou annulez la connexion.';

  @override
  String get provider_oauth_retry => 'Réessayer';

  @override
  String provider_oauth_complete(String provider) {
    return 'Terminer la connexion à $provider';
  }

  @override
  String get provider_oauth_code_instruction =>
      'Saisissez ce code temporaire sur la page du fournisseur :';

  @override
  String get provider_oauth_waiting =>
      'En attente d’approbation. Cette session expire automatiquement.';

  @override
  String get provider_oauth_open_browser =>
      'Ouvrir le fournisseur dans le navigateur';

  @override
  String get provider_oauth_cancel => 'Annuler la connexion';

  @override
  String get provider_oauth_signed_out => 'Non connecté sur l’hôte';

  @override
  String get provider_oauth_sign_in_again => 'Se reconnecter';

  @override
  String get provider_oauth_sign_in => 'Se connecter';

  @override
  String get provider_oauth_cli_required =>
      'Connectez-vous avec la CLI du fournisseur sur votre hôte Hermes. Cet hôte ne propose pas de connexion dans l’application pour ce fournisseur.';

  @override
  String get provider_oauth_checking_account =>
      'Autorisation reçue. Vérification du compte sur le serveur…';

  @override
  String get provider_oauth_verification_unavailable =>
      'Autorisation reçue ; vérification du compte indisponible. Ouvrez Utilisation pour actualiser les données du compte.';

  @override
  String provider_oauth_verified_account(String email) {
    return 'Connecté sur le serveur Hermes en tant que $email. Ouvrez Utilisation pour actualiser les données du compte.';
  }

  @override
  String get provider_oauth_credentials_unverified =>
      'Le serveur signale des identifiants disponibles ; l’identité du compte n’est pas vérifiée.';

  @override
  String get provider_oauth_account_status_unknown =>
      'État du compte sur le serveur indisponible.';

  @override
  String get app_language => 'Langue de l’application';

  @override
  String get app_language_system => 'Comme le téléphone';

  @override
  String get auto_archives_after_72_hours =>
      'Archivage automatique après 72 heures';

  @override
  String get automation => 'Automatisation';

  @override
  String get voice_recording_start => 'Enregistrer un message vocal';

  @override
  String get voice_recording_pause => 'Suspendre l’enregistrement';

  @override
  String get voice_recording_preview => 'Lire l’enregistrement';

  @override
  String get voice_recording_resume => 'Reprendre l’enregistrement';

  @override
  String get voice_recording_send => 'Envoyer le message vocal';

  @override
  String get voice_recording_discard => 'Supprimer l’enregistrement';

  @override
  String get voice_recording_processing => 'Préparation du message vocal…';

  @override
  String voice_recording_elapsed(String time) {
    return 'Enregistrement $time';
  }

  @override
  String voice_recording_draft(String time) {
    return 'Message vocal $time';
  }

  @override
  String get voice_recording_permission =>
      'Autorisez l’accès au microphone pour enregistrer un message vocal.';

  @override
  String get voice_recording_limit =>
      'Cet enregistrement a atteint la limite de dix minutes.';

  @override
  String get voice_recording_empty =>
      'Aucun son n’a été enregistré. Réessayez.';

  @override
  String get voice_recording_failed =>
      'Impossible de traiter l’enregistrement. Les fragments sauvegardés ont été conservés.';

  @override
  String get voice_recording_unconfirmed =>
      'La livraison n’a pas été confirmée. Votre enregistrement est sauvegardé. Vérifiez la discussion avant de réessayer.';

  @override
  String get voice_recording_submit_failed =>
      'Impossible d’envoyer le message vocal. Votre enregistrement est sauvegardé. Vérifiez la connexion, l’accès au tableau de bord et les paramètres de transcription du serveur.';

  @override
  String get voice_recording_pause_playback => 'Suspendre la lecture';

  @override
  String get projects_root_title => 'Dossier des Projets sur le serveur';

  @override
  String get projects_root_more_subtitle =>
      'Où sont créés les nouveaux dossiers de Projet sur le serveur';

  @override
  String get projects_root_description =>
      'Les Projets créés sur ce téléphone reçoivent leur dossier ici. Pointez-le vers le dossier utilisé par Hermes afin que le téléphone et le serveur partagent les mêmes Projets.';

  @override
  String get projects_root_label => 'Chemin racine des Projets';

  @override
  String projects_root_default_hint(String path) {
    return 'Valeur par défaut du serveur : $path';
  }

  @override
  String get projects_root_locked_title => 'Défini par le serveur';

  @override
  String get projects_root_locked_explanation =>
      'Ce serveur limite l\'accès aux fichiers à une seule racine ; le dossier des Projets ne peut donc pas être modifié depuis l\'application.';

  @override
  String get projects_root_saved => 'Dossier des Projets enregistré.';

  @override
  String get projects_root_reset => 'Utiliser la valeur par défaut du serveur';

  @override
  String get projects_root_invalid_empty => 'Saisissez un chemin de dossier.';

  @override
  String get projects_root_invalid_absolute =>
      'Saisissez un chemin absolu commençant par une barre oblique.';

  @override
  String get projects_root_invalid_segments =>
      'Supprimez les segments en points et les caractères de contrôle du chemin.';

  @override
  String get projects_root_unsupported =>
      'Non pris en charge sur cette connexion. Une connexion Desktop Gateway avec accès au Tableau de bord est nécessaire pour lire ou modifier le dossier des Projets du serveur.';

  @override
  String get projects_root_unavailable =>
      'Impossible de lire le dossier des Projets du serveur. Vérifiez la connexion au Tableau de bord, puis réessayez.';

  @override
  String get adopt_folder_action => 'Ajouter un dossier existant';

  @override
  String adopt_folder_description(String root) {
    return 'Dossiers sous $root qui ne sont pas encore enregistrés comme Projet.';
  }

  @override
  String adopt_folder_registered(String name) {
    return 'Déjà un Projet : $name';
  }

  @override
  String get adopt_folder_none =>
      'Tous les dossiers de ce chemin sont déjà des Projets.';

  @override
  String get adopt_folder_unsupported =>
      'Cette connexion ne peut pas lister les dossiers du serveur. Saisissez plutôt le chemin absolu d\'un dossier existant.';

  @override
  String adopt_folder_failed(String error) {
    return 'Impossible de lister les dossiers du serveur : $error';
  }

  @override
  String get adopt_folder_manual_label => 'Chemin du dossier existant';

  @override
  String get adopt_folder_name_label => 'Nom du Projet';

  @override
  String get adopt_folder_add => 'Ajouter comme Projet';

  @override
  String adopt_folder_added(String name, String path) {
    return '$name utilise désormais $path';
  }

  @override
  String adopt_folder_error(String error) {
    return 'Impossible d\'ajouter le dossier : $error';
  }

  @override
  String adopt_folder_folderless(String name) {
    return '$name a été créé, mais le dossier n\'a pas été rattaché. Rattachez-le depuis Hermes sur le serveur.';
  }

  @override
  String get slash_commands => 'Slash commands';

  @override
  String get slash_commands_loading => 'Loading commands…';

  @override
  String get slash_commands_empty => 'No matching commands';

  @override
  String slash_command_info_alias(String alias, String command) {
    return '$alias est un alias de $command';
  }

  @override
  String get slash_command_info_no_description =>
      'Aucune description disponible.';

  @override
  String get slash_command_info_arguments_options =>
      'Accepte une option parmi une liste fixe.';

  @override
  String get slash_command_info_arguments_text =>
      'Accepte du texte après la commande.';

  @override
  String get slash_command_info_arguments_mixed =>
      'Accepte une option ou du texte après la commande.';

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
      'Cette commande n\'est pas disponible sur ce serveur.';

  @override
  String get slash_sessions_inline =>
      'Ouvrez la liste des sessions pour choisir une conversation. Votre brouillon a été conservé.';

  @override
  String get composer_snippets => 'Modèles de prompts';

  @override
  String get composer_snippets_description =>
      'Choisir un prompt de départ à insérer dans la zone de saisie.';

  @override
  String get composer_snippet_review => 'Revue de code';

  @override
  String get composer_snippet_review_body =>
      'Vérifier la modification actuelle pour repérer les régressions, les cas limites oubliés et les tests manquants.';

  @override
  String get composer_snippet_review_text =>
      'Veuillez examiner ceci pour repérer les bugs, les régressions et les tests manquants.';

  @override
  String get composer_snippet_plan => 'Plan de mise en œuvre';

  @override
  String get composer_snippet_plan_body =>
      'Définir une approche avant de toucher au code pour garder un diff ciblé.';

  @override
  String get composer_snippet_plan_text =>
      'Veuillez établir un plan de mise en œuvre concis avant de modifier le code.';

  @override
  String get composer_snippet_explain => 'Expliquer ceci';

  @override
  String get composer_snippet_explain_body =>
      'Expliquer le fonctionnement du code sélectionné et indiquer les fichiers clés.';

  @override
  String get composer_snippet_explain_text =>
      'Veuillez expliquer comment ceci fonctionne et m’indiquer les fichiers clés.';

  @override
  String get composer_status => 'Statut';

  @override
  String get composer_status_context => 'Contexte';

  @override
  String get composer_status_cache => 'Succès du cache';

  @override
  String get composer_status_throughput => 'Tokens générés/s';

  @override
  String get composer_status_running => 'En cours';

  @override
  String get composer_status_session => 'Session';

  @override
  String get composer_status_not_reported => 'Non signalé';

  @override
  String get composer_status_empty =>
      'Aucune répartition du contexte n’a été signalée.';

  @override
  String get composer_status_loading =>
      'Chargement de la répartition du contexte';

  @override
  String get composer_status_reset => 'Réinitialiser la barre d’état';

  @override
  String get composer_resume_title => 'Reprendre une discussion';

  @override
  String get composer_resume_search =>
      'Rechercher dans les titres et identifiants';

  @override
  String get composer_resume_empty => 'Aucune discussion correspondante.';

  @override
  String get composer_resume_unavailable =>
      'Ce volet n’a pas de liste de discussions à parcourir.';

  @override
  String get composer_failure_retry => 'Réessayer';

  @override
  String composer_failure_retry_at(String time) {
    return 'Réessayer à $time';
  }

  @override
  String get composer_failure_compress => 'Compresser';

  @override
  String get composer_failure_switch_model => 'Changer de modèle';

  @override
  String composer_failure_switch_to(String model) {
    return 'Passer à $model';
  }

  @override
  String get composer_failure_new_chat => 'Nouvelle discussion';

  @override
  String get composer_failure_edit => 'Modifier le message';

  @override
  String get composer_failure_details => 'Détails';

  @override
  String get composer_failure_hide_details => 'Masquer les détails';

  @override
  String get composer_failure_copy => 'Copier les diagnostics';

  @override
  String get composer_failure_account =>
      'L’autre solution se trouve dans le compte de la passerelle. Cette discussion ne permet pas de l’appliquer.';

  @override
  String get composer_failure_account_only =>
      'Ceci doit être corrigé dans le compte de la passerelle. Cette discussion ne permet pas de le faire.';

  @override
  String get composer_failure_confirm_compress =>
      'Compresser cette discussion ? La passerelle raccourcira la transcription.';

  @override
  String composer_failure_confirm_model(String model) {
    return 'Passer cette discussion à $model ?';
  }

  @override
  String get composer_drop_attach => 'Déposer pour joindre';

  @override
  String get composer_drop_folder_unsupported =>
      'Les dossiers ne peuvent pas être joints. Déposez plutôt les fichiers.';

  @override
  String get composer_drop_reference => 'Déposer pour référencer';

  @override
  String get composer_reference_copy => 'Copier la référence';

  @override
  String get composer_reference_remove => 'Retirer la référence';

  @override
  String get composer_btw_usage =>
      'Utilisation : /btw <question> — réponse à partir d’un instantané de cette conversation, sans l’interrompre.';

  @override
  String get composer_background_usage =>
      'Utilisation : /background <prompt> — la tâche s’exécute séparément et le résultat revient ici.';

  @override
  String get composer_handoff_usage =>
      'Utilisation : /handoff <platform> — transférer cette discussion vers cette plateforme de messagerie.';

  @override
  String get composer_command_needs_session =>
      'Cette commande nécessite une discussion ouverte.';

  @override
  String get composer_retry_not_found =>
      'Ce tour ne figure pas dans l’historique enregistré ; Réessayer ne peut donc pas le remplacer. Rien n’a été renvoyé. Modifiez le message et envoyez-le pour réessayer.';

  @override
  String get composer_retry_unavailable =>
      'Réessayer ne peut pas remplacer un tour sur cette connexion ; rien n’a donc été renvoyé. Modifiez le message et envoyez-le pour réessayer.';

  @override
  String get composer_failure_switch_no_retry =>
      'Le changement ne modifie que le modèle : cette connexion ne peut pas relancer le tour en échec. Renvoyez-le après le changement.';

  @override
  String get composer_command_needs_gateway_session =>
      'Cette discussion n’a pas encore de session sur la passerelle. Envoyez d’abord un message, puis relancez la commande.';

  @override
  String get composer_side_question =>
      'btw — réponse à partir d’un instantané de la conversation';

  @override
  String composer_side_question_id(String id) {
    return 'btw $id — réponse à partir d’un instantané de la conversation';
  }

  @override
  String get composer_background_started =>
      'Tâche en arrière-plan démarrée. Vous pouvez continuer la discussion. Le résultat apparaîtra ici.';

  @override
  String composer_background_started_id(String id) {
    return 'Tâche en arrière-plan $id démarrée. Vous pouvez continuer la discussion. Le résultat apparaîtra ici.';
  }

  @override
  String composer_handoff_requested(String platform) {
    return 'Transfert vers $platform demandé.';
  }

  @override
  String composer_handoff_done(String platform) {
    return 'Cette discussion a été transférée vers $platform.';
  }

  @override
  String get composer_handoff_failed => 'Échec du transfert.';

  @override
  String get composer_handoff_timeout =>
      'Le transfert n’est pas terminé. Il est peut-être encore en cours sur la passerelle.';

  @override
  String get composer_compress_done => 'Cette discussion a été compressée.';

  @override
  String get composer_file_missing => 'Ce fichier n’est pas sur cet appareil.';

  @override
  String get composer_attach_busy =>
      'Les pièces jointes pourront être ajoutées une fois cette réponse terminée.';

  @override
  String get nextgen_toggle => 'Interface NextGen';

  @override
  String get nextgen_toggle_subtitle =>
      'Un nouveau design avec une seule connexion, des discussions en direct et la découverte réseau. Vos passerelles et discussions sont partagées avec cette interface.';

  @override
  String get nextgen_single_login => 'Se connecter avec un seul identifiant';

  @override
  String get nextgen_single_login_subtitle =>
      'Ajoutez une passerelle avec la seule adresse de son tableau de bord et une connexion.';

  @override
  String get ng_allow_this_command => 'Autoriser cette commande ?';

  @override
  String ng_hermes_wants_to_run_this_with(Object tool) {
    return 'Hermes veut exécuter ceci avec $tool.';
  }

  @override
  String get ng_hermes_wants_to_run_this => 'Hermes veut exécuter ceci.';

  @override
  String get ng_hermes_has_a_question => 'Hermes a une question';

  @override
  String get ng_hermes_has_questions => 'Hermes a des questions';

  @override
  String get ng_password_for_sudo => 'Mot de passe sudo';

  @override
  String get ng_hermes_needs_your_sudo_password_to =>
      'Hermes a besoin de votre mot de passe sudo pour exécuter cette commande.';

  @override
  String get ng_a_secret_value => 'Une valeur secrète';

  @override
  String ng_value_for(Object variable) {
    return 'Valeur pour $variable';
  }

  @override
  String get ng_your_password_manager => 'votre gestionnaire de mots de passe';

  @override
  String ng_unlock(Object name) {
    return 'Déverrouiller $name';
  }

  @override
  String ng_hermes_needs_unlocked_to_sign_in(Object name) {
    return 'Hermes a besoin que $name soit déverrouillé pour vous connecter.';
  }

  @override
  String get ng_sign_in_code => 'Code de connexion';

  @override
  String get ng_enter_the_sign_in_code => 'Saisissez le code de connexion.';

  @override
  String ng_enter_the_sign_in_code_for(Object site) {
    return 'Saisissez le code de connexion pour $site.';
  }

  @override
  String get ng_save_a_login => 'Enregistrer ces identifiants ?';

  @override
  String ng_save_your_login(Object site) {
    return 'Enregistrer vos identifiants pour $site ?';
  }

  @override
  String ng_couldn_t_load_this_chat(Object error) {
    return 'Impossible de charger cette conversation : $error';
  }

  @override
  String ng_live_updates_are_unavailable(Object error) {
    return 'Les mises à jour en direct sont indisponibles : $error';
  }

  @override
  String ng_preparing(Object name) {
    return 'préparation de $name…';
  }

  @override
  String get ng_the_turn_failed => 'Le tour a échoué.';

  @override
  String get ng_turn_changed =>
      'ce tour est déjà terminé ou un tour plus récent a commencé';

  @override
  String get ng_steer_rejected => 'le tour en cours ne l’a pas accepté';

  @override
  String get ng_turn_not_known_yet =>
      'le tour en cours n’est pas encore connu ; réessayez dans un instant';

  @override
  String ng_couldn_t_stop(Object error) {
    return 'Impossible d\'arrêter : $error';
  }

  @override
  String get ng_server_access => 'Accès au serveur';

  @override
  String get ng_sign_in => 'Connexion';

  @override
  String get ng_live_connection => 'Connexion en direct';

  @override
  String get ng_check_that_tailscale_is_on_on =>
      'Vérifiez que Tailscale est activé sur ce téléphone et sur le serveur.';

  @override
  String get ng_check_the_address_and_that_the =>
      'Vérifiez l\'adresse et que le proxy redirige vers le tableau de bord.';

  @override
  String get ng_use_the_same_network_as_the =>
      'Utilisez le même réseau que le serveur et lancez le tableau de bord avec --host 0.0.0.0 pour qu\'il soit accessible depuis d\'autres appareils.';

  @override
  String get ng_check_the_address_vpn_or_tailscale =>
      'Vérifiez l\'adresse, le VPN ou la connexion Tailscale.';

  @override
  String get ng_not_checked_yet => 'Pas encore vérifié.';

  @override
  String get ng_checking => 'Vérification…';

  @override
  String ng_hermes_answers_at(Object version, Object address) {
    return 'Hermes $version répond à $address.';
  }

  @override
  String get ng_something_answered_but_not_a_hermes =>
      'Une réponse a été reçue, mais ce n\'est pas un tableau de bord Hermes.';

  @override
  String ng_something_answered_http_but_not_a(Object status) {
    return 'Une réponse a été reçue (HTTP $status), mais ce n\'est pas un tableau de bord Hermes.';
  }

  @override
  String get ng_use_the_dashboard_s_address_and =>
      'Utilisez l\'adresse et le port du tableau de bord (9119 par défaut), et non ceux du serveur API.';

  @override
  String get ng_cloudflare_access_turned_the_service_token =>
      'Cloudflare Access a refusé le jeton de service.';

  @override
  String get ng_cloudflare_access_is_in_front_of =>
      'Cloudflare Access se trouve devant cette adresse.';

  @override
  String get ng_check_the_service_token_and_its =>
      'Vérifiez le jeton de service et sa règle Service Auth.';

  @override
  String get ng_add_a_cloudflare_access_service_token =>
      'Ajoutez un jeton de service Cloudflare Access pour cette adresse.';

  @override
  String get ng_the_server_asks_for_a_client =>
      'Le serveur demande un certificat client.';

  @override
  String get ng_pick_the_client_certificate_for_this =>
      'Sélectionnez le certificat client de cette passerelle, puis réessayez.';

  @override
  String get ng_needs_server_access_first =>
      'L\'accès au serveur est requis au préalable.';

  @override
  String get ng_needs_a_sign_in_first => 'Vous devez d\'abord vous connecter.';

  @override
  String ng_signed_in_as(Object name) {
    return 'Connecté en tant que $name.';
  }

  @override
  String get ng_this_dashboard_doesn_t_need_a =>
      'Ce tableau de bord ne nécessite pas de connexion.';

  @override
  String get ng_the_saved_sign_in_has_expired =>
      'La connexion enregistrée a expiré.';

  @override
  String get ng_sign_in_again => 'Reconnectez-vous.';

  @override
  String get ng_too_many_sign_in_attempts => 'Trop de tentatives de connexion.';

  @override
  String get ng_wait_a_minute_then_check_again =>
      'Attendez une minute, puis réessayez.';

  @override
  String ng_the_gateway_answered(Object message) {
    return 'La passerelle a répondu : $message.';
  }

  @override
  String get ng_sign_in_again_or_update_hermes =>
      'Reconnectez-vous ou mettez Hermes à jour.';

  @override
  String ng_couldn_t_check_the_sign_in(Object error) {
    return 'Impossible de vérifier la connexion : $error';
  }

  @override
  String ng_the_gateway_wouldn_t_issue_a(Object message) {
    return 'La passerelle n\'a pas voulu émettre de ticket de chat ($message).';
  }

  @override
  String get ng_the_chat_connection_opened_and_the =>
      'La connexion au chat est ouverte et la passerelle indique qu\'elle est prête.';

  @override
  String get ng_the_gateway_never_said_it_was =>
      'La passerelle n\'a jamais indiqué qu\'elle était prête.';

  @override
  String get ng_check_that_the_agent_is_running =>
      'Vérifiez que l\'agent est en cours d\'exécution sur le serveur.';

  @override
  String get ng_the_gateway_refused_the_chat_connection =>
      'La passerelle a refusé la connexion au chat (HTTP 403).';

  @override
  String get ng_this_dashboard_has_no_chat_endpoint =>
      'Ce tableau de bord n\'a pas de point de terminaison de chat (/api/ws).';

  @override
  String ng_the_chat_connection_failed(Object detail) {
    return 'La connexion au chat a échoué : $detail';
  }

  @override
  String get ng_use_the_exact_address_the_dashboard =>
      'Utilisez l\'adresse exacte configurée pour le tableau de bord.';

  @override
  String get ng_update_hermes => 'Mettez Hermes à jour.';

  @override
  String get ng_make_sure_the_proxy_allows_websocket =>
      'Vérifiez que le proxy autorise les mises à niveau WebSocket sur /api/ws.';

  @override
  String get ng_offline => 'Hors ligne';

  @override
  String get ng_connecting => 'Connexion…';

  @override
  String get ng_connected => 'Connecté';

  @override
  String get ng_reconnecting => 'Reconnexion…';

  @override
  String get ng_signed_out => 'Déconnecté';

  @override
  String get ng_connection_failed => 'Échec de la connexion';

  @override
  String get ng_rate_limited_by_gateway =>
      'Limite de requêtes atteinte auprès de la passerelle';

  @override
  String ng_couldn_t_open_the_chat_connection(Object message) {
    return 'Impossible d’ouvrir la connexion au chat : $message';
  }

  @override
  String get ng_the_gateway_returned_no_websocket_ticket =>
      'La passerelle n’a renvoyé aucun ticket WebSocket.';

  @override
  String get ng_connection_lost => 'Connexion perdue';

  @override
  String get ng_this_dashboard_has_no_chat_endpoint_2 =>
      'Ce tableau de bord n’a pas de point de terminaison pour le chat (/api/ws). Mettez Hermes à jour.';

  @override
  String get ng_the_gateway_refused_the_chat_connection_2 =>
      'La passerelle a refusé la connexion au chat. Vérifiez que l’adresse correspond à l’hôte configuré pour le tableau de bord et que le chat intégré est activé.';

  @override
  String ng_the_gateway_refused(Object method) {
    return 'La passerelle a refusé $method.';
  }

  @override
  String ng_couldn_t_read_your_saved_gateways(Object error) {
    return 'Impossible de lire vos passerelles enregistrées : $error';
  }

  @override
  String get ng_applies_to_new_chats => 'S’applique aux nouveaux chats';

  @override
  String ng_couldn_t_change(Object label, Object error) {
    return 'Impossible de modifier $label : $error';
  }

  @override
  String get ng_capabilities => 'Capacités';

  @override
  String get ng_skills => 'Compétences';

  @override
  String get ng_toolsets => 'Ensembles d’outils';

  @override
  String get ng_search => 'Rechercher';

  @override
  String get ng_couldn_t_load => 'Impossible de charger';

  @override
  String get ng_try_again => 'Réessayer';

  @override
  String get ng_no_skills => 'Aucune compétence';

  @override
  String get ng_no_toolsets => 'Aucun ensemble d’outils';

  @override
  String get ng_no_mcp_servers => 'Aucun serveur MCP';

  @override
  String get ng_that_file_is_too_large_to =>
      'Ce fichier est trop volumineux pour être un certificat.';

  @override
  String ng_the_certificate_couldn_t_be_imported(Object error) {
    return 'Impossible d’importer le certificat : $error';
  }

  @override
  String get ng_now_pick_its_private_key =>
      'Choisissez maintenant sa clé privée.';

  @override
  String get ng_now_pick_its_certificate =>
      'Choisissez maintenant son certificat.';

  @override
  String get ng_that_file_isn_t_a_certificate =>
      'Ce fichier n’est ni un certificat ni une clé privée.';

  @override
  String get ng_if_a_proxy_in_front_of =>
      'Si un proxy situé devant cette adresse demande un certificat client, choisissez-le ici pour que le test, la connexion et le chat le présentent.';

  @override
  String get ng_client_certificates_are_only_used_with =>
      'Les certificats client sont utilisés uniquement avec les adresses https://.';

  @override
  String get ng_remove => 'Supprimer';

  @override
  String get ng_certificate_password => 'Mot de passe du certificat';

  @override
  String get ng_importing => 'Importation…';

  @override
  String get ng_pick_certificate => 'Choisir un certificat';

  @override
  String get ng_pick_a_different_certificate => 'Choisir un autre certificat';

  @override
  String get ng_accepts_p12_pfx_or_pem_certificate =>
      'Accepte les fichiers .p12/.pfx, ou les fichiers de certificat et de clé PEM. La clé reste dans le stockage privé de cette app.';

  @override
  String get ng_photos => 'Photos';

  @override
  String get ng_camera => 'Appareil photo';

  @override
  String get ng_files => 'Fichiers';

  @override
  String ng_you_can_attach_up_to_files(Object count) {
    return 'Vous pouvez joindre jusqu’à $count fichiers.';
  }

  @override
  String ng_couldn_t_read(Object name) {
    return 'Impossible de lire $name.';
  }

  @override
  String ng_couldn_t_prepare_that_file(Object error) {
    return 'Impossible de préparer ce fichier : $error';
  }

  @override
  String get ng_hermes_is_still_working => 'Hermes travaille encore';

  @override
  String get ng_steer => 'Orienter';

  @override
  String get ng_adds_this_to_the_running_turn =>
      'Ajoute ceci au tour en cours à l’étape suivante';

  @override
  String get ng_queue => 'Mettre en file d’attente';

  @override
  String get ng_sends_it_when_the_turn_finishes =>
      'Envoie ceci à la fin du tour';

  @override
  String get ng_stop_and_send => 'Arrêter et envoyer';

  @override
  String get ng_stops_the_turn_then_sends_this =>
      'Arrête le tour, puis envoie ceci';

  @override
  String ng_dictation_stopped(Object message) {
    return 'Dictée arrêtée : $message';
  }

  @override
  String get ng_speech_recognition_isn_t_available =>
      'La reconnaissance vocale n’est pas disponible.';

  @override
  String get ng_working => 'En cours';

  @override
  String get ng_ready => 'Prêt';

  @override
  String get ng_chats => 'Chats';

  @override
  String get ng_new_chat => 'Nouveau chat';

  @override
  String get ng_usage => 'Utilisation';

  @override
  String get ng_rename_chat => 'Renommer le chat';

  @override
  String ng_couldn_t_rename(Object error) {
    return 'Impossible de renommer : $error';
  }

  @override
  String get ng_this_chat => 'Ce chat';

  @override
  String get ng_input_tokens => 'Jetons d’entrée';

  @override
  String get ng_output_tokens => 'Jetons de sortie';

  @override
  String get ng_reasoning_tokens => 'Jetons de raisonnement';

  @override
  String get ng_cache_reads => 'Lectures du cache';

  @override
  String get ng_api_calls => 'Appels API';

  @override
  String get ng_cost => 'Coût';

  @override
  String get ng_context => 'Contexte';

  @override
  String get ng_your_sign_in_expired => 'Votre session a expiré.';

  @override
  String get ng_sign_in_2 => 'Se connecter';

  @override
  String get ng_retry => 'Réessayer';

  @override
  String get ng_project_home => 'Accueil';

  @override
  String get ng_choose_project => 'Choisir un projet';

  @override
  String ng_project_cwd_fallback(String path) {
    return 'Le dossier du projet n’était pas disponible ; cette conversation s’exécute donc dans $path.';
  }

  @override
  String get ng_project_create_uncertain =>
      'La passerelle a peut-être créé cette conversation sans le confirmer. Vérifiez les conversations avant d’en démarrer une autre ; cette demande ne sera pas relancée automatiquement.';

  @override
  String get ng_what_should_we_work_on => 'Sur quoi voulez-vous travailler ?';

  @override
  String get ng_ask_hermes_anything_it_can_run =>
      'Demandez ce que vous voulez à Hermes. Il peut utiliser des outils, naviguer sur le Web et travailler sur vos fichiers sur le serveur.';

  @override
  String ng_working_2(Object frame) {
    return 'En cours · $frame';
  }

  @override
  String get ng_default_model => 'Modèle par défaut';

  @override
  String get ng_listening => 'Écoute…';

  @override
  String get ng_steer_or_queue_a_message =>
      'Orientez Hermes ou mettez un message en attente';

  @override
  String get ng_message_hermes => 'Envoyer un message à Hermes';

  @override
  String get ng_attach => 'Joindre';

  @override
  String get ng_stop_dictation => 'Arrêter la dictée';

  @override
  String get ng_dictate => 'Dicter';

  @override
  String get ng_stop => 'Arrêter';

  @override
  String get ng_send => 'Envoyer';

  @override
  String ng_slash_command_alias(String alias, String command) {
    return '$alias est un alias de $command';
  }

  @override
  String get ng_slash_command_no_description =>
      'Aucune description disponible.';

  @override
  String get ng_slash_command_arguments_options =>
      'Accepte une option parmi une liste fixe.';

  @override
  String get ng_slash_command_arguments_text =>
      'Accepte du texte après la commande.';

  @override
  String get ng_slash_command_arguments_mixed =>
      'Accepte une option ou du texte après la commande.';

  @override
  String get ng_slash_command_sent_as_message =>
      'NextGen envoie ceci à Hermes comme un message normal ; la commande elle-même n’est pas exécutée.';

  @override
  String get ng_slash_command_output => 'Sortie de la commande';

  @override
  String get ng_slash_command_running => 'Exécution de la commande…';

  @override
  String get ng_slash_command_done => 'Terminé.';

  @override
  String ng_slash_command_failed(Object error) {
    return 'Impossible d\'exécuter la commande : $error';
  }

  @override
  String get ng_slash_command_refused =>
      'Hermes ne peut pas exécuter cette commande ici.';

  @override
  String get ng_slash_command_delivery_unknown =>
      'La commande a été envoyée mais aucune réponse n’est arrivée. Elle est peut-être encore en cours sur la passerelle : elle n’a donc pas été renvoyée et votre brouillon a été conservé.';

  @override
  String get ng_slash_command_nothing_running => 'Rien n’est en cours.';

  @override
  String get ng_steered => 'Orienté';

  @override
  String get ng_copied => 'Copié';

  @override
  String ng_not_sent(Object reason) {
    return 'Non envoyé : $reason';
  }

  @override
  String get ng_thinking => 'Réflexion…';

  @override
  String get ng_thought => 'Réflexion';

  @override
  String ng_used(Object name) {
    return 'A utilisé $name';
  }

  @override
  String ng_used_tools(Object count) {
    return 'A utilisé $count outils';
  }

  @override
  String get ng_copy => 'Copier';

  @override
  String get ng_read_aloud => 'Lire à voix haute';

  @override
  String get ng_the_gateway_connection_dropped_try_again =>
      'La connexion à la passerelle a été interrompue. Réessayez.';

  @override
  String get ng_allow_once => 'Autoriser une fois';

  @override
  String get ng_allow_until_sandbox_off =>
      'Jusqu’à la désactivation du bac à sable';

  @override
  String get ng_folder_access => 'Accès au dossier';

  @override
  String get ng_folder_access_unspecified =>
      'La passerelle n’a pas indiqué si l’accès est en lecture seule ou en lecture et écriture.';

  @override
  String get ng_folder_read_only => 'Lecture seule';

  @override
  String get ng_folder_read_write => 'Lecture et écriture';

  @override
  String get ng_website_access => 'Accès au site web';

  @override
  String get ng_allow_for_this_chat => 'Autoriser pour cette conversation';

  @override
  String get ng_always_allow => 'Toujours autoriser';

  @override
  String get ng_deny => 'Refuser';

  @override
  String get ng_your_answer => 'Votre réponse';

  @override
  String get ng_or_type_an_answer => 'Ou saisissez une réponse';

  @override
  String get ng_skip => 'Ignorer';

  @override
  String get ng_answer => 'Répondre';

  @override
  String get ng_cancel => 'Annuler';

  @override
  String get ng_username_or_email => 'Nom d’utilisateur ou e-mail';

  @override
  String get ng_password => 'Mot de passe';

  @override
  String get ng_not_now => 'Pas maintenant';

  @override
  String get ng_save => 'Enregistrer';

  @override
  String get ng_enter_both_the_client_id_and =>
      'Saisissez l’ID client et le secret client, ou ne saisissez ni l’un ni l’autre.';

  @override
  String get ng_enter_your_username_and_password =>
      'Saisissez votre nom d’utilisateur et votre mot de passe.';

  @override
  String ng_couldn_t_save_the_sign_in(Object error) {
    return 'Impossible d’enregistrer les identifiants : $error';
  }

  @override
  String get ng_wrong_username_or_password =>
      'Nom d’utilisateur ou mot de passe incorrect.';

  @override
  String get ng_too_many_attempts_wait_a_moment =>
      'Trop de tentatives. Attendez un instant, puis réessayez.';

  @override
  String get ng_welcome_to_hermes => 'Bienvenue sur Ares';

  @override
  String get ng_add_a_gateway => 'Ajouter une passerelle';

  @override
  String get ng_connect_to_your_hermes_agent_dashboard =>
      'Connectez-vous au tableau de bord de votre Hermes Agent. Une adresse et une connexion vous donnent accès à vos conversations, outils et paramètres. Rien n’est envoyé avant votre connexion.';

  @override
  String get ng_connect_to_another_hermes_agent_dashboard =>
      'Connectez-vous à un autre tableau de bord Hermes Agent. Vous restez connecté aux tableaux de bord que vous avez enregistrés.';

  @override
  String get ng_dashboard_address => 'Adresse du tableau de bord';

  @override
  String get ng_testing => 'Test en cours…';

  @override
  String get ng_test => 'Tester';

  @override
  String get ng_where_your_hermes_dashboard_runs_lan =>
      'Adresse de votre tableau de bord Hermes : réseau local, Tailscale ou HTTPS.';

  @override
  String get ng_find_on_my_network => 'Rechercher sur mon réseau';

  @override
  String get ng_which_address_do_i_use => 'Quelle adresse utiliser ?';

  @override
  String get ng_behind_cloudflare_access => 'Derrière Cloudflare Access ?';

  @override
  String get ng_need_a_client_certificate => 'Besoin d’un certificat client ?';

  @override
  String get ng_this_address_isn_t_private_and =>
      'Cette adresse n’est pas privée et n’utilise pas https://. Votre mot de passe et vos conversations circuleraient donc sur Internet sans chiffrement. Utilisez plutôt https://, Tailscale ou votre propre réseau.';

  @override
  String get ng_continue_to_sign_in => 'Continuer la connexion';

  @override
  String get ng_use_the_classic_interface_instead =>
      'Utiliser plutôt l’interface classique';

  @override
  String get ng_if_cloudflare_access_protects_this_address =>
      'Si Cloudflare Access protège cette adresse, créez un jeton de service dans Cloudflare Zero Trust (Access, Service credentials), puis ajoutez une règle Service Auth à l’application Access.';

  @override
  String get ng_a_service_token_is_saved_for =>
      'Un jeton de service est enregistré pour cette adresse';

  @override
  String get ng_forget => 'Oublier';

  @override
  String get ng_client_id => 'ID client';

  @override
  String get ng_client_secret => 'Secret client';

  @override
  String get ng_stored_encrypted_on_this_phone_and =>
      'Stockés de façon chiffrée sur ce téléphone et envoyés uniquement à cette adresse.';

  @override
  String get ng_hermes_is_reachable => 'Hermes est accessible';

  @override
  String ng_hermes_is_reachable_2(Object version) {
    return 'Hermes $version est accessible';
  }

  @override
  String get ng_sign_in_is_tested_next_then =>
      'La connexion est testée ensuite, puis le chat';

  @override
  String get ng_agent_gateway => 'Passerelle d’agent';

  @override
  String get ng_running => 'En cours';

  @override
  String get ng_stopped => 'Arrêté';

  @override
  String get ng_username_password => 'Nom d’utilisateur et mot de passe';

  @override
  String get ng_browser => 'Navigateur';

  @override
  String get ng_in_the_browser_sso => 'Dans le navigateur (SSO)';

  @override
  String get ng_profiles => 'Profils';

  @override
  String get ng_this_dashboard_offers_neither_a_username =>
      'Ce tableau de bord ne propose ni connexion par nom d’utilisateur et mot de passe, ni connexion dans le navigateur. Mettez Hermes à jour ou configurez le fournisseur de nom d’utilisateur et mot de passe sur le serveur.';

  @override
  String get ng_the_auth_gate_is_off_on =>
      'Le contrôle d’accès est désactivé sur ce tableau de bord. Toute personne qui peut y accéder peut utiliser votre agent.';

  @override
  String get ng_couldn_t_reach_the_dashboard =>
      'Impossible de joindre le tableau de bord';

  @override
  String ng_check_the_address_and_port_9119(Object reason) {
    return '$reason\n\nVérifiez l’adresse et le port (9119 par défaut). Si le tableau de bord n’est pas encore lancé, exécutez cette commande sur le serveur :\nhermes dashboard --host 0.0.0.0';
  }

  @override
  String get ng_that_isn_t_a_hermes_dashboard =>
      'Ce n’est pas un tableau de bord Hermes';

  @override
  String get ng_something_answered_but_not_a_hermes_2 =>
      'Une réponse a été reçue, mais ce n’est pas un tableau de bord Hermes. Utilisez l’adresse du tableau de bord, pas celle du serveur API (port 8642).';

  @override
  String ng_something_answered_http_but_not_a_2(Object status) {
    return 'Une réponse a été reçue (HTTP $status), mais ce n’est pas un tableau de bord Hermes. Utilisez l’adresse du tableau de bord, pas celle du serveur API (port 8642).';
  }

  @override
  String get ng_cloudflare_access_stopped_the_request =>
      'Cloudflare Access a bloqué la requête';

  @override
  String ng_cloudflare_access_turned_down_the_service(Object status) {
    return 'Cloudflare Access a refusé le jeton de service (HTTP $status). Vérifiez le Client ID, le Secret et la règle Service Auth.';
  }

  @override
  String get ng_add_a_cloudflare_access_service_token_2 =>
      'Ajoutez un jeton de service Cloudflare Access ci-dessous, puis réessayez.';

  @override
  String get ng_a_client_certificate_is_needed =>
      'Un certificat client est requis';

  @override
  String get ng_this_server_asks_for_a_client =>
      'Ce serveur demande un certificat client avant toute communication. Sélectionnez ci-dessous celui qu’il vous a fourni, puis réessayez.';

  @override
  String get ng_this_dashboard_doesn_t_ask_for =>
      'Ce tableau de bord ne demande pas de connexion.';

  @override
  String ng_use_the_dashboard_username_and_password(Object address) {
    return 'Utilisez le nom d’utilisateur et le mot de passe configurés pour le tableau de bord sur $address, ou connectez-vous dans votre navigateur.';
  }

  @override
  String ng_use_the_dashboard_username_and_password_2(Object address) {
    return 'Utilisez le nom d’utilisateur et le mot de passe configurés pour le tableau de bord sur $address.';
  }

  @override
  String ng_sign_in_to_in_your_browser(Object address) {
    return 'Connectez-vous à $address dans votre navigateur avec le compte utilisé par son tableau de bord.';
  }

  @override
  String ng_gateway(Object address) {
    return 'Passerelle $address';
  }

  @override
  String get ng_profile => 'Profil';

  @override
  String get ng_server_default => 'Valeur par défaut du serveur';

  @override
  String get ng_continue => 'Continuer';

  @override
  String get ng_username => 'Nom d’utilisateur';

  @override
  String get ng_signing_in => 'Connexion…';

  @override
  String get ng_waiting_for_the_browser => 'En attente du navigateur…';

  @override
  String get ng_sign_in_with_browser => 'Se connecter avec le navigateur';

  @override
  String get ng_finish_signing_in_on_the_page =>
      'Terminez la connexion sur la page qui s’est ouverte. Hermes reviendra automatiquement une fois terminé.';

  @override
  String get ng_use_a_different_gateway => 'Utiliser une autre passerelle';

  @override
  String get ng_same_wi_fi_or_local_network => 'Même Wi-Fi ou réseau local';

  @override
  String get ng_use_the_server_s_local_address =>
      'Utilisez l’adresse locale et le port du serveur, par exemple 192.168.1.20:9119. Lancez le tableau de bord avec --host 0.0.0.0 pour que d’autres appareils puissent y accéder.';

  @override
  String get ng_tailscale => 'Tailscale';

  @override
  String get ng_turn_on_tailscale_on_this_phone =>
      'Activez Tailscale sur ce téléphone et utilisez l’adresse Tailscale du serveur, par exemple 100.64.0.1:9119 ou son nom .ts.net. Fonctionne aussi en dehors de chez vous.';

  @override
  String get ng_use_your_https_address_when_the =>
      'Utilisez votre adresse https:// si le tableau de bord se trouve derrière un proxy avec un certificat. Le proxy doit aussi transmettre les mises à niveau WebSocket sur /api/ws.';

  @override
  String get ng_start_the_dashboard_on_the_server =>
      'Lancez le tableau de bord sur le serveur :';

  @override
  String get ng_enter_a_port_from_1_to =>
      'Saisissez un port compris entre 1 et 65535.';

  @override
  String get ng_looks_for_hermes_dashboards_on_port =>
      'Recherche les tableaux de bord Hermes sur le port 9119 de ce réseau Wi-Fi et vérifie les ordinateurs déjà enregistrés.';

  @override
  String ng_looks_for_hermes_dashboards_on_ports(Object port) {
    return 'Recherche les tableaux de bord Hermes sur les ports 9119 et $port de ce réseau Wi-Fi et vérifie les ordinateurs déjà enregistrés.';
  }

  @override
  String get ng_other_port_optional => 'Autre port (facultatif)';

  @override
  String get ng_no_dashboards_answered_start_one_with =>
      'Aucun tableau de bord n’a répondu. Lancez-en un avec hermes dashboard --host 0.0.0.0, ou saisissez son adresse.';

  @override
  String get ng_using_tailscale_or_a_vpn_those =>
      'Vous utilisez Tailscale ou un VPN ? Ces réseaux ne peuvent pas être explorés. Saisissez plutôt l’adresse 100.x de l’ordinateur ou son nom .ts.net.';

  @override
  String get ng_search_again => 'Rechercher à nouveau';

  @override
  String get ng_insights => 'Statistiques';

  @override
  String get ng_couldn_t_load_insights =>
      'Impossible de charger les statistiques';

  @override
  String get ng_sessions => 'Sessions';

  @override
  String get ng_tokens => 'Tokens';

  @override
  String get ng_est_cost => 'Coût estimé';

  @override
  String get ng_daily_tokens => 'Tokens quotidiens';

  @override
  String get ng_models => 'Modèles';

  @override
  String get ng_tools => 'Outils';

  @override
  String get ng_hermes_is_waiting_for_you => 'Hermes vous attend.';

  @override
  String get ng_hermes_replied => 'Hermes a répondu';

  @override
  String get ng_the_turn_finished => 'Le tour est terminé.';

  @override
  String get ng_off => 'Désactivé';

  @override
  String get ng_minimal => 'Minimal';

  @override
  String get ng_low => 'Faible';

  @override
  String get ng_medium => 'Moyen';

  @override
  String get ng_high => 'Élevé';

  @override
  String get ng_extra_high => 'Très élevé';

  @override
  String get ng_max => 'Max';

  @override
  String get ng_ultra => 'Ultra';

  @override
  String get ng_default => 'Par défaut';

  @override
  String ng_couldn_t_switch_model(Object error) {
    return 'Impossible de changer de modèle : $error';
  }

  @override
  String get ng_model => 'Modèle';

  @override
  String get ng_thinking_2 => 'Réflexion';

  @override
  String get ng_search_models => 'Rechercher des modèles';

  @override
  String get ng_no_models_match => 'Aucun modèle ne correspond à ces filtres.';

  @override
  String get privacy_policy => 'Politique de confidentialité';

  @override
  String get report_ai_output => 'Signaler une réponse IA';

  @override
  String ng_couldn_t_load_models(Object error) {
    return 'Impossible de charger les modèles : $error';
  }

  @override
  String get ng_no_providers_are_set_up_on =>
      'Aucun fournisseur n’est encore configuré sur cette passerelle.';

  @override
  String get ng_starred => 'Favoris';

  @override
  String get ng_recent => 'Récents';

  @override
  String get ng_more => 'Plus';

  @override
  String get ng_archived_chats => 'Conversations archivées';

  @override
  String get ng_projects => 'Projets';

  @override
  String get ng_chats_grouped_by_project_and_workspace =>
      'Conversations regroupées par projet et espace de travail';

  @override
  String get ng_agent => 'Agent';

  @override
  String get ng_memory => 'Mémoire';

  @override
  String get ng_what_hermes_remembers_about_you =>
      'Ce que Hermes retient de vous';

  @override
  String get ng_skills_library => 'Bibliothèque de compétences';

  @override
  String get ng_browse_and_read_installed_skills =>
      'Parcourir et lire les compétences installées';

  @override
  String get ng_cron_editor => 'Éditeur cron';

  @override
  String get ng_edit_schedules_prompts_and_delivery =>
      'Modifier les planifications, les instructions et les envois';

  @override
  String get ng_config_file => 'Fichier de configuration';

  @override
  String get ng_edit_config_yaml_on_the_gateway =>
      'Modifier config.yaml sur la passerelle';

  @override
  String get ng_models_and_providers => 'Modèles et fournisseurs';

  @override
  String get ng_model_management => 'Gestion des modèles';

  @override
  String get ng_default_fallback_and_auxiliary_models =>
      'Modèles par défaut, de secours et auxiliaires';

  @override
  String get ng_provider_sign_in => 'Connexion aux fournisseurs';

  @override
  String get ng_connect_provider_accounts_with_oauth =>
      'Connecter des comptes fournisseurs avec OAuth';

  @override
  String get ng_nous_portal => 'Nous Portal';

  @override
  String get ng_subscription_credits_and_usage =>
      'Abonnement, crédits et utilisation';

  @override
  String get ng_interface => 'Interface';

  @override
  String get ng_switch_to_the_classic_interface =>
      'Passer à l’interface classique';

  @override
  String get ng_turns_nextgen_off_you_can_turn =>
      'Désactive NextGen. Vous pourrez le réactiver dans les paramètres.';

  @override
  String get ng_restored => 'Restauré';

  @override
  String get ng_archived => 'Archivé';

  @override
  String get ng_couldn_t_load_archived_chats =>
      'Impossible de charger les conversations archivées';

  @override
  String get ng_nothing_archived => 'Aucune conversation archivée';

  @override
  String get ng_restore => 'Restaurer';

  @override
  String get ng_saved_new_chats_use_it =>
      'Enregistré. Les nouvelles conversations l’utiliseront.';

  @override
  String ng_couldn_t_save(Object error) {
    return 'Impossible d’enregistrer : $error';
  }

  @override
  String get ng_saving => 'Enregistrement…';

  @override
  String ng_today(Object time) {
    return 'Aujourd’hui $time';
  }

  @override
  String get ng_mon => 'lun.';

  @override
  String get ng_tue => 'mar.';

  @override
  String get ng_wed => 'mer.';

  @override
  String get ng_thu => 'jeu.';

  @override
  String get ng_fri => 'ven.';

  @override
  String get ng_sat => 'sam.';

  @override
  String get ng_sun => 'dim.';

  @override
  String get ng_scheduled => 'Planifié';

  @override
  String get ng_new_job => 'Nouvelle tâche';

  @override
  String get ng_couldn_t_load_scheduled_jobs =>
      'Impossible de charger les tâches planifiées';

  @override
  String get ng_nothing_scheduled => 'Aucune tâche planifiée';

  @override
  String get ng_ask_hermes_to_do_something_on =>
      'Demandez à Hermes d’effectuer une tâche selon un calendrier, ou ajoutez-en une ici.';

  @override
  String get ng_active => 'Actif';

  @override
  String get ng_paused => 'En pause';

  @override
  String ng_next(Object when) {
    return 'Prochaine occurrence : $when';
  }

  @override
  String ng_last(Object when) {
    return 'Dernière occurrence : $when';
  }

  @override
  String ng_last_2(Object when, Object result) {
    return 'Dernière occurrence : $when · $result';
  }

  @override
  String ng_job(Object id) {
    return 'Tâche $id';
  }

  @override
  String get ng_delete => 'Supprimer';

  @override
  String get ng_delete_this_job => 'Supprimer cette tâche ?';

  @override
  String get ng_it_stops_running_past_runs_stay =>
      'Elle cessera de s’exécuter. Les exécutions passées resteront dans vos conversations.';

  @override
  String ng_next_run(Object when) {
    return 'Prochaine exécution : $when';
  }

  @override
  String ng_delivers_to(Object target) {
    return 'Envoi à $target';
  }

  @override
  String get ng_run_now => 'Exécuter maintenant';

  @override
  String get ng_started => 'Démarré';

  @override
  String get ng_pause => 'Mettre en pause';

  @override
  String get ng_resume => 'Reprendre';

  @override
  String get ng_resumed => 'Repris';

  @override
  String get ng_prompt => 'Instruction';

  @override
  String get ng_runs => 'Exécutions';

  @override
  String get ng_no_runs_yet => 'Aucune exécution pour le moment.';

  @override
  String get ng_enter_a_schedule_and_a_prompt =>
      'Saisissez une planification et une instruction.';

  @override
  String get ng_name_optional => 'Nom (facultatif)';

  @override
  String get ng_schedule => 'Planification';

  @override
  String get ng_every_1h_0_9_or_30m => 'every 1h, 0 9 * * *, or 30m';

  @override
  String get ng_create => 'Créer';

  @override
  String get ng_unpin => 'Désépingler';

  @override
  String get ng_pin => 'Épingler';

  @override
  String get ng_rename => 'Renommer';

  @override
  String get ng_archive => 'Archiver';

  @override
  String get ng_delete_this_chat => 'Supprimer cette discussion ?';

  @override
  String get ng_it_is_removed_from_the_gateway =>
      'Elle sera supprimée de la passerelle sur tous les appareils.';

  @override
  String get ng_search_chats => 'Rechercher des discussions';

  @override
  String get ng_pinned => 'Épinglées';

  @override
  String get ng_no_chats_match => 'Aucune discussion correspondante.';

  @override
  String get ng_no_chats_yet => 'Aucune discussion pour le moment.';

  @override
  String get ng_nothing_is_running => 'Aucune tâche en cours.';

  @override
  String get ng_nothing_is_waiting_on_you =>
      'Aucune action n’est requise de votre part.';

  @override
  String get ng_settings => 'Paramètres';

  @override
  String get ng_all => 'Tout';

  @override
  String ng_needs_you(Object count) {
    return 'À traiter · $count';
  }

  @override
  String get ng_needs_you_2 => 'À traiter';

  @override
  String get ng_gateways => 'Passerelles';

  @override
  String ng_classic_connection(Object address) {
    return '$address · connexion classique';
  }

  @override
  String get ng_gateway_2 => 'Passerelle';

  @override
  String get ng_signed_in => 'Session ouverte';

  @override
  String get ng_classic_connection_2 => 'Connexion classique';

  @override
  String get ng_in_the_browser => 'Dans le navigateur';

  @override
  String ng_in_the_browser_as(Object name) {
    return 'Dans le navigateur en tant que $name';
  }

  @override
  String get ng_not_required => 'Non requis';

  @override
  String get ng_test_connection => 'Tester la connexion';

  @override
  String get ng_sign_in_again_2 => 'Se reconnecter';

  @override
  String get ng_sign_out => 'Se déconnecter';

  @override
  String get ng_saved_gateways => 'Passerelles enregistrées';

  @override
  String get ng_in_use => 'Utilisée';

  @override
  String get ng_appearance => 'Apparence';

  @override
  String get ng_theme => 'Thème';

  @override
  String get ng_system => 'Système';

  @override
  String get ng_light => 'Clair';

  @override
  String get ng_dark => 'Sombre';

  @override
  String get ng_accent => 'Couleur d’accentuation';

  @override
  String get ng_pure_black => 'Noir pur';

  @override
  String get ng_dark_theme_uses_true_black_oled =>
      'Le thème sombre utilise un vrai noir (OLED)';

  @override
  String get ng_glow => 'Halo';

  @override
  String get ng_soft_accent_light_behind_each_screen =>
      'Une douce lueur d’accentuation derrière chaque écran';

  @override
  String get ng_the_new_interface_turn_off_to =>
      'La nouvelle interface. Désactivez-la pour revenir à l’interface classique ; vos passerelles et vos discussions sont partagées.';

  @override
  String get ng_more_settings => 'Plus de paramètres';

  @override
  String get ng_voice_notifications_language_backups_and_the =>
      'Voix, notifications, langue, sauvegardes et configuration de la passerelle';

  @override
  String get ng_licences => 'Licences';

  @override
  String ng_sign_out_of(Object name) {
    return 'Se déconnecter de $name ?';
  }

  @override
  String get ng_this_gateway_and_its_saved_sign =>
      'Cette passerelle et ses informations de connexion enregistrées seront supprimées de ce téléphone, dans les deux interfaces. Vos discussions restent sur la passerelle.';

  @override
  String get ng_password_or_browser => 'Mot de passe ou navigateur';

  @override
  String get ng_unsupported => 'Non pris en charge';

  @override
  String get ng_background_task_finished => 'Tâche en arrière-plan terminée';

  @override
  String get ng_background_process_finished =>
      'Processus en arrière-plan terminé';

  @override
  String get ng_system_message => 'Message système';

  @override
  String get ng_summary => 'Résumé';

  @override
  String get classic_interface_only => 'Interface classique uniquement';

  @override
  String get classic_only_settings_hint =>
      'Les sections marquées « Interface classique uniquement » modifient uniquement l’apparence et les discussions de l’interface classique, pas celles de NextGen. NextGen dispose de ses propres options d’apparence dans ses paramètres.';

  @override
  String get attachment_preview_too_large =>
      'Aperçu trop volumineux. Enregistrez ou partagez le fichier pour le télécharger sur votre téléphone (jusqu’à 1 Go).';

  @override
  String get attachment_over_phone_limit =>
      'Ce fichier dépasse 1 Go et la limite de téléchargement. Ouvrez le tableau de bord pour le télécharger.';

  @override
  String attachment_downloading_percent(int percent) {
    return 'Téléchargement… $percent %';
  }

  @override
  String attachment_downloading_mb(int megabytes) {
    return 'Téléchargement… $megabytes Mo';
  }

  @override
  String ng_attachment_too_large_for_gateway(String name) {
    return '$name dépasse la limite de 12 Mo de cette passerelle. Mettez Hermes à jour pour envoyer des fichiers jusqu’à 100 Mo.';
  }

  @override
  String ng_couldn_t_upload(String name) {
    return 'Impossible d’importer $name.';
  }

  @override
  String ng_uploading_percent(int percent) {
    return 'Importation… $percent %';
  }

  @override
  String get ng_show_tasks => 'Afficher les tâches';

  @override
  String get ng_hide_tasks => 'Masquer les tâches';

  @override
  String get ng_goal => 'Objectif';

  @override
  String get ng_loop => 'Boucle';

  @override
  String get ng_heartbeat => 'Rappel périodique';

  @override
  String get ng_goal_working => 'En cours';

  @override
  String get ng_goal_waiting => 'En attente';

  @override
  String get ng_goal_blocked => 'Bloqué';

  @override
  String get ng_goal_done => 'Terminé';

  @override
  String ng_goal_turns_of(int used, int max) {
    return '$used tours sur $max';
  }

  @override
  String ng_goal_turn(int used) {
    return 'tour $used';
  }

  @override
  String get ng_loop_held => 'En pause pour l’objectif';

  @override
  String get ng_loop_finished => 'Terminée';

  @override
  String get ng_loop_running => 'En cours';

  @override
  String ng_loop_runs_of(int fired, int times) {
    return '$fired exécutions sur $times';
  }

  @override
  String ng_loop_runs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exécutions',
      one: '1 exécution',
    );
    return '$_temp0';
  }

  @override
  String ng_loop_next(String time) {
    return 'prochaine : $time';
  }

  @override
  String get ng_loop_due_now => 'prévue maintenant';

  @override
  String ng_every_seconds(int seconds) {
    return 'toutes les $seconds s';
  }

  @override
  String ng_every_minutes(int minutes) {
    return 'toutes les $minutes min';
  }

  @override
  String ng_every_hours(int hours) {
    return 'toutes les $hours h';
  }

  @override
  String ng_every_hours_minutes(int hours, int minutes) {
    return 'toutes les $hours h et $minutes min';
  }

  @override
  String ng_heartbeat_fired(int count) {
    return '$count déclenchements';
  }

  @override
  String ng_heartbeat_last_fired(String time) {
    return 'Dernier déclenchement à $time';
  }

  @override
  String ng_wait_until(String time) {
    return 'En attente jusqu’à $time';
  }

  @override
  String get ng_wait_resume => 'En attente de reprise';

  @override
  String get ng_wait_other_chat => 'En attente d’une autre conversation';

  @override
  String ng_wait_process(String pid) {
    return 'En attente du processus $pid';
  }

  @override
  String get ng_control_open => 'Ouvrir les objectifs et l’automatisation';

  @override
  String get ng_control_title => 'Objectif et automatisation';

  @override
  String get ng_control_subtitle =>
      'Ce que cette conversation cherche à accomplir et ce qui s’exécute automatiquement.';

  @override
  String get ng_contract_outcome => 'Résultat';

  @override
  String get ng_contract_verification => 'Vérification';

  @override
  String get ng_contract_constraints => 'Contraintes';

  @override
  String get ng_contract_boundaries => 'Limites';

  @override
  String get ng_contract_stop_when => 'Arrêter lorsque';

  @override
  String get ng_subgoals => 'Sous-objectifs';

  @override
  String get ng_subgoal_add_placeholder => 'Ajouter un sous-objectif';

  @override
  String get ng_add => 'Ajouter';

  @override
  String get ng_subgoal_remove => 'Supprimer le sous-objectif';

  @override
  String get ng_goal_checks => 'Vérifications';

  @override
  String get ng_gate_not_run => 'Pas encore exécuté';

  @override
  String ng_gate_attempts(int attempts, int tries) {
    return '$attempts tentatives sur $tries';
  }

  @override
  String ng_gate_exit(int code) {
    return 'code de sortie $code';
  }

  @override
  String get ng_resume_now => 'Reprendre maintenant';

  @override
  String get ng_goal_clear => 'Effacer l’objectif';

  @override
  String get ng_goal_clear_title => 'Effacer cet objectif ?';

  @override
  String get ng_goal_clear_message =>
      'L’agent cessera de travailler sur cet objectif. Ses sous-objectifs et ses vérifications seront également supprimés.';

  @override
  String get ng_subgoal_remove_title => 'Supprimer ce sous-objectif ?';

  @override
  String ng_subgoal_remove_message(String text) {
    return '« $text » ne fera plus partie de l’objectif.';
  }

  @override
  String get ng_subgoals_clear_title => 'Effacer tous les sous-objectifs ?';

  @override
  String get ng_subgoals_clear_message =>
      'L’objectif conservera son titre, mais tous ses sous-objectifs seront supprimés.';

  @override
  String get ng_clear_all => 'Tout effacer';

  @override
  String get ng_clear => 'Effacer';

  @override
  String get ng_dismiss => 'Fermer';

  @override
  String get ng_loop_stop_title => 'Arrêter cette boucle ?';

  @override
  String get ng_heartbeat_clear_title => 'Effacer ce rappel périodique ?';

  @override
  String get ng_wont_fire_again => 'Il ne se déclenchera plus.';

  @override
  String get ng_loop_self_paced => 'À son propre rythme';

  @override
  String ng_loop_until(String condition) {
    return 'Jusqu’à : $condition';
  }

  @override
  String get ng_loop_waits_for_goal =>
      'Attend pendant que l’objectif est en cours.';

  @override
  String get ng_loop_awaiting_reply => 'En attente de la réponse de l’agent.';

  @override
  String ng_loop_stopped_reason(String reason) {
    return 'Arrêtée : $reason';
  }

  @override
  String get ng_hide_subagents => 'Masquer les sous-agents';

  @override
  String get ng_show_subagents => 'Afficher les sous-agents';

  @override
  String get ng_subagent => 'Sous-agent';

  @override
  String get ng_subagent_queued => 'En file d’attente';

  @override
  String get ng_subagent_starting => 'Démarrage…';

  @override
  String get ng_subagent_running => 'En cours';

  @override
  String get ng_subagent_done => 'Terminé';

  @override
  String get ng_subagent_failed => 'Échec';

  @override
  String get ng_subagent_stopped => 'Arrêté';

  @override
  String get ng_subagent_stop => 'Arrêter le sous-agent';

  @override
  String ng_subagent_tools(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count outils',
      one: '1 outil',
    );
    return '$_temp0';
  }

  @override
  String get ng_mark_as_read => 'Marquer comme lu';

  @override
  String get ng_mark_as_unread => 'Marquer comme non lu';

  @override
  String ng_chats_unread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Conversations, $count non lues',
      one: 'Conversations, 1 non lue',
    );
    return '$_temp0';
  }

  @override
  String get ng_unread_finished => 'Terminé, réponse non lue';

  @override
  String get ng_unread_updates => 'En cours, mises à jour non lues';

  @override
  String get ng_notifications => 'Notifications';

  @override
  String get ng_notifications_hint =>
      'Réponses et demandes lorsque Ares est en arrière-plan';

  @override
  String get ng_notify_replies => 'Réponses';

  @override
  String get ng_notify_replies_hint =>
      'Lorsqu’un tour se termine ou échoue dans la conversation ouverte';

  @override
  String get ng_notify_requests => 'Autorisations et questions';

  @override
  String get ng_notify_requests_hint =>
      'Une notification lorsque l’agent attend votre réponse, avec les boutons « Autoriser une fois » et « Refuser »';

  @override
  String get ng_keep_running =>
      'Rester connecté pendant la génération d’une réponse';

  @override
  String get ng_keep_running_hint =>
      'Maintient la connexion en arrière-plan jusqu’à la fin de la réponse, avec une notification discrète';

  @override
  String get ng_battery_settings => 'Optimisation de la batterie';

  @override
  String get ng_battery_settings_hint =>
      'Autorisez Ares à fonctionner en arrière-plan pour recevoir les notifications à temps';

  @override
  String get ng_send_test_notification => 'Envoyer une notification de test';

  @override
  String get ng_test_notification_title =>
      'Les notifications Ares fonctionnent';

  @override
  String get ng_test_notification_body =>
      'Les réponses et les demandes s’afficheront ainsi.';

  @override
  String get ng_test_notification_sent => 'Notification de test envoyée';

  @override
  String get ng_notifications_blocked =>
      'Les notifications sont bloquées. Autorisez-les dans les paramètres Android.';

  @override
  String get ng_notifications_off_hint =>
      'Les notifications sont désactivées : rien ne s’affichera lorsque Ares sera en arrière-plan.';

  @override
  String get ng_insights_building =>
      'Création du rapport en cours. La première génération d’un rapport couvrant une longue période peut prendre jusqu’à une minute.';

  @override
  String get ng_insights_timed_out =>
      'La passerelle a mis trop de temps à générer ce rapport. Réessayez ou sélectionnez une période plus courte.';

  @override
  String get ng_dock_goal_active => 'Objectif en cours';

  @override
  String get ng_dock_goal_paused => 'Objectif en pause';

  @override
  String get ng_dock_goal_waiting => 'Objectif en attente';

  @override
  String get ng_dock_goal_blocked => 'Objectif bloqué';

  @override
  String get ng_dock_goal_done => 'Objectif terminé';

  @override
  String ng_dock_turn_of(int used, int max) {
    return 'Tour $used/$max';
  }

  @override
  String ng_dock_turn(int used) {
    return 'Tour $used';
  }

  @override
  String ng_dock_subagents(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sous-agents',
      one: '1 sous-agent',
    );
    return '$_temp0';
  }

  @override
  String ng_dock_subagents_done(int count) {
    return '$count terminés';
  }

  @override
  String ng_dock_tasks(int done, int total) {
    return 'Tâches $done/$total';
  }

  @override
  String ng_dock_previous_tasks(int done, int total) {
    return 'Tâches précédentes $done/$total';
  }

  @override
  String get ng_dock_manage => 'Gérer';

  @override
  String get ng_recent_notifications => 'Notifications récentes';

  @override
  String get ng_recent_notifications_hint =>
      'Ce qu’Ares a tenté de publier et si Android l’a affiché';

  @override
  String get ng_recent_notifications_empty =>
      'Rien pour l’instant. Les tentatives apparaîtront ici dès qu’une réponse, une question ou un échec devrait vous envoyer une notification.';

  @override
  String get ng_notify_permission_granted => 'Autorisation accordée';

  @override
  String get ng_notify_permission_denied => 'Autorisation refusée';

  @override
  String get ng_notify_master_on => 'Notifications activées';

  @override
  String get ng_notify_master_off => 'Notifications désactivées';

  @override
  String get ng_models_default => 'Modèle par défaut';

  @override
  String get ng_models_change => 'Modifier';

  @override
  String get ng_models_custom_endpoint =>
      'Utilise un point de terminaison personnalisé. Modifiez-le sur la passerelle.';

  @override
  String get ng_models_context_window => 'Fenêtre de contexte';

  @override
  String ng_models_token_count(String count) {
    return '$count tokens';
  }

  @override
  String ng_models_context_override(String count) {
    return 'Défini sur la passerelle. Détecté automatiquement : $count tokens.';
  }

  @override
  String get ng_models_max_output => 'Sortie maximale';

  @override
  String get ng_models_input_price => 'Prix en entrée';

  @override
  String get ng_models_output_price => 'Prix en sortie';

  @override
  String get ng_models_cache_price => 'Prix de l’entrée en cache';

  @override
  String ng_models_per_million(String price) {
    return '$price par million de tokens';
  }

  @override
  String ng_models_price_pair(String input, String output) {
    return '$input en entrée · $output en sortie par million de tokens';
  }

  @override
  String get ng_models_free => 'Gratuit';

  @override
  String get ng_models_vision => 'Vision';

  @override
  String get ng_models_reasoning => 'Raisonnement';

  @override
  String get ng_models_fast => 'Mode rapide';

  @override
  String get ng_models_in_use => 'Utilisé';

  @override
  String ng_models_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count modèles',
      one: '$count modèle',
    );
    return '$_temp0';
  }

  @override
  String get ng_models_rate_limited => 'Limite atteinte';

  @override
  String get ng_models_plan_locked => 'Non inclus dans votre forfait';

  @override
  String get ng_models_unsaved => 'Modifications non enregistrées';

  @override
  String get ng_models_discard => 'Abandonner';

  @override
  String get ng_models_aux_hint =>
      'Les tâches auxiliaires utilisent le modèle par défaut, sauf si vous leur en attribuez un.';

  @override
  String get ng_models_uses_default => 'Utilise le modèle par défaut';

  @override
  String get ng_models_thinking_level => 'Niveau de réflexion';

  @override
  String get ng_models_providers => 'Fournisseurs';

  @override
  String get ng_models_saved => 'Enregistré';

  @override
  String get ng_aux_vision => 'Vision';

  @override
  String get ng_aux_vision_hint => 'Lit les images et les captures d’écran';

  @override
  String get ng_aux_compression => 'Compression';

  @override
  String get ng_aux_compression_hint =>
      'Condense une longue conversation pour qu’elle tienne dans la fenêtre de contexte';

  @override
  String get ng_aux_approval => 'Approbation';

  @override
  String get ng_aux_approval_hint =>
      'Décide si une commande peut s’exécuter sans demander';

  @override
  String get ng_aux_mcp => 'MCP';

  @override
  String get ng_aux_mcp_hint => 'Choisit les outils MCP à utiliser';

  @override
  String get ng_aux_title_generation => 'Titres des conversations';

  @override
  String get ng_aux_title_generation_hint =>
      'Nomme les nouvelles conversations';

  @override
  String get ng_aux_review => 'Revue';

  @override
  String get ng_aux_review_hint =>
      'Passe le travail en revue quand vous lancez /review';

  @override
  String get ng_aux_voice_chat => 'Chat vocal';

  @override
  String get ng_aux_voice_chat_hint => 'Répond en mode vocal';

  @override
  String get ng_aux_triage_specifier => 'Tri';

  @override
  String get ng_aux_triage_specifier_hint =>
      'Transforme une carte Kanban d’une ligne en spécification';

  @override
  String get ng_aux_kanban_decomposer => 'Découpage Kanban';

  @override
  String get ng_aux_kanban_decomposer_hint =>
      'Divise une carte Kanban en tâches plus petites';

  @override
  String get ng_aux_profile_describer => 'Descriptions de profil';

  @override
  String get ng_aux_profile_describer_hint =>
      'Rédige la courte description de chaque profil';

  @override
  String get ng_aux_curator => 'Curateur';

  @override
  String get ng_aux_curator_hint => 'Examine l’utilisation des compétences';

  @override
  String get appearance_save_failed =>
      'Impossible d’enregistrer cette modification.';

  @override
  String get appearance_keep_which_theme => 'Quel thème conserver ?';

  @override
  String get appearance_tour_back => 'Retour';

  @override
  String get appearance_tour_finish => 'Terminer';

  @override
  String get appearance_tour_next => 'Suivant';

  @override
  String get appearance_tour_close => 'Fermer la visite';

  @override
  String get appearance_dismiss_tip => 'Masquer l’astuce';

  @override
  String get appearance_search_settings => 'Rechercher dans les paramètres';

  @override
  String get appearance_search_show => 'Afficher';

  @override
  String get appearance_no_matching_setting => 'Aucun paramètre correspondant.';

  @override
  String get appearance_replay_tour => 'Revoir la visite';

  @override
  String get appearance_show_tips_again => 'Réafficher les astuces';

  @override
  String get appearance_window_translucency_unavailable =>
      'La translucidité des fenêtres est indisponible sur cet hôte. Linux ne peut pas la fournir, et les runners Apple et Windows dessinent une vue Flutter opaque.';

  @override
  String get appearance_imported_themes => 'Thèmes importés';

  @override
  String get appearance_import_theme_file => 'Importer un fichier de thème';

  @override
  String get appearance_remove_theme => 'Retirer le thème';

  @override
  String get appearance_chat_font => 'Police de discussion';

  @override
  String get appearance_terminal_font => 'Police du terminal';

  @override
  String get appearance_font_platform => 'Plateforme';

  @override
  String get appearance_automatic => 'Automatique';

  @override
  String get appearance_force_left_to_right => 'Forcer de gauche à droite';

  @override
  String get appearance_force_right_to_left => 'Forcer de droite à gauche';

  @override
  String get appearance_user_bubble_opacity => 'Opacité des bulles utilisateur';

  @override
  String get appearance_inline_embeds => 'Contenus intégrés';

  @override
  String get appearance_inline_embeds_hint =>
      'Les aperçus enrichis se chargent depuis des sites tiers (YouTube, X, …). Demander affiche un espace réservé jusqu’à ce que vous autorisiez chacun ; Toujours les charge automatiquement ; Désactivé conserve des liens simples.';

  @override
  String get appearance_embeds_ask => 'Demander';

  @override
  String get appearance_embeds_always => 'Toujours';

  @override
  String get appearance_embeds_off => 'Désactivé';

  @override
  String appearance_embeds_reset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Réinitialiser $count services autorisés',
      one: 'Réinitialiser 1 service autorisé',
    );
    return '$_temp0';
  }

  @override
  String get appearance_embed_load => 'Charger';

  @override
  String appearance_embed_always_allow(String service) {
    return 'Toujours autoriser $service';
  }

  @override
  String get appearance_embed_loading => 'Chargement de l’aperçu…';

  @override
  String appearance_embed_image_failed(String host) {
    return 'Impossible de charger l’image depuis $host. Touchez pour l’ouvrir.';
  }

  @override
  String get appearance_embed_preview_unavailable => 'Aperçu indisponible';

  @override
  String get appearance_emoji_reactions => 'Réactions emoji';

  @override
  String get appearance_celebration_hearts => 'Cœurs de célébration';

  @override
  String get appearance_celebration_hearts_hint =>
      'Un cœur s’anime lorsqu’une réponse est arrivée pendant votre absence.';

  @override
  String get appearance_pop_out_companion => 'Détacher le compagnon';

  @override
  String get appearance_mosskip => 'Mosskip';

  @override
  String get appearance_emberbun => 'Emberbun';

  @override
  String get appearance_tideling => 'Tideling';

  @override
  String get appearance_my_hatchling => 'Mon petit compagnon';

  @override
  String get appearance_at_rest => 'Au repos';

  @override
  String get appearance_working => 'En cours';

  @override
  String get appearance_thinking => 'Réfléchit';

  @override
  String get appearance_waiting_for_you => 'Vous attend';

  @override
  String get appearance_reply_ready => 'Réponse prête';

  @override
  String get appearance_turn_failed => 'Échec du tour';

  @override
  String get appearance_small => 'Petit';

  @override
  String get appearance_medium => 'Moyen';

  @override
  String get appearance_large => 'Grand';

  @override
  String get appearance_hello => 'Bonjour !';

  @override
  String get appearance_unread_reply => 'Réponse non lue';

  @override
  String get appearance_compose => 'Rédiger';

  @override
  String get appearance_say_hello => 'Dire bonjour';

  @override
  String get appearance_pet_image_failed =>
      'Impossible d’ouvrir cette image. Choisissez un PNG ou un JPEG plus petit.';

  @override
  String get appearance_pet_companion => 'Compagnon virtuel';

  @override
  String get appearance_pet_companion_hint =>
      'Afficher un compagnon pendant la discussion.';

  @override
  String get appearance_adopt_a_companion => 'Adopter un compagnon';

  @override
  String get appearance_roam_when_idle => 'Se promener au repos';

  @override
  String get appearance_pet_size => 'Taille du compagnon';

  @override
  String get appearance_hatch_from_a_local_picture =>
      'Faire éclore à partir d’une image locale';

  @override
  String get appearance_pet_image_limits =>
      'Choisissez un PNG ou un JPEG (jusqu’à 4 MiB, 4096 px par côté et 8 MP). Prévisualisez-le d’abord. L’éclosion enregistre un portrait de 24 × 24 pixels et remplace votre précédent petit compagnon.';

  @override
  String get appearance_choose_picture => 'Choisir une image';

  @override
  String get appearance_hatchling_preview => 'Aperçu du petit compagnon';

  @override
  String get appearance_hatch_and_adopt => 'Faire éclore et adopter';

  @override
  String get appearance_discard_draft => 'Supprimer le brouillon';

  @override
  String get appearance_forget_saved_hatchling =>
      'Oublier le petit compagnon enregistré';

  @override
  String get appearance_radio => 'Radio';

  @override
  String appearance_radio_hint(String stations) {
    return 'Les flux proviennent directement de $stations et ne démarrent que lorsque vous appuyez sur Lecture. La recherche de stations reste sur cet appareil.';
  }

  @override
  String get appearance_radio_save_failed =>
      'Impossible d’enregistrer les paramètres de la radio.';

  @override
  String get appearance_choose_a_station => 'Choisir une station';

  @override
  String get appearance_pause_radio => 'Mettre la radio en pause';

  @override
  String get appearance_play_radio => 'Écouter la radio';

  @override
  String get appearance_next_station => 'Station suivante';

  @override
  String get appearance_radio_trace_semantics =>
      'Activité du flux. Les niveaux audio sont indisponibles ; cette ligne reste donc plate.';

  @override
  String get appearance_radio_is_off => 'La radio est désactivée';

  @override
  String get appearance_paused => 'En pause';

  @override
  String get appearance_connecting => 'Connexion…';

  @override
  String get appearance_live => 'En direct';

  @override
  String get appearance_stream_unavailable => 'Flux indisponible';

  @override
  String appearance_now_playing(String credit) {
    return 'En cours de lecture : $credit';
  }

  @override
  String get appearance_audio_only_waveform_unavailable =>
      'Audio seul · forme d’onde indisponible';

  @override
  String get appearance_volume => 'Volume';

  @override
  String get appearance_search_presets => 'Rechercher dans les préréglages';

  @override
  String get appearance_no_stations_found => 'Aucune station trouvée';

  @override
  String appearance_unpin_station(String station) {
    return 'Désépingler la station : $station';
  }

  @override
  String appearance_pin_station(String station) {
    return 'Épingler la station : $station';
  }

  @override
  String get appearance_radio_picker_metadata_notice =>
      'Tant que ce sélecteur est ouvert, les stations en lecture peuvent partager les détails des titres directement depuis le diffuseur.';

  @override
  String get appearance_message_from_your_companion =>
      'Message de votre compagnon';

  @override
  String get appearance_send_to_the_open_chat =>
      'Envoyer à la discussion ouverte';

  @override
  String get appearance_tour_theme_body =>
      'Importez un thème de couleur VS Code depuis un fichier de cet appareil, puis choisissez la variante à conserver.';

  @override
  String get appearance_tour_fonts_title => 'Polices de lecture';

  @override
  String get appearance_tour_fonts_body =>
      'Le texte des discussions et le code du terminal utilisent des polices distinctes fournies avec Ares.';

  @override
  String get appearance_tour_direction_title => 'Sens de la transcription';

  @override
  String get appearance_tour_direction_body =>
      'Laissez le réglage automatique ou imposez à la transcription un sens de gauche à droite ou de droite à gauche.';

  @override
  String get appearance_tour_pet_title => 'Compagnon';

  @override
  String get appearance_tour_pet_body =>
      'Le compagnon reste désactivé jusqu’à ce que vous en adoptiez un. Le mode détaché ajoute une petite zone de saisie.';

  @override
  String get appearance_tour_radio_body =>
      'La radio reste désactivée jusqu’à son activation. Appuyer sur Lecture ouvre un flux.';

  @override
  String get appearance_tip_theme =>
      'Les thèmes importés remplacent la palette intégrée jusqu’à ce que vous effaciez la sélection. Seules les couleurs sont conservées.';

  @override
  String get appearance_tip_pet =>
      'Le compagnon conserve un petit portrait sur cet appareil. L’image utilisée pour l’éclosion n’est pas téléversée.';

  @override
  String get appearance_theme_import_failed =>
      'Impossible d’importer ce thème. Choisissez un thème de couleur VS Code enregistré dans un fichier .vsix, .json ou .jsonc.';

  @override
  String get render_widget_file_truncated =>
      'Seul le début de ce fichier a été lu : le widget peut être incomplet.';

  @override
  String get setup_beat_title => 'Configuration';

  @override
  String setup_beat_use_name(String name) {
    return 'Utiliser $name';
  }

  @override
  String get setup_beat_name_hint => 'Comment Hermes doit-il vous appeler ?';

  @override
  String get setup_beat_on_computer =>
      'Cette étape se fait dans Hermes, sur l’ordinateur où il s’exécute. Continuer conserve ce qui y est déjà configuré.';

  @override
  String get setup_beat_not_waiting =>
      'Cette carte de configuration n’attend plus de réponse.';

  @override
  String get catalog_kind_plugin => 'Plugin';

  @override
  String get catalog_kind_skill => 'Compétence';

  @override
  String get catalog_tier_official => 'Officiel';

  @override
  String get catalog_tier_verified => 'Vérifié';

  @override
  String get catalog_tier_community => 'Communauté';

  @override
  String get catalog_install => 'Installer';

  @override
  String get catalog_waiting => 'En attente de votre choix';

  @override
  String get catalog_installed => 'Installé';

  @override
  String get catalog_installed_off => 'Installé, non activé';

  @override
  String get catalog_skipped => 'Ignoré';

  @override
  String get catalog_not_installed => 'Non installé';

  @override
  String catalog_target_profile(String profile) {
    return 'S’installe dans le profil $profile';
  }

  @override
  String catalog_source(String repo, String sha) {
    return '$repo à $sha';
  }

  @override
  String catalog_scan(String status, String summary) {
    return 'Analyse de sécurité : $status. $summary';
  }

  @override
  String catalog_requires_hermes(String range) {
    return 'Nécessite Hermes $range';
  }

  @override
  String catalog_skill_ready(String name) {
    return 'La compétence $name est prête';
  }

  @override
  String catalog_missing_env(String names) {
    return 'Il manque encore : $names';
  }

  @override
  String catalog_server_error(String name, String error) {
    return '$name ne s’est pas connecté : $error';
  }

  @override
  String get catalog_send_failed =>
      'Votre choix n’a pas été envoyé. Réessayez.';

  @override
  String get attachment_video_speed => 'Vitesse de lecture';

  @override
  String get catalog_installing => 'Installation…';

  @override
  String get catalog_phase_downloading => 'Téléchargement…';

  @override
  String get catalog_phase_python_packages =>
      'Installation des paquets Python…';

  @override
  String get catalog_phase_loading_tools => 'Chargement de ses outils…';

  @override
  String get setup_beat_send_failed =>
      'Votre réponse n’a pas été envoyée. Réessayez.';

  @override
  String catalog_tool_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count outils',
      one: '1 outil',
    );
    return '$_temp0';
  }

  @override
  String get render_svg_not_drawn => 'Ce SVG n’a pas été dessiné.';

  @override
  String get render_notes_directive => 'Directive de notes';

  @override
  String get render_maths_source => 'Source de la formule';

  @override
  String get render_inline_maths_source => 'Source de la formule en ligne';

  @override
  String get render_sequence_outline => 'Plan de la séquence';

  @override
  String get render_diagram_outline => 'Plan du diagramme';

  @override
  String render_revision_of(int index, int count) {
    return 'Révision $index sur $count';
  }

  @override
  String get render_previous_revision => 'Révision précédente';

  @override
  String get render_next_revision => 'Révision suivante';

  @override
  String get render_show_rendered => 'Rendu';

  @override
  String get render_show_source => 'Code source';

  @override
  String render_copied_file(String name) {
    return '$name copié';
  }

  @override
  String render_copy_file(String name) {
    return 'Copier $name';
  }

  @override
  String get render_artifact_too_long =>
      'Cet artefact est trop long pour être affiché ici sous forme de page.';

  @override
  String get render_active_content_removed =>
      'Les scripts, les cadres et les adresses externes ont été supprimés.';

  @override
  String render_widget_file(String file) {
    return 'Fichier widget $file';
  }

  @override
  String get render_widget_runs_as_text =>
      'S’exécute sous forme de texte dans cette discussion. Les scripts et les cadres externes sont supprimés.';

  @override
  String get render_load_widget => 'Charger le widget';

  @override
  String get render_not_html_widget => 'Ce fichier n’est pas un widget HTML.';

  @override
  String get render_widget_sent => 'Envoyé dans cette discussion';

  @override
  String get render_widget_not_sent => 'Non envoyé dans cette discussion';

  @override
  String get render_widget_throttled =>
      'Patientez un instant avant de renvoyer';

  @override
  String get render_widget_too_long =>
      'Cette demande est trop longue pour être envoyée';

  @override
  String get render_widget_no_gesture =>
      'Touchez une commande du widget pour envoyer';

  @override
  String get render_widget_invalid => 'Cette demande n’a pas pu être envoyée';

  @override
  String get render_inspected_image => 'Image inspectée';

  @override
  String get render_contributions => 'Contributions';

  @override
  String get render_contributions_intro =>
      'Seules les contributions intégrées à Ares peuvent compléter une réponse. Le texte de la discussion ne peut pas en enregistrer, et une autorisation ne s’applique qu’à cette connexion.';

  @override
  String render_grant_plugin(String name) {
    return 'Autoriser $name';
  }

  @override
  String render_revoke_plugin(String name) {
    return 'Révoquer $name';
  }

  @override
  String render_plugin_slots(String directive) {
    return 'cartes de réponse pour ::$directive';
  }

  @override
  String get render_plugin_notes => 'Notes';

  @override
  String get catalog_scan_passed => 'réussi';

  @override
  String get catalog_scan_warnings => 'avertissements trouvés';

  @override
  String get catalog_scan_failed => 'échoué';

  @override
  String get deployment_token_label => 'Jeton de déploiement (facultatif)';

  @override
  String get deployment_token_helper =>
      'Pour les jetons de session Hermes Dashboard envoyés comme X-Hermes-Session-Token. Non stocké en clair dans les préférences.';

  @override
  String get deployment_token_hint => 'Jeton de session du tableau de bord';

  @override
  String get custom_headers_label => 'En-têtes personnalisés (facultatif)';

  @override
  String get custom_headers_helper =>
      'Un par ligne, p. ex. X-Custom: valeur. Les en-têtes interdits sont refusés.';

  @override
  String get custom_headers_hint => 'p. ex. X-Custom-Header: valeur';

  @override
  String get desktop_tray_open => 'Ouvrir Ares';

  @override
  String get desktop_tray_new_chat => 'Nouvelle discussion';

  @override
  String get desktop_tray_quick_entry => 'Saisie rapide…';

  @override
  String get desktop_tray_pause_notifications => 'Suspendre les notifications';

  @override
  String get desktop_tray_quit => 'Quitter Ares';

  @override
  String get desktop_integration_title => 'Intégration au bureau';

  @override
  String get desktop_tray_setting =>
      'Afficher Ares dans la zone de notification ou la barre des menus';

  @override
  String get desktop_tray_setting_help =>
      'Depuis l’icône : ouvrir Ares, démarrer une discussion, ouvrir la saisie rapide, suspendre les notifications ou quitter.';

  @override
  String get desktop_close_to_tray_setting =>
      'Continuer dans la zone de notification à la fermeture de la fenêtre';

  @override
  String get desktop_tray_unsupported =>
      'Ce bureau n’a pas de zone de notification utilisable par Ares.';

  @override
  String get quick_entry_title => 'Saisie rapide';

  @override
  String get quick_entry_hint => 'Saisissez une requête pour Ares…';

  @override
  String get quick_entry_submit => 'Placer dans la zone de saisie';

  @override
  String get quick_entry_never_sends =>
      'Entrée place le texte dans la zone de saisie de la discussion. Rien n’est envoyé avant que vous appuyiez sur Envoyer.';

  @override
  String get quick_entry_unavailable =>
      'Impossible d’ouvrir la saisie rapide. Réessayez.';

  @override
  String get desktop_hotkey_setting => 'Raccourci de saisie rapide';

  @override
  String desktop_hotkey_help(String shortcut) {
    return 'Appuyez sur $shortcut n’importe où pour ouvrir la saisie rapide.';
  }

  @override
  String desktop_hotkey_conflict(String shortcut) {
    return 'Une autre app utilise déjà $shortcut. Choisissez un autre raccourci.';
  }

  @override
  String get desktop_hotkey_unsupported =>
      'Ce bureau ne permet pas aux apps d’enregistrer un raccourci global (par exemple sous Wayland).';

  @override
  String get desktop_hotkey_no_modifier => 'Incluez Cmd, Ctrl ou Alt.';

  @override
  String get desktop_hotkey_super_key =>
      'La touche Windows ou Super est réservée au système.';

  @override
  String get desktop_hotkey_reserved => 'Le système utilise déjà ce raccourci.';

  @override
  String desktop_hotkey_in_app(String action) {
    return 'Ares utilise déjà ce raccourci pour $action.';
  }

  @override
  String get desktop_hotkey_change => 'Modifier';

  @override
  String get desktop_hotkey_reset => 'Utiliser la valeur par défaut';

  @override
  String get capture_screen_action => 'Capturer l’écran';

  @override
  String get capture_screen_help =>
      'Ajoute une capture au message en brouillon. Rien n’est envoyé avant que vous appuyiez sur Envoyer.';

  @override
  String get capture_screen_unavailable =>
      'La capture d’écran n’est pas disponible sur ce bureau.';

  @override
  String get capture_screen_failed =>
      'Impossible de capturer l’écran. Réessayez.';

  @override
  String get capture_permission_title =>
      'Autoriser l’enregistrement de l’écran';

  @override
  String get capture_permission_body =>
      'Pour capturer une fenêtre, Ares a besoin de l’autorisation d’enregistrement de l’écran. Activez Ares dans Réglages Système > Confidentialité et sécurité > Enregistrement de l’écran, puis réessayez.';

  @override
  String get capture_open_settings => 'Ouvrir Réglages Système';

  @override
  String get keep_awake_title => 'Garder l’ordinateur éveillé';

  @override
  String get keep_awake_title_mobile => 'Garder l’écran allumé';

  @override
  String get keep_awake_mode_off => 'Désactivé';

  @override
  String get keep_awake_mode_while_working => 'Pendant le travail';

  @override
  String get keep_awake_mode_always => 'Toujours';

  @override
  String get keep_awake_off_help =>
      'Ne jamais empêcher la mise en veille (par défaut).';

  @override
  String get keep_awake_while_working_help =>
      'Empêcher la mise en veille d’inactivité uniquement pendant un tour de l’agent.';

  @override
  String get keep_awake_always_help =>
      'Empêcher la mise en veille d’inactivité tant qu’Ares est ouvert sur cet appareil.';

  @override
  String get keep_awake_off_help_mobile =>
      'Laisser l’écran s’éteindre normalement (par défaut).';

  @override
  String get keep_awake_while_working_help_mobile =>
      'Garder l’écran allumé pendant un tour de l’agent, tant qu’Ares est ouvert.';

  @override
  String get keep_awake_always_help_mobile =>
      'Garder l’écran allumé tant qu’Ares est ouvert.';

  @override
  String get ng_token_gateway_has_no_sign_in =>
      'Cette passerelle n’a pas de connexion, elle ne peut donc pas vérifier un jeton de déploiement. Activez l’authentification du tableau de bord sur l’hôte (ou mettez Hermes à jour), puis réessayez.';

  @override
  String get palette_open => 'Palette de commandes de l’app';

  @override
  String get palette_no_matches => 'Aucune action correspondante';

  @override
  String get palette_filter_hint => 'Tapez pour filtrer les actions…';

  @override
  String get palette_keys_move => '↑↓ pour se déplacer';

  @override
  String get palette_keys_run => 'Entrée pour exécuter';

  @override
  String get palette_keys_close => 'Échap pour fermer';

  @override
  String get palette_search_sessions => 'Rechercher des sessions';

  @override
  String get palette_scheduled_crons => 'Planifiées / Crons';

  @override
  String get palette_capabilities_skills => 'Capacités et compétences';

  @override
  String get palette_insights_usage => 'Aperçus et utilisation';

  @override
  String get palette_more_projects => 'Plus et projets';

  @override
  String get deeplink_chat_not_found =>
      'Discussion introuvable dans la liste. Elle n’est peut-être pas encore chargée.';

  @override
  String get keyboard_shortcuts_title => 'Raccourcis clavier';

  @override
  String get shortcuts_reset_all => 'Tout réinitialiser';

  @override
  String get shortcuts_reset_to_default => 'Rétablir la valeur par défaut';

  @override
  String get shortcut_action_command_palette => 'Palette de commandes';

  @override
  String get shortcut_action_new_chat => 'Nouvelle discussion';

  @override
  String get shortcut_action_search => 'Rechercher';

  @override
  String get shortcut_action_settings => 'Paramètres';

  @override
  String shortcut_action_go_to_tab(int number) {
    return 'Aller à l’onglet $number';
  }

  @override
  String shortcuts_conflict(String first, String second, String chord) {
    return 'Conflit : « $first » et « $second » utilisent tous deux $chord. Le raccourci personnalisé garde sa valeur par défaut jusqu’à ce que vous en changiez un.';
  }

  @override
  String shortcuts_editor_title(String action) {
    return 'Raccourci : $action';
  }

  @override
  String get shortcuts_editor_help =>
      'Appuyez sur une combinaison de touches, ou choisissez des modificateurs et une touche ci-dessous :';

  @override
  String get shortcuts_editor_needs_modifier =>
      'Choisissez au moins Cmd/Meta, Ctrl ou Alt pour que la saisie dans le champ de message ne soit pas affectée.';

  @override
  String shortcuts_text_editing_warning(String chord) {
    return '$chord est un raccourci d’édition de texte (copier, coller, couper, annuler, rétablir ou tout sélectionner). L’attribuer ici le retire aux champs de texte.';
  }

  @override
  String shortcuts_text_editing_in_use(String action, String chord) {
    return '« $action » utilise $chord, un raccourci d’édition de texte. Les champs de texte le perdent tant qu’il est attribué ici.';
  }

  @override
  String custom_headers_problem_format(int line) {
    return 'Ligne $line : « Nom: Valeur » attendu';
  }

  @override
  String custom_headers_problem_missing_name(int line) {
    return 'Ligne $line : nom d’en-tête manquant';
  }

  @override
  String custom_headers_problem_invalid_name(int line, String name) {
    return 'Ligne $line : nom d’en-tête « $name » non valide';
  }

  @override
  String custom_headers_problem_reserved(int line, String name) {
    return 'Ligne $line : « $name » est réservé et ne peut pas être transmis';
  }

  @override
  String custom_headers_problem_empty_value(int line) {
    return 'Ligne $line : valeur d’en-tête vide';
  }

  @override
  String get ng_enter_a_deployment_token =>
      'Saisissez un jeton de session de déploiement.';

  @override
  String get ng_custom_headers => 'En-têtes personnalisés';

  @override
  String get ng_custom_headers_help =>
      'En-têtes HTTP supplémentaires pour cette passerelle (Nom: Valeur, un par ligne), envoyés avec ses appels REST et WebSocket. Ils sont conservés dans le stockage sécurisé des identifiants. Les en-têtes d’authentification et hop-by-hop sont refusés.';

  @override
  String get ng_use_a_deployment_token =>
      'Utiliser un jeton de session de déploiement';

  @override
  String get ng_sign_in_with_deployment_token =>
      'Se connecter avec le jeton de déploiement';

  @override
  String get ng_signed_in_with_deployment_token =>
      'Connecté avec le jeton de déploiement.';

  @override
  String get auto_speak_replies_title => 'Lire les réponses à voix haute';

  @override
  String get auto_speak_replies_subtitle =>
      'Lit chaque nouvelle réponse à voix haute à la fin d’un tour. Par défaut désactivé ; le contrôle « Spoken replies » reste valable.';

  @override
  String get ng_auto_read_replies_title => 'Lecture automatique des réponses';

  @override
  String get ng_auto_read_replies_subtitle =>
      'Lit chaque nouvelle réponse à voix haute à la fin d’un tour. Par défaut désactivé.';

  @override
  String get barge_in_title => 'Couper la lecture';

  @override
  String get barge_in_subtitle =>
      'Parlez par-dessus une réponse pour l’interrompre. Le micro reste allumé pendant la lecture des réponses à voix haute.';

  @override
  String get barge_in_mic_live =>
      'Micro allumé : parlez pour interrompre la réponse';

  @override
  String get ng_barge_in_title => 'Couper la lecture';

  @override
  String get ng_barge_in_subtitle =>
      'Parlez par-dessus une réponse pour l’interrompre. Le micro reste allumé pendant la lecture des réponses à voix haute.';

  @override
  String get ng_barge_in_mic_live =>
      'Micro allumé : parlez pour interrompre la réponse';

  @override
  String get wake_word_title => 'Mot d’activation';

  @override
  String get wake_word_subtitle =>
      'Détection mains libres sur la passerelle. Désactivée par défaut ; ne diffuse le micro que lorsque la capture client est active.';

  @override
  String wake_word_listening(String phrase) {
    return 'Écoute du mot d’activation « $phrase »';
  }

  @override
  String wake_word_paused(String phrase) {
    return 'Mot d’activation « $phrase » — en pause';
  }

  @override
  String wake_word_off(String phrase) {
    return 'Mot d’activation « $phrase » — désactivé';
  }

  @override
  String get wake_word_arming => 'Activation du mot d’activation…';

  @override
  String get wake_word_stop => 'Arrêter le mot d’activation';

  @override
  String get wake_word_rearm => 'Réarmer';

  @override
  String get wake_word_capture_mode => 'Mode de capture';

  @override
  String get wake_word_capture_auto => 'Automatique';

  @override
  String get wake_word_capture_client => 'Microphone de cet appareil';

  @override
  String get wake_word_capture_local => 'Microphone de l’hôte passerelle';

  @override
  String get wake_word_capture_unavailable =>
      'Cette passerelle ne permet pas aux applications de changer le mode de capture. Définissez wake_word.capture dans la configuration Hermes de l’hôte passerelle.';

  @override
  String get wake_word_input_device => 'Microphone d’entrée';

  @override
  String get wake_word_default_device => 'Par défaut du système';

  @override
  String get ng_wake_word_title => 'Mot d’activation';

  @override
  String get ng_wake_word_subtitle =>
      'Détection mains libres sur la passerelle. Désactivée par défaut.';

  @override
  String get voice_engine_title => 'Moteur de conversation vocale';

  @override
  String get voice_engine_subtitle =>
      'Choisissez comment les conversations vocales mains libres fonctionnent sur ce profil de passerelle.';

  @override
  String get voice_engine_chained =>
      'Enchaîné (parole en texte → Hermes → parole)';

  @override
  String get voice_engine_chained_short => 'Enchaîné';

  @override
  String get voice_engine_live => 'GPT-Live (voix en temps réel)';

  @override
  String get voice_engine_live_short => 'GPT-Live';

  @override
  String get voice_engine_live_needs_key =>
      'Configurez une clé d’API OpenAI sur l’hôte de la passerelle pour activer GPT-Live.';

  @override
  String voice_engine_fallback_chained(String reason) {
    return 'GPT-Live indisponible ($reason) — voix enchaînée utilisée.';
  }

  @override
  String get voice_live_start => 'Démarrer une conversation vocale';

  @override
  String get voice_live_stop => 'Terminer la conversation vocale';

  @override
  String get voice_live_mute => 'Couper le micro';

  @override
  String get voice_live_unmute => 'Réactiver le micro';

  @override
  String get voice_live_interrupt => 'Interrompre ou répondre maintenant';

  @override
  String get voice_live_listening => 'À l’écoute';

  @override
  String get voice_live_speaking => 'Parle';

  @override
  String get voice_live_thinking => 'Réfléchit';

  @override
  String get voice_live_muted => 'Micro coupé';

  @override
  String get voice_live_ended_connection_lost =>
      'La session vocale en direct a perdu la connexion.';

  @override
  String get voice_live_ended_closed =>
      'La session vocale en direct a été fermée par le service.';

  @override
  String wake_word_other_profile(String profile) {
    return 'Ce mot d’activation appartient au profil « $profile ». Ouvrez une connexion à ce profil pour y répondre.';
  }

  @override
  String get wake_word_reason_disabled => 'Désactivé — touchez pour activer';

  @override
  String get wake_word_reason_surface =>
      'Limité à une autre interface (configuration wake_word.surface)';

  @override
  String get wake_word_reason_owned =>
      'Une autre interface gère l’écoute du mot d’activation';

  @override
  String wake_word_reason_owned_by(String surface) {
    return 'Une autre interface ($surface) gère l’écoute du mot d’activation';
  }

  @override
  String get wake_word_reason_unavailable =>
      'Mot d’activation indisponible sur cette passerelle';

  @override
  String get wake_word_reason_permission_denied =>
      'Autorisation du micro refusée';

  @override
  String get wake_word_reason_permission_required =>
      'Autorisation du micro requise — touchez pour activer';

  @override
  String get voice_live_not_enabled =>
      'GPT-Live n’est pas activé pour ce profil.';

  @override
  String get voice_live_not_available => 'GPT-Live n’est pas disponible';

  @override
  String voice_live_start_failed(String error) {
    return 'Impossible de démarrer GPT-Live : $error';
  }

  @override
  String voice_direct_stt_timeout(String seconds, String provider) {
    return 'La transcription a expiré après $seconds s ($provider n’a pas répondu)';
  }

  @override
  String voice_direct_stt_error(String provider, String status) {
    return 'Erreur STT de $provider (HTTP $status)';
  }

  @override
  String voice_direct_tts_failed(String provider) {
    return 'La requête TTS à $provider a échoué';
  }

  @override
  String voice_direct_tts_error(String provider, String status) {
    return 'Erreur TTS de $provider (HTTP $status)';
  }

  @override
  String ng_wake_status_listening(String phrase) {
    return 'À l’écoute (« $phrase »)';
  }

  @override
  String ng_wake_status_off(String phrase) {
    return 'Désactivé (« $phrase »)';
  }

  @override
  String ng_wire_setting_unavailable(Object setting) {
    return 'La modification de $setting n’est pas encore disponible sur la passerelle partagée';
  }

  @override
  String ng_wire_method_unavailable(Object method) {
    return '$method n’est pas encore disponible sur la passerelle partagée';
  }

  @override
  String ng_wire_session_options_unsupported(Object options) {
    return 'La passerelle canonique ne prend pas en charge ces options de session explicites : $options';
  }

  @override
  String get ng_wire_prompt_stale =>
      'La demande est obsolète ou indisponible ; reconnectez-vous avant de répondre';

  @override
  String get ng_wire_revision_unavailable =>
      'La révision de la session est indisponible ; rouvrez la session avant de modifier les métadonnées';

  @override
  String get ng_wire_generation_unavailable =>
      'L’identité d’exécution de la session est indisponible ; reconnectez-vous avant cette commande';

  @override
  String get ng_wire_message_not_saved =>
      'Ce message n’est pas encore enregistré ; attendez qu’il soit finalisé, puis créez de nouveau une branche à partir de lui';

  @override
  String get ng_wire_not_available =>
      'Pas encore disponible sur la passerelle partagée';

  @override
  String get edit_turn_title => 'Modifier cette invite ?';

  @override
  String get edit_turn_body =>
      'L’invite sera relancée à partir d’ici. Les tours suivants seront archivés.';

  @override
  String get edit_turn_send => 'Envoyer';

  @override
  String get restore_turn_title => 'Restaurer à ce point de contrôle ?';

  @override
  String get restore_turn_body =>
      'Tout ce qui suit cette invite sera retiré de la conversation et l’invite sera relancée à partir d’ici.';

  @override
  String get restore_turn_confirm => 'Restaurer et relancer';

  @override
  String get edit_turn_later_turns_body =>
      'Cela archivera les tours suivants de la conversation. Continuer ?';

  @override
  String get session_history => 'Historique de la session';

  @override
  String get import_claude_or_codex => 'Importer Claude ou Codex';

  @override
  String get ng_session_history => 'Historique de la session';

  @override
  String get ng_import_claude_or_codex => 'Importer Claude ou Codex';

  @override
  String get ng_edit_and_resend => 'Modifier et renvoyer';

  @override
  String get ng_restore_turn_confirm => 'Restaurer et relancer';

  @override
  String get rewind_target_unsaved =>
      'Ce message n\'est pas encore enregistré. Attendez qu\'il soit terminé, puis modifiez-le à nouveau.';

  @override
  String get rewind_turn_busy =>
      'La réponse en cours n\'est pas encore arrêtée, rien n\'a donc été envoyé. Réessayez dans un instant.';

  @override
  String get rewind_session_changed =>
      'Cette conversation a changé depuis son ouverture ici, rien n\'a donc été supprimé ni envoyé. Rouvrez-la, puis réessayez.';

  @override
  String get history_lineage => 'Conversations liées';

  @override
  String get history_lineage_none =>
      'Cette conversation n’a ni branche ni conversation sœur.';

  @override
  String get history_lineage_unavailable =>
      'Impossible de lire les conversations liées depuis cette passerelle.';

  @override
  String get history_lineage_parent => 'Parent';

  @override
  String get history_lineage_sibling => 'Sœur';

  @override
  String get history_lineage_fork => 'Branche';

  @override
  String get history_messages => 'Messages';

  @override
  String get history_messages_hint =>
      'Sélectionnez un message enregistré pour créer une branche ou revenir à ce point.';

  @override
  String get history_messages_none =>
      'Aucun message enregistré pour l’instant.';

  @override
  String get history_messages_unavailable =>
      'Impossible de lire les messages enregistrés. Ouvrez cette conversation, puis actualisez.';

  @override
  String get history_role_user => 'Vous';

  @override
  String get history_role_assistant => 'Hermes';

  @override
  String get history_branch_here => 'Créer une branche ici';

  @override
  String get history_rewind_here => 'Revenir à ce point';

  @override
  String get history_branch_title => 'Créer une branche depuis ce message';

  @override
  String get history_branch_body =>
      'Cela crée une nouvelle conversation contenant l’historique jusqu’au message sélectionné. La conversation actuelle reste telle quelle.';

  @override
  String get history_rewind_title => 'Revenir à ce message';

  @override
  String get history_rewind_body =>
      'Les messages à partir de celui sélectionné sont retirés de cette conversation. Les fichiers de l’ordinateur ne changent pas. Leur restauration est une action distincte, par point de contrôle.';

  @override
  String history_branched(String id) {
    return 'Branche créée : $id';
  }

  @override
  String get history_open_chat => 'Ouvrir la conversation';

  @override
  String get history_mutate_unsupported =>
      'Les branches et le retour en arrière nécessitent Hermes 0.23 ou plus récent sur cette passerelle.';

  @override
  String get history_checkpoints => 'Points de contrôle';

  @override
  String get history_checkpoints_none =>
      'Cette session n’a aucun point de contrôle de fichiers.';

  @override
  String get history_checkpoints_unavailable =>
      'Les points de contrôle ne sont pas disponibles sur cette passerelle.';

  @override
  String get history_diff_none => 'Aucune différence.';

  @override
  String get history_diff_loading => 'Chargement des modifications…';

  @override
  String get history_diff_failed =>
      'Les modifications n’ont pas pu être chargées ; ce point de contrôle ne peut pas encore être restauré.';

  @override
  String get history_restore_checkpoint => 'Restaurer le point de contrôle';

  @override
  String get history_restore_title => 'Restaurer ce point de contrôle';

  @override
  String get history_restore_body =>
      'Les fichiers modifiés par l’agent depuis ce point de contrôle reviennent à leur état d’alors. Vos propres modifications sont conservées. Des messages ultérieurs peuvent aussi être retirés. La conversation n’est pas dupliquée.';

  @override
  String get history_restore_body_all =>
      'Tous les fichiers du dossier de la session reviennent à ce point de contrôle, y compris vos propres modifications. Des messages ultérieurs peuvent aussi être retirés. La conversation n’est pas dupliquée.';

  @override
  String get history_restore_own_edits =>
      'Annuler aussi mes propres modifications';

  @override
  String get history_restored => 'Point de contrôle restauré.';

  @override
  String history_restored_removed(int count) {
    return 'Point de contrôle restauré. $count messages ont été retirés.';
  }

  @override
  String get history_export => 'Exporter';

  @override
  String get history_export_redact => 'Masquer les jetons';

  @override
  String get history_export_action => 'Exporter la transcription';

  @override
  String get history_export_saved => 'Transcription enregistrée.';

  @override
  String get history_export_unsupported =>
      'L’export nécessite Hermes 0.23 ou plus récent sur cette passerelle.';

  @override
  String get history_import_unsupported =>
      'L’import depuis Claude et Codex n’est pas pris en charge par cette passerelle.';

  @override
  String history_import_destination(String profile) {
    return 'Profil de destination : $profile.';
  }

  @override
  String history_import_reading(String host, String profile, int count) {
    return 'Lecture depuis $host · Profil de destination : $profile. $count journaux illisibles.';
  }

  @override
  String get history_import_all => 'Tous';

  @override
  String history_import_scan_failed(String reason) {
    return 'Impossible d’analyser les sessions de l’hôte : $reason';
  }

  @override
  String get history_import_none =>
      'Aucune session Claude Code ou Codex trouvée sur cet hôte.';

  @override
  String get history_import_no_match => 'Aucune session d’hôte correspondante.';

  @override
  String history_import_preview_failed(String reason) {
    return 'Aperçu de la session impossible : $reason';
  }

  @override
  String get history_import_open => 'Ouvrir la session importée';

  @override
  String get history_import_action => 'Importer la session sélectionnée';

  @override
  String get history_import_title => 'Importer cette session';

  @override
  String history_import_body(String profile) {
    return 'Copier cette session Claude ou Codex dans le profil « $profile » de cette passerelle.';
  }

  @override
  String history_import_body_existing(String profile) {
    return 'Cette session a déjà été importée dans « $profile ». Continuer avec la copie existante.';
  }

  @override
  String history_imported(String id) {
    return 'Importé : $id';
  }

  @override
  String history_imported_already(String id) {
    return 'Déjà importé : $id';
  }

  @override
  String history_import_directory(String path) {
    return 'Dossier : $path';
  }

  @override
  String history_import_preview_partial(int shown, int total) {
    return 'L’aperçu affiche $shown sur $total.';
  }

  @override
  String history_failed(String reason) {
    return 'Impossible de terminer : $reason';
  }

  @override
  String get history_error_unavailable =>
      'La passerelle n’a pas pu le faire pour le moment. Réessayez.';

  @override
  String get history_error_unsupported =>
      'Cette passerelle ne prend pas cela en charge.';

  @override
  String get history_error_denied => 'Cette passerelle a refusé la demande.';

  @override
  String get history_error_changed =>
      'Cette conversation a changé pendant que cette page était ouverte. Actualisez, puis réessayez.';

  @override
  String get history_error_unbound =>
      'Cette conversation n’est pas ouverte sur la passerelle. Ouvrez-la, puis réessayez.';

  @override
  String get history_error_invalid =>
      'La passerelle a envoyé une réponse que cette application n’a pas pu lire.';

  @override
  String ng_dock_kanban(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cartes Kanban',
      one: '1 carte Kanban',
    );
    return '$_temp0';
  }

  @override
  String ng_dock_kanban_done(int count) {
    return '$count terminées';
  }

  @override
  String get ng_show_kanban => 'Afficher les cartes Kanban';

  @override
  String get ng_hide_kanban => 'Masquer les cartes Kanban';

  @override
  String get ng_kanban_status_triage => 'Tri';

  @override
  String get ng_kanban_status_todo => 'À faire';

  @override
  String get ng_kanban_status_scheduled => 'Planifiée';

  @override
  String get ng_kanban_status_ready => 'Prête';

  @override
  String get ng_kanban_status_running => 'En cours';

  @override
  String get ng_kanban_status_blocked => 'Bloquée';

  @override
  String get ng_kanban_status_review => 'En revue';

  @override
  String get ng_kanban_status_done => 'Terminée';

  @override
  String get ng_kanban_status_archived => 'Archivée';

  @override
  String ng_kanban_open_card(String title) {
    return 'Ouvrir $title dans Kanban';
  }

  @override
  String ng_kanban_show_all(int count) {
    return 'Tout afficher ($count)';
  }

  @override
  String ng_kanban_this_chat(int count) {
    return 'Cette discussion ($count)';
  }

  @override
  String get ng_kanban_close => 'Fermer Kanban';

  @override
  String get ng_kanban_block_no_dashboard =>
      'Cette connexion n’a pas accès au tableau de bord : l’état des cartes n’est pas en direct et le tableau ne peut pas s’ouvrir.';

  @override
  String get ng_kanban_block_unsupported =>
      'Kanban n’est pas activé sur cette passerelle. Activez son plugin kanban pour voir l’état en direct et ouvrir le tableau.';

  @override
  String get ng_kanban_block_denied =>
      'Connectez-vous au tableau de bord pour voir l’état en direct des cartes et ouvrir le tableau.';

  @override
  String get ng_kanban_block_insecure =>
      'Kanban nécessite HTTPS ou une connexion locale : l’état des cartes n’est pas en direct et le tableau ne peut pas s’ouvrir.';

  @override
  String get ng_kanban_block_unreachable =>
      'Impossible de joindre Kanban sur cette passerelle. L’état des cartes n’est peut-être plus à jour.';

  @override
  String get ng_kanban_block_stale =>
      'La connexion a changé. Rouvrez cette discussion pour voir l’état en direct des cartes.';

  @override
  String get ng_bots_tab_roster => 'Équipe';

  @override
  String get ng_bots_tab_rooms => 'Salons';

  @override
  String get ng_bots_tab_screen => 'Écran';

  @override
  String get ng_bots_tab_routines => 'Routines';

  @override
  String ng_bots_rooms_load_failed(String error) {
    return 'Impossible de charger les salons : $error';
  }

  @override
  String ng_bots_routines_load_failed(String error) {
    return 'Impossible de charger les routines : $error';
  }

  @override
  String ng_bots_desktop_failed(String error) {
    return 'Bot Desktop : $error';
  }

  @override
  String get ng_bots_install_not_started =>
      'La passerelle n’a pas lancé l’installation.';

  @override
  String ng_bots_install_failed_error(String error) {
    return 'Échec de l’installation : $error';
  }

  @override
  String get ng_bots_install_cancelled => 'L’installation a été annulée.';

  @override
  String get ng_bots_install_no_sudo =>
      'sudo n’est pas disponible sur l’hôte de la passerelle. Exécutez-y la commande ci-dessus, puis actualisez.';

  @override
  String ng_bots_install_exit_code(String code) {
    return 'L’installation a échoué (code de sortie $code).';
  }

  @override
  String ng_bots_install_done(String bot) {
    return 'Bot Desktop installé pour $bot';
  }

  @override
  String get ng_bots_start_failed => 'Échec du démarrage';

  @override
  String ng_bots_stop_title(String bot) {
    return 'Arrêter Bot Desktop pour $bot ?';
  }

  @override
  String get ng_bots_stop_human_held =>
      'Quelqu’un contrôle cet écran. L’arrêter met fin à sa session et ferme tout ce qui y est ouvert.';

  @override
  String get ng_bots_stop_body =>
      'Tout ce qui est ouvert sur l’écran du bot sera fermé.';

  @override
  String get ng_bots_stop_refused => 'Arrêt refusé';

  @override
  String get ng_bots_take_over_reason => 'Prise de main depuis Ares';

  @override
  String ng_bots_take_over_failed(String error) {
    return 'Échec de la prise de main : $error';
  }

  @override
  String ng_bots_force_hand_back_title(String bot) {
    return 'Rendre l’écran de $bot au bot ?';
  }

  @override
  String get ng_bots_force_hand_back_body =>
      'Une personne contrôle cet écran. Si elle l’utilise encore, elle en perdra le contrôle.';

  @override
  String get ng_bots_hand_back => 'Rendre la main';

  @override
  String get ng_bots_hand_back_failed => 'Échec de la restitution';

  @override
  String get ng_bots_adopt_title => 'Adopter la nouvelle image de sandbox ?';

  @override
  String ng_bots_adopt_body(String bot, String current, String target) {
    return '$bot passe de $current à $target. Son conteneur sera recréé au prochain appel du terminal ; tout ce qui n’existe que dans le conteneur actuel sera perdu.';
  }

  @override
  String get ng_bots_adopt_image => 'Adopter l’image';

  @override
  String get ng_bots_image_switch_failed => 'Échec du changement d’image';

  @override
  String get ng_bots_keep_refused => 'Conservation refusée';

  @override
  String ng_bots_chat_open_failed(String error) {
    return 'Impossible d’ouvrir Bot Chat : $error';
  }

  @override
  String ng_bots_title(String connection) {
    return 'Bots · $connection';
  }

  @override
  String get ng_bots_protocol_tooltip =>
      'La passerelle injecte elle-même le protocole de messagerie entre coéquipiers — aucun protocole SOUL.md supplémentaire n’est envoyé.';

  @override
  String ng_bots_unavailable(String reason) {
    return 'Bots indisponibles ($reason)';
  }

  @override
  String get ng_bots_account_changed =>
      'Le compte a changé. Reconnectez-vous ou actualisez.';

  @override
  String get ng_bots_try_refresh =>
      'Essayez d’actualiser. Si le problème persiste, la passerelle ne prend peut-être pas en charge les bots.';

  @override
  String get ng_bots_search => 'Rechercher des bots';

  @override
  String get ng_bots_none_found => 'Aucun bot trouvé.';

  @override
  String get ng_bots_no_model => 'aucun modèle';

  @override
  String ng_bots_skill_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count compétences',
      one: '1 compétence',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_bot_chat => 'Bot Chat';

  @override
  String ng_bots_install_id(String id, String protocol) {
    return 'La passerelle signale l’ID d’installation $id · bot_mode_protocol : $protocol';
  }

  @override
  String get ng_bots_protocol_note =>
      'La passerelle injecte le protocole de messagerie entre coéquipiers lorsque bot_mode_protocol est défini. Identifiant : default→hermes, sinon le nom du profil.';

  @override
  String get ng_bots_no_rooms =>
      'Aucun salon pour l’instant. Créez-en un depuis votre équipe.';

  @override
  String ng_bots_member_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membres',
      one: '1 membre',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_room_disbanded => 'dissous';

  @override
  String get ng_bots_room_adopted => 'adopté';

  @override
  String get ng_bots_rooms_gateway => 'Salons de la passerelle';

  @override
  String get ng_bots_rooms_desktop => 'Salons pilotés par le Desktop';

  @override
  String ng_bots_rooms_gateway_body(String methods) {
    return 'Les salons appartiennent à la passerelle. Méthodes : $methods.';
  }

  @override
  String get ng_bots_rooms_no_seat =>
      'Cette passerelle ne peut peut-être pas héberger de salons (processus persistant requis).';

  @override
  String get ng_bots_rooms_fallback =>
      'Repli classique : le Desktop pilote les tours de groupe (non créés ici).';

  @override
  String get ng_bots_create_room => 'Créer un salon';

  @override
  String get ng_bots_refresh_rooms => 'Actualiser les salons';

  @override
  String get ng_bots_room_created => 'Salon créé';

  @override
  String ng_bots_room_refused(String reason) {
    return 'Création du salon refusée ($reason)';
  }

  @override
  String ng_bots_room_failed(String error) {
    return 'Échec de la création du salon : $error';
  }

  @override
  String get ng_bots_bot => 'Bot';

  @override
  String get ng_bots_screen_unavailable => 'État de l’écran indisponible';

  @override
  String get ng_bots_screen_unavailable_body =>
      'Démarrez l’écran du bot pour voir sa miniature, ou prenez la main pour l’utiliser vous-même.';

  @override
  String get ng_bots_take_over_note =>
      '« Prendre la main » ouvre l’écran en direct et vous en donne le contrôle. Le contrôle revient au bot lorsque vous fermez l’écran en direct, quittez cette page ou mettez l’app en arrière-plan.';

  @override
  String get ng_bots_not_installed => 'Non installé';

  @override
  String get ng_bots_unsupported_host => 'Hôte non pris en charge';

  @override
  String ng_bots_pid(String pid) {
    return 'pid $pid';
  }

  @override
  String ng_bots_missing(String items) {
    return 'manquant : $items';
  }

  @override
  String ng_bots_blocked(String reason) {
    return 'bloqué : $reason';
  }

  @override
  String get ng_bots_no_switch =>
      'Aucun changement d’image de sandbox en attente.';

  @override
  String ng_bots_switch_image(String current, String target) {
    return 'changement d’image : $current → $target';
  }

  @override
  String get ng_bots_bot_in_control => 'le bot a le contrôle';

  @override
  String get ng_bots_person_in_control => 'une personne a le contrôle';

  @override
  String get ng_bots_installing =>
      'Installation de Bot Desktop sur l’hôte de la passerelle…';

  @override
  String get ng_bots_install_unfinished => 'L’installation n’a pas abouti';

  @override
  String get ng_bots_install => 'Installer';

  @override
  String get ng_bots_start => 'Démarrer';

  @override
  String get ng_bots_take_over => 'Prendre la main';

  @override
  String get ng_bots_keep_image => 'Conserver l’image actuelle';

  @override
  String ng_bots_missing_pieces(String items) {
    return 'La passerelle signale des composants manquants : $items';
  }

  @override
  String get ng_bots_install_missing => 'Installer les composants manquants';

  @override
  String get ng_bots_thumbnail_unavailable => 'Miniature indisponible';

  @override
  String get ng_bots_thumbnail_title => 'Miniature de l’écran (en direct)';

  @override
  String get ng_bots_thumbnail_suppressed =>
      'Miniature masquée tant qu’une personne contrôle l’écran.';

  @override
  String get ng_bots_thumbnail_pending => 'Miniature pas encore disponible.';

  @override
  String ng_bots_routines_of(String bot) {
    return '$bot · routines';
  }

  @override
  String get ng_bots_add_routine => 'Ajouter une routine';

  @override
  String get ng_bots_no_routines => 'Aucune routine pour ce bot.';

  @override
  String get ng_bots_routines_note =>
      'Les routines sont des tâches marquées [bot:<name>] qui appartiennent au stockage du profil du bot. Les anciennes routines déléguées sont mises en pause d’office au chargement.';

  @override
  String ng_bots_routine_last(String status) {
    return 'dernière : $status';
  }

  @override
  String ng_bots_routine_next(String time) {
    return 'prochaine : $time';
  }

  @override
  String ng_bots_routine_error(String error) {
    return 'erreur : $error';
  }

  @override
  String ng_bots_remove_routine_title(String routine) {
    return 'Supprimer la routine $routine ?';
  }

  @override
  String ng_bots_remove_routine_body(String bot) {
    return 'La routine sera supprimée du planning de $bot. Cette action est irréversible.';
  }

  @override
  String ng_bots_routine_action_failed(String action, String error) {
    return 'Échec de l’action $action : $error';
  }

  @override
  String get ng_bots_not_connected => 'Non connecté.';

  @override
  String ng_bots_add_failed(String error) {
    return 'Échec de l’ajout : $error';
  }

  @override
  String get ng_bots_routine_added => 'Routine ajoutée';

  @override
  String get ng_bots_routine_enabled => 'activée';

  @override
  String get ng_bots_routine_paused => 'en pause';

  @override
  String ng_bots_path(String path) {
    return 'Chemin : $path';
  }

  @override
  String get ng_bots_chat_present => 'Bot Chat présent';

  @override
  String get ng_bots_chat_missing => 'Bot Chat absent';

  @override
  String ng_bots_last_session(String preview) {
    return 'Dernière session : $preview';
  }

  @override
  String get ng_bots_open_chat => 'Ouvrir Bot Chat';

  @override
  String get ng_bots_desktop => 'Bot Desktop';

  @override
  String get ng_bots_room_name => 'Nom du salon';

  @override
  String get ng_bots_select_member => 'Sélectionnez au moins un membre.';

  @override
  String get ng_bots_sudo_title => 'Mot de passe administrateur';

  @override
  String ng_bots_sudo_body(String bot) {
    return 'L’installation de Bot Desktop pour $bot nécessite sudo sur l’hôte de la passerelle. Le mot de passe est envoyé uniquement à cette passerelle, pour cette installation, et n’est pas enregistré.';
  }

  @override
  String get ng_bots_sudo_password => 'Mot de passe sudo';

  @override
  String get ng_bots_new_routine => 'Nouvelle routine';

  @override
  String get ng_bots_routine_title => 'Titre';

  @override
  String get ng_bots_routine_instruction => 'Instruction';

  @override
  String get ng_bots_cron => 'Expression cron';

  @override
  String get ng_bots_interval => 'Intervalle';

  @override
  String get ng_bots_cron_help => '0 9 * * * s’exécute tous les jours à 09:00';

  @override
  String get ng_bots_every => 'Tous les';

  @override
  String get ng_bots_unit_minutes => 'minutes';

  @override
  String get ng_bots_unit_hours => 'heures';

  @override
  String get ng_bots_unit_days => 'jours';

  @override
  String get ng_bots_stop_after => 'Arrêter après (exécutions)';

  @override
  String get ng_bots_stop_after_help =>
      'Laisser vide pour continuer indéfiniment';

  @override
  String get ng_bots_send_results => 'Envoyer les résultats à';

  @override
  String get ng_bots_run_history => 'Historique d’exécution uniquement';

  @override
  String get ng_bots_continuity =>
      'Reprendre à partir de l’exécution précédente';

  @override
  String get ng_bots_account_changed_refresh =>
      'Le compte a changé. Actualisez avant de continuer.';

  @override
  String ng_bots_room_load_failed(String error) {
    return 'Impossible de charger le salon : $error';
  }

  @override
  String ng_bots_send_failed(String error) {
    return 'Échec de l’envoi : $error';
  }

  @override
  String ng_bots_stop_failed(String error) {
    return 'Échec de l’arrêt : $error';
  }

  @override
  String get ng_bots_stop_room => 'Arrêter le salon';

  @override
  String get ng_bots_send_message => 'Envoyer un message';

  @override
  String get ng_bots_room_hint =>
      'Écrire au salon (mentionnez des membres avec @handle)';

  @override
  String get ng_bots_history => 'Historique';

  @override
  String ng_bots_revision(String revision) {
    return 'révision $revision';
  }

  @override
  String ng_bots_last_error(String error) {
    return 'dernière erreur : $error';
  }

  @override
  String get ng_bots_members => 'Membres';

  @override
  String get ng_bots_room_context => 'Contexte du salon';

  @override
  String ng_bots_purpose(String purpose) {
    return 'Objectif : $purpose';
  }

  @override
  String ng_bots_notes(String notes) {
    return 'Notes : $notes';
  }

  @override
  String ng_bots_routing(String routing) {
    return 'Routage : $routing';
  }

  @override
  String ng_bots_lead(String member) {
    return 'responsable $member';
  }

  @override
  String get ng_bots_viewer_you_control =>
      'Vous contrôlez cet écran. Le bot attend que vous lui rendiez la main.';

  @override
  String get ng_bots_viewer_handed_back => 'Le bot a repris le contrôle.';

  @override
  String get ng_bots_viewer_background =>
      'Le contrôle est revenu au bot, car l’app n’est plus au premier plan.';

  @override
  String get ng_bots_viewer_taken =>
      'Quelqu’un d’autre a pris le contrôle de cet écran.';

  @override
  String get ng_bots_viewer_lost =>
      'La vue en direct a été perdue ; le contrôle est donc revenu au bot.';

  @override
  String ng_bots_viewer_title(String bot) {
    return 'Bot Desktop · $bot';
  }

  @override
  String get ng_bots_viewer_type_hint => 'Saisir sur l’écran du bot';

  @override
  String get ng_bots_viewer_type => 'Saisir';

  @override
  String get ng_bots_viewer_enter => 'Entrée';

  @override
  String get ng_bots_viewer_backspace => 'Retour arrière';

  @override
  String get ng_more_kanban => 'Kanban';

  @override
  String get ng_more_kanban_subtitle =>
      'Tableaux, dépendances des tâches, affectation des workers et journaux';

  @override
  String get ng_more_bots => 'Bots';

  @override
  String get ng_more_bots_subtitle => 'Équipe, salons, routines et Bot Desktop';

  @override
  String get ng_slash_kanban => 'Ouvrir le tableau Kanban';

  @override
  String get ng_slash_bots => 'Ouvrir vos bots';

  @override
  String ng_board_card_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cartes',
      one: '1 carte',
    );
    return '$_temp0';
  }

  @override
  String ng_board_event_toast(String task, String event) {
    return 'Kanban $task : $event';
  }

  @override
  String get ng_board_task => 'tâche';

  @override
  String ng_board_refused_http(String status) {
    return 'Action refusée (HTTP $status).';
  }

  @override
  String get ng_board_err_unsupported =>
      'Le plugin Kanban n’est pas activé sur cette passerelle.';

  @override
  String get ng_board_err_denied =>
      'Connexion ou autorisation requise sur cette passerelle.';

  @override
  String get ng_board_err_stale =>
      'Le propriétaire de la passerelle a changé. Actualisez avant de continuer.';

  @override
  String get ng_board_err_insecure =>
      'HTTPS (ou loopback) est requis pour les opérations sur l’espace de travail Kanban.';

  @override
  String get ng_board_err_unreachable =>
      'Impossible de joindre le service Kanban sur cette passerelle.';

  @override
  String get ng_board_err_failed =>
      'L’opération a échoué. Actualisez, puis réessayez.';

  @override
  String ng_board_block_title(String task) {
    return 'Bloquer $task';
  }

  @override
  String get ng_board_block_reason => 'Motif du blocage';

  @override
  String get ng_board_block_hint => 'Qu’est-ce qui bloque cette carte ?';

  @override
  String ng_board_review_title(String task) {
    return 'Demander une revue de $task';
  }

  @override
  String get ng_board_review_summary => 'Résumé de la revue';

  @override
  String get ng_board_review_hint =>
      'Qu’est-ce qui a été implémenté et vérifié ?';

  @override
  String ng_board_move_title(String cards, String column) {
    return 'Déplacer $cards vers $column ?';
  }

  @override
  String ng_board_move_body(String board) {
    return 'Chaque carte sélectionnée de $board change de colonne. Une carte en cours d’exécution est arrêtée.';
  }

  @override
  String get ng_board_move => 'Déplacer';

  @override
  String ng_board_moved(String column) {
    return 'Cartes déplacées vers $column';
  }

  @override
  String ng_board_unassign_title(String cards) {
    return 'Désassigner $cards ?';
  }

  @override
  String ng_board_assign_title(String cards, String profile) {
    return 'Assigner $cards à @$profile ?';
  }

  @override
  String get ng_board_assign_body =>
      'Les cartes en cours d’exécution sont d’abord récupérées : leurs workers sont arrêtés.';

  @override
  String get ng_board_unassign => 'Désassigner';

  @override
  String get ng_board_assign => 'Assigner';

  @override
  String get ng_board_unassigned_done => 'Cartes sélectionnées désassignées';

  @override
  String ng_board_assigned_done(String profile) {
    return '@$profile assigné';
  }

  @override
  String ng_board_archive_title(String cards) {
    return 'Archiver $cards ?';
  }

  @override
  String ng_board_archive_body(String board) {
    return 'Les cartes archivées quittent $board. Activez « Archivées » pour les revoir.';
  }

  @override
  String get ng_board_archived_done => 'Cartes sélectionnées archivées';

  @override
  String ng_board_delete_title(String cards) {
    return 'Supprimer $cards ?';
  }

  @override
  String ng_board_delete_body(String board) {
    return 'Les cartes sélectionnées seront définitivement supprimées de $board.';
  }

  @override
  String ng_board_deleted(String cards) {
    return 'Suppression effectuée : $cards.';
  }

  @override
  String ng_board_partial_failure(String failed, String total, String reason) {
    return '$failed sur $total en échec : $reason';
  }

  @override
  String get ng_board_refused => 'refusé';

  @override
  String ng_board_dispatched(
    String spawned,
    String promoted,
    String reclaimed,
  ) {
    return 'Répartition : $spawned lancés, $promoted promus, $reclaimed récupérés.';
  }

  @override
  String ng_board_board_archived(String board) {
    return 'Tableau $board archivé';
  }

  @override
  String ng_board_board_archived_to(String path) {
    return 'Archivé dans $path';
  }

  @override
  String ng_board_exported(String board, String archive) {
    return '$board exporté vers $archive';
  }

  @override
  String ng_board_imported(String board, String warnings) {
    return 'Tableau $board importé$warnings';
  }

  @override
  String ng_board_created(String task) {
    return 'Tâche $task créée';
  }

  @override
  String get ng_board_orchestration_saved => 'Orchestration Kanban enregistrée';

  @override
  String get ng_board_auto_describe_unavailable =>
      'Description automatique indisponible';

  @override
  String ng_board_description_updated(String profile) {
    return 'Description de @$profile mise à jour';
  }

  @override
  String ng_board_title(String board) {
    return 'Kanban · $board';
  }

  @override
  String ng_board_active(String count) {
    return 'Actives : $count';
  }

  @override
  String get ng_board_dispatch => 'Répartir maintenant les tâches prêtes';

  @override
  String get ng_board_orchestration => 'Orchestration et workers';

  @override
  String get ng_board_new_task => 'Nouvelle tâche';

  @override
  String get ng_board_enable_plugin =>
      'Activez le plugin « kanban » fourni dans Capacités → Plugins sur cette passerelle pour activer son routeur de tableaux.';

  @override
  String get ng_board_filter => 'Filtrer les tâches…';

  @override
  String get ng_board_all_assignees => 'Tous les assignés';

  @override
  String get ng_board_unassigned => 'Non assigné';

  @override
  String get ng_board_running_by_profile => 'En cours par profil';

  @override
  String get ng_board_select => 'Sélectionner';

  @override
  String ng_board_selected_chip(String count) {
    return 'Sélection ($count)';
  }

  @override
  String get ng_board_locked_column =>
      'Colonne gérée — glisser-déposer désactivé';

  @override
  String ng_board_add_to(String column) {
    return 'Ajouter à $column';
  }

  @override
  String ng_board_collapse(String column) {
    return 'Réduire $column';
  }

  @override
  String ng_board_column_empty(String column) {
    return 'Aucune tâche dans $column';
  }

  @override
  String get ng_board_drop_here => 'Déposer ou + tâche';

  @override
  String get ng_board_card_actions => 'Actions de la carte';

  @override
  String get ng_board_open_details => 'Ouvrir les détails';

  @override
  String get ng_board_select_card => 'Sélectionner la carte';

  @override
  String ng_board_move_to(String column) {
    return 'Déplacer vers $column';
  }

  @override
  String get ng_board_parked => 'En attente';

  @override
  String ng_board_blocked_by(String count) {
    return 'Bloquée par $count';
  }

  @override
  String get ng_board_goal_loop => 'Boucle d’objectif';

  @override
  String ng_board_selected(String count) {
    return 'Sélection : $count';
  }

  @override
  String get ng_board_move_menu => 'Déplacer…';

  @override
  String get ng_board_assign_menu => 'Assigner…';

  @override
  String get ng_board_new_board_title => 'Nouveau tableau Kanban';

  @override
  String get ng_board_slug => 'Slug (minuscules, p. ex. release-v5)';

  @override
  String get ng_board_display_name => 'Nom d’affichage';

  @override
  String get ng_board_linked_project => 'Projet lié (facultatif)';

  @override
  String get ng_board_none => 'Aucun';

  @override
  String get ng_board_default_workdir =>
      'Répertoire de travail par défaut sur l’hôte (facultatif)';

  @override
  String get ng_board_import_title => 'Importer une archive de tableau';

  @override
  String get ng_board_import_path => 'Chemin de l’archive .tar.gz sur l’hôte';

  @override
  String get ng_board_import => 'Importer';

  @override
  String ng_board_edit_board(String board) {
    return 'Modifier $board';
  }

  @override
  String get ng_board_name => 'Nom';

  @override
  String get ng_board_description => 'Description';

  @override
  String get ng_board_workdir_clear =>
      'Répertoire de travail par défaut (vide pour effacer)';

  @override
  String get ng_board_boards => 'Tableaux Kanban';

  @override
  String get ng_board_new_board => 'Nouveau tableau';

  @override
  String get ng_board_search_boards => 'Rechercher des tableaux…';

  @override
  String get ng_board_unpin => 'Désépingler l’onglet';

  @override
  String get ng_board_pin => 'Épingler l’onglet';

  @override
  String ng_board_archive_board_title(String board) {
    return 'Archiver le tableau $board ?';
  }

  @override
  String ng_board_archive_board_body(String cards) {
    return 'Le tableau et ses cartes ($cards) quittent la liste des tableaux. La passerelle en conserve une archive sur son hôte.';
  }

  @override
  String get ng_board_edit_metadata => 'Modifier les métadonnées';

  @override
  String get ng_board_export => 'Exporter en .tar.gz sur l’hôte';

  @override
  String get ng_board_move_pin_left =>
      'Déplacer l’onglet épinglé vers la gauche';

  @override
  String get ng_board_archive_board => 'Archiver le tableau';

  @override
  String get ng_board_new_task_title => 'Nouvelle tâche Kanban';

  @override
  String get ng_board_title_required => 'Titre *';

  @override
  String get ng_board_spec => 'Spécification et critères d’acceptation';

  @override
  String get ng_board_estimate => 'Estimation';

  @override
  String ng_board_estimate_draft(String complexity, String tokens) {
    return 'Complexité $complexity (~$tokens tok — estimation en tokens uniquement, pas un coût en dollars)';
  }

  @override
  String get ng_board_estimate_unavailable => 'Estimation indisponible';

  @override
  String get ng_board_initial_column => 'Colonne initiale';

  @override
  String get ng_board_worker_assignee => 'Worker assigné';

  @override
  String get ng_board_parked_unassigned => 'En attente (non assignée)';

  @override
  String get ng_board_priority => 'Priorité';

  @override
  String get ng_board_workspace => 'Espace de travail';

  @override
  String get ng_board_scratch => 'Temporaire';

  @override
  String get ng_board_worktree => 'Worktree Git';

  @override
  String get ng_board_shared_dir => 'Répertoire partagé';

  @override
  String get ng_board_workspace_path =>
      'Chemin de l’espace de travail sur l’hôte';

  @override
  String get ng_board_parent => 'Dépendance parente (facultatif)';

  @override
  String get ng_board_skills =>
      'Compétences épinglées (séparées par des virgules, facultatif)';

  @override
  String get ng_board_provider_override => 'Forcer le fournisseur';

  @override
  String get ng_board_model_override => 'Forcer le modèle';

  @override
  String get ng_board_reasoning => 'Effort de raisonnement';

  @override
  String get ng_board_profile_default => 'Par défaut du profil';

  @override
  String get ng_board_xhigh => 'Très élevé';

  @override
  String get ng_board_goal_mode => 'Mode boucle d’objectif';

  @override
  String get ng_board_goal_turns =>
      'Tours max. de l’objectif (vide = par défaut)';

  @override
  String get ng_board_create_task => 'Créer la tâche';

  @override
  String get ng_board_orchestration_title =>
      'Orchestration et profils de workers';

  @override
  String ng_board_orchestrator(String profile) {
    return 'Profil de l’orchestrateur (résolu : $profile)';
  }

  @override
  String get ng_board_inherit_default =>
      'Hériter de la valeur par défaut active';

  @override
  String ng_board_default_assignee(String profile) {
    return 'Assigné par défaut (résolu : $profile)';
  }

  @override
  String get ng_board_auto_decompose =>
      'Décomposer automatiquement les cartes de triage';

  @override
  String get ng_board_auto_decompose_help =>
      'Utilise le modèle kanban_decomposer configuré pour les tâches de triage';

  @override
  String get ng_board_save_orchestration => 'Enregistrer l’orchestration';

  @override
  String get ng_board_worker_descriptions =>
      'Descriptions des spécialisations des workers';

  @override
  String ng_board_worker_label(String profile, String model, String skills) {
    return '@$profile ($model · $skills)';
  }

  @override
  String get ng_board_default_model => 'modèle par défaut';

  @override
  String get ng_board_save_description => 'Enregistrer la description';

  @override
  String get ng_board_auto_describe =>
      'Décrire automatiquement à partir des compétences et du persona';

  @override
  String get ng_board_manual_block => 'Blocage manuel par l’opérateur';

  @override
  String get ng_board_requested_review => 'Revue demandée';

  @override
  String ng_board_requeue_title(String task) {
    return 'Remettre $task en file d’attente ?';
  }

  @override
  String get ng_board_requeue_body =>
      'Le worker qui exécute cette carte est arrêté et la carte retourne dans la file d’attente.';

  @override
  String get ng_board_requeue => 'Remettre en file';

  @override
  String ng_board_reassign_title(String task, String profile) {
    return 'Réassigner $task à @$profile ?';
  }

  @override
  String get ng_board_reassign_body =>
      'Cette carte est en cours d’exécution : son worker sera d’abord arrêté.';

  @override
  String get ng_board_reassign => 'Réassigner';

  @override
  String ng_board_saved_task(String task) {
    return 'Tâche $task enregistrée';
  }

  @override
  String get ng_board_commented_requeued =>
      'Commentaire publié et tâche remise en file d’attente';

  @override
  String get ng_board_commented => 'Commentaire publié';

  @override
  String ng_board_requeued(String task) {
    return 'Tâche $task remise en file d’attente';
  }

  @override
  String get ng_board_decompose_failed => 'Échec de la décomposition.';

  @override
  String ng_board_decompose_failed_reason(String reason) {
    return 'Échec de la décomposition : $reason';
  }

  @override
  String ng_board_decomposed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Décomposée en $count sous-tâches',
      one: 'Décomposée en 1 sous-tâche',
    );
    return '$_temp0';
  }

  @override
  String get ng_board_no_children => 'Aucune sous-tâche n’a été créée.';

  @override
  String ng_board_no_children_reason(String reason) {
    return 'Aucune sous-tâche n’a été créée : $reason';
  }

  @override
  String ng_board_uploaded(String file) {
    return '$file téléversé';
  }

  @override
  String ng_board_linked_parent(String task) {
    return 'Tâche parente $task liée';
  }

  @override
  String ng_board_unlinked_parent(String task) {
    return 'Lien vers la tâche parente $task supprimé';
  }

  @override
  String get ng_board_task_load_failed => 'Impossible de charger la tâche';

  @override
  String get ng_board_refresh_task => 'Actualiser la tâche';

  @override
  String get ng_board_tab_overview => 'Aperçu';

  @override
  String get ng_board_tab_comments => 'Commentaires et liens';

  @override
  String get ng_board_tab_runs => 'Exécutions et journal';

  @override
  String get ng_board_tab_events => 'Événements';

  @override
  String get ng_board_decompose => 'Décomposer';

  @override
  String get ng_board_attach => 'Joindre un fichier';

  @override
  String ng_board_estimate_task(
    String complexity,
    String tokens,
    String rationale,
  ) {
    return 'Estimation : $complexity · ~$tokens tokens ($rationale) — pas un coût en dollars.';
  }

  @override
  String get ng_board_no_rationale => 'aucune justification';

  @override
  String get ng_board_status => 'Statut';

  @override
  String get ng_board_assignee => 'Assigné à';

  @override
  String get ng_board_title_label => 'Titre';

  @override
  String get ng_board_body => 'Corps / spécification';

  @override
  String get ng_board_save_changes => 'Enregistrer les modifications';

  @override
  String get ng_board_clear_model => 'Retirer le modèle forcé';

  @override
  String ng_board_blocked_reason(String reason) {
    return 'Motif du blocage : $reason';
  }

  @override
  String ng_board_result(String result) {
    return 'Résultat : $result';
  }

  @override
  String ng_board_parents(String count) {
    return 'Bloquée par (parents · $count)';
  }

  @override
  String get ng_board_add_parent => '+ Ajouter un parent';

  @override
  String ng_board_children(String count) {
    return 'Bloque (enfants · $count)';
  }

  @override
  String ng_board_attachments(String count) {
    return 'Pièces jointes ($count)';
  }

  @override
  String get ng_board_worker => 'worker';

  @override
  String ng_board_comments(String count) {
    return 'Commentaires ($count)';
  }

  @override
  String get ng_board_comment_hint =>
      'Ajouter un commentaire / des consignes pour le worker';

  @override
  String get ng_board_post_comment => 'Publier le commentaire';

  @override
  String get ng_board_comment_requeue => 'Commenter et remettre en file';

  @override
  String ng_board_runs(String count) {
    return 'Exécutions ($count)';
  }

  @override
  String get ng_board_no_runs =>
      'Aucune exécution de worker enregistrée pour l’instant.';

  @override
  String ng_board_run_error(String error) {
    return 'Erreur : $error';
  }

  @override
  String ng_board_log_tail_truncated(String bytes) {
    return 'Fin du journal du worker ($bytes o, tronqué)';
  }

  @override
  String ng_board_log_tail(String bytes) {
    return 'Fin du journal du worker ($bytes o)';
  }

  @override
  String get ng_board_refresh_log => 'Actualiser le journal';

  @override
  String get ng_board_no_log => 'Aucune sortie dans le journal du worker.';

  @override
  String get ng_board_no_events => 'Aucun événement enregistré.';

  @override
  String get ng_bots_room_unknown => 'inconnu';

  @override
  String get ng_bots_room_blocked => 'bloqué';

  @override
  String get ng_bots_room_working => 'au travail';

  @override
  String get ng_bots_room_running => 'en marche';

  @override
  String get ng_bots_room_idle => 'inactif';

  @override
  String ng_board_run_title(String id, String profile, String outcome) {
    return 'Exécution n° $id · @$profile · $outcome';
  }

  @override
  String get ng_bots_new_bot => 'Nouveau bot';

  @override
  String get ng_bots_new_bot_hint =>
      'Un coéquipier nommé, avec sa propre mémoire, ses compétences et son chat. Il peut écrire à vos autres agents.';

  @override
  String get ng_bots_field_name => 'Nom';

  @override
  String get ng_bots_field_title => 'Titre';

  @override
  String get ng_bots_field_description => 'Description';

  @override
  String get ng_bots_description_hint => 'Avec quoi ce bot doit-il aider ?';

  @override
  String get ng_bots_name_invalid =>
      'Utilisez des minuscules, chiffres, tirets ou tirets bas, en commençant par une lettre ou un chiffre (64 caractères au plus).';

  @override
  String ng_bots_name_taken(String name) {
    return 'Un agent nommé « $name » existe déjà.';
  }

  @override
  String ng_bots_profile_id(String id) {
    return 'ID de profil : $id';
  }

  @override
  String get ng_bots_advanced =>
      'Avancé — modèle, compétences, jeux d’outils, SOUL.md';

  @override
  String get ng_bots_clone_from => 'Cloner depuis le profil';

  @override
  String get ng_bots_clone_main => 'Profil principal (default)';

  @override
  String get ng_bots_fresh_profile => 'Nouveau profil (compétences fournies)';

  @override
  String get ng_bots_create_empty =>
      'Créer vide (sans les compétences fournies)';

  @override
  String get ng_bots_share_keys =>
      'Partager clés et comptes avec le profil principal';

  @override
  String get ng_bots_provider => 'Fournisseur';

  @override
  String get ng_bots_model => 'Modèle';

  @override
  String get ng_bots_model_pair => 'Indiquez un fournisseur et un modèle.';

  @override
  String get ng_bots_soul =>
      'SOUL.md (facultatif — remplace la persona générée)';

  @override
  String get ng_bots_soul_edit => 'SOUL.md';

  @override
  String get ng_bots_creating => 'Création…';

  @override
  String get ng_bots_create_bot => 'Créer le bot';

  @override
  String ng_bots_created(String name) {
    return 'Bot « $name » créé';
  }

  @override
  String get ng_bots_look_failed =>
      'Son apparence n’a pas été enregistrée sur la passerelle ; réglez-la dans Modifier le profil.';

  @override
  String ng_bots_request_failed(String reason) {
    return 'La passerelle ne l’a pas accepté ($reason).';
  }

  @override
  String get ng_bots_avatar_shape => 'Forme';

  @override
  String ng_bots_avatar_shape_n(int n) {
    return 'Forme $n';
  }

  @override
  String get ng_bots_avatar_colour => 'Couleur';

  @override
  String ng_bots_avatar_colour_n(int n) {
    return 'Couleur $n';
  }

  @override
  String get ng_bots_avatar_match_name => 'Selon le nom';

  @override
  String get ng_bots_avatar_upload => 'Choisir une image…';

  @override
  String get ng_bots_avatar_remove => 'Retirer l’image — utiliser la forme';

  @override
  String get ng_bots_avatar_too_large => 'Image trop volumineuse (15 Mo max.).';

  @override
  String get ng_bots_avatar_unreadable => 'Impossible de lire cette image.';

  @override
  String get ng_bots_edit_profile => 'Modifier le profil';

  @override
  String ng_bots_edit_description(String name, String profile) {
    return 'Apparence et rôle de $name ($profile).';
  }

  @override
  String ng_bots_advanced_failed(String reason) {
    return 'Impossible de charger les réglages du profil ($reason).';
  }

  @override
  String get ng_bots_skills => 'Compétences';

  @override
  String get ng_bots_toolsets => 'Jeux d’outils';

  @override
  String get ng_bots_toolsets_hint =>
      'Tout cocher (ou rien) conserve le comportement par défaut des jeux d’outils.';

  @override
  String get ng_bots_mcp_servers => 'Serveurs MCP';

  @override
  String get ng_bots_saving => 'Enregistrement…';

  @override
  String get ng_bots_confirm_changes_title => 'Enregistrer ces modifications ?';

  @override
  String get ng_bots_change_remove_image => 'Retirer l’image du bot';

  @override
  String get ng_bots_change_soul => 'Remplacer son SOUL.md';

  @override
  String ng_bots_change_turn_off(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Désactiver $count compétences, jeux d’outils ou serveurs MCP',
      one: 'Désactiver 1 compétence, jeu d’outils ou serveur MCP',
    );
    return '$_temp0';
  }

  @override
  String ng_bots_updated(String name) {
    return '$name mis à jour';
  }

  @override
  String ng_bots_sections_failed(String sections) {
    return 'Certaines sections ont échoué : $sections';
  }

  @override
  String get ng_bots_model_confirm_title => 'Changer de modèle ?';

  @override
  String get ng_bots_model_confirm_ok => 'Changer';

  @override
  String get ng_bots_model_not_switched => 'Le modèle n’a pas été changé.';

  @override
  String get ng_bots_section_new => 'Nouvelle section';

  @override
  String get ng_bots_section_new_ellipsis => 'Nouvelle section…';

  @override
  String get ng_bots_section_name => 'Nom de la section';

  @override
  String get ng_bots_section_name_hint => 'p. ex. Clients';

  @override
  String get ng_bots_section_create => 'Créer';

  @override
  String get ng_bots_section_rename => 'Renommer la section';

  @override
  String get ng_bots_section_delete => 'Supprimer la section';

  @override
  String get ng_bots_section_move_up => 'Monter';

  @override
  String get ng_bots_section_move_down => 'Descendre';

  @override
  String get ng_bots_section_unassigned => 'Non classés';

  @override
  String ng_bots_section_options(String name) {
    return 'Options de la section $name';
  }

  @override
  String get ng_bots_section_empty =>
      'Aucun bot ici pour l’instant. Utilisez Déplacer vers une section sur un bot.';

  @override
  String get ng_bots_section_move_to => 'Déplacer vers une section';

  @override
  String get ng_bots_section_remove => 'Retirer de la section';

  @override
  String ng_bots_section_deleted(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '« $name » supprimée — $count bots déplacés vers Non classés',
      one: '« $name » supprimée — 1 bot déplacé vers Non classés',
      zero: '« $name » supprimée',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_undo => 'Annuler';

  @override
  String ng_bots_section_move_failed(String reason) {
    return 'Impossible de déplacer le bot ($reason).';
  }

  @override
  String ng_bots_bot_actions(String name) {
    return 'Actions pour $name';
  }

  @override
  String ng_bots_section_toggle(String name) {
    return 'Afficher ou masquer $name';
  }

  @override
  String
  get release_core_transcript_reader_this_passage_is_no_longer_in_the_loaded =>
      'Ce passage ne fait plus partie de la portion chargée.';

  @override
  String get release_core_transcript_reader_loaded_prompts => 'Prompts chargés';

  @override
  String get release_core_transcript_reader_jump_to_latest =>
      'Aller au dernier élément';

  @override
  String get release_core_transcript_reader_no_prompts_loaded =>
      'Aucun prompt chargé';

  @override
  String get release_core_transcript_reader_find_in_loaded_messages =>
      'Rechercher dans les messages chargés';

  @override
  String get release_core_transcript_reader_previous_match =>
      'Résultat précédent';

  @override
  String get release_core_transcript_reader_next_match => 'Résultat suivant';

  @override
  String get release_core_transcript_reader_prompt_timeline =>
      'Chronologie des prompts';

  @override
  String get release_core_transcript_reader_close_find => 'Fermer la recherche';

  @override
  String get release_core_session_organisation_organise_chats =>
      'Organiser les discussions';

  @override
  String get release_core_session_organisation_show_model_and_usage =>
      'Afficher le modèle et l’utilisation';

  @override
  String
  get release_core_session_files_view_connection_changed_reopen_files_on_the_new_connection =>
      'La connexion a changé. Rouvrez les fichiers avec la nouvelle connexion.';

  @override
  String
  get release_core_session_files_view_the_connection_or_session_changed_reopen_this_pane =>
      'La connexion ou la session a changé. Rouvrez ce volet.';

  @override
  String
  get release_core_session_files_view_no_verified_host_working_directory_for_this_session =>
      'Aucun répertoire de travail vérifié sur l’hôte pour cette session.';

  @override
  String
  get release_core_session_files_view_the_gateway_denied_this_operation =>
      'La passerelle a refusé cette opération.';

  @override
  String
  get release_core_session_files_view_this_gateway_does_not_support_this_operation =>
      'Cette passerelle ne prend pas en charge cette opération.';

  @override
  String
  get release_core_session_files_view_the_file_owner_or_working_directory_changed_reload =>
      'Le fichier, le propriétaire ou le répertoire de travail a changé. Rechargez et vérifiez.';

  @override
  String
  get release_core_session_files_view_the_gateway_returned_an_unsafe_path_or_invalid =>
      'La passerelle a renvoyé un chemin non sûr ou une réponse de fichier invalide.';

  @override
  String
  get release_core_session_files_view_workspace_access_requires_a_secure_gateway_connection =>
      'L’accès à l’espace de travail nécessite une connexion sécurisée à la passerelle.';

  @override
  String
  get release_core_session_files_view_gateway_unavailable_refresh_to_check_the_current_state =>
      'Passerelle indisponible. Actualisez pour vérifier l’état actuel.';

  @override
  String
  get release_core_session_files_view_gateway_operation_could_not_be_confirmed =>
      'L’opération de la passerelle n’a pas pu être confirmée.';

  @override
  String get release_core_session_files_view_git_status_unavailable =>
      'État Git indisponible.';

  @override
  String
  get release_core_session_files_view_change_this_chat_s_working_directory =>
      'Modifier le répertoire de travail de cette discussion ?';

  @override
  String get release_core_session_files_view_absolute_gateway_directory =>
      'Répertoire absolu sur la passerelle';

  @override
  String get release_core_session_files_view_change_directory =>
      'Changer de répertoire';

  @override
  String get release_core_session_files_view_replace_gateway_file =>
      'Remplacer le fichier sur la passerelle ?';

  @override
  String
  release_core_session_files_view_only_if_the_file_still_matches_the_version(
    String path,
  ) {
    return '$path\n\nUniquement si le fichier correspond toujours à la version que vous avez examinée. Un hôte compatible conserve le fichier remplacé pour permettre sa récupération.';
  }

  @override
  String get release_core_session_files_view_save_changes =>
      'Enregistrer les modifications';

  @override
  String
  get release_core_session_files_view_saved_and_verified_on_the_gateway =>
      'Enregistré et vérifié sur la passerelle.';

  @override
  String
  get release_core_session_files_view_guarded_saving_is_unavailable_on_this_gateway_your =>
      'L’enregistrement protégé est indisponible sur cette passerelle. Votre brouillon est toujours là.';

  @override
  String
  release_core_session_files_view_save_was_not_confirmed_your_draft_is_still(
    String reason,
  ) {
    return '$reason L’enregistrement n’a pas été confirmé. Votre brouillon est toujours là.';
  }

  @override
  String get release_core_session_files_view_review_current_gateway_version =>
      'Examiner la version actuelle sur la passerelle';

  @override
  String get release_core_session_files_view_discard_draft_and_reload =>
      'Supprimer le brouillon et recharger';

  @override
  String get release_core_session_files_view_keep_draft_against_this_version =>
      'Conserver le brouillon sur la base de cette version';

  @override
  String get release_core_session_files_view_discard_unsaved_edits =>
      'Abandonner les modifications non enregistrées ?';

  @override
  String get release_core_session_files_view_keep_editing =>
      'Continuer la modification';

  @override
  String get release_core_session_files_view_discard_edits =>
      'Abandonner les modifications';

  @override
  String get release_core_session_files_view_remote_working_directory =>
      'Répertoire de travail distant';

  @override
  String get release_core_session_files_view_change_working_directory =>
      'Changer de répertoire de travail';

  @override
  String get release_core_session_files_view_show_ignored_files =>
      'Afficher les fichiers ignorés';

  @override
  String
  get release_core_session_files_view_gateway_does_not_report_ignored_status =>
      'La passerelle n’indique pas quels fichiers sont ignorés.';

  @override
  String get release_core_session_files_view_no_visible_entries =>
      'Aucune entrée visible';

  @override
  String get release_core_session_files_view_changed => 'Modifié';

  @override
  String get release_core_session_files_view_ignored => 'Ignoré';

  @override
  String release_core_session_files_view_actions_for(String name) {
    return 'Actions pour $name';
  }

  @override
  String get release_core_session_files_view_copy_relative_path =>
      'Copier le chemin relatif';

  @override
  String get release_core_session_files_view_copy_gateway_path =>
      'Copier le chemin sur la passerelle';

  @override
  String get release_core_session_files_view_attach_folder_reference =>
      'Joindre une référence de dossier';

  @override
  String get release_core_session_files_view_attach_file_reference =>
      'Joindre une référence de fichier';

  @override
  String
  get release_core_session_files_view_preview_truncated_editing_disabled =>
      'Aperçu tronqué — modification désactivée.';

  @override
  String get release_core_session_files_view_select_lines =>
      'Sélectionner des lignes';

  @override
  String get release_core_session_files_view_review_gateway_version =>
      'Examiner la version sur la passerelle';

  @override
  String get release_core_session_files_view_attach_selected_lines =>
      'Joindre les lignes sélectionnées';

  @override
  String get release_core_session_files_view_binary_file_no_text_preview =>
      'Fichier binaire — aucun aperçu textuel.';

  @override
  String get release_core_session_files_view_file_source => 'Source du fichier';

  @override
  String get release_core_session_files_view_close_session_files =>
      'Fermer les fichiers de la session';

  @override
  String get release_core_session_files_view_back_to_tree =>
      'Revenir à l’arborescence';

  @override
  String get release_core_session_files_view_session_files =>
      'Fichiers de la session';

  @override
  String get release_core_session_files_view_git_review => 'Revue Git';

  @override
  String get release_core_session_files_view_refresh_tree =>
      'Actualiser l’arborescence';

  @override
  String
  get release_core_gateway_queue_screen_this_connection_changed_reopen_its_chat =>
      'Cette connexion a changé. Rouvrez la discussion associée.';

  @override
  String
  get release_core_gateway_queue_screen_disconnected_reconnect_the_chat_then_refresh =>
      'Connexion interrompue. Reconnectez la discussion, puis actualisez.';

  @override
  String release_core_gateway_queue_screen_gateway_queue_unavailable(
    String reason,
  ) {
    return 'File d’attente de la passerelle indisponible : $reason.';
  }

  @override
  String release_core_gateway_queue_screen_not_confirmed_nothing_was_resent(
    String reason,
  ) {
    return 'Non confirmé ($reason). Rien n’a été renvoyé.';
  }

  @override
  String get release_core_gateway_queue_screen_gateway_confirmed_admission =>
      'La passerelle a confirmé la prise en charge.';

  @override
  String
  get release_core_gateway_queue_screen_edited_entry_admitted_at_the_end_of_the =>
      'Entrée modifiée prise en charge en fin de file d’attente.';

  @override
  String get release_core_gateway_queue_screen_discard_unknown_outcome =>
      'Abandonner l’entrée au résultat inconnu ?';

  @override
  String get release_core_gateway_queue_screen_remove_this_entry =>
      'Supprimer cette entrée ?';

  @override
  String
  get release_core_gateway_queue_screen_the_lost_turn_will_not_be_retried_waiting =>
      'Le tour perdu ne sera pas relancé. Les tours en attente peuvent maintenant s’exécuter.';

  @override
  String
  get release_core_gateway_queue_screen_if_the_gateway_has_just_started_this_entry =>
      'Si la passerelle vient de démarrer cette entrée, sa suppression peut arrêter le tour correspondant.';

  @override
  String get release_core_gateway_queue_screen_keep => 'Conserver';

  @override
  String get release_core_gateway_queue_screen_discard_and_resume =>
      'Abandonner et reprendre';

  @override
  String get release_core_gateway_queue_screen_remove_entry =>
      'Supprimer l’entrée';

  @override
  String
  get release_core_gateway_queue_screen_lost_admission_resolved_it_was_not_resent =>
      'Prise en charge incertaine résolue ; rien n’a été renvoyé.';

  @override
  String get release_core_gateway_queue_screen_gateway_acknowledged_removal =>
      'La passerelle a confirmé la suppression.';

  @override
  String get release_core_gateway_queue_screen_gateway_queue =>
      'File d’attente de la passerelle';

  @override
  String get release_core_gateway_queue_screen_refresh_queue =>
      'Actualiser la file d’attente';

  @override
  String get release_core_gateway_queue_screen_queue_paused_unknown_outcome =>
      'File d’attente suspendue : résultat inconnu';

  @override
  String
  get release_core_gateway_queue_screen_review_the_lost_admission_before_resuming_nothing_is =>
      'Examinez la prise en charge incertaine avant de reprendre. Rien n’est renvoyé.';

  @override
  String get release_core_gateway_queue_screen_no_pending_admissions =>
      'Aucune prise en charge en attente';

  @override
  String get release_core_gateway_queue_screen_discard => 'Abandonner…';

  @override
  String
  get release_core_gateway_queue_screen_gateway_acknowledged_the_steering_request =>
      'La passerelle a confirmé la demande de réorientation.';

  @override
  String get release_core_gateway_queue_screen_steer_running_turn =>
      'Réorienter le tour en cours';

  @override
  String get release_core_gateway_queue_screen_remove => 'Supprimer…';

  @override
  String get release_core_gateway_queue_screen_next_prompt => 'Prompt suivant';

  @override
  String get release_core_gateway_queue_screen_edit_queued_prompt =>
      'Modifier le prompt en attente';

  @override
  String get release_core_gateway_queue_screen_submit_to_gateway_queue =>
      'Envoyer à la file d’attente de la passerelle';

  @override
  String get release_core_gateway_queue_screen_save_at_queue_end =>
      'Enregistrer en fin de file d’attente';

  @override
  String get release_core_gateway_queue_screen_cancel_edit =>
      'Annuler la modification';

  @override
  String get release_core_git_review_pane_the_git_operation_did_not_complete =>
      'L’opération Git ne s’est pas terminée.';

  @override
  String get release_core_git_review_pane_close_git_review =>
      'Fermer la revue Git';

  @override
  String get release_core_git_review_pane_pin_lane => 'Épingler la voie';

  @override
  String get release_core_git_review_pane_refresh_git_review =>
      'Actualiser la revue Git';

  @override
  String get release_core_git_review_pane_uncommitted => 'Non commité';

  @override
  String get release_core_git_review_pane_last_turn => 'Dernier tour';

  @override
  String
  get release_core_git_review_pane_branch_and_last_turn_views_are_read_only =>
      'Les vues de branche et du dernier tour sont en lecture seule.';

  @override
  String get release_core_git_review_pane_mark_head_as_the_turn_baseline =>
      'Définir HEAD comme référence de départ du tour';

  @override
  String get release_core_git_review_pane_stage_all => 'Tout indexer';

  @override
  String get release_core_git_review_pane_discard_every_uncommitted_change =>
      'Abandonner toutes les modifications non commitées ?';

  @override
  String
  get release_core_git_review_pane_tracked_files_return_to_head_and_untracked_files =>
      'Les fichiers suivis sont rétablis à HEAD et les fichiers non suivis de ce répertoire de session sont supprimés.';

  @override
  String get release_core_git_review_pane_discard => 'Abandonner';

  @override
  String get release_core_git_review_pane_discard_all => 'Tout abandonner';

  @override
  String get release_core_git_review_pane_unstage => 'Désindexer';

  @override
  String get release_core_git_review_pane_stage => 'Indexer';

  @override
  String get release_core_git_review_pane_discard_file =>
      'Abandonner les modifications du fichier';

  @override
  String release_core_git_review_pane_discard_2(String path) {
    return 'Abandonner les modifications de $path ?';
  }

  @override
  String
  get release_core_git_review_pane_this_restores_the_committed_copy_or_removes_the =>
      'Cela rétablit la version commitée ou supprime le fichier non suivi.';

  @override
  String get release_core_git_review_pane_commit_message => 'Message de commit';

  @override
  String get release_core_git_review_pane_nothing_in_the_diff_to_summarise =>
      'Aucune modification à résumer dans le diff.';

  @override
  String get release_core_git_review_pane_generate_message =>
      'Générer le message';

  @override
  String get release_core_git_review_pane_commit => 'Commiter';

  @override
  String get release_core_git_review_pane_commit_and_push =>
      'Commiter et pousser';

  @override
  String get release_core_git_review_pane_push => 'Pousser';

  @override
  String get release_core_git_review_pane_create_pull_request =>
      'Créer une pull request';

  @override
  String get release_core_git_review_pane_pull_request_ready =>
      'Pull request prête';

  @override
  String get release_core_git_review_pane_ask_hermes_to_ship =>
      'Demander à Hermes de publier';

  @override
  String get release_core_git_review_pane_gh_is_authenticated_on_this_gateway =>
      'gh est authentifié sur cette passerelle.';

  @override
  String
  get release_core_git_review_pane_install_the_github_cli_gh_and_sign_in =>
      'Installez la CLI GitHub (gh) et connectez-vous pour ouvrir des PR';

  @override
  String get release_core_git_review_pane_worktrees => 'Arbres de travail';

  @override
  String get release_core_git_review_pane_main => 'Principal';

  @override
  String release_core_git_review_pane_follow(String branch) {
    return 'Suivre $branch ?';
  }

  @override
  String
  get release_core_git_review_pane_the_session_working_directory_becomes_this_worktree_unless =>
      'Cet arbre de travail devient le répertoire de travail de la session, sauf si la voie est épinglée.';

  @override
  String get release_core_git_review_pane_follow_2 => 'Suivre';

  @override
  String release_core_git_review_pane_remove(String branch) {
    return 'Supprimer $branch ?';
  }

  @override
  String get release_core_git_review_pane_the_worktree_directory_is_removed =>
      'Le répertoire de l’arbre de travail est supprimé.';

  @override
  String get release_core_git_review_pane_remove_2 => 'Supprimer';

  @override
  String get release_core_git_review_pane_new_worktree_name =>
      'Nom du nouvel arbre de travail';

  @override
  String get release_core_git_review_pane_new_branch => 'Nouvelle branche';

  @override
  String get release_core_git_review_pane_base_branch => 'Branche de base';

  @override
  String get release_core_git_review_pane_create_worktree =>
      'Créer un arbre de travail';

  @override
  String get release_core_git_review_pane_existing_branch =>
      'Branche existante';

  @override
  String get release_core_git_review_pane_convert_branch_to_worktree =>
      'Convertir la branche en arbre de travail';

  @override
  String get release_core_git_review_pane_switch_branch => 'Changer de branche';

  @override
  String
  get release_core_git_review_pane_this_gateway_does_not_support_that_git_operation =>
      'Cette passerelle ne prend pas en charge cette opération Git.';

  @override
  String
  get release_core_git_review_pane_git_needs_the_session_directory_on_the_local =>
      'Git a besoin du répertoire de session sur le backend de terminal local.';

  @override
  String
  get release_core_git_review_pane_the_gateway_refused_the_git_operation =>
      'La passerelle a refusé l’opération Git.';

  @override
  String
  get release_core_git_review_pane_the_session_changed_refresh_and_try_again =>
      'La session a changé. Actualisez et réessayez.';

  @override
  String
  get release_core_git_review_pane_this_review_is_no_longer_the_selected_session =>
      'Cette revue ne correspond plus à la session sélectionnée.';

  @override
  String
  get release_core_git_review_pane_the_gateway_returned_an_unexpected_git_result =>
      'La passerelle a renvoyé un résultat Git inattendu.';

  @override
  String
  get release_core_git_review_pane_git_review_requires_the_gateway_transport =>
      'La revue Git nécessite le transport de la passerelle.';

  @override
  String get release_core_client_held_queue_bar_resume => 'Reprendre';

  @override
  String get release_core_client_held_queue_bar_send_queued_prompt =>
      'Envoyer le prompt en attente';

  @override
  String get release_core_client_held_queue_bar_edit_unsent_prompt =>
      'Modifier le prompt non envoyé';

  @override
  String get release_core_client_held_queue_bar_remove_unsent_prompt =>
      'Supprimer le prompt non envoyé';

  @override
  String get release_core_workspace_discovery_view_repository_discovery =>
      'Découverte des dépôts';

  @override
  String get release_core_workspace_discovery_view_refresh_results =>
      'Actualiser les résultats';

  @override
  String release_core_workspace_discovery_view_hide(String path) {
    return 'Masquer $path';
  }

  @override
  String
  get release_core_workspace_discovery_view_invalid_path_or_discovery_data_use_absolute_server =>
      'Chemin ou données de découverte invalides. Utilisez des chemins absolus sur le serveur, sans composants « . » ou « .. ».';

  @override
  String
  get release_core_workspace_discovery_view_this_gateway_does_not_support_repository_discovery =>
      'Cette passerelle ne prend pas en charge la découverte des dépôts.';

  @override
  String
  get release_core_workspace_discovery_view_the_gateway_denied_access_to_repository_discovery =>
      'La passerelle a refusé l’accès à la découverte des dépôts.';

  @override
  String
  get release_core_workspace_discovery_view_the_connection_changed_reopen_discovery_on_the_current =>
      'La connexion a changé. Rouvrez la découverte sur la passerelle actuelle.';

  @override
  String
  get release_core_workspace_discovery_view_the_displayed_settings_have_changed_refresh_before_trying =>
      'Les paramètres affichés ont changé. Actualisez avant de réessayer.';

  @override
  String
  get release_core_workspace_discovery_view_could_not_load_or_verify_discovery_settings_refresh =>
      'Impossible de charger ou de vérifier les paramètres de découverte. Actualisez pour réessayer.';

  @override
  String release_core_workspace_discovery_view_repositories_shown_of(
    int visible,
    int total,
  ) {
    return 'Dépôts affichés : $visible sur $total';
  }

  @override
  String
  get release_core_workspace_discovery_view_the_gateway_returned_no_repositories =>
      'La passerelle n’a renvoyé aucun dépôt.';

  @override
  String
  get release_core_workspace_discovery_view_no_repositories_match_your_device_filters =>
      'Aucun dépôt ne correspond aux filtres de votre appareil.';

  @override
  String get release_core_workspace_discovery_view_gateway_scan_policy =>
      'Politique d’analyse de la passerelle';

  @override
  String
  get release_core_workspace_discovery_view_this_gateway_did_not_report_a_scan_policy =>
      'Cette passerelle n’a pas indiqué de politique d’analyse.';

  @override
  String
  get release_core_workspace_discovery_view_to_scan_folders_configure_repository_scanning_in_the =>
      'Pour analyser les dossiers, configurez l’analyse des dépôts dans les paramètres Desktop du profil de la passerelle.';

  @override
  String
  get release_core_workspace_discovery_view_results_can_include_cached_repositories_and_repositories_with =>
      'Les résultats peuvent inclure des dépôts en cache et des dépôts associés à des sessions. Une analyse ne garantit pas que tous les dossiers ont été atteints.';

  @override
  String get release_core_workspace_discovery_view_scan_gateway_roots =>
      'Analyser les répertoires racines de la passerelle';

  @override
  String
  get release_core_workspace_discovery_view_filter_results_on_this_device =>
      'Filtrer les résultats sur cet appareil';

  @override
  String
  get release_core_workspace_discovery_view_only_this_discovery_list_changes_not_the_gateway =>
      'Seule cette liste de découverte change, pas l’analyse de la passerelle.';

  @override
  String get release_core_workspace_discovery_view_include_subtrees_empty_all =>
      'Inclure les sous-arborescences (vide = toutes)';

  @override
  String get release_core_workspace_discovery_view_exclude_subtrees =>
      'Exclure les sous-arborescences';

  @override
  String get release_core_workspace_discovery_view_apply_filters =>
      'Appliquer les filtres';

  @override
  String release_core_workspace_discovery_view_hidden_repositories(int count) {
    return 'Dépôts masqués ($count)';
  }

  @override
  String get release_core_workspace_discovery_view_undo_hide =>
      'Annuler le masquage';

  @override
  String
  get release_core_workspace_discovery_view_one_absolute_server_path_per_line =>
      'Un chemin absolu sur le serveur par ligne';

  @override
  String get release_core_project_settings_view_project_settings =>
      'Paramètres du projet';

  @override
  String
  get release_core_project_settings_view_the_gateway_did_not_confirm_the_selected_project =>
      'La passerelle n’a pas confirmé le projet sélectionné ou la modification. Vérifiez les paramètres avant de réessayer.';

  @override
  String
  get release_core_project_settings_view_could_not_verify_these_settings_use_one_absolute =>
      'Impossible de vérifier ces paramètres. Utilisez un chemin absolu de dossier sur le serveur par ligne, sans composants « . » ou « .. ».';

  @override
  String get release_core_project_settings_view_set_active =>
      'Définir comme actif';

  @override
  String get release_core_project_settings_view_icon => 'Icône';

  @override
  String get release_core_project_settings_view_folder => 'Dossier';

  @override
  String get release_core_project_settings_view_repository => 'Dépôt';

  @override
  String get release_core_project_settings_view_rocket => 'Fusée';

  @override
  String get release_core_project_settings_view_star => 'Étoile';

  @override
  String get release_core_project_settings_view_book => 'Livre';

  @override
  String get release_core_project_settings_view_terminal => 'Terminal';

  @override
  String get release_core_project_settings_view_colour => 'Couleur';

  @override
  String get release_core_project_settings_view_primary_folder =>
      'Dossier principal';

  @override
  String get release_core_project_settings_view_server_folder_paths =>
      'Chemins des dossiers sur le serveur';

  @override
  String
  get release_core_project_settings_view_one_absolute_path_per_line_existing_folders_are =>
      'Un chemin absolu par ligne. Les dossiers existants sont conservés.';

  @override
  String get release_core_project_settings_view_add_folders =>
      'Ajouter des dossiers';

  @override
  String release_core_project_settings_view_choose(String label) {
    return 'Choisir $label';
  }

  @override
  String
  get release_core_prepared_image_recovery_wait_for_an_empty_draft_before_restoring =>
      'Attendez que le brouillon soit vide avant de restaurer.';

  @override
  String
  get release_core_prepared_image_recovery_no_unacknowledged_image_drafts_in_this_chat =>
      'Aucun brouillon d’image non confirmé dans cette discussion.';

  @override
  String get release_core_prepared_image_recovery_unacknowledged_image_drafts =>
      'Brouillons d’images non confirmés';

  @override
  String
  get release_core_prepared_image_recovery_the_gateway_may_already_have_received_these_restore =>
      'La passerelle les a peut-être déjà reçus. Restaurez-les pour les examiner ; rien n’est envoyé.';

  @override
  String get release_core_prepared_image_recovery_image_draft =>
      'Brouillon d’image';

  @override
  String get release_core_prepared_image_recovery_discard_local_copy =>
      'Supprimer la copie locale';

  @override
  String
  get release_core_prepared_image_recovery_discard_this_local_image_draft =>
      'Supprimer ce brouillon d’image local ?';

  @override
  String
  get release_core_prepared_image_recovery_image_draft_recovery_is_unavailable =>
      'La récupération des brouillons d’images est indisponible.';

  @override
  String get release_core_prepared_image_recovery_recover_image_draft =>
      'Récupérer un brouillon d’image…';

  @override
  String get release_core_session_search_mode_menu_could_not_save_search_mode =>
      'Impossible d’enregistrer le mode de recherche.';

  @override
  String get release_core_projects_pane_discover_repositories =>
      'Découvrir des dépôts';

  @override
  String
  get release_core_projects_pane_project_created_but_the_gateway_did_not_confirm =>
      'Projet créé, mais la passerelle n’a pas confirmé son idée.';

  @override
  String get release_core_projects_pane_project_idea_optional =>
      'Idée de projet (facultatif)';

  @override
  String
  get release_core_projects_pane_saved_in_the_project_description_not_a_file =>
      'Enregistrée dans la description du projet, pas dans un fichier.';

  @override
  String get release_core_project_detail_screen_new_chat_in_this_lane =>
      'Nouvelle discussion dans cette voie';

  @override
  String get release_core_project_detail_screen_review_git => 'Examiner Git';

  @override
  String get release_core_more_pane_gateway_fleet => 'Parc de passerelles';

  @override
  String
  get release_core_more_pane_connected_sessions_hermes_cloud_and_desktop_webapp =>
      'Sessions connectées, Hermes Cloud et application Web Desktop';

  @override
  String get release_core_more_pane_use_dashboard_sign_in_for_a_named_profile =>
      'Utilisez la connexion au tableau de bord pour un profil nommé. Cette ancienne API ne peut pas confirmer à quel profil appartient l’historique des discussions.';

  @override
  String get release_core_more_pane_capabilities => 'Capacités';

  @override
  String
  get release_core_more_pane_install_and_govern_skills_plugins_connectors_and_tool =>
      'Installer et gérer les compétences, extensions, connecteurs et backends d’outils';

  @override
  String get release_core_more_pane_browser_vault =>
      'Coffre-fort du navigateur';

  @override
  String
  get release_core_more_pane_site_logins_addresses_cards_and_credential_sources =>
      'Connexions aux sites, adresses, cartes et sources d’identifiants';

  @override
  String get release_core_more_pane_agent_policy => 'Politique de l’agent';

  @override
  String
  get release_core_more_pane_approvals_checkpoints_browser_access_and_shared_metrics =>
      'Approbations, points de contrôle, accès au navigateur et métriques partagées';

  @override
  String get release_core_more_pane_remote_logs_health_maintenance_and_update =>
      'Journaux distants, état du système, maintenance et mise à jour';

  @override
  String get release_core_more_pane_schedules => 'Planifications';

  @override
  String get release_core_more_pane_all_profiles_blueprints_catch_up_and_stop =>
      'Tous les profils, modèles, rattrapage et arrêt';

  @override
  String get release_core_more_pane_memory_graph => 'Graphe de mémoire';

  @override
  String get release_core_more_pane_timeline_edits_and_memory_providers =>
      'Chronologie, modifications et fournisseurs de mémoire';

  @override
  String get release_core_more_pane_providers_and_routes =>
      'Fournisseurs et routes';

  @override
  String get release_core_more_pane_keys_endpoints_delegation_and_mixtures =>
      'Clés, points de terminaison, délégation et combinaisons';

  @override
  String get release_core_more_pane_credits_and_plans => 'Crédits et offres';

  @override
  String
  get release_core_more_pane_consented_nous_billing_when_the_account_allows_it =>
      'Facturation Nous avec consentement, si le compte l’autorise';

  @override
  String
  get release_core_fleet_screen_this_gateway_does_not_offer_this_service =>
      'Cette passerelle ne propose pas ce service.';

  @override
  String
  get release_core_fleet_screen_sign_in_or_permission_required_on_this_gateway =>
      'Connexion ou autorisation requise sur cette passerelle.';

  @override
  String get release_core_fleet_screen_a_secure_gateway_address_is_required =>
      'Une adresse de passerelle sécurisée est requise.';

  @override
  String
  get release_core_fleet_screen_the_owner_changed_refresh_before_continuing =>
      'Le propriétaire a changé. Actualisez avant de continuer.';

  @override
  String
  get release_core_fleet_screen_could_not_verify_the_operation_check_the_gateway =>
      'Impossible de vérifier l’opération. Vérifiez la passerelle et actualisez.';

  @override
  String get release_core_fleet_screen_verified_ssh => 'SSH vérifié';

  @override
  String
  get release_core_fleet_screen_confirm_a_host_key_inspect_a_remote_service =>
      'Confirmer une clé d’hôte, inspecter un service distant ou ouvrir son shell';

  @override
  String get release_core_fleet_screen_cloud_and_desktop_webapp =>
      'Cloud et application Web Desktop';

  @override
  String get release_core_fleet_screen_register_an_existing_gateway_or_webapp =>
      'Enregistrer une passerelle ou une application Web existante';

  @override
  String
  get release_core_fleet_screen_sign_in_to_its_address_nothing_is_hosted =>
      'Connectez-vous à son adresse. Rien n’est hébergé sur cet appareil.';

  @override
  String get release_core_fleet_screen_fleet_updates => 'Mises à jour du parc';

  @override
  String get release_core_fleet_screen_refresh_roster => 'Actualiser la liste';

  @override
  String release_core_fleet_screen_disconnect(String gateway) {
    return 'Déconnecter $gateway';
  }

  @override
  String get release_core_fleet_screen_open_this_gateway_on_launch =>
      'Ouvrir cette passerelle au lancement';

  @override
  String
  get release_core_fleet_screen_primary_for_ares_does_not_change_the_last =>
      'Principale pour Ares ; ne change pas la dernière passerelle utilisée.';

  @override
  String get release_core_fleet_screen_reconnect_in_fleet_on_launch =>
      'Reconnecter dans le parc au lancement';

  @override
  String get release_core_fleet_screen_no_sessions_for_this_profile =>
      'Aucune session pour ce profil.';

  @override
  String get release_core_fleet_screen_more_sessions => 'Plus de sessions';

  @override
  String get release_core_fleet_screen_this_gateway_was_disconnected =>
      'Cette passerelle a été déconnectée.';

  @override
  String
  get release_core_fleet_screen_some_conversation_data_could_not_be_loaded =>
      'Certaines données de conversation n’ont pas pu être chargées.';

  @override
  String get release_core_fleet_screen_message_this_session =>
      'Écrire à cette session';

  @override
  String get release_core_fleet_screen_send_to_this_session =>
      'Envoyer à cette session';

  @override
  String get release_core_fleet_updates_screen_update_these_remote_gateways =>
      'Mettre à jour ces passerelles distantes ?';

  @override
  String
  release_core_fleet_updates_screen_this_can_restart_the_backend_and_interrupt_other(
    String gateways,
  ) {
    return 'Cela peut redémarrer le backend et interrompre d’autres utilisateurs. Ares ne sera pas mis à jour.\n\n$gateways';
  }

  @override
  String get release_core_fleet_updates_screen_update_listed_gateways =>
      'Mettre à jour les passerelles répertoriées';

  @override
  String
  get release_core_fleet_updates_screen_checks_connected_gateways_cloud_is_platform_managed_entries =>
      'Vérifie les passerelles connectées. Le Cloud est géré par la plateforme ; les entrées sans preuve d’enrôlement sont exclues.';

  @override
  String get release_core_fleet_updates_screen_check_connected_gateways =>
      'Vérifier les passerelles connectées';

  @override
  String get release_core_fleet_updates_screen_read_update_receipt =>
      'Lire le compte rendu de mise à jour';

  @override
  String get release_core_fleet_updates_screen_review_eligible_updates =>
      'Examiner les mises à jour admissibles';

  @override
  String
  get release_core_fleet_webapp_screen_account_changed_reopen_this_page =>
      'Le compte a changé. Rouvrez cette page.';

  @override
  String
  get release_core_fleet_webapp_screen_set_the_webapp_s_primary_gateway =>
      'Définir la passerelle principale de l’application Web ?';

  @override
  String
  release_core_fleet_webapp_screen_this_changes_the_shared_registry_not_the_last(
    String webapp,
    String gateway,
    String id,
  ) {
    return '$webapp → $gateway ($id)\nCela modifie le registre partagé, pas la dernière passerelle utilisée.';
  }

  @override
  String get release_core_fleet_webapp_screen_set_primary =>
      'Définir comme principale';

  @override
  String get release_core_fleet_webapp_screen_serving_profile =>
      'Profil de service';

  @override
  String get release_core_fleet_webapp_screen_hermes_cloud => 'Hermes Cloud';

  @override
  String get release_core_fleet_webapp_screen_discover_signed_in_agents =>
      'Découvrir les agents connectés';

  @override
  String release_core_fleet_webapp_screen_organisation(String organisation) {
    return 'Organisation : $organisation';
  }

  @override
  String get release_core_fleet_webapp_screen_no_agents_available =>
      'Aucun agent disponible.';

  @override
  String get release_core_fleet_webapp_screen_existing_desktop_webapp =>
      'Application Web Desktop existante';

  @override
  String
  get release_core_fleet_webapp_screen_check_gateway_and_web_access_status =>
      'Vérifier l’état de la passerelle et de l’accès Web';

  @override
  String
  get release_core_fleet_webapp_screen_these_settings_belong_to_the_machine_serving_this =>
      'Ces paramètres appartiennent à la machine qui héberge cette application Web. La publication et les redémarrages ne sont pas des actions distantes.';

  @override
  String get release_core_fleet_webapp_screen_read_webapp_gateway_registry =>
      'Lire le registre des passerelles de l’application Web';

  @override
  String get release_core_fleet_webapp_screen_last_used => 'Dernière utilisée';

  @override
  String get release_core_fleet_webapp_screen_primary => 'Principale';

  @override
  String release_core_fleet_webapp_screen_set_primary_2(String gateway) {
    return 'Définir comme principale : $gateway';
  }

  @override
  String get release_core_fleet_webapp_screen_read_shared_display_preferences =>
      'Lire les préférences d’affichage partagées';

  @override
  String
  get release_core_fleet_webapp_screen_chat_text_direction_on_this_webapp_and_desktop =>
      'Sens du texte des discussions dans cette application Web et sur Desktop';

  @override
  String release_core_schedule_desk_screen_created_on(
    String job,
    String profile,
  ) {
    return '$job créé sur $profile.';
  }

  @override
  String
  get release_core_schedule_desk_screen_the_list_covers_every_profile_on_this_gateway =>
      'La liste couvre tous les profils de cette passerelle. Les actions d’arrêt, de pause, de rattrapage, de livraison et les modèles sont envoyés au profil propriétaire de la tâche.';

  @override
  String get release_core_schedule_desk_screen_a_run_is_in_progress =>
      'Une exécution est en cours';

  @override
  String get release_core_schedule_desk_screen_no_current_run =>
      'Aucune exécution en cours';

  @override
  String release_core_schedule_desk_screen_stop_requested_for(String job) {
    return 'Arrêt demandé pour $job.';
  }

  @override
  String release_core_schedule_desk_screen_no_run_was_in_flight_for(
    String job,
  ) {
    return 'Aucune exécution n’était en cours pour $job.';
  }

  @override
  String get release_core_schedule_desk_screen_stop_current_run =>
      'Arrêter l’exécution en cours';

  @override
  String get release_core_schedule_desk_screen_pause_future_runs =>
      'Suspendre les prochaines exécutions';

  @override
  String get release_core_schedule_desk_screen_resume_future_runs =>
      'Reprendre les prochaines exécutions';

  @override
  String get release_core_schedule_desk_screen_catch_up_default =>
      'Rattrapage par défaut';

  @override
  String get release_core_schedule_desk_screen_run_one_missed =>
      'Rattraper une exécution manquée';

  @override
  String get release_core_schedule_desk_screen_skip_missed =>
      'Ignorer les exécutions manquées';

  @override
  String get release_core_schedule_desk_screen_blueprint_recipes =>
      'Recettes de modèles';

  @override
  String get release_core_schedule_desk_screen_profile_for_the_new_job =>
      'Profil de la nouvelle tâche';

  @override
  String release_core_schedule_desk_screen_create(String blueprint) {
    return 'Créer $blueprint';
  }

  @override
  String get release_core_schedule_desk_screen_loading_delivery_targets =>
      'Chargement des destinations de livraison';

  @override
  String release_core_schedule_desk_screen_no_home_channel(String target) {
    return '$target (aucun canal d’accueil)';
  }

  @override
  String release_core_memory_graph_screen_edit(String label) {
    return 'Modifier $label';
  }

  @override
  String get release_core_memory_graph_screen_content => 'Contenu';

  @override
  String get release_core_memory_graph_screen_archive_skill =>
      'Archiver la compétence';

  @override
  String get release_core_memory_graph_screen_delete_memory =>
      'Supprimer le souvenir';

  @override
  String release_core_memory_graph_screen_archive_on_it_can_be_restored_on_the(
    String label,
    String profile,
  ) {
    return 'Archiver $label sur $profile ? La restauration est possible sur l’hôte avec le Curator.';
  }

  @override
  String release_core_memory_graph_screen_delete_from_this_removes_that_memory(
    String label,
    String profile,
  ) {
    return 'Supprimer $label de $profile ? Cela supprime ce souvenir.';
  }

  @override
  String get release_core_memory_graph_screen_filter => 'Filtre';

  @override
  String get release_core_memory_graph_screen_timeline => 'Chronologie';

  @override
  String get release_core_memory_graph_screen_play_timeline =>
      'Lire la chronologie';

  @override
  String get release_core_memory_graph_screen_layout_code =>
      'Code de disposition';

  @override
  String get release_core_memory_graph_screen_external_memory_providers =>
      'Fournisseurs de mémoire externes';

  @override
  String
  get release_core_memory_graph_screen_a_value_is_stored_leave_blank_to_keep =>
      'Une valeur est enregistrée. Laissez vide pour la conserver.';

  @override
  String get release_core_memory_graph_screen_save_provider =>
      'Enregistrer le fournisseur';

  @override
  String release_core_workspace_profiles_screen_applies_to(String profile) {
    return 'S’applique à : $profile';
  }

  @override
  String get release_core_workspace_profiles_screen_choose_another_profile =>
      'Choisir un autre profil';

  @override
  String
  get release_core_workspace_profiles_screen_could_not_verify_the_selected_profile_on_this =>
      'Impossible de vérifier le profil sélectionné sur cette passerelle.';

  @override
  String get release_core_workspace_profiles_screen_create_profile =>
      'Créer un profil';

  @override
  String get release_core_workspace_profiles_screen_new_profile_id =>
      'Identifiant du nouveau profil';

  @override
  String get release_core_assets_screen_links => 'Liens';

  @override
  String get release_core_workspace_picker_no_matching_items =>
      'Aucun élément correspondant.';

  @override
  String get release_core_workspace_picker_save_layout =>
      'Enregistrer la disposition';

  @override
  String get release_core_workspace_picker_layout_name =>
      'Nom de la disposition';

  @override
  String
  get release_core_workspace_popout_this_chat_already_has_a_pop_out_window =>
      'Cette discussion dispose déjà d’une fenêtre détachée.';

  @override
  String
  get release_core_workspace_popout_could_not_open_this_saved_chat_check_the =>
      'Impossible d’ouvrir cette discussion enregistrée. Vérifiez la connexion et réessayez.';

  @override
  String
  get release_core_popout_bootstrap_use_the_main_window_to_change_your_connection =>
      'Utilisez la fenêtre principale pour changer de connexion.';

  @override
  String get release_core_guarded_save_refused =>
      'Ce fichier ne peut pas être enregistré par la passerelle';

  @override
  String get release_core_guarded_save_unavailable =>
      'L’enregistrement protégé n’est pas disponible sur cette passerelle';

  @override
  String release_core_git_files_changed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers modifiés pendant ce tour',
      one: '1 fichier modifié pendant ce tour',
    );
    return '$_temp0';
  }

  @override
  String release_core_git_entries_omitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count entrées Git ont été omises, car leur affichage n’était pas sûr.',
      one: '1 entrée Git a été omise, car son affichage n’était pas sûr.',
    );
    return '$_temp0';
  }

  @override
  String get release_core_git_staged => 'Indexé';

  @override
  String get release_core_session_sort_recent => 'Activité récente';

  @override
  String get release_core_session_sort_created => 'Création la plus récente';

  @override
  String get release_core_session_sort_status => 'En cours d’abord';

  @override
  String get release_core_session_sort_tokens => 'Le plus de jetons';

  @override
  String get release_core_session_sort_cost => 'Coût le plus élevé';

  @override
  String get release_core_session_group_standard => 'Regroupement par défaut';

  @override
  String get release_core_session_group_status => 'Regrouper par état';

  @override
  String get release_core_session_group_project => 'Regrouper par projet';

  @override
  String release_core_session_tokens(int count) {
    return '$count jetons';
  }

  @override
  String release_core_search_gateway_mode(String mode) {
    return '$mode (passerelle)';
  }

  @override
  String release_core_search_mode_tooltip(String label, String mode) {
    return '$label : $mode';
  }

  @override
  String get release_core_image_recovery_new_turn =>
      'L’envoi crée un nouveau tour';

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
    return 'Analyse : $state';
  }

  @override
  String get release_core_discovery_enabled => 'activée';

  @override
  String get release_core_discovery_disabled => 'désactivée';

  @override
  String get release_core_discovery_none => 'aucun';

  @override
  String release_core_discovery_roots(String paths) {
    return 'Répertoires racines à analyser : $paths';
  }

  @override
  String release_core_discovery_excluded(String paths) {
    return 'Sous-arborescences exclues : $paths';
  }

  @override
  String release_core_discovery_repository_sessions(String path, int count) {
    return '$path\nSessions : $count';
  }

  @override
  String get release_core_projects_local_only =>
      'Cette passerelle Hermes est antérieure aux projets côté serveur ; les discussions ne sont donc regroupées que sur cet appareil. Mettez à jour Hermes pour partager les mêmes projets entre vos appareils.';

  @override
  String get release_core_fleet_no_address =>
      'Pas encore d’adresse de passerelle';

  @override
  String release_core_fleet_diagnostics(String version, String access) {
    return 'Passerelle $version · $access';
  }

  @override
  String get release_core_schedule_builtin => 'intégré';

  @override
  String get release_core_memory_gateway_profile => 'passerelle';

  @override
  String release_core_memory_profile_summary(String profile, String gateway) {
    return 'Profil $profile sur $gateway. Le code de partage enregistre uniquement le zoom, le temps et les filtres.';
  }

  @override
  String release_core_memory_layers_summary(
    int memoryBytes,
    int userBytes,
    String provider,
  ) {
    return 'Mémoire intégrée : $memoryBytes octets, utilisateur : $userBytes octets. Fournisseur actif : $provider.';
  }

  @override
  String get release_core_memory_kind_all => 'Tous';

  @override
  String get release_core_memory_kind_skill => 'Compétences';

  @override
  String get release_core_memory_kind_memory => 'Mémoire';

  @override
  String get release_core_workspace_failure_stale => 'connexion modifiée';

  @override
  String get release_core_workspace_failure_unbound =>
      'aucun répertoire de travail vérifié';

  @override
  String get release_core_workspace_failure_denied => 'autorisation refusée';

  @override
  String get release_core_workspace_failure_ineligible =>
      'opération non autorisée pour ce fichier';

  @override
  String get release_core_workspace_failure_unsupported =>
      'non pris en charge par cette passerelle';

  @override
  String get release_core_workspace_failure_mismatch => 'état distant modifié';

  @override
  String get release_core_workspace_failure_invalid =>
      'réponse de passerelle invalide';

  @override
  String get release_core_workspace_failure_insecure =>
      'connexion sécurisée requise';

  @override
  String get release_core_workspace_failure_unavailable =>
      'passerelle indisponible';

  @override
  String get release_core_queue_state_queued => 'En attente';

  @override
  String get release_core_queue_state_started => 'Démarré';

  @override
  String get release_core_queue_state_unknown => 'Résultat inconnu';

  @override
  String get release_core_unknown_state => 'Inconnu';

  @override
  String get release_core_fleet_state_idle => 'Hors ligne';

  @override
  String get release_core_fleet_state_connected => 'Connecté';

  @override
  String get release_core_fleet_state_reconnecting => 'Reconnexion…';

  @override
  String get release_core_fleet_state_sessionExpired => 'Déconnecté';

  @override
  String get release_core_fleet_state_failed => 'Échec de la connexion';

  @override
  String release_core_workspace_operation_failed(String reason) {
    return 'L’opération de la passerelle n’a pas pu être confirmée : $reason.';
  }

  @override
  String get release_core_workspace_invalid_data =>
      'Impossible de vérifier les données ou la saisie. Vérifiez-les et réessayez.';

  @override
  String
  get release_core_parallel_workspace_layout_changed_in_this_window_but_could_not =>
      'La disposition a changé dans cette fenêtre, mais n’a pas pu être enregistrée.';

  @override
  String get release_core_parallel_workspace_first_pane => 'Premier volet';

  @override
  String get release_core_parallel_workspace_second_pane => 'Second volet';

  @override
  String get release_core_parallel_workspace_unavailable_page =>
      'Page indisponible';

  @override
  String release_core_parallel_workspace_close_a_tab_first_maximum(
    String maximum,
  ) {
    return 'Fermez d’abord un onglet (maximum : $maximum).';
  }

  @override
  String get release_core_parallel_workspace_dock_beside_current_pane =>
      'Ancrer à côté du volet actuel';

  @override
  String get release_core_parallel_workspace_add_chat =>
      'Ajouter une discussion';

  @override
  String
  get release_core_parallel_workspace_action_failed_check_the_connection_and_try_again =>
      'Échec de l’action. Vérifiez la connexion et réessayez.';

  @override
  String
  get release_core_parallel_workspace_close_a_tab_before_reopening_another =>
      'Fermez un onglet avant d’en rouvrir un autre.';

  @override
  String release_core_parallel_workspace_replace_layout(String name) {
    return 'Remplacer la disposition « $name » ?';
  }

  @override
  String
  get release_core_parallel_workspace_layout_limit_reached_replace_an_existing_layout =>
      'Limite de dispositions atteinte. Remplacez une disposition existante.';

  @override
  String get release_core_parallel_workspace_restore_layout =>
      'Restaurer la disposition';

  @override
  String get release_core_parallel_workspace_workspace_options =>
      'Options de l’espace de travail';

  @override
  String get release_core_parallel_workspace_dock_another_pane =>
      'Ancrer un autre volet';

  @override
  String get release_core_parallel_workspace_swap_panes =>
      'Permuter les volets';

  @override
  String get release_core_parallel_workspace_undock_second_pane =>
      'Détacher le second volet';

  @override
  String get release_core_parallel_workspace_arrange_side_by_side =>
      'Disposer côte à côte';

  @override
  String get release_core_parallel_workspace_arrange_top_to_bottom =>
      'Disposer de haut en bas';

  @override
  String release_core_parallel_workspace_change_split_size(String percent) {
    return 'Modifier la proportion de partage ($percent %)';
  }

  @override
  String get release_core_parallel_workspace_focus_pane_full_screen =>
      'Afficher le volet actif en plein écran';

  @override
  String get release_core_parallel_workspace_open_chat_in_new_window =>
      'Ouvrir la discussion dans une nouvelle fenêtre';

  @override
  String get release_core_parallel_workspace_hide_pane_keep_running =>
      'Masquer le volet (laisser en cours)';

  @override
  String get release_core_parallel_workspace_previous_tab => 'Onglet précédent';

  @override
  String get release_core_parallel_workspace_next_tab => 'Onglet suivant';

  @override
  String get release_core_parallel_workspace_move_tab_left =>
      'Déplacer l’onglet vers la gauche';

  @override
  String get release_core_parallel_workspace_move_tab_right =>
      'Déplacer l’onglet vers la droite';

  @override
  String get release_core_parallel_workspace_reload_current_tab =>
      'Recharger l’onglet actuel';

  @override
  String get release_core_parallel_workspace_close_tab => 'Fermer l’onglet';

  @override
  String get release_core_parallel_workspace_close_other_tabs =>
      'Fermer les autres onglets';

  @override
  String get release_core_parallel_workspace_close_tabs_to_the_right =>
      'Fermer les onglets à droite';

  @override
  String get release_core_parallel_workspace_close_all_tabs =>
      'Fermer tous les onglets';

  @override
  String get release_core_parallel_workspace_reopen_closed_tab =>
      'Rouvrir l’onglet fermé';

  @override
  String get release_core_parallel_workspace_save_named_layout =>
      'Enregistrer une disposition nommée';

  @override
  String get release_core_parallel_workspace_restore_named_layout =>
      'Restaurer une disposition nommée';

  @override
  String get release_core_parallel_workspace_refresh_chat_list =>
      'Actualiser la liste des discussions';

  @override
  String get release_core_parallel_workspace_workspace_tools =>
      'Outils de l’espace de travail';

  @override
  String get release_core_parallel_workspace_choose_a_chat_for_this_pane =>
      'Choisir une discussion pour ce volet';

  @override
  String release_core_parallel_workspace_choose_chat_for(String pane) {
    return 'Choisir une discussion pour $pane';
  }

  @override
  String get release_core_parallel_workspace_add_a_chat_to_start_a_workspace =>
      'Ajoutez une discussion pour démarrer un espace de travail.';

  @override
  String get release_core_parallel_workspace_select_a_tab_to_show_its_pane =>
      'Sélectionnez un onglet pour afficher son volet.';

  @override
  String get release_core_parallel_workspace_parallel_workspace =>
      'Espace de travail parallèle';

  @override
  String get release_core_parallel_workspace_show_workspace =>
      'Afficher l’espace de travail';

  @override
  String get release_core_parallel_workspace_could_not_load_chats_retry =>
      'Impossible de charger les discussions. Réessayer';

  @override
  String release_core_parallel_workspace_close(String pane) {
    return 'Fermer $pane';
  }

  @override
  String release_core_parallel_workspace_switch_pane(String pane) {
    return 'Changer de volet : $pane';
  }

  @override
  String get release_core_workspace_registry_session_id_copied =>
      'Identifiant de session copié.';

  @override
  String get release_core_workspace_registry_chat_details =>
      'Détails de la discussion';

  @override
  String get release_core_workspace_registry_server_default =>
      'Valeur par défaut du serveur';

  @override
  String get release_core_workspace_registry_session_id =>
      'Identifiant de session';

  @override
  String get release_core_workspace_registry_title => 'Titre';

  @override
  String get release_core_workspace_label_terminals => 'Terminaux';

  @override
  String get release_core_workspace_label_copy_id =>
      'Copier l’identifiant de session';

  @override
  String get release_core_workspace_label_contributions => 'Contributions';

  @override
  String get release_core_workspace_owner_inactive =>
      'Le propriétaire de cet espace de travail n’est plus actif.';

  @override
  String get release_core_workspace_select_chat =>
      'Sélectionnez d’abord une discussion.';

  @override
  String get release_core_workspace_chat_unavailable =>
      'Cette discussion n’est pas disponible pour cette connexion.';

  @override
  String get release_core_workspace_page_unavailable =>
      'Cette page n’est pas disponible pour cette connexion.';

  @override
  String release_core_client_queue_count(int count) {
    return '$count en attente';
  }

  @override
  String release_core_client_queue_paused_count(int count) {
    return '$count en attente — en pause';
  }

  @override
  String release_core_git_diff_truncated(String diff) {
    return '$diff\n… tronqué';
  }

  @override
  String get release_core_search_no_models =>
      'Hermes n’a renvoyé aucun modèle configuré et sélectionnable.';

  @override
  String get release_core_chat_archive_unavailable =>
      'L’action d’archivage de la discussion est indisponible.';

  @override
  String get release_core_chat_pin_unconfirmed =>
      'L’état d’épinglage n’a pas été confirmé.';

  @override
  String get release_core_chat_archive_unconfirmed =>
      'L’état d’archivage n’a pas été confirmé.';

  @override
  String get release_core_chat_archive_history_unavailable =>
      'Historique archivé indisponible';

  @override
  String get release_core_quick_chat_history_unavailable =>
      'Historique des discussions rapides indisponible';

  @override
  String get release_core_chat_project_ownership_unavailable =>
      'Appartenance au projet indisponible';

  @override
  String get release_core_chat_unknown_project => 'Projet inconnu';

  @override
  String get release_core_chat_local_search_fallback =>
      'Recherche de messages indisponible. Affichage des résultats locaux.';

  @override
  String release_core_fleet_update_eligible(String version) {
    return 'Admissible · $version';
  }

  @override
  String get release_core_fleet_update_state_1 => 'Ignoré : même installation';

  @override
  String get release_core_fleet_update_state_2 => 'Non vérifié';

  @override
  String get release_core_fleet_update_state_3 => 'Ignoré : géré par le Cloud';

  @override
  String get release_core_fleet_update_state_4 =>
      'Ignoré : non enrôlé comme passerelle directe';

  @override
  String get release_core_fleet_update_state_5 =>
      'Ignoré : déconnecté ou occupé';

  @override
  String get release_core_fleet_update_state_6 =>
      'Aucune mise à jour applicable';

  @override
  String get release_core_fleet_update_state_7 =>
      'Impossible de vérifier l’admissibilité';

  @override
  String get release_core_fleet_update_state_8 =>
      'Ignoré : obsolète, occupé ou déjà demandé';

  @override
  String get release_core_fleet_update_state_9 => 'Demande en cours';

  @override
  String get release_core_fleet_update_state_10 =>
      'Accepté ; compte rendu indisponible';

  @override
  String get release_core_fleet_update_state_11 =>
      'Accepté ; en attente du compte rendu';

  @override
  String get release_core_fleet_update_state_12 =>
      'Ignoré : une discussion est en cours sur cette installation';

  @override
  String get release_core_fleet_update_state_13 =>
      'Non confirmé ; ne pas renvoyer automatiquement';

  @override
  String get release_core_fleet_update_state_14 =>
      'Reconnectez-vous pour vérifier le compte rendu';

  @override
  String get release_core_fleet_update_state_15 => 'Compte rendu indisponible';

  @override
  String get release_core_fleet_update_state_16 =>
      'En attente du compte rendu correspondant';

  @override
  String get release_core_fleet_update_state_17 =>
      'Mis à jour ; suivi nécessaire';

  @override
  String get release_core_fleet_update_state_19 => 'Partiellement mis à jour';

  @override
  String get release_core_fleet_update_state_20 => 'Échec de la mise à jour';

  @override
  String get release_core_fleet_update_state_21 => 'Non confirmé';

  @override
  String get release_core_cloud_status_ready => 'Prêt';

  @override
  String get release_core_cloud_status_online => 'En ligne';

  @override
  String get release_core_cloud_status_stopped => 'Arrêté';

  @override
  String get release_core_cloud_status_error => 'Erreur';

  @override
  String get ng_release_more_contributions_subtitle =>
      'Cartes de réponse examinées pour cette connexion';

  @override
  String get ng_release_more_gateway_fleet => 'Parc de passerelles';

  @override
  String get ng_release_more_memory_graph => 'Graphe de mémoire';

  @override
  String get ng_release_more_memory_graph_subtitle =>
      'Chronologie, modifications et fournisseurs de mémoire';

  @override
  String get ng_release_more_capabilities_subtitle =>
      'Installer et gérer les compétences, extensions, connecteurs et backends d’outils';

  @override
  String get ng_release_more_browser_vault => 'Coffre-fort du navigateur';

  @override
  String get ng_release_more_browser_vault_subtitle =>
      'Connexions aux sites, adresses, cartes et sources d’identifiants';

  @override
  String get ng_release_more_agent_policy => 'Politique de l’agent';

  @override
  String get ng_release_more_agent_policy_subtitle =>
      'Approbations, points de contrôle, accès au navigateur et métriques partagées';

  @override
  String get ng_release_more_schedules => 'Planifications';

  @override
  String get ng_release_more_schedules_subtitle =>
      'Tous les profils, modèles, rattrapage et arrêt';

  @override
  String get ng_release_more_host_subtitle =>
      'Journaux distants, état du système, maintenance et mise à jour';

  @override
  String get ng_release_more_providers_routes => 'Fournisseurs et routes';

  @override
  String get ng_release_more_providers_routes_subtitle =>
      'Clés, points de terminaison, délégation et combinaisons';

  @override
  String get ng_release_more_credits_plans => 'Crédits et offres';

  @override
  String get ng_release_more_credits_plans_subtitle =>
      'Facturation Nous avec consentement, si le compte l’autorise';

  @override
  String get ng_release_sign_in_or => 'ou';

  @override
  String ng_release_deployment_sign_in_hint(String message) {
    return '$message Vous pouvez toujours vous connecter avec un jeton de session du déploiement à l’étape suivante.';
  }

  @override
  String get ng_release_message_search_unavailable =>
      'Recherche de messages indisponible. Affichage des résultats locaux.';

  @override
  String ng_release_insights_days(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours',
      one: '$days jour',
    );
    return '$_temp0';
  }

  @override
  String get ng_release_signed_in_you => 'vous';

  @override
  String get release_chat_unsent_prompt_gone =>
      'Ce prompt non envoyé n’est plus dans la file d’attente.';

  @override
  String ng_release_attachment_not_attached(String name) {
    return 'La passerelle n’a pas joint $name.';
  }

  @override
  String get ng_release_gateway_not_connected =>
      'Pas encore connecté à la passerelle.';

  @override
  String get ng_release_gateway_unreachable =>
      'Impossible de joindre la passerelle.';

  @override
  String get ng_release_projects_scope_changed =>
      'Le périmètre des projets n’est plus sélectionné';

  @override
  String get ng_release_missing_providers => 'Fournisseurs manquants';

  @override
  String get ng_release_missing_tasks => 'Tâches manquantes';

  @override
  String ng_release_age_minutes(int count) {
    return '$count min';
  }

  @override
  String ng_release_age_hours(int count) {
    return '$count h';
  }

  @override
  String ng_release_age_days(int count) {
    return '$count j';
  }

  @override
  String ng_release_age_weeks(int count) {
    return '$count sem.';
  }

  @override
  String ng_release_age_years(int count) {
    return '$count a';
  }

  @override
  String ng_release_compact_billions(String count) {
    return '$count Md';
  }

  @override
  String ng_release_compact_millions(String count) {
    return '$count M';
  }

  @override
  String ng_release_compact_thousands(String count) {
    return '$count k';
  }

  @override
  String ng_release_token_thousands(String count) {
    return '$count k';
  }

  @override
  String ng_release_elapsed_minutes_seconds(int minutes, int seconds) {
    return '$minutes min $seconds s';
  }

  @override
  String ng_release_elapsed_seconds(int seconds) {
    return '$seconds s';
  }

  @override
  String get ng_release_notification_foreground =>
      'Ares était affiché à l’écran';

  @override
  String get ng_release_notification_stopped => 'le tour a été arrêté';

  @override
  String get ng_release_more_parallel_workspace =>
      'Espace de travail parallèle';

  @override
  String get ng_release_more_parallel_workspace_subtitle =>
      'Ouvrez plusieurs discussions dans des onglets ou côte à côte.';

  @override
  String get release_chat_unknown_model => 'inconnu';

  @override
  String release_chat_profile_default(String model) {
    return 'Valeur par défaut du profil : $model';
  }

  @override
  String release_chat_profile_default_provider(String model, String provider) {
    return 'Valeur par défaut du profil : $model • $provider';
  }

  @override
  String get release_chat_choose_provider =>
      'Ce modèle est disponible auprès de plusieurs fournisseurs. Choisissez un fournisseur pour continuer.';

  @override
  String get release_chat_slash_needs_gateway =>
      'Les commandes slash nécessitent la passerelle Desktop';

  @override
  String get release_chat_recovering_without_resending =>
      'Récupération sans renvoi';

  @override
  String get release_chat_live_request_unreachable =>
      'Désolé, je n’ai pas pu joindre Hermes pour cette demande.';

  @override
  String release_chat_live_working(String tool) {
    return 'Hermes travaille : $tool. Ce n’est pas encore terminé.';
  }

  @override
  String get release_chat_live_finished_without_spoken_result =>
      'Hermes a terminé cette demande sans résultat vocal.';

  @override
  String get release_chat_reply_language_unavailable =>
      'La langue de réponse sélectionnée est indisponible';

  @override
  String get release_chat_reply_voice_unavailable =>
      'La voix de réponse sélectionnée est indisponible';

  @override
  String get release_chat_reply_voice_configuration_unavailable =>
      'La configuration de la voix de réponse est indisponible';

  @override
  String get release_chat_notification_review_action =>
      'Ouvrez la discussion pour examiner l’action demandée.';

  @override
  String get release_chat_notification_respond =>
      'Ouvrez la discussion pour répondre.';

  @override
  String get release_chat_start_new_main_window =>
      'Démarrez une nouvelle discussion dans la fenêtre principale.';

  @override
  String get release_chat_no_desktop_gateway => 'Aucune passerelle Desktop';

  @override
  String get release_chat_attachment_preparation_cancelled =>
      'La préparation de la pièce jointe a été annulée.';

  @override
  String get release_chat_approval_authority_revoked =>
      'Le pouvoir d’approbation a été révoqué.';

  @override
  String get release_chat_gateway_session_disconnected =>
      'La session de la passerelle Desktop n’est plus connectée';

  @override
  String get release_chat_stop_requested =>
      'Arrêt demandé. En attente de la fin de l’exécution de Hermes.';

  @override
  String release_chat_stop_request_failed(String error) {
    return 'Impossible de demander l’arrêt : $error';
  }

  @override
  String get release_chat_queued_prompt_not_sent =>
      'Le prompt en attente n’a pas été envoyé.';

  @override
  String get release_chat_running_turn_unreachable =>
      'Le tour en cours n’a pas pu être joint. Reconnexion sans renvoi.';

  @override
  String get release_chat_wait_for_composer =>
      'Attendez que la zone de rédaction soit disponible.';

  @override
  String get release_chat_find_in_transcript =>
      'Rechercher dans la transcription';

  @override
  String get release_chat_open_browser_preview =>
      'Ouvrir l’aperçu du navigateur';

  @override
  String get release_chat_more_tools => 'Autres outils de discussion';

  @override
  String get release_chat_queue_until_finished =>
      'Mettre en attente jusqu’à la fin de ce tour';

  @override
  String get release_chat_format_bold => 'Gras';

  @override
  String get release_chat_format_italic => 'Italique';

  @override
  String get ng_release_chat_gateway_queue_requirements =>
      'La file d’attente de la passerelle nécessite une discussion rattachée et un prompt contenant uniquement du texte.';

  @override
  String get ng_release_chat_start_new_main_screen =>
      'Démarrez une nouvelle discussion depuis l’écran principal des discussions.';

  @override
  String get ng_release_chat_image => 'image';

  @override
  String ng_release_chat_tool_seconds(String seconds) {
    return '$seconds s';
  }

  @override
  String get release_preview_chat_changed =>
      'La discussion a changé. Reconnectez l’aperçu pour continuer.';

  @override
  String get release_preview_authenticating_chat =>
      'Authentification de la discussion…';

  @override
  String release_preview_unavailable_reason(String reason) {
    return 'Aperçu indisponible : $reason';
  }

  @override
  String get release_preview_operation_failed =>
      'Échec de l’opération d’aperçu.';

  @override
  String get release_preview_added_to_draft =>
      'Ajouté au brouillon. Rien n’a été envoyé.';

  @override
  String get release_preview_open_site_title => 'Ouvrir ce site ?';

  @override
  String release_preview_open_site_body(String origin) {
    return '$origin\n\nLe mode lecture charge uniquement ce document. Il ne partage ni les cookies, ni les identifiants de connexion, ni la page avec Hermes.';
  }

  @override
  String get release_preview_open_site => 'Ouvrir le site';

  @override
  String get release_preview_discard_pins_title =>
      'Abandonner les repères non ajoutés au brouillon ?';

  @override
  String get release_preview_keep_pins => 'Conserver les repères';

  @override
  String get release_preview_share_page_title =>
      'Partager cette page avec cette discussion ?';

  @override
  String release_preview_share_page_body(String origin) {
    return 'Hermes peut lire le texte affiché et la liste des éléments de $origin, et faire défiler ce volet. Toute navigation met fin au partage. Les formulaires et les identifiants ne sont pas partagés.';
  }

  @override
  String get release_preview_share_page => 'Partager la page';

  @override
  String release_preview_comment_number(int number) {
    return 'Commentaire n° $number';
  }

  @override
  String get release_preview_note => 'Note';

  @override
  String get release_preview_keep_pin => 'Conserver le repère';

  @override
  String get release_preview_title => 'Aperçu du navigateur';

  @override
  String get release_preview_hide => 'Masquer l’aperçu';

  @override
  String get release_preview_close_and_forget => 'Fermer et oublier la page';

  @override
  String get release_preview_site_address => 'Adresse du site';

  @override
  String get release_preview_go_to_address => 'Aller à l’adresse';

  @override
  String get release_preview_forward => 'Suivant';

  @override
  String get release_preview_reload => 'Recharger';

  @override
  String get release_preview_share_with_hermes =>
      'Partager la page avec Hermes';

  @override
  String get release_preview_stop_sharing => 'Arrêter le partage de la page';

  @override
  String get release_preview_annotate => 'Annoter un élément ou une zone';

  @override
  String get release_preview_reader_console => 'Console de lecture';

  @override
  String get release_preview_reconnect => 'Reconnecter l’aperçu';

  @override
  String get release_preview_reader_mode_help =>
      'Mode lecture : HTML et texte. Aucun script, aucune ressource intégrée ni aucun profil de navigateur connecté.';

  @override
  String release_preview_sharing_origin(String origin) {
    return 'Lecteur partagé avec cette discussion : $origin';
  }

  @override
  String get release_preview_annotation_help =>
      'Touchez un élément ou tracez une zone pour ajouter un commentaire.';

  @override
  String get release_preview_reader_requests =>
      'Requêtes du lecteur (JavaScript désactivé)';

  @override
  String release_preview_selected_requests(int count) {
    return '$count sélectionnées · JavaScript désactivé';
  }

  @override
  String get release_preview_copy_all => 'Tout copier';

  @override
  String get release_preview_copy_selected => 'Copier la sélection';

  @override
  String get release_preview_add_log_to_draft =>
      'Ajouter le journal au brouillon';

  @override
  String release_preview_requests_draft(String log) {
    return 'Requêtes du lecteur :\n$log';
  }

  @override
  String release_preview_add_pins_to_draft(int count) {
    return 'Ajouter $count au brouillon';
  }

  @override
  String release_preview_request_loaded(String origin, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments du lecteur',
      one: '$count élément du lecteur',
    );
    return 'HTTP 200 · $origin · $_temp0';
  }

  @override
  String release_preview_annotation_intro(String origin) {
    return 'Examinez ces commentaires sur l’aperçu de $origin. Les captures jointes sont numérotées dans le même ordre.';
  }

  @override
  String get release_preview_reader_region => 'zone du lecteur';

  @override
  String get release_preview_capture_failed =>
      'Impossible de capturer ces pixels.';

  @override
  String get release_preview_address_not_approved =>
      'Cette adresse est en dehors de l’origine autorisée pour l’aperçu.';

  @override
  String get release_preview_page_limit =>
      'La page dépasse la limite du lecteur.';

  @override
  String get release_preview_page_unreadable => 'La page n’a pas pu être lue.';

  @override
  String get release_preview_page_complex =>
      'Cette page est trop complexe pour le mode lecture.';

  @override
  String release_preview_http_failed(int statusCode) {
    return 'HTTP $statusCode. Aucune redirection n’a été suivie et aucune connexion à un compte n’a été effectuée.';
  }

  @override
  String get release_preview_unsupported_type =>
      'Seuls le HTML et le texte brut peuvent être ouverts en mode lecture.';

  @override
  String get release_preview_load_insecure =>
      'Le site n’a pas pu être chargé de manière sécurisée.';

  @override
  String get release_preview_crop_limit =>
      'La capture de l’aperçu dépasse sa limite.';

  @override
  String get release_preview_image_unreadable =>
      'L’image sélectionnée est vide ou illisible.';

  @override
  String get release_preview_image_budget =>
      'L’image sélectionnée dépasse la limite de 64 MiB du brouillon.';

  @override
  String get release_preview_image_format =>
      'Format d’image non pris en charge. Choisissez une image JPEG, PNG ou WebP.';

  @override
  String get release_preview_image_decode =>
      'L’image JPEG, PNG ou WebP sélectionnée n’a pas pu être décodée en toute sécurité.';

  @override
  String get release_preview_image_sanitize =>
      'Impossible de nettoyer cette image. Choisissez une image JPEG, PNG ou WebP valide.';

  @override
  String get release_preview_draft_budget =>
      'Les pièces jointes sont limitées à un total de 64 MiB par brouillon.';

  @override
  String get release_preview_generic_file_limit =>
      'Les fichiers génériques sont limités à 16 MiB chacun.';

  @override
  String get release_preview_image_not_sanitized =>
      'Les images distantes doivent être nettoyées avant l’envoi.';

  @override
  String get release_preview_stage_failed =>
      'Impossible d’ajouter les éléments de l’aperçu au brouillon. Réessayez.';

  @override
  String get release_misc_find_hermes_on_lan =>
      'Rechercher Hermes sur le réseau local';

  @override
  String release_misc_discovery_failed(String error) {
    return 'Échec de la découverte : $error';
  }

  @override
  String get release_misc_no_lan_servers =>
      'Aucun serveur Hermes trouvé sur le réseau local.';

  @override
  String release_misc_api_key_rejected(String endpoint, int statusCode) {
    return 'La clé API a été rejetée par $endpoint (HTTP $statusCode).';
  }

  @override
  String get release_misc_api_key_required =>
      'Le serveur nécessite une clé API. Saisissez votre API_SERVER_KEY.';

  @override
  String release_misc_gateway_not_found(String endpoint) {
    return 'Le point de terminaison de la passerelle $endpoint a renvoyé HTTP 404. Vérifiez le préfixe de chemin de la passerelle et les routes du proxy inverse.';
  }

  @override
  String release_misc_gateway_http_error(String endpoint, int statusCode) {
    return 'Le point de terminaison de la passerelle $endpoint a renvoyé HTTP $statusCode.';
  }

  @override
  String release_misc_gateway_unreachable(String endpoint) {
    return 'Impossible de joindre le point de terminaison de la passerelle $endpoint.';
  }

  @override
  String get release_core_schedule_invalid_delivery_target =>
      'Destination de livraison non valide';

  @override
  String get release_core_file_save_direct_only =>
      'Seul un fichier situé directement dans le répertoire de travail peut être enregistré.';

  @override
  String get release_core_file_save_hidden =>
      'La passerelle ne peut pas enregistrer les fichiers masqués.';

  @override
  String get rel_admin_choose_provider =>
      'Choisissez un fournisseur et un modèle.';

  @override
  String get rel_admin_known_effort => 'Choisissez un niveau d’effort connu.';

  @override
  String get rel_admin_endpoint_name_required =>
      'Saisissez un nom pour ce point de terminaison.';

  @override
  String get rel_admin_endpoint_model_required =>
      'Saisissez le modèle fourni par ce point de terminaison.';

  @override
  String get rel_admin_known_api_mode =>
      'Choisissez Automatique ou un mode API connu.';

  @override
  String get rel_admin_endpoint_id_invalid =>
      'Cet identifiant de point de terminaison n’est pas utilisable.';

  @override
  String get rel_admin_endpoint_https =>
      'Utilisez HTTPS pour un point de terminaison distant, ou HTTP sur localhost.';

  @override
  String get rel_admin_key_invalid =>
      'Cette clé API ne peut pas être enregistrée.';

  @override
  String get rel_admin_response_shape =>
      'La réponse de la passerelle n’avait pas la structure attendue.';

  @override
  String get rel_admin_limits_required =>
      'Saisissez les limites d’itérations, de simultanéité et de délai avant d’enregistrer.';

  @override
  String get rel_admin_route_required =>
      'Chaque route doit avoir un nom et un modèle avant d’être enregistrée.';

  @override
  String get rel_admin_route_unique =>
      'Les noms des routes doivent être uniques.';

  @override
  String get rel_admin_route_default_invalid =>
      'La route par défaut doit être l’une des routes enregistrées.';

  @override
  String get rel_admin_policy_required =>
      'Choisissez une politique avec alerte ou silencieuse pour les références dégradées.';

  @override
  String get rel_admin_mixture_missing =>
      'La passerelle n’a renvoyé aucun mélange actif.';

  @override
  String get rel_admin_mixture_slots_required =>
      'Indiquez un fournisseur et un modèle pour l’agrégateur et chaque référence.';

  @override
  String get rel_admin_chat_id_required =>
      'Saisissez l’identifiant du chat auquel ce changement s’applique.';

  @override
  String rel_admin_http_error(String status) {
    return 'La passerelle a renvoyé HTTP $status.';
  }

  @override
  String get rel_admin_response_unreadable =>
      'La réponse de la passerelle n’a pas pu être lue.';

  @override
  String get rel_admin_connect_before_change =>
      'Connectez la session active de la passerelle avant de modifier la facturation ou un chat.';

  @override
  String get rel_admin_operation_unavailable =>
      'Cette passerelle ne propose pas cette opération.';

  @override
  String get rel_admin_key_required => 'Saisissez la clé à enregistrer.';

  @override
  String get rel_admin_key_save_failed =>
      'La passerelle n’a pas enregistré cette clé.';

  @override
  String get rel_admin_key_clear_required =>
      'Choisissez une clé de fournisseur à effacer.';

  @override
  String get rel_admin_key_clear_failed =>
      'La passerelle n’a pas effacé cette clé.';

  @override
  String get rel_admin_endpoint_save_failed =>
      'La passerelle n’a pas enregistré ce point de terminaison.';

  @override
  String get rel_admin_endpoint_activate_failed =>
      'La passerelle n’a pas activé ce point de terminaison.';

  @override
  String get rel_admin_accounts_secure_required =>
      'Les comptes fournisseurs nécessitent une passerelle HTTPS authentifiée, ou localhost.';

  @override
  String get rel_admin_accounts_read_failed =>
      'Les comptes fournisseurs n’ont pas pu être lus.';

  @override
  String get rel_admin_account_disconnect_failed =>
      'La passerelle n’a pas déconnecté ce compte.';

  @override
  String get rel_admin_account_not_disconnectable =>
      'Ce compte fournisseur ne peut pas être déconnecté.';

  @override
  String get rel_admin_backend_required =>
      'Choisissez l’un des moteurs de délégation disponibles.';

  @override
  String get rel_admin_backend_save_failed =>
      'La passerelle n’a pas sélectionné ce moteur.';

  @override
  String get rel_admin_routes_save_failed =>
      'La passerelle n’a pas enregistré ces routes.';

  @override
  String get rel_admin_profile_route_required =>
      'Chaque route de profil doit avoir un nom de profil.';

  @override
  String get rel_admin_profile_route_unique =>
      'Les routes de profil doivent être uniques.';

  @override
  String get rel_admin_profile_route_default_invalid =>
      'La route de profil par défaut doit correspondre à l’un des profils autorisés.';

  @override
  String get rel_admin_profile_routes_save_failed =>
      'La passerelle n’a pas enregistré ces routes de profil.';

  @override
  String get rel_admin_limits_save_failed =>
      'La passerelle n’a pas enregistré ces limites.';

  @override
  String get rel_admin_mixture_save_failed =>
      'La passerelle n’a pas enregistré ce mélange.';

  @override
  String get rel_admin_credit_amount_required =>
      'Choisissez l’un des montants de crédit proposés.';

  @override
  String get rel_admin_charge_check_failed =>
      'Ce débit n’a pas pu être vérifié.';

  @override
  String get rel_admin_reload_amounts_missing =>
      'Les montants de recharge automatique n’ont pas été fournis et n’ont donc pas été modifiés.';

  @override
  String get rel_admin_plan_required => 'Choisissez d’abord une offre.';

  @override
  String get rel_admin_plan_scheduled_only =>
      'Seul un changement d’offre programmé peut être confirmé ici.';

  @override
  String get rel_admin_billing_refused =>
      'La passerelle a refusé cette demande de facturation.';

  @override
  String get rel_admin_request_refused =>
      'La passerelle a refusé cette demande.';

  @override
  String get rel_admin_endpoint_answered =>
      'Le point de terminaison a répondu.';

  @override
  String get rel_admin_endpoint_no_answer =>
      'Le point de terminaison n’a pas répondu.';

  @override
  String get rel_admin_charge_unknown =>
      'Le résultat du débit est inconnu. Il peut encore être finalisé. Consultez le portail avant de réessayer.';

  @override
  String get rel_admin_connect_before_billing =>
      'Connectez la session active de la passerelle avant de consulter la facturation. Aucun débit n’est effectué depuis cette page.';

  @override
  String get rel_admin_preset_required =>
      'Enregistrez un préréglage avant de l’appliquer.';

  @override
  String get rel_admin_cancel => 'Annuler';

  @override
  String get rel_admin_refresh => 'Actualiser';

  @override
  String get rel_admin_credits_and_plans => 'Crédits et offres';

  @override
  String get rel_admin_saved => 'Enregistré';

  @override
  String get rel_admin_name => 'Nom';

  @override
  String get rel_admin_base_url => 'URL de base';

  @override
  String get rel_admin_model => 'Modèle';

  @override
  String get rel_admin_signed_in => 'Session ouverte';

  @override
  String get rel_admin_not_signed_in => 'Non connecté';

  @override
  String get rel_admin_provider => 'Fournisseur';

  @override
  String get rel_admin_apply_to_this_chat => 'Appliquer à cette discussion';

  @override
  String get rel_admin_auto => 'Automatique';

  @override
  String get rel_admin_chat_completions => 'Complétions de chat';

  @override
  String get rel_admin_codex_responses => 'Réponses Codex';

  @override
  String get rel_admin_anthropic_messages => 'Messages Anthropic';

  @override
  String get rel_admin_could_not_complete_that_request =>
      'Cette demande n’a pas pu être effectuée.';

  @override
  String get rel_admin_confirm => 'Confirmer';

  @override
  String get rel_admin_providers_and_billing => 'Fournisseurs et facturation';

  @override
  String get rel_admin_api_keys => 'Clés API';

  @override
  String get rel_admin_custom_endpoints =>
      'Points de terminaison personnalisés';

  @override
  String get rel_admin_provider_accounts => 'Comptes fournisseurs';

  @override
  String get rel_admin_effort_and_speed_presets =>
      'Préréglages d’effort et de vitesse';

  @override
  String get rel_admin_delegation => 'Délégation';

  @override
  String get rel_admin_mixture_of_agents => 'Mélange d’agents';

  @override
  String get rel_admin_no_provider_keys_were_reported_for_this_profile =>
      'Aucune clé de fournisseur n’a été signalée pour ce profil.';

  @override
  String get rel_admin_not_saved => 'Non enregistré';

  @override
  String get rel_admin_new_key_value => 'Nouvelle valeur de clé';

  @override
  String get rel_admin_provider_key_saved => 'Clé du fournisseur enregistrée.';

  @override
  String get rel_admin_save_key => 'Enregistrer la clé';

  @override
  String get rel_admin_clear_provider_key => 'Effacer la clé du fournisseur';

  @override
  String get rel_admin_provider_key_cleared => 'Clé du fournisseur effacée.';

  @override
  String get rel_admin_clear_key => 'Effacer la clé';

  @override
  String get rel_admin_new_endpoint => 'Nouveau point de terminaison';

  @override
  String get rel_admin_api_key => 'Clé API';

  @override
  String get rel_admin_leave_blank_to_keep_a_key_this_endpoint_already_has =>
      'Laissez vide pour conserver la clé existante de ce point de terminaison.';

  @override
  String get rel_admin_reachable => 'Accessible';

  @override
  String get rel_admin_unreachable => 'Inaccessible';

  @override
  String get rel_admin_test_endpoint => 'Tester le point de terminaison';

  @override
  String get rel_admin_endpoint_saved => 'Point de terminaison enregistré.';

  @override
  String get rel_admin_save_endpoint => 'Enregistrer le point de terminaison';

  @override
  String get rel_admin_use_this_endpoint => 'Utiliser ce point de terminaison';

  @override
  String
  get rel_admin_make_this_named_endpoint_the_current_model_for_this_profile =>
      'Définir ce point de terminaison nommé comme modèle actuel de ce profil ?';

  @override
  String get rel_admin_endpoint_is_now_current =>
      'Ce point de terminaison est désormais le point actuel.';

  @override
  String get rel_admin_use_endpoint => 'Utiliser le point de terminaison';

  @override
  String get rel_admin_delete_endpoint => 'Supprimer le point de terminaison';

  @override
  String get rel_admin_delete_this_named_endpoint_from_the_profile =>
      'Supprimer ce point de terminaison nommé du profil ?';

  @override
  String get rel_admin_endpoint_deleted => 'Point de terminaison supprimé.';

  @override
  String get rel_admin_signing_in_stays_on_the_provider_sign_in_screen =>
      'La connexion reste sur l’écran de connexion du fournisseur. La déconnexion n’a lieu que si cette passerelle indique que le compte peut être supprimé.';

  @override
  String get rel_admin_disconnect_this_provider_account_on_the_gateway =>
      'Déconnecter ce compte fournisseur sur la passerelle ?';

  @override
  String get rel_admin_provider_account_disconnected =>
      'Compte fournisseur déconnecté.';

  @override
  String get rel_admin_disconnect => 'Déconnecter';

  @override
  String get rel_admin_not_disconnectable => 'Déconnexion impossible';

  @override
  String get rel_admin_fast => 'Rapide';

  @override
  String get rel_admin_preset_saved_for_this_model =>
      'Préréglage enregistré pour ce modèle.';

  @override
  String get rel_admin_save_preset => 'Enregistrer le préréglage';

  @override
  String get rel_admin_chat_id => 'Identifiant du chat';

  @override
  String get rel_admin_apply_preset => 'Appliquer le préréglage';

  @override
  String get rel_admin_set_this_chat_s_effort_and_speed_from_the_saved_preset =>
      'Définir l’effort et la vitesse de ce chat à partir du préréglage enregistré ?';

  @override
  String get rel_admin_preset_applied_to_this_chat =>
      'Préréglage appliqué à ce chat.';

  @override
  String get rel_admin_this_route_sends_the_picked_effort_unchanged =>
      'Cette route transmet l’effort choisi sans modification.';

  @override
  String get rel_admin_show_route_clamp => 'Afficher la limitation de la route';

  @override
  String get rel_admin_delegation_backend => 'Moteur de délégation';

  @override
  String get rel_admin_delegation_backend_saved =>
      'Moteur de délégation enregistré.';

  @override
  String get rel_admin_save_backend => 'Enregistrer le moteur';

  @override
  String get rel_admin_max_iterations => 'Itérations maximales';

  @override
  String get rel_admin_max_concurrent_children =>
      'Agents enfants simultanés maximum';

  @override
  String get rel_admin_child_timeout_seconds =>
      'Délai des agents enfants en secondes';

  @override
  String get rel_admin_delegation_effort_leave_unchanged =>
      'Effort de délégation, laisser inchangé';

  @override
  String get rel_admin_delegation_limits_saved =>
      'Limites de délégation enregistrées.';

  @override
  String get rel_admin_save_limits => 'Enregistrer les limites';

  @override
  String get rel_admin_remove_route => 'Retirer la route';

  @override
  String get rel_admin_route_name => 'Nom de la route';

  @override
  String get rel_admin_route_provider => 'Fournisseur de la route';

  @override
  String get rel_admin_route_model => 'Modèle de la route';

  @override
  String get rel_admin_route_effort_unchanged => 'Effort de la route inchangé';

  @override
  String get rel_admin_add_route => 'Ajouter une route';

  @override
  String get rel_admin_default_route => 'Route par défaut';

  @override
  String get rel_admin_delegation_routes_saved =>
      'Routes de délégation enregistrées.';

  @override
  String get rel_admin_save_routes => 'Enregistrer les routes';

  @override
  String get rel_admin_profile_routes_saved => 'Routes de profil enregistrées.';

  @override
  String get rel_admin_save_profile_routes =>
      'Enregistrer les routes de profil';

  @override
  String get rel_admin_no_mixture_is_loaded => 'Aucun mélange n’est chargé.';

  @override
  String get rel_admin_mixture_enabled => 'Mélange activé';

  @override
  String get rel_admin_loud_degraded_references =>
      'Références dégradées avec alerte';

  @override
  String get rel_admin_silent_degraded_references =>
      'Références dégradées silencieuses';

  @override
  String get rel_admin_aggregator => 'Agrégateur';

  @override
  String get rel_admin_aggregator_provider => 'Fournisseur de l’agrégateur';

  @override
  String get rel_admin_aggregator_model => 'Modèle de l’agrégateur';

  @override
  String get rel_admin_reference_provider => 'Fournisseur de référence';

  @override
  String get rel_admin_reference_model => 'Modèle de référence';

  @override
  String get rel_admin_add_reference_model => 'Ajouter un modèle de référence';

  @override
  String get rel_admin_mixture_saved => 'Mélange enregistré.';

  @override
  String get rel_admin_save_mixture => 'Enregistrer le mélange';

  @override
  String get rel_admin_credit_purchase_submitted => 'Achat de crédits envoyé.';

  @override
  String get rel_admin_credit_purchase_settled => 'Achat de crédits finalisé.';

  @override
  String get rel_admin_credit_and_plan_changes_wait_for_confirmation_a_plan =>
      'Les changements de crédits et d’offre attendent une confirmation. Une offre entraînant un débit immédiat est affichée, mais n’est pas confirmée ici.';

  @override
  String get rel_admin_buy_credits => 'Acheter des crédits';

  @override
  String get rel_admin_retry_same_charge => 'Réessayer le même débit';

  @override
  String get rel_admin_retry_the_same_credit_charge_this_does_not_start =>
      'Réessayez le même débit de crédits. Cela ne lance pas un second achat.';

  @override
  String get rel_admin_credit_purchases_are_not_available_for_this_account =>
      'L’achat de crédits n’est pas disponible pour ce compte.';

  @override
  String get rel_admin_auto_reload => 'Recharge automatique';

  @override
  String get rel_admin_read_only_until_this_account_can_charge =>
      'Lecture seule tant que ce compte ne peut pas être débité.';

  @override
  String get rel_admin_auto_reload_updated =>
      'Recharge automatique mise à jour.';

  @override
  String get rel_admin_keep_going_on_credits => 'Continuer avec des crédits';

  @override
  String get rel_admin_continue_on_credits_when_the_plan_window_is_used_up =>
      'Continuer avec des crédits lorsque le quota de la période de l’offre est épuisé ?';

  @override
  String
  get rel_admin_stop_continuing_on_credits_when_the_plan_window_is_used_up =>
      'Arrêter de continuer avec des crédits lorsque le quota de la période de l’offre est épuisé ?';

  @override
  String get rel_admin_credit_continuation_updated =>
      'Poursuite avec des crédits mise à jour.';

  @override
  String get rel_admin_this_plan_change_is_not_confirmed_from_ares =>
      'Ce changement d’offre n’est pas confirmé depuis Ares.';

  @override
  String get rel_admin_this_change_is_scheduled_confirm_to_apply_it =>
      'Ce changement est programmé. Confirmez pour l’appliquer.';

  @override
  String get rel_admin_preview_plan => 'Aperçu de l’offre';

  @override
  String get rel_admin_schedule_plan_change =>
      'Programmer le changement d’offre';

  @override
  String get rel_admin_plan_change_scheduled => 'Changement d’offre programmé.';

  @override
  String get rel_admin_confirm_scheduled_plan_change =>
      'Confirmer le changement d’offre programmé';

  @override
  String rel_admin_remove_key_confirm(String key) {
    return 'Supprimer la valeur enregistrée de $key de ce profil ?';
  }

  @override
  String rel_admin_current_endpoint(String name) {
    return '$name · actuel';
  }

  @override
  String rel_admin_endpoint_result(
    String status,
    String transport,
    String count,
    String message,
  ) {
    return '$status · $transport · $count modèles. $message';
  }

  @override
  String rel_admin_disconnect_account(String name) {
    return 'Déconnecter $name';
  }

  @override
  String rel_admin_delegation_blocked(String reason) {
    return 'La délégation est bloquée : $reason';
  }

  @override
  String rel_admin_backend_unavailable(String name) {
    return '$name · indisponible';
  }

  @override
  String rel_admin_reference_number(String number) {
    return 'Référence $number';
  }

  @override
  String rel_admin_reload_enable_confirm(String amount, String threshold) {
    return 'Activer la recharge automatique et débiter $amount lorsque le solde descend sous $threshold ?';
  }

  @override
  String rel_admin_reload_disable_confirm(String amount, String threshold) {
    return 'Désactiver la recharge automatique ? Elle débite actuellement $amount lorsque le solde descend sous $threshold.';
  }

  @override
  String get rel_admin_this_plan => 'cette offre';

  @override
  String rel_admin_plan_confirm(String name) {
    return 'Programmer $name. Le changement est prévu à la fin de la période en cours. Aucun débit n’est effectué maintenant.';
  }

  @override
  String rel_admin_plan_confirm_price(String name, String price) {
    return 'Programmer $name à $price. Le changement est prévu à la fin de la période en cours. Aucun débit n’est effectué maintenant.';
  }

  @override
  String rel_admin_plan_confirm_when(String name, String when) {
    return 'Programmer $name. Le changement prend effet $when. Aucun débit n’est effectué maintenant.';
  }

  @override
  String rel_admin_plan_confirm_price_when(
    String name,
    String price,
    String when,
  ) {
    return 'Programmer $name à $price. Le changement prend effet $when. Aucun débit n’est effectué maintenant.';
  }

  @override
  String rel_admin_balance(String amount) {
    return 'Solde $amount';
  }

  @override
  String rel_admin_buy_confirm(String amount) {
    return 'Débiter \$$amount sur le moyen de paiement de ce compte Nous. Cela dépense de l’argent réel.';
  }

  @override
  String rel_admin_reload_portal(String url) {
    return 'Modifiez la recharge automatique sur le portail : $url';
  }

  @override
  String rel_admin_team_portal(String url) {
    return 'Les abonnements d’équipe se modifient sur le portail : $url';
  }

  @override
  String get rel_admin_effort_none => 'aucun';

  @override
  String get rel_admin_effort_minimal => 'minimal';

  @override
  String get rel_admin_effort_low => 'faible';

  @override
  String get rel_admin_effort_medium => 'moyen';

  @override
  String get rel_admin_effort_high => 'élevé';

  @override
  String get rel_admin_effort_xhigh => 'très élevé';

  @override
  String get rel_admin_effort_max => 'maximal';

  @override
  String get rel_admin_effort_ultra => 'ultra-élevé';

  @override
  String get rel_admin_auto_lower => 'Automatique';

  @override
  String get rel_admin_create => 'Créer';

  @override
  String get rel_admin_prompt => 'Instruction';

  @override
  String get rel_admin_new_profile_id => 'Identifiant du nouveau profil';

  @override
  String get rel_admin_this_operation_is_unavailable_on_this_gateway =>
      'Cette opération n’est pas disponible sur cette passerelle.';

  @override
  String get rel_admin_access_denied_by_the_gateway =>
      'Accès refusé par la passerelle.';

  @override
  String get rel_admin_connection_changed_reopen_profiles =>
      'La connexion a changé. Rouvrez Profils.';

  @override
  String
  get rel_admin_invalid_input_or_gateway_response_check_the_target_before =>
      'Saisie ou réponse de la passerelle invalide. Vérifiez la cible avant de réessayer.';

  @override
  String get rel_admin_could_not_verify_the_result_refresh_the_target_before =>
      'Le résultat n’a pas pu être vérifié. Actualisez la cible avant de réessayer.';

  @override
  String get rel_admin_edit_soul_md => 'Modifier SOUL.md';

  @override
  String get rel_admin_persona => 'Personnalité';

  @override
  String get rel_admin_persona_saved => 'Personnalité enregistrée.';

  @override
  String get rel_admin_not_set => 'non défini';

  @override
  String get rel_admin_enabled => 'Activé';

  @override
  String get rel_admin_keys_to_remove_comma_separated =>
      'Clés à retirer (séparées par des virgules)';

  @override
  String get rel_admin_saved_and_applied_by_the_gateway =>
      'Enregistré et appliqué par la passerelle.';

  @override
  String get rel_admin_saved_a_gateway_restart_may_be_required =>
      'Enregistré. Un redémarrage de la passerelle peut être nécessaire.';

  @override
  String get rel_admin_create_signed_route => 'Créer une route signée';

  @override
  String get rel_admin_route_id => 'Identifiant de route';

  @override
  String get rel_admin_signature => 'Signature';

  @override
  String get rel_admin_events_comma_separated =>
      'Événements (séparés par des virgules)';

  @override
  String get rel_admin_delivery_target => 'Destination de livraison';

  @override
  String get rel_admin_skills_comma_separated =>
      'Compétences (séparées par des virgules)';

  @override
  String get rel_admin_delivery_mode => 'Mode de livraison';

  @override
  String get rel_admin_delivery_chat_id_optional =>
      'Identifiant du chat de livraison (facultatif)';

  @override
  String get rel_admin_hide_signing_secret => 'Masquer le secret de signature';

  @override
  String get rel_admin_reveal_signing_secret =>
      'Afficher le secret de signature';

  @override
  String get rel_admin_edit_persona => 'Modifier la personnalité';

  @override
  String get rel_admin_portable_profile_bundle => 'Paquet de profil portable';

  @override
  String get rel_admin_clone_profile => 'Cloner le profil';

  @override
  String get rel_admin_rename_display_label => 'Renommer le libellé affiché';

  @override
  String get rel_admin_rename_profile => 'Renommer le profil';

  @override
  String get rel_admin_new_name => 'Nouveau nom';

  @override
  String get rel_admin_rename_verified => 'Renommage vérifié.';

  @override
  String get rel_admin_delete_profile => 'Supprimer le profil';

  @override
  String get rel_admin_profile_id_to_delete =>
      'Identifiant du profil à supprimer';

  @override
  String get rel_admin_profile_deleted => 'Profil supprimé.';

  @override
  String
  get rel_admin_profile_deleted_server_identity_cleanup_is_still_pending =>
      'Profil supprimé. Le nettoyage de l’identité du serveur est toujours en attente.';

  @override
  String get rel_admin_export_profile_archive => 'Exporter l’archive du profil';

  @override
  String get rel_admin_import_profile_archive => 'Importer l’archive du profil';

  @override
  String get rel_admin_import_a_trusted_profile =>
      'Importer un profil de confiance';

  @override
  String get rel_admin_absolute_archive_path_on_gateway =>
      'Chemin absolu de l’archive sur la passerelle';

  @override
  String get rel_admin_messaging_channels => 'Canaux de messagerie';

  @override
  String get rel_admin_dm_pairing_requests =>
      'Demandes d’association par message privé';

  @override
  String get rel_admin_no_pending_or_approved_users =>
      'Aucun utilisateur en attente ou approuvé.';

  @override
  String get rel_admin_legacy_pairing_no_verifiable_request_id_ask_the_user =>
      'Ancienne association : aucun identifiant de demande vérifiable. Demandez à l’utilisateur de s’associer à nouveau.';

  @override
  String get rel_admin_pairing_change_verified =>
      'Changement d’association vérifié.';

  @override
  String get rel_admin_create_telegram_bot_by_qr =>
      'Créer un bot Telegram par QR';

  @override
  String get rel_admin_create_telegram_bot => 'Créer un bot Telegram';

  @override
  String get rel_admin_bot_name => 'Nom du bot';

  @override
  String get rel_admin_telegram_bot_creation_qr_code =>
      'Code QR de création d’un bot Telegram';

  @override
  String get rel_admin_check_telegram_pairing =>
      'Vérifier l’association Telegram';

  @override
  String get rel_admin_waiting_for_telegram => 'En attente de Telegram.';

  @override
  String get rel_admin_apply_telegram_bot => 'Appliquer le bot Telegram';

  @override
  String get rel_admin_allowed_numeric_user_ids =>
      'Identifiants numériques des utilisateurs autorisés';

  @override
  String get rel_admin_saved_restart_still_required =>
      'Enregistré. Un redémarrage reste nécessaire.';

  @override
  String get rel_admin_saved_gateway_restart_requested =>
      'Enregistré ; redémarrage de la passerelle demandé.';

  @override
  String get rel_admin_cancel_telegram_setup =>
      'Annuler la configuration Telegram';

  @override
  String get rel_admin_inbound_webhooks => 'Webhooks entrants';

  @override
  String get rel_admin_enable_webhook_service =>
      'Activer le service de webhooks';

  @override
  String get rel_admin_enable_webhooks => 'Activer les webhooks';

  @override
  String get rel_admin_enabled_restart_still_required =>
      'Activé. Un redémarrage reste nécessaire.';

  @override
  String get rel_admin_enabled_restart_requested =>
      'Activé ; redémarrage demandé.';

  @override
  String get rel_admin_route_change_verified => 'Changement de route vérifié.';

  @override
  String get rel_admin_delete_route => 'Supprimer la route';

  @override
  String get rel_admin_disable_route => 'Désactiver la route';

  @override
  String get rel_admin_enable_route => 'Activer la route';

  @override
  String get rel_admin_back_up_entire_agent_home =>
      'Sauvegarder tout le répertoire personnel de l’agent';

  @override
  String get rel_admin_transfer_to_a_cloud_agent =>
      'Transférer vers un agent Cloud';

  @override
  String get rel_admin_check_backup_progress =>
      'Vérifier l’avancement de la sauvegarde';

  @override
  String get rel_admin_save_backup_to_this_device =>
      'Enregistrer la sauvegarde sur cet appareil';

  @override
  String get rel_admin_save_sensitive_full_home_archive =>
      'Enregistrer l’archive sensible de tout le répertoire personnel';

  @override
  String get rel_admin_save_cancelled => 'Enregistrement annulé.';

  @override
  String get rel_admin_backup_saved => 'Sauvegarde enregistrée.';

  @override
  String get rel_admin_up_to_32_mib_larger_archives_remain_on_the_gateway =>
      'Jusqu’à 32 MiB. Les archives plus volumineuses restent sur la passerelle.';

  @override
  String rel_admin_persona_scope(String scope) {
    return 'Enregistrez la personnalité de $scope.';
  }

  @override
  String rel_admin_configure_channel(String name) {
    return 'Configurer $name';
  }

  @override
  String rel_admin_channel_warning(String scope) {
    return 'S’applique à $scope. Un champ vide conserve la valeur existante. Pour supprimer une valeur, indiquez sa clé ci-dessous.';
  }

  @override
  String rel_admin_hook_warning(String scope) {
    return 'S’applique à $scope. Utilisez un nom unique. La passerelle crée un secret de signature. Si un autre opérateur crée ce nom en même temps, l’hôte peut remplacer cette route.';
  }

  @override
  String rel_admin_hook_created(String url) {
    return '$url créé. Conservez le secret de signature avant de quitter.';
  }

  @override
  String rel_admin_clone_warning(String scope) {
    return 'Copiez les paramètres, compétences, personnalité et éventuellement les identifiants fournisseurs de $scope. Les jetons de messagerie ne sont pas demandés.';
  }

  @override
  String rel_admin_cloned(String source, String destination) {
    return '$source cloné vers $destination.';
  }

  @override
  String rel_admin_rename_target(String name) {
    return 'Renommer $name';
  }

  @override
  String rel_admin_rename_label_warning(String scope) {
    return 'Modifiez le libellé affiché de $scope. Son identifiant reste default.';
  }

  @override
  String rel_admin_rename_warning(String scope) {
    return 'Renommez $scope sur le serveur. Une passerelle en cours d’exécution peut s’arrêter.';
  }

  @override
  String rel_admin_delete_target(String name) {
    return 'Supprimer $name';
  }

  @override
  String rel_admin_delete_profile_warning(String scope) {
    return 'Supprimez définitivement $scope, y compris les sessions et identifiants. Saisissez l’identifiant exact du profil.';
  }

  @override
  String rel_admin_export_target(String name) {
    return 'Exporter $name';
  }

  @override
  String rel_admin_export_warning(String scope) {
    return 'Créez un .tar.gz sur $scope. Les magasins d’identifiants connus sont exclus, mais des données privées peuvent rester. Examinez avant de partager.';
  }

  @override
  String rel_admin_archive_on(String gateway, String path) {
    return 'Archive sur $gateway : $path';
  }

  @override
  String rel_admin_import_warning(String gateway) {
    return 'Utilisez un .tar.gz examiné déjà présent sur $gateway. Il peut contenir des plugins, scripts et programmations. Un nouvel identifiant de profil est requis.';
  }

  @override
  String rel_admin_imported(String name) {
    return '$name importé.';
  }

  @override
  String rel_admin_approve_user(String user) {
    return 'Approuver $user';
  }

  @override
  String rel_admin_revoke_user(String user) {
    return 'Révoquer $user';
  }

  @override
  String rel_admin_allow_pair(String platform, String scope) {
    return '$platform sur $scope : autoriser l’accès de cet utilisateur à la messagerie.';
  }

  @override
  String rel_admin_remove_pair(String platform, String scope) {
    return '$platform sur $scope : retirer l’accès de cet utilisateur à la messagerie.';
  }

  @override
  String rel_admin_telegram_start(String scope) {
    return 'Démarrez une association Telegram sur $scope via le service de configuration de la passerelle.';
  }

  @override
  String rel_admin_expires(String time) {
    return 'Expire : $time';
  }

  @override
  String rel_admin_telegram_apply(String bot, String scope) {
    return 'Activez @$bot sur $scope et tentez un redémarrage de la passerelle. Seuls les utilisateurs indiqués peuvent lui envoyer des messages.';
  }

  @override
  String rel_admin_hooks_enable(String scope) {
    return 'Activez les webhooks entrants sur $scope et tentez un redémarrage de la passerelle.';
  }

  @override
  String rel_admin_disable_target(String name) {
    return 'Désactiver $name';
  }

  @override
  String rel_admin_enable_target(String name) {
    return 'Activer $name';
  }

  @override
  String rel_admin_hook_change(String name, String scope) {
    return 'Modifiez précisément $name sur $scope.';
  }

  @override
  String rel_admin_backup_warning(String gateway) {
    return 'Ce n’est pas une sauvegarde des paramètres d’Ares. Sauvegardez tous les profils, sessions et identifiants sur $gateway. L’archive est sensible.';
  }

  @override
  String rel_admin_backup_started(String gateway) {
    return 'Sauvegarde démarrée sur $gateway.';
  }

  @override
  String rel_admin_backup_verified(String gateway, String path) {
    return 'Sauvegarde vérifiée sur $gateway : $path';
  }

  @override
  String rel_admin_backup_running(String gateway) {
    return 'La sauvegarde est toujours en cours sur $gateway.';
  }

  @override
  String get rel_admin_choice_yes => 'oui';

  @override
  String get rel_admin_choice_no => 'non';

  @override
  String get rel_admin_choice_generic => 'générique';

  @override
  String get rel_admin_choice_log => 'journal';

  @override
  String get rel_admin_choice_email => 'e-mail';

  @override
  String get rel_admin_choice_github_comment => 'commentaire GitHub';

  @override
  String get rel_admin_choice_agent => 'L’agent traite l’événement';

  @override
  String get rel_admin_choice_direct => 'Livraison directe';

  @override
  String get rel_admin_configured => 'configuré';

  @override
  String get rel_admin_state_pending_restart => 'redémarrage en attente';

  @override
  String get rel_admin_state_unknown => 'inconnu';

  @override
  String get rel_admin_state_connected => 'connecté';

  @override
  String get rel_admin_state_disconnected => 'déconnecté';

  @override
  String get rel_admin_state_disabled => 'désactivé';

  @override
  String get rel_admin_state_enabled => 'activé';

  @override
  String get rel_admin_state_running => 'en cours';

  @override
  String get rel_admin_state_stopped => 'arrêté';

  @override
  String get rel_admin_state_error => 'erreur';

  @override
  String get rel_admin_state_not_configured => 'non configuré';

  @override
  String get rel_admin_state_startup_failed => 'échec du démarrage';

  @override
  String get rel_admin_state_gateway_stopped => 'passerelle arrêtée';

  @override
  String get rel_admin_state_connecting => 'connexion en cours';

  @override
  String get rel_admin_state_retrying => 'nouvelle tentative';

  @override
  String get rel_admin_state_fatal => 'erreur fatale';

  @override
  String get rel_admin_unsupported_or_oversized_profile_archive =>
      'Archive de profil non prise en charge ou trop volumineuse.';

  @override
  String get rel_admin_current_layout => 'Disposition actuelle';

  @override
  String get rel_admin_one_pane => 'Un volet';

  @override
  String get rel_admin_stacked => 'Empilé';

  @override
  String get rel_admin_side_by_side => 'Côte à côte';

  @override
  String get rel_admin_no_supported_appearance_in_this_profile =>
      'Aucune apparence prise en charge dans ce profil.';

  @override
  String get rel_admin_review_appearance_saved_with_this_profile =>
      'Examiner l’apparence enregistrée avec ce profil';

  @override
  String get rel_admin_applies_only_to_this_named_profile_on_this_device =>
      'S’applique uniquement à ce profil nommé sur cet appareil. Une disposition importée commence avec des volets vides ; choisissez vous-même ses chats.';

  @override
  String get rel_admin_apply_to_this_profile_on_this_device =>
      'Appliquer à ce profil sur cet appareil';

  @override
  String get rel_admin_export_prepares_a_tar_gz_on_the_gateway_review =>
      'L’export prépare un .tar.gz sur la passerelle. Examinez ses fichiers portables avant d’enregistrer une copie ici. L’import ouvre une archive locale pour examen ; l’ouverture seule ne téléverse rien.';

  @override
  String get rel_admin_prepare_profile_export => 'Préparer l’export du profil';

  @override
  String get rel_admin_open_tar_gz_from_this_device =>
      'Ouvrir un .tar.gz de cet appareil';

  @override
  String get rel_admin_only_selected_text_files_travel_review_for_secrets_and =>
      'Seuls les fichiers texte sélectionnés sont transférés. Vérifiez l’absence de secrets et d’informations privées. La configuration, les compétences et les programmations peuvent modifier le comportement du nouveau profil.';

  @override
  String get rel_admin_include_this_reviewed_file =>
      'Inclure ce fichier examiné';

  @override
  String get rel_admin_apply_appearance_to_the_new_profile_on_this_device =>
      'Appliquer l’apparence au nouveau profil sur cet appareil';

  @override
  String
  get rel_admin_imports_colours_and_pane_sizes_never_chats_tools_or_session_ids =>
      'Importe les couleurs et tailles des volets, jamais les chats, outils ou identifiants de session.';

  @override
  String
  get rel_admin_the_gateway_retains_a_private_staged_copy_import_creates =>
      'La passerelle conserve une copie privée préparée. L’import crée un nouveau profil ; il ne remplace pas un profil existant.';

  @override
  String get rel_admin_appearance_not_applied_the_gateway_did_not_confirm_the =>
      ' Apparence non appliquée : la passerelle n’a pas confirmé la surcouche examinée.';

  @override
  String get rel_admin_appearance_applied_on_this_device =>
      ' Apparence appliquée sur cet appareil.';

  @override
  String get rel_admin_appearance_was_not_saved_on_this_device =>
      ' L’apparence n’a pas été enregistrée sur cet appareil.';

  @override
  String get rel_admin_save_reviewed_profile_bundle =>
      'Enregistrer le paquet de profil examiné';

  @override
  String get rel_admin_profile_bundle_saved => 'Paquet de profil enregistré.';

  @override
  String get rel_admin_import_selected_files =>
      'Importer les fichiers sélectionnés';

  @override
  String get rel_admin_save_selected_files_to_device =>
      'Enregistrer les fichiers sélectionnés sur l’appareil';

  @override
  String rel_admin_layout_first_pane(String layout, String percent) {
    return '$layout · $percent% premier volet';
  }

  @override
  String rel_admin_appearance_summary(String skin, String mode, String layout) {
    return 'Thème : $skin · Mode : $mode · $layout';
  }

  @override
  String rel_admin_appearance_applied(String gateway, String profile) {
    return 'Apparence appliquée à $gateway / $profile.';
  }

  @override
  String rel_admin_bundle_summary(
    String profile,
    String count,
    String omitted,
  ) {
    return 'Paquet : $profile · $count fichiers examinables · $omitted omis';
  }

  @override
  String rel_admin_imported_on(String name, String gateway) {
    return '$name importé sur $gateway.';
  }

  @override
  String get rel_admin_unchanged => 'inchangé';

  @override
  String get rel_admin_mode_system => 'système';

  @override
  String get rel_admin_mode_light => 'clair';

  @override
  String get rel_admin_mode_dark => 'sombre';

  @override
  String get rel_admin_skin_classic => 'classique';

  @override
  String get rel_admin_skin_midnight => 'minuit';

  @override
  String get rel_admin_skin_ember => 'braise';

  @override
  String get rel_admin_skin_mono => 'monochrome';

  @override
  String get rel_admin_skin_cyberpunk => 'cyberpunk';

  @override
  String get rel_admin_skin_slate => 'ardoise';

  @override
  String get rel_admin_no_available_cloud_agents_in_this_account =>
      'Aucun agent Cloud disponible dans ce compte.';

  @override
  String get rel_admin_the_previous_undo_receipt_could_not_be_verified_no =>
      'Le reçu d’annulation précédent n’a pas pu être vérifié. Aucune modification n’a été effectuée.';

  @override
  String get rel_admin_transfer_to_cloud => 'Transférer vers Cloud';

  @override
  String
  get rel_admin_connection_changed_leave_this_page_a_restore_already_submitted =>
      'La connexion a changé. Quittez cette page. Une restauration déjà soumise peut se poursuivre.';

  @override
  String get rel_admin_find_my_cloud_agents => 'Trouver mes agents Cloud';

  @override
  String
  get rel_admin_undo_replaces_the_destination_with_its_pre_transfer_backup =>
      'L’annulation remplace la destination par sa sauvegarde d’avant le transfert.';

  @override
  String get rel_admin_replace_this_cloud_agent_with_the_entire_source_home =>
      'Remplacez cet agent Cloud par tout le répertoire personnel source, y compris les identifiants, conversations et fichiers. La source n’est pas supprimée. Les bots de messagerie entrante sont désactivés.';

  @override
  String get rel_admin_type_destination_agent_id =>
      'Saisissez l’identifiant de l’agent de destination';

  @override
  String
  get rel_admin_could_not_retain_the_local_undo_receipt_keep_this_page_open =>
      'Le reçu d’annulation local n’a pas pu être conservé. Gardez cette page ouverte.';

  @override
  String get rel_admin_undo_transfer => 'Annuler le transfert';

  @override
  String get rel_admin_replace_cloud_agent => 'Remplacer l’agent Cloud';

  @override
  String
  get rel_admin_local_undo_receipt_forgotten_no_remote_backup_was_removed =>
      'Reçu d’annulation local oublié. Aucune sauvegarde distante n’a été supprimée.';

  @override
  String get rel_admin_forget_local_undo_receipt_only =>
      'Oublier uniquement le reçu d’annulation local';

  @override
  String get rel_admin_stop_before_restore => 'Arrêter avant la restauration';

  @override
  String get rel_admin_do_not_close_this_page_restore_runs_on_the =>
      'Ne fermez pas cette page. La restauration s’exécute sur la destination et ne peut pas être annulée.';

  @override
  String get rel_admin_files_restored_destination_gateway_needs_attention =>
      'Fichiers restaurés ; la passerelle de destination nécessite une intervention.';

  @override
  String rel_admin_transfer_sign_in(String origin) {
    return 'Connectez-vous à une seule connexion Ares enregistrée pour $origin, puis revenez ici.';
  }

  @override
  String rel_admin_transfer_source(String gateway, String profile) {
    return 'Source : $gateway / $profile';
  }

  @override
  String rel_admin_transfer_destination(String name, String origin) {
    return 'Destination : $name · $origin / default';
  }

  @override
  String rel_admin_agent_id(String id) {
    return 'Identifiant de l’agent : $id';
  }

  @override
  String rel_admin_transfer_status(String phase) {
    return 'État : $phase';
  }

  @override
  String rel_admin_copied_percent(String percent) {
    return 'Copié à $percent%';
  }

  @override
  String rel_admin_undo_point(String path) {
    return 'Point d’annulation sur la destination : $path';
  }

  @override
  String rel_admin_messaging_disabled(String channels) {
    return 'Messagerie désactivée : $channels';
  }

  @override
  String get rel_admin_phase_prepared => 'préparé';

  @override
  String get rel_admin_phase_backup => 'sauvegarde';

  @override
  String get rel_admin_phase_upload => 'téléversement';

  @override
  String get rel_admin_phase_restore => 'restauration';

  @override
  String get rel_admin_phase_finished => 'terminé';

  @override
  String get rel_admin_phase_failed => 'échoué';

  @override
  String get rel_admin_phase_undo => 'annulation';

  @override
  String get rel_admin_phase_undone => 'annulé';

  @override
  String rel_ops_cap_install_blocked(String verdict, String detail) {
    return 'Installation bloquée ($verdict) : $detail';
  }

  @override
  String rel_ops_cap_scan_confirm(String verdict, String requested) {
    return 'Résultat de l’analyse : $verdict. Confirmez $requested avant l’installation.';
  }

  @override
  String rel_ops_cap_install_unconfirmed(String requested) {
    return 'La passerelle n’a pas confirmé l’installation de $requested.';
  }

  @override
  String rel_ops_cap_edit_skill(String name) {
    return 'Modifier $name';
  }

  @override
  String rel_ops_cap_archive_skill(String name) {
    return 'Archiver $name ?';
  }

  @override
  String rel_ops_cap_archive_explanation(String command) {
    return 'La compétence sera archivée et pourra être restaurée avec $command.';
  }

  @override
  String rel_ops_cap_install_anyway(String name) {
    return 'Installer $name quand même';
  }

  @override
  String rel_ops_cap_install_despite_scan(String name) {
    return 'Installer $name malgré l’analyse ?';
  }

  @override
  String rel_ops_cap_scan_warning(String name) {
    return 'L’analyse de sécurité a bloqué $name. Cette confirmation ne s’applique qu’à $name.';
  }

  @override
  String rel_ops_cap_accept_scan_warning(String name) {
    return 'Accepter les capacités ne permet pas de contourner l’analyse de $name.';
  }

  @override
  String rel_ops_cap_review_scan(String name) {
    return 'Consulter l’analyse de $name';
  }

  @override
  String rel_ops_cap_desktop_grants(String description) {
    return '$description\nLes autorisations des dossiers et des scripts d’aperçu restent dans l’application Desktop de cet ordinateur. Supprimer le plugin ici ne révoque pas ces autorisations locales.';
  }

  @override
  String rel_ops_cap_remove_plugin(String name) {
    return 'Supprimer $name ?';
  }

  @override
  String rel_ops_cap_probe_result(String name, String tools) {
    return 'Test de $name : $tools';
  }

  @override
  String rel_ops_cap_save_tool_grants_for(String connector) {
    return 'Enregistrer les autorisations des outils pour $connector';
  }

  @override
  String rel_ops_cap_backends_for(String name) {
    return 'Moteurs pour $name';
  }

  @override
  String rel_ops_cap_use_backend_confirmation(String name) {
    return 'Utiliser $name ?';
  }

  @override
  String rel_ops_cap_unlock_source(String name) {
    return 'Déverrouiller $name';
  }

  @override
  String get rel_ops_cap_capabilities => 'Capacités';

  @override
  String get rel_ops_cap_plugins => 'Plugins';

  @override
  String get rel_ops_cap_connectors => 'Connecteurs';

  @override
  String get rel_ops_cap_backends => 'Moteurs';

  @override
  String get rel_ops_cap_save_skill => 'Enregistrer la compétence';

  @override
  String get rel_ops_cap_archive => 'Archiver';

  @override
  String get rel_ops_cap_hub_identifier => 'Identifiant du Hub';

  @override
  String get rel_ops_cap_install => 'Installer';

  @override
  String get rel_ops_cap_update_all => 'Tout mettre à jour';

  @override
  String get rel_ops_cap_unlock => 'Déverrouiller';

  @override
  String get rel_ops_cap_lock => 'Verrouiller';

  @override
  String get rel_ops_cap_this_update_adds_capabilities_nothing_changed_yet =>
      'Cette mise à jour ajoute des capacités. Rien n’a encore changé.';

  @override
  String get rel_ops_cap_the_scan_blocked_this_plugin =>
      'L’analyse a bloqué ce plugin.';

  @override
  String get rel_ops_cap_the_plugin_was_not_changed =>
      'Le plugin n’a pas été modifié.';

  @override
  String get rel_ops_cap_repository => 'Dépôt';

  @override
  String get rel_ops_cap_install_plugin => 'Installer un plugin';

  @override
  String get rel_ops_cap_update_plugins => 'Mettre à jour les plugins';

  @override
  String get rel_ops_cap_accept_capabilities => 'Accepter les capacités';

  @override
  String get rel_ops_cap_update => 'Mettre à jour';

  @override
  String get rel_ops_cap_remove_desktop_half =>
      'Supprimer le composant de bureau';

  @override
  String get rel_ops_cap_server_name => 'Nom du serveur';

  @override
  String get rel_ops_cap_command => 'Commande';

  @override
  String get rel_ops_cap_http_url => 'URL HTTP';

  @override
  String get rel_ops_cap_add_server => 'Ajouter un serveur';

  @override
  String get rel_ops_cap_probe => 'Tester';

  @override
  String get rel_ops_cap_probe_failed => 'Échec du test.';

  @override
  String get rel_ops_cap_logs => 'Journaux';

  @override
  String get rel_ops_cap_mcp_log => 'Journal MCP';

  @override
  String get rel_ops_cap_connector => 'Connecteur';

  @override
  String get rel_ops_cap_account_alias => 'Alias du compte';

  @override
  String get rel_ops_cap_link_account => 'Associer un compte';

  @override
  String get rel_ops_cap_remove_account => 'Supprimer le compte';

  @override
  String get rel_ops_cap_tool_connector => 'Connecteur d’outils';

  @override
  String get rel_ops_cap_load_tools => 'Charger les outils';

  @override
  String get rel_ops_cap_save_tool_grants =>
      'Enregistrer les autorisations des outils';

  @override
  String
  get rel_ops_cap_this_policy_has_no_member_revision_so_tool_grants_stay_unchanged =>
      'Cette politique n’a pas de révision de membre ; les autorisations des outils restent donc inchangées.';

  @override
  String get rel_ops_cap_active => 'Actif';

  @override
  String get rel_ops_cap_use => 'Utiliser';

  @override
  String get rel_ops_cap_run_setup => 'Lancer la configuration';

  @override
  String get rel_ops_cap_terminal_backends => 'Moteurs du terminal';

  @override
  String get rel_ops_cap_this_changes_the_terminal_backend_for_this_profile =>
      'Cela modifie le moteur du terminal pour ce profil.';

  @override
  String get rel_ops_cap_use_backend => 'Utiliser ce moteur';

  @override
  String get rel_ops_cap_select => 'Sélectionner';

  @override
  String get rel_ops_cap_browser_vault => 'Coffre-fort du navigateur';

  @override
  String
  get rel_ops_cap_saved_site_logins_addresses_and_cards_passwords_stay_in_the_secure_fields_and_are_not_listed_here =>
      'Connexions aux sites, adresses et cartes enregistrées. Les mots de passe restent dans les champs sécurisés et ne sont pas affichés ici.';

  @override
  String get rel_ops_cap_remove_saved_item => 'Supprimer l’élément enregistré';

  @override
  String get rel_ops_cap_delete_this_item => 'Supprimer cet élément ?';

  @override
  String get rel_ops_cap_unlocked => 'Déverrouillé';

  @override
  String get rel_ops_cap_locked => 'Verrouillé';

  @override
  String get rel_ops_cap_not_detected => 'Non détecté';

  @override
  String get rel_ops_cap_master_password => 'Mot de passe principal';

  @override
  String get rel_ops_cap_login => 'Identifiants de connexion';

  @override
  String get rel_ops_cap_address => 'Adresse';

  @override
  String get rel_ops_cap_card => 'Carte';

  @override
  String get rel_ops_cap_label => 'Libellé';

  @override
  String get rel_ops_cap_site_origin => 'Origine du site';

  @override
  String get rel_ops_cap_identifier => 'Identifiant';

  @override
  String get rel_ops_cap_password => 'Mot de passe';

  @override
  String get rel_ops_cap_authenticator_key => 'Clé d’authentification';

  @override
  String get rel_ops_cap_street => 'Rue';

  @override
  String get rel_ops_cap_city => 'Ville';

  @override
  String get rel_ops_cap_postal_code => 'Code postal';

  @override
  String get rel_ops_cap_country => 'Pays';

  @override
  String get rel_ops_cap_name_on_card => 'Nom sur la carte';

  @override
  String get rel_ops_cap_card_number => 'Numéro de carte';

  @override
  String get rel_ops_cap_expiry_month => 'Mois d’expiration';

  @override
  String get rel_ops_cap_expiry_year => 'Année d’expiration';

  @override
  String get rel_ops_cap_security_code => 'Code de sécurité';

  @override
  String get rel_ops_cap_this_gateway_has_no_shared_metrics_consent_method =>
      'Cette passerelle n’a pas de méthode de consentement au partage des métriques.';

  @override
  String get rel_ops_cap_agent_policy => 'Politique de l’agent';

  @override
  String get rel_ops_cap_loading_policy => 'Chargement de la politique';

  @override
  String get rel_ops_cap_approval_timeout => 'Délai d’approbation';

  @override
  String get rel_ops_cap_confirm_mcp_reloads =>
      'Confirmer les rechargements MCP';

  @override
  String get rel_ops_cap_command_allowlist => 'Liste des commandes autorisées';

  @override
  String get rel_ops_cap_file_checkpoints =>
      'Points de restauration des fichiers';

  @override
  String get rel_ops_cap_checkpoint_limit =>
      'Limite des points de restauration';

  @override
  String get rel_ops_cap_browser_private_urls =>
      'URL privées dans le navigateur';

  @override
  String get rel_ops_cap_use_my_real_browser_profile =>
      'Utiliser mon vrai profil de navigateur';

  @override
  String get rel_ops_cap_save_policy => 'Enregistrer la politique';

  @override
  String get rel_ops_cap_shared_metrics_for_this_profile =>
      'Métriques partagées pour ce profil';

  @override
  String get rel_ops_cap_send_shared_metrics =>
      'Envoyer les métriques partagées';

  @override
  String get rel_ops_cap_error_enter_a_label => 'Saisissez un libellé.';

  @override
  String get rel_ops_cap_error_enter_a_valid_url_like_https_example_com =>
      'Saisissez une URL valide, comme https://example.com.';

  @override
  String get rel_ops_cap_error_enter_the_identifier_and_password =>
      'Saisissez l’identifiant et le mot de passe.';

  @override
  String
  get rel_ops_cap_error_enter_the_card_name_number_expiry_and_security_code =>
      'Saisissez le nom sur la carte, son numéro, sa date d’expiration et son code de sécurité.';

  @override
  String get rel_ops_cap_error_enter_the_street_city_postal_code_and_country =>
      'Saisissez la rue, la ville, le code postal et le pays.';

  @override
  String
  get rel_ops_cap_error_the_gateway_returned_a_response_that_could_not_be_read =>
      'La passerelle a renvoyé une réponse illisible.';

  @override
  String rel_ops_cap_error_the_gateway_refused_the_request_status(
    int statusCode,
  ) {
    return 'La passerelle a refusé la requête ($statusCode).';
  }

  @override
  String
  rel_ops_cap_error_this_connection_has_no_gateway_socket_so_method_is_unavailable(
    String method,
  ) {
    return 'Cette connexion n’a pas de socket de passerelle ; $method n’est donc pas disponible.';
  }

  @override
  String get rel_ops_cap_error_choose_a_skill => 'Choisissez une compétence.';

  @override
  String get rel_ops_cap_error_the_skill_text_was_not_returned =>
      'Le texte de la compétence n’a pas été renvoyé.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_saved =>
      'La compétence n’a pas été enregistrée.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_archived =>
      'La compétence n’a pas été archivée.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_installed =>
      'La compétence n’a pas été installée.';

  @override
  String get rel_ops_cap_error_skill_updates_did_not_start =>
      'Les mises à jour des compétences n’ont pas démarré.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_removed =>
      'La compétence n’a pas été supprimée.';

  @override
  String get rel_ops_cap_error_enter_a_skill_or_plugin_identifier =>
      'Saisissez un identifiant de compétence ou de plugin.';

  @override
  String get rel_ops_cap_error_choose_a_plugin => 'Choisissez un plugin.';

  @override
  String get rel_ops_cap_error_the_plugin_was_not_removed =>
      'Le plugin n’a pas été supprimé.';

  @override
  String get rel_ops_cap_error_the_desktop_half_was_not_removed =>
      'Le composant de bureau n’a pas été supprimé.';

  @override
  String
  get rel_ops_cap_error_this_gateway_did_not_give_the_plugin_a_stable_key =>
      'Cette passerelle n’a pas attribué de clé stable au plugin.';

  @override
  String get rel_ops_cap_error_the_plugin_was_not_changed =>
      'Le plugin n’a pas été modifié.';

  @override
  String get rel_ops_cap_error_choose_a_server => 'Choisissez un serveur.';

  @override
  String get rel_ops_cap_error_name_the_server => 'Donnez un nom au serveur.';

  @override
  String get rel_ops_cap_error_give_the_server_a_command_or_an_http_s_url =>
      'Indiquez une commande ou une URL http(s) pour le serveur.';

  @override
  String get rel_ops_cap_error_choose_a_toolset =>
      'Choisissez un ensemble d’outils.';

  @override
  String get rel_ops_cap_error_tool_backend_status_was_not_returned =>
      'L’état du moteur d’outils n’a pas été renvoyé.';

  @override
  String get rel_ops_cap_error_choose_a_provider =>
      'Choisissez un fournisseur.';

  @override
  String get rel_ops_cap_error_this_provider_has_no_setup_action =>
      'Ce fournisseur n’a pas d’action de configuration.';

  @override
  String get rel_ops_cap_error_setup_did_not_start =>
      'La configuration n’a pas démarré.';

  @override
  String get rel_ops_cap_error_choose_a_terminal_backend =>
      'Choisissez un moteur de terminal.';

  @override
  String get rel_ops_cap_error_name_the_connector =>
      'Donnez un nom au connecteur.';

  @override
  String get rel_ops_cap_error_choose_an_account => 'Choisissez un compte.';

  @override
  String
  get rel_ops_cap_error_reload_the_connector_policy_before_changing_tool_grants =>
      'Rechargez la politique du connecteur avant de modifier les autorisations des outils.';

  @override
  String get rel_ops_cap_error_choose_an_item => 'Choisissez un élément.';

  @override
  String get rel_ops_cap_error_choose_a_source => 'Choisissez une source.';

  @override
  String get rel_ops_cap_error_enter_the_master_password =>
      'Saisissez le mot de passe principal.';

  @override
  String get rel_ops_cap_error_gateway_config_was_not_returned =>
      'La configuration de la passerelle n’a pas été renvoyée.';

  @override
  String get rel_ops_cap_error_choose_a_known_approval_mode =>
      'Choisissez un mode d’approbation connu.';

  @override
  String get rel_ops_cap_error_use_a_positive_limit =>
      'Utilisez une limite positive.';

  @override
  String get rel_ops_cap_error_the_policy_was_not_saved =>
      'La politique n’a pas été enregistrée.';

  @override
  String get rel_ops_cap_value_manual => 'manuelle';

  @override
  String get rel_ops_cap_value_smart => 'intelligente';

  @override
  String get rel_ops_cap_value_off => 'désactivé';

  @override
  String get rel_ops_cap_value_safe => 'sûr';

  @override
  String get rel_ops_cap_value_caution => 'prudence';

  @override
  String get rel_ops_cap_value_dangerous => 'dangereux';

  @override
  String get rel_ops_cap_value_blocked => 'bloqué';

  @override
  String get rel_ops_cap_value_clean => 'sans menace';

  @override
  String get rel_ops_cap_value_ready => 'prêt';

  @override
  String get rel_ops_cap_value_available => 'disponible';

  @override
  String get rel_ops_cap_value_unavailable => 'indisponible';

  @override
  String get rel_ops_cap_value_enabled => 'activé';

  @override
  String get rel_ops_cap_value_disabled => 'désactivé';

  @override
  String get rel_ops_cap_value_active => 'actif';

  @override
  String get rel_ops_cap_value_inactive => 'inactif';

  @override
  String get rel_ops_cap_value_installed => 'installé';

  @override
  String get rel_ops_cap_value_missing => 'manquant';

  @override
  String get rel_ops_cap_value_configured => 'configuré';

  @override
  String get rel_ops_cap_value_not_configured => 'non configuré';

  @override
  String get rel_ops_cap_value_error => 'erreur';

  @override
  String get rel_ops_cap_value_unknown => 'inconnu';

  @override
  String get rel_ops_cap_value_login => 'connexion';

  @override
  String get rel_ops_cap_value_address => 'adresse';

  @override
  String get rel_ops_cap_value_payment => 'paiement';

  @override
  String get rel_ops_term_connecting => 'Connexion…';

  @override
  String get rel_ops_term_unbound =>
      'Aucune session active ni aucun répertoire de travail de l’hôte ne correspond. Ouvrez d’abord la discussion associée.';

  @override
  String get rel_ops_term_unsupported =>
      'Cette passerelle ne propose pas cette fonctionnalité de terminal. Aucun interpréteur de commandes local n’a été lancé.';

  @override
  String get rel_ops_term_local_pty_unavailable =>
      'Le pseudo-terminal local (PTY) fourni n’est pas disponible sur cet appareil.';

  @override
  String get rel_ops_term_operation_failed =>
      'Impossible d’ouvrir ou de contrôler le terminal. Vérifiez l’hôte, les identifiants et l’empreinte. Aucun interpréteur de commandes de secours n’a été lancé.';

  @override
  String get rel_ops_term_input_refused =>
      'Saisie refusée. Rouvrez la discussion d’origine.';

  @override
  String get rel_ops_term_cancel => 'Annuler';

  @override
  String get rel_ops_term_confirm => 'Confirmer';

  @override
  String get rel_ops_term_open_device_title =>
      'Ouvrir un interpréteur de commandes sur cet appareil ?';

  @override
  String get rel_ops_term_ssh_shell => 'Interpréteur de commandes SSH';

  @override
  String get rel_ops_term_local_shell => 'Interpréteur de commandes local';

  @override
  String get rel_ops_term_connection_lost => 'Connexion perdue';

  @override
  String get rel_ops_term_shell_ended => 'Interpréteur de commandes terminé';

  @override
  String get rel_ops_term_no_owner =>
      'Cette discussion n’a pas de propriétaire authentifié pour le terminal de la passerelle. Une URL ou une connexion au cloud seule ne donne pas accès à un interpréteur de commandes.';

  @override
  String get rel_ops_term_open_gateway_title =>
      'Ouvrir un interpréteur de commandes sur la passerelle ?';

  @override
  String get rel_ops_term_shell_expired =>
      'Interpréteur de commandes terminé ou expiré';

  @override
  String get rel_ops_term_disconnected => 'Déconnecté';

  @override
  String get rel_ops_term_gateway_shell =>
      'Interpréteur de commandes de la passerelle';

  @override
  String get rel_ops_term_close_body =>
      'Terminer cet interpréteur de commandes. Pour le laisser fonctionner, masquez plutôt le volet.';

  @override
  String get rel_ops_term_closing => 'Fermeture…';

  @override
  String get rel_ops_term_close_unconfirmed => 'Fermeture non confirmée';

  @override
  String get rel_ops_term_processes_require_chat =>
      'Les processus de l’agent nécessitent la discussion authentifiée à laquelle ils appartiennent.';

  @override
  String get rel_ops_term_watching_processes =>
      'Surveillance des processus de l’agent de cette discussion. Fermer une vue miroir n’arrête jamais son processus.';

  @override
  String get rel_ops_term_paste_limit => 'Le collage est limité à 16 KiB.';

  @override
  String get rel_ops_term_paste => 'Coller';

  @override
  String get rel_ops_term_select_first =>
      'Sélectionnez d’abord la sortie du terminal.';

  @override
  String get rel_ops_term_open_chat_to_insert =>
      'Ouvrez la discussion d’origine avant d’insérer la sortie.';

  @override
  String get rel_ops_term_added_to_draft =>
      'Ajouté au brouillon de la discussion d’origine. Rien n’a été envoyé.';

  @override
  String get rel_ops_term_close => 'Fermer';

  @override
  String get rel_ops_term_add_selection =>
      'Ajouter la sélection au brouillon de la discussion';

  @override
  String get rel_ops_term_new_terminal => 'Nouveau terminal';

  @override
  String get rel_ops_term_gateway_terminal =>
      'Terminal de l’hôte de la passerelle';

  @override
  String get rel_ops_term_verified_ssh_terminal => 'Terminal SSH vérifié';

  @override
  String get rel_ops_term_device_local_shell =>
      'Cet appareil (interpréteur de commandes local)';

  @override
  String get rel_ops_term_local_unavailable_mobile =>
      'Interpréteur de commandes local indisponible sur mobile';

  @override
  String get rel_ops_term_watch_processes =>
      'Surveiller les processus de l’agent';

  @override
  String get rel_ops_term_select_output => 'Sélectionner ou copier la sortie';

  @override
  String get rel_ops_term_add_selected_output =>
      'Ajouter la sortie sélectionnée au brouillon de la discussion';

  @override
  String get rel_ops_term_review_paste =>
      'Vérifier le collage du presse-papiers';

  @override
  String get rel_ops_term_reconnect =>
      'Se reconnecter au même interpréteur de commandes';

  @override
  String get rel_ops_term_close_mirror => 'Fermer la vue miroir';

  @override
  String get rel_ops_term_close_shell => 'Fermer l’interpréteur de commandes';

  @override
  String get rel_ops_term_empty =>
      'Choisissez + pour ouvrir un terminal. Aucun interpréteur de commandes ne démarre automatiquement.';

  @override
  String get rel_ops_term_reason_stale => 'périmé';

  @override
  String get rel_ops_term_reason_mismatch => 'non concordant';

  @override
  String get rel_ops_term_reason_unbound => 'non associé';

  @override
  String get rel_ops_term_reason_unsupported => 'non pris en charge';

  @override
  String get rel_ops_term_reason_denied => 'refusé';

  @override
  String get rel_ops_term_reason_ineligible => 'non admissible';

  @override
  String get rel_ops_term_reason_unavailable => 'indisponible';

  @override
  String get rel_ops_term_reason_invalid => 'non valide';

  @override
  String get rel_ops_term_reason_insecure => 'non sécurisé';

  @override
  String rel_ops_term_refused(String reason) {
    return 'La passerelle a refusé cette opération de terminal ($reason).';
  }

  @override
  String rel_ops_term_open_device_body(String connection) {
    return 'Il s’agit de l’appareil Ares, et non de $connection. L’interpréteur de commandes utilise les autorisations de l’application et démarre dans son espace de stockage.';
  }

  @override
  String rel_ops_term_open_gateway_body(String host) {
    return 'Lancez un interpréteur de commandes sur $host dans le répertoire de travail vérifié de la discussion. Il ne s’agit pas d’un interpréteur de commandes sur l’appareil.';
  }

  @override
  String rel_ops_term_close_tab_title(String label) {
    return 'Fermer $label ?';
  }

  @override
  String rel_ops_term_read_only_status(String status) {
    return 'Lecture seule · $status';
  }

  @override
  String rel_ops_term_paste_title(String label) {
    return 'Coller dans $label ?';
  }

  @override
  String rel_ops_term_output_title(String label) {
    return 'Sortie · $label';
  }

  @override
  String rel_ops_term_mirror_status(String label) {
    return 'Vue miroir du processus en lecture seule · $label';
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
    return 'Cet appareil · $number';
  }

  @override
  String rel_ops_term_gateway_tab(String host, int number) {
    return 'Passerelle $host · $number';
  }

  @override
  String get rel_ops_term_earlier_output_trimmed =>
      '[Sortie antérieure tronquée]';

  @override
  String get rel_ops_term_ssh_dialog_title => 'Ouvrir un terminal SSH vérifié';

  @override
  String get rel_ops_term_ssh_dialog_body =>
      'Utilisez une empreinte obtenue indépendamment auprès de l’administrateur de l’hôte. Cela ouvre une nouvelle session distante, et non la passerelle ni un interpréteur de commandes local.';

  @override
  String get rel_ops_term_ssh_host => 'Hôte SSH';

  @override
  String get rel_ops_term_ssh_port => 'Port';

  @override
  String get rel_ops_term_ssh_user => 'Utilisateur';

  @override
  String get rel_ops_term_ssh_fingerprint =>
      'Empreinte de la clé de l’hôte (SHA256:…)';

  @override
  String get rel_ops_term_ssh_password => 'Mot de passe SSH (non enregistré)';

  @override
  String get rel_ops_term_connect => 'Se connecter';

  @override
  String get rel_ops_ssh_invalid_destination =>
      'Hôte, port ou utilisateur SSH non valide.';

  @override
  String get rel_ops_ssh_public_key_required =>
      'Une clé publique d’hôte OpenSSH Ed25519 est requise.';

  @override
  String get rel_ops_ssh_invalid_public_key => 'Clé d’hôte Ed25519 non valide.';

  @override
  String get rel_ops_ssh_invalid_saved_key =>
      'La clé d’hôte enregistrée n’est pas valide.';

  @override
  String get rel_ops_ssh_enrollment_unverified =>
      'Impossible de vérifier l’enrôlement de la clé d’hôte.';

  @override
  String get rel_ops_ssh_different_key_pinned =>
      'Une autre clé est déjà épinglée. Vérifiez le changement séparément.';

  @override
  String get rel_ops_ssh_open_ssh_unavailable =>
      'OpenSSH n’est pas disponible sur le système.';

  @override
  String get rel_ops_ssh_confirm_host_key =>
      'Confirmez la clé d’hôte avant de vous connecter.';

  @override
  String get rel_ops_ssh_absolute_identity_required =>
      'Sélectionnez un fichier d’identité avec un chemin absolu.';

  @override
  String get rel_ops_ssh_invalid_remote_port => 'Port distant non valide.';

  @override
  String get rel_ops_ssh_preview_too_large =>
      'L’aperçu dépasse la limite de 64 KiB.';

  @override
  String get rel_ops_ssh_connection_refused =>
      'Connexion SSH refusée. Vérifiez la clé d’hôte enrôlée, l’identité et le service.';

  @override
  String get rel_ops_ssh_http_not_ok =>
      'Le service distant n’a pas renvoyé HTTP 200.';

  @override
  String get rel_ops_ssh_encoded_response =>
      'Cet aperçu ne prend pas en charge les réponses encodées.';

  @override
  String get rel_ops_ssh_preview_type_unsupported =>
      'Seuls le texte et le code source HTML peuvent être prévisualisés.';

  @override
  String get rel_ops_ssh_health_unconfirmed =>
      'Le service n’a pas confirmé le bon fonctionnement de la passerelle.';

  @override
  String get rel_ops_ssh_enroll_host_key_first =>
      'Enrôlez d’abord la clé publique de l’hôte.';

  @override
  String get rel_ops_ssh_cancel => 'Annuler';

  @override
  String get rel_ops_ssh_confirm => 'Confirmer';

  @override
  String get rel_ops_ssh_pin_title => 'Épingler cette clé d’hôte SSH ?';

  @override
  String rel_ops_ssh_pin_detail(String destination, String fingerprint) {
    return '$destination\n$fingerprint\nComparez cette empreinte avec l’administrateur de l’hôte via un canal indépendant. Aucune connexion ne sera établie.';
  }

  @override
  String get rel_ops_ssh_host_key_pinned => 'Clé d’hôte épinglée.';

  @override
  String get rel_ops_ssh_shell_detail =>
      'Ouvrir un shell de connexion interactif.';

  @override
  String rel_ops_ssh_read_detail(String path, int port) {
    return 'Lire $path sur 127.0.0.1:$port de la machine distante via un canal SSH.';
  }

  @override
  String rel_ops_ssh_connect_title(String destination) {
    return 'Se connecter à $destination ?';
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
      'Authentifiez-vous avec votre agent SSH.';

  @override
  String get rel_ops_ssh_identity_auth =>
      'Utiliser le fichier d’identité sélectionné.';

  @override
  String rel_ops_ssh_gateway_responding(int port) {
    return 'La passerelle répond sur le port de bouclage distant $port.';
  }

  @override
  String get rel_ops_ssh_session_closed => 'Session SSH fermée.';

  @override
  String get rel_ops_ssh_session_unclean =>
      'La session SSH s’est terminée sans sortie normale.';

  @override
  String get rel_ops_ssh_operation_failed =>
      'Échec de l’opération SSH. Vérifiez la destination et l’identité.';

  @override
  String get rel_ops_ssh_title => 'SSH vérifié';

  @override
  String get rel_ops_ssh_unsupported =>
      'Cet appareil ne dispose d’aucun transport OpenSSH système pris en charge. Le relais de la passerelle épinglée accepte automatiquement les nouvelles clés et ne peut pas être utilisé pour un enrôlement vérifié.';

  @override
  String get rel_ops_ssh_host => 'Hôte SSH';

  @override
  String get rel_ops_ssh_port => 'Port SSH';

  @override
  String get rel_ops_ssh_user => 'Utilisateur SSH';

  @override
  String get rel_ops_ssh_identity =>
      'Fichier d’identité (facultatif ; sinon, utiliser l’agent SSH)';

  @override
  String get rel_ops_ssh_public_key =>
      'Clé publique d’hôte fournie par l’administrateur (ssh-ed25519)';

  @override
  String get rel_ops_ssh_review_key => 'Examiner la clé d’hôte';

  @override
  String get rel_ops_ssh_remote_port => 'Port du service de bouclage distant';

  @override
  String get rel_ops_ssh_check_gateway => 'Vérifier la passerelle via SSH';

  @override
  String get rel_ops_ssh_preview_source =>
      'Prévisualiser le code source via SSH';

  @override
  String get rel_ops_ssh_open_shell => 'Ouvrir un shell SSH';

  @override
  String get rel_ops_ssh_shell_line => 'Ligne à envoyer au shell distant';

  @override
  String get rel_ops_ssh_disconnect => 'Déconnecter le shell';

  @override
  String get rel_ops_host_cancel => 'Annuler';

  @override
  String get rel_ops_host_confirm => 'Confirmer';

  @override
  String get rel_ops_host_title => 'Hôte';

  @override
  String get rel_ops_host_refresh => 'Actualiser';

  @override
  String get rel_ops_host_update => 'Mettre à jour Hermes à distance';

  @override
  String rel_ops_host_update_confirmation(String profile) {
    return 'Ceci lance une mise à jour sur place sur l’hôte de la passerelle pour $profile. Ares ne sera pas mis à jour sur cet appareil. La réussite est attestée par le compte rendu de mise à jour correspondant, et non par le fait que l’hôte reste joignable.';
  }

  @override
  String get rel_ops_host_update_awaiting =>
      'En attente du compte rendu correspondant. La mise à jour est toujours en cours.';

  @override
  String get rel_ops_host_receipt_success =>
      'Le compte rendu de mise à jour indique une réussite.';

  @override
  String get rel_ops_host_receipt_partial =>
      'Mise à jour appliquée ; des étapes de suivi restent à effectuer.';

  @override
  String get rel_ops_host_receipt_failed =>
      'Le compte rendu de mise à jour indique un échec.';

  @override
  String get rel_ops_host_receipt_refused =>
      'Le compte rendu de mise à jour indique un refus.';

  @override
  String get rel_ops_host_update_running =>
      'La mise à jour est toujours en cours.';

  @override
  String get rel_ops_host_update_unknown =>
      'Le résultat de la mise à jour est inconnu. Une passerelle active ne signifie pas que la mise à jour a réussi.';

  @override
  String get rel_ops_host_default_profile =>
      'le profil par défaut de la passerelle';

  @override
  String get rel_ops_host_restart => 'Redémarrer la passerelle distante';

  @override
  String rel_ops_host_restart_shared_confirmation(String profiles) {
    return 'Ceci redémarre la passerelle partagée par $profiles. Les tours en cours sur cette passerelle seront interrompus. Reconnectez-vous ensuite. Le fait qu’elle soit joignable ne prouve pas que le redémarrage est terminé.';
  }

  @override
  String rel_ops_host_restart_confirmation(String profile) {
    return 'Ceci redémarre la passerelle distante pour $profile. Les tours en cours sur cette passerelle seront interrompus. Reconnectez-vous ensuite.';
  }

  @override
  String get rel_ops_host_restart_running =>
      'La commande de redémarrage est toujours en cours.';

  @override
  String get rel_ops_host_restart_finished =>
      'La commande de redémarrage est terminée. Reconnectez-vous à l’hôte manuellement.';

  @override
  String get rel_ops_host_restart_failed =>
      'La commande de redémarrage a échoué.';

  @override
  String rel_ops_host_maintenance_running(String name) {
    return '$name est toujours en cours';
  }

  @override
  String rel_ops_host_maintenance_finished(String name) {
    return '$name est terminé';
  }

  @override
  String rel_ops_host_maintenance_failed(String name) {
    return '$name a échoué';
  }

  @override
  String get rel_ops_host_curator_paused_result => 'Curateur en pause.';

  @override
  String get rel_ops_host_curator_resumed_result => 'Curateur relancé.';

  @override
  String get rel_ops_host_reset =>
      'Réinitialiser les fichiers de mémoire distants';

  @override
  String rel_ops_host_reset_confirmation(String targetName, String profile) {
    return 'Supprimer le fichier de mémoire $targetName sur $profile ? Cette action ne peut pas être annulée depuis Ares.';
  }

  @override
  String rel_ops_host_reset_result(String targetName, int count) {
    return '$targetName réinitialisé. $count fichier(s) distant(s) supprimé(s).';
  }

  @override
  String get rel_ops_host_share_not_redacted =>
      'L’hôte n’a pas confirmé le masquage des données sensibles dans l’archive. Aucun lien n’est affiché.';

  @override
  String rel_ops_host_scope(String connection, String profile) {
    return 'Ces commandes agissent sur la passerelle distante $connection pour $profile, pas sur cet appareil ni sur la mise à jour du client Ares.';
  }

  @override
  String rel_ops_host_health_running(String version, int count) {
    return 'Processus de passerelle en cours $version · $count sessions';
  }

  @override
  String rel_ops_host_health_stopped(String version, int count) {
    return 'Processus de passerelle arrêté $version · $count sessions';
  }

  @override
  String rel_ops_host_heartbeat_stale(num seconds) {
    return 'Le signal de présence de l’hôte est ancien ($seconds s).';
  }

  @override
  String get rel_ops_host_doctor => 'Exécuter Doctor';

  @override
  String get rel_ops_host_security_audit => 'Audit de sécurité';

  @override
  String get rel_ops_host_check_receipt =>
      'Vérifier le compte rendu de mise à jour';

  @override
  String get rel_ops_host_logs => 'Journaux de l’hôte distant';

  @override
  String get rel_ops_host_search_logs =>
      'Rechercher dans les journaux de l’hôte';

  @override
  String get rel_ops_host_driver => 'Pilote de l’hôte distant';

  @override
  String get rel_ops_host_driver_scope =>
      'La disponibilité du contrôle de l’ordinateur dépend du pilote et des autorisations du système d’exploitation de la machine de la passerelle, pas de cet appareil.';

  @override
  String rel_ops_host_computer_status(
    String platform,
    String installed,
    String ready,
  ) {
    return '$platform · installé $installed · prêt $ready';
  }

  @override
  String get rel_ops_host_null => 'indisponible';

  @override
  String get rel_ops_host_true => 'oui';

  @override
  String get rel_ops_host_false => 'non';

  @override
  String get rel_ops_host_curator => 'Curateur';

  @override
  String get rel_ops_host_curator_paused => 'Curateur en pause';

  @override
  String get rel_ops_host_curator_running => 'Curateur en cours d’exécution';

  @override
  String get rel_ops_host_no_run => 'Aucune exécution terminée';

  @override
  String get rel_ops_host_run_curator => 'Exécuter le Curateur maintenant';

  @override
  String get rel_ops_host_reset_memory => 'Réinitialiser le fichier de mémoire';

  @override
  String get rel_ops_host_reset_user => 'Réinitialiser le fichier utilisateur';

  @override
  String get rel_ops_host_reset_both => 'Réinitialiser les deux fichiers';

  @override
  String get rel_ops_host_share_consent =>
      'J’accepte d’envoyer une archive de diagnostic de l’hôte distant dont les données sensibles ont été masquées';

  @override
  String get rel_ops_host_share =>
      'Partager les diagnostics avec les données sensibles masquées';

  @override
  String get rel_ops_host_update_unknown_installation =>
      'Cette installation est inconnue ; la mise à jour n’a donc pas été envoyée';

  @override
  String get rel_ops_host_update_busy_installation =>
      'Une conversation est en cours sur cette installation';

  @override
  String get rel_ops_host_update_refused => 'Mise à jour distante refusée';

  @override
  String get rel_ops_host_error_stale => 'Espace de travail distant : obsolète';

  @override
  String get rel_ops_host_error_mismatch =>
      'Espace de travail distant : discordance';

  @override
  String get rel_ops_host_error_unbound =>
      'Espace de travail distant : non associé';

  @override
  String get rel_ops_host_error_unsupported =>
      'Espace de travail distant : non pris en charge';

  @override
  String get rel_ops_host_error_denied =>
      'Espace de travail distant : accès refusé';

  @override
  String get rel_ops_host_error_ineligible =>
      'Espace de travail distant : non admissible';

  @override
  String get rel_ops_host_error_unavailable =>
      'Espace de travail distant : indisponible';

  @override
  String get rel_ops_host_error_invalid =>
      'Espace de travail distant : invalide';

  @override
  String get rel_ops_host_error_insecure =>
      'Espace de travail distant : non sécurisé';

  @override
  String get rel_ops_host_error_request =>
      'Impossible de terminer cette demande.';

  @override
  String get rel_svc_push_api_select_sessions =>
      'Sélectionnez de 1 à 128 ID de session durables, de 1 à 200 caractères ASCII chacun, avec uniquement des lettres, chiffres, _ . : @ ou -. Supprimez les ID vides et les espaces.';

  @override
  String get rel_svc_push_api_unavailable =>
      'Les notifications push mobiles ne sont pas disponibles sur ce serveur.';

  @override
  String get rel_svc_push_api_invalid_vapid =>
      'La clé publique VAPID du serveur n’est pas valide.';

  @override
  String get rel_svc_push_api_update_plugin =>
      'Ce serveur nécessite une extension mobile-push à jour pour les abonnements automatiques.';

  @override
  String get rel_svc_push_status_android_only => 'Android uniquement';

  @override
  String get rel_svc_push_native_prefs_sync_failed =>
      'Impossible de synchroniser les préférences de notifications natives.';

  @override
  String get rel_svc_push_choose_android_connection =>
      'Choisissez d’abord une connexion enregistrée sur Android.';

  @override
  String get rel_svc_push_status_checking_authorization =>
      'Vérification de l’autorisation du serveur';

  @override
  String get rel_svc_push_revoke_persist_failed =>
      'Impossible d’enregistrer la révocation. Réessayez de désactiver avant de quitter l’application.';

  @override
  String get rel_svc_push_status_off_api_ready =>
      'Désactivé ; API du serveur prête';

  @override
  String get rel_svc_push_status_off_revoke_pending =>
      'Désactivé ; révocation du serveur en attente';

  @override
  String get rel_svc_push_status_off_connection_changed =>
      'Désactivé ; connexion enregistrée modifiée';

  @override
  String get rel_svc_push_status_pending_endpoint =>
      'Point de terminaison du distributeur en attente';

  @override
  String get rel_svc_push_status_registering => 'Inscription en cours';

  @override
  String get rel_svc_push_status_pending_challenge =>
      'Défi chiffré en attente (attente de la notification push silencieuse de vérification du serveur)';

  @override
  String get rel_svc_push_allow_android_notifications_retry =>
      'Autorisez les notifications Android dans les paramètres système, puis réessayez.';

  @override
  String get rel_svc_push_plugin_invalid =>
      'L’extension mobile-push du serveur est indisponible, obsolète ou a renvoyé une réponse d’abonnement non valide. Demandez à l’opérateur de la mettre à jour, puis réessayez.';

  @override
  String get rel_svc_push_transport_unavailable =>
      'Aucun transport push n’est disponible. La distribution intégrée nécessite des services Google Play fonctionnels ; vous pouvez aussi installer un distributeur UnifiedPush et réessayer.';

  @override
  String get rel_svc_push_transport_choice =>
      'Plusieurs distributeurs UnifiedPush sont disponibles. Choisissez-en un dans Transport avancé, puis réessayez.';

  @override
  String get rel_svc_push_transport_missing =>
      'Le distributeur UnifiedPush sélectionné est indisponible. Restaurez-le ou choisissez-en un autre dans Transport avancé.';

  @override
  String get rel_svc_push_companion_unavailable =>
      'Le composant mobile-push du serveur est indisponible. Il est peut-être absent ou désactivé, ou cette connexion pointe vers le mauvais tableau de bord. Installez ou activez le composant sur le serveur, vérifiez la connexion au tableau de bord, puis actualisez. Consultez le guide de configuration du serveur ci-dessus.';

  @override
  String get rel_svc_push_server_denied =>
      'Le serveur a refusé les notifications push mobiles. Demandez à l’opérateur d’autoriser ce principal et ces sessions.';

  @override
  String get rel_svc_push_not_ready =>
      'Les notifications push mobiles ne sont pas prêtes. Vérifiez l’autorisation de l’extension serveur, le distributeur et le réseau, puis réessayez.';

  @override
  String get rel_svc_push_availability_read_failed =>
      'Impossible de vérifier la disponibilité des notifications push Android. Réessayez ci-dessous.';

  @override
  String get rel_svc_push_setup_failed =>
      'La configuration push a échoué. Vérifiez l’autorisation Android, l’autorisation du serveur et le transport, puis réessayez.';

  @override
  String rel_svc_push_status(String status) {
    return 'État : $status';
  }

  @override
  String rel_svc_push_status_bound(
    String bound,
    String connection,
    String status,
  ) {
    return 'État : lié à $bound (inactif pour $connection ; négociation : $status)';
  }

  @override
  String get rel_svc_push_another_saved_connection =>
      'une autre connexion enregistrée';

  @override
  String get rel_svc_push_background_notifications =>
      'Notifications en arrière-plan';

  @override
  String rel_svc_push_bound_subtitle(String bound, String connection) {
    return 'Lié à $bound — révoquez cette liaison ci-dessous avant l’activation pour $connection';
  }

  @override
  String rel_svc_push_private_activity(String connection) {
    return 'Activité privée du serveur pour $connection';
  }

  @override
  String rel_svc_push_bound_warning_named(String bound) {
    return 'Lié à une autre connexion enregistrée ($bound). Désactivez et révoquez cette liaison avant l’activation pour cette connexion.';
  }

  @override
  String get rel_svc_push_bound_warning =>
      'Lié à une autre connexion enregistrée. Désactivez et révoquez cette liaison avant l’activation pour cette connexion.';

  @override
  String get rel_svc_push_local_notifications_muted =>
      'Les notifications locales sont désactivées ci-dessus. Le consentement aux notifications en arrière-plan reste inchangé, mais les alertes d’activité ordinaires sont silencieuses jusqu’à l’activation de \"Activer les notifications\".';

  @override
  String rel_svc_push_legacy_subscription(int count) {
    return 'Ancien abonnement : $count session(s) sélectionnée(s) uniquement. Il ne s’étendra pas automatiquement. Désactivez puis réactivez pour accepter les sessions autorisées par le serveur.';
  }

  @override
  String get rel_svc_push_authorized_binding =>
      'Lié uniquement à cette connexion enregistrée et à ce profil. L’accès aux sessions suit l’autorisation actuelle du serveur.';

  @override
  String get rel_svc_push_revocation_pending =>
      'Révocation du serveur en attente. La distribution locale est désactivée ; réessayez tant que la connexion enregistrée d’origine est disponible.';

  @override
  String get rel_svc_push_refresh_retry => 'Actualiser / réessayer';

  @override
  String rel_svc_push_disable_named(String bound) {
    return 'Désactiver et révoquer $bound';
  }

  @override
  String get rel_svc_push_other_connection => 'autre connexion';

  @override
  String get rel_svc_push_disable => 'Désactiver et révoquer';

  @override
  String get rel_svc_push_refresh_explanation =>
      'Actualiser / réessayer revérifie la disponibilité après la configuration du serveur ; cela ne peut pas installer le composant. L’activation des notifications reste un choix distinct.';

  @override
  String get rel_svc_push_companion_required =>
      'Les notifications en arrière-plan nécessitent un composant mobile-push côté serveur installé et activé séparément. Android ne peut pas l’installer. La mise à jour de l’APK seul ne configure pas le serveur.';

  @override
  String get rel_svc_push_server_setup_guide =>
      'Guide de configuration du serveur';

  @override
  String get rel_svc_push_enable_disclosure =>
      'Activez pour demander l’autorisation de notifications Android et partager avec ce serveur le point de terminaison et les clés de chiffrement de cette installation. Les alertes d’activité chiffrées ne contiennent aucun contenu de discussion. Seules les sessions autorisées par votre connexion au serveur sont incluses.';

  @override
  String get rel_svc_push_transport_disclosure =>
      'La distribution intégrée utilise le transport push de Google et nécessite les services Google Play, sans inclure le SDK Firebase. Un distributeur UnifiedPush facultatif peut être utilisé. La distribution est au mieux ; rouvrez Hermes pour réconcilier.';

  @override
  String get rel_svc_push_advanced_transport => 'Transport avancé';

  @override
  String get rel_svc_push_automatic_explanation =>
      'Automatique conserve le distributeur existant ; sinon, la distribution Google intégrée est utilisée si disponible. Désactivez avant de changer de transport.';

  @override
  String get rel_svc_push_transport_label => 'Transport push';

  @override
  String get rel_svc_push_automatic_recommended => 'Automatique (recommandé)';

  @override
  String get rel_svc_push_selected_unavailable =>
      'Distributeur sélectionné (indisponible)';

  @override
  String get rel_svc_push_no_transport_detected =>
      'Aucun transport disponible détecté. La distribution intégrée nécessite les services Google Play ; sinon, installez et configurez un distributeur UnifiedPush, puis actualisez.';

  @override
  String get rel_svc_push_channel_turns_name => 'Tours Ares';

  @override
  String get rel_svc_push_channel_turns_description =>
      'Notifications pour les tours terminés en arrière-plan';

  @override
  String get rel_svc_push_channel_attention_name => 'Attention Ares';

  @override
  String get rel_svc_push_channel_attention_description =>
      'Approbations et demandes de saisie qui vous attendent';

  @override
  String get rel_svc_push_channel_background_name => 'Ares en arrière-plan';

  @override
  String get rel_svc_push_channel_background_description =>
      'Achèvements des tâches en arrière-plan';

  @override
  String get rel_svc_push_channel_notices_name => 'Avis Ares';

  @override
  String get rel_svc_push_channel_notices_description =>
      'Avis de crédits et d’extensions';

  @override
  String get rel_svc_push_diag_not_initialised => 'non initialisé';

  @override
  String get rel_svc_push_diag_replies_off => 'les réponses sont désactivées';

  @override
  String get rel_svc_push_diag_conversation => 'conversation';

  @override
  String get rel_svc_push_diag_conversation_permission_denied =>
      'conversation ; autorisation refusée';

  @override
  String rel_svc_push_diag_conversation_error(String error) {
    return 'conversation : $error';
  }

  @override
  String get rel_svc_push_diag_failures_off => 'les échecs sont désactivés';

  @override
  String rel_svc_push_diag_kind_off(String kind) {
    return '$kind est désactivé';
  }

  @override
  String get rel_svc_push_diag_windows_setting_unknown =>
      'Windows n’a pas indiqué son paramètre de notifications';

  @override
  String get rel_svc_backup_not_hermes_configuration_backup =>
      'Ce fichier n’est pas une sauvegarde de configuration Hermes.';

  @override
  String get rel_svc_backup_newer_version_cannot_import =>
      'Cette sauvegarde a été créée avec une version plus récente de l’application et ne peut pas être importée.';

  @override
  String get rel_svc_backup_missing_client_certificate =>
      'Cette sauvegarde indique un certificat client pour une connexion, mais ne le contient pas ; une restauration complète est donc impossible.';

  @override
  String get rel_svc_backup_damaged_unreadable =>
      'Ce fichier de sauvegarde est endommagé et n’a pas pu être lu.';

  @override
  String get rel_svc_backup_unsupported_preference_type =>
      'Une préférence enregistrée est d’un type non pris en charge et ne peut pas être exportée.';

  @override
  String get rel_svc_backup_choose_passphrase_api_keys =>
      'Choisissez une phrase secrète — la sauvegarde contient vos clés API.';

  @override
  String get rel_svc_backup_could_not_protect_safely =>
      'La sauvegarde n’a pas pu être protégée de manière sûre.';

  @override
  String get rel_svc_backup_unsupported_encryption =>
      'Cette sauvegarde utilise un schéma de chiffrement non pris en charge.';

  @override
  String get rel_svc_backup_wrong_passphrase_or_altered =>
      'La phrase secrète est incorrecte ou ce fichier de sauvegarde a été modifié.';

  @override
  String get rel_svc_backup_share_subject =>
      'Sauvegarde de configuration Hermes';

  @override
  String get rel_svc_backup_selected_file_unreadable =>
      'Ce fichier n’a pas pu être lu.';

  @override
  String rel_svc_backup_connections_added(int count) {
    return '$count ajoutées';
  }

  @override
  String rel_svc_backup_connections_updated(int count) {
    return '$count mises à jour';
  }

  @override
  String rel_svc_backup_connections_removed(int count) {
    return '$count supprimées';
  }

  @override
  String get rel_svc_backup_no_connection_changes =>
      'Aucune modification des connexions';

  @override
  String rel_svc_backup_connections_summary(String changes) {
    return 'Connexions : $changes';
  }

  @override
  String rel_svc_backup_restore_summary(String connections, int count) {
    return '$connections · $count paramètres restaurés';
  }

  @override
  String rel_svc_backup_certificate_not_included(String label, String error) {
    return 'Le certificat client de « $label » n’a pas pu être inclus dans cette sauvegarde : $error';
  }

  @override
  String get rel_svc_backup_certificate_password_needed =>
      'Ce certificat nécessite son mot de passe. Saisissez-le ci-dessous et il s’ouvrira automatiquement.';

  @override
  String get rel_svc_backup_certificate_password_or_corrupt =>
      'Le mot de passe du certificat est incorrect ou le fichier est endommagé.';

  @override
  String get rel_svc_backup_certificate_password_incorrect =>
      'Le mot de passe du certificat est incorrect.';

  @override
  String get rel_svc_backup_certificate_unsupported_encryption =>
      'Ce certificat utilise une méthode de chiffrement que l’application ne peut pas lire.';

  @override
  String get rel_svc_backup_certificate_unreadable_pkcs12 =>
      'Le fichier sélectionné n’est pas un certificat PKCS#12 (.p12/.pfx) lisible.';

  @override
  String get rel_svc_backup_certificate_unreadable =>
      'Le certificat sélectionné n’a pas pu être lu.';

  @override
  String get rel_svc_backup_not_certificate_file =>
      'Ce fichier n’est pas un certificat : choisissez un conteneur .p12/.pfx ou des fichiers de certificat et de clé PEM.';

  @override
  String get rel_svc_backup_not_pem_certificate =>
      'Le certificat sélectionné n’est pas un certificat PEM.';

  @override
  String get rel_svc_backup_not_pem_private_key =>
      'La clé privée sélectionnée n’est pas une clé privée PEM.';

  @override
  String get rel_svc_backup_certificate_pair_unloadable =>
      'Le certificat et la clé privée sélectionnés n’ont pas pu être chargés.';

  @override
  String get rel_svc_backup_saved_certificate_files_unreadable =>
      'Les fichiers de certificat client enregistrés n’ont pas pu être lus.';

  @override
  String get rel_svc_backup_client_certificate_storage_failed =>
      'Le certificat client n’a pas pu être stocké de manière sécurisée sur cet appareil.';

  @override
  String get rel_svc_backup_certificate_storage_failed =>
      'Le certificat n’a pas pu être stocké de manière sécurisée sur cet appareil.';

  @override
  String get rel_svc_backup_client_certificate_label => 'Certificat client';

  @override
  String rel_svc_backup_search_dashboard_unreachable(String error) {
    return 'Impossible d’accéder au tableau de bord : $error';
  }

  @override
  String get rel_svc_backup_search_credentials_rejected =>
      'Le tableau de bord a refusé les identifiants enregistrés. Vérifiez le nom d’utilisateur et le mot de passe du tableau de bord pour cette connexion.';

  @override
  String get rel_svc_backup_search_not_supported =>
      'Ce tableau de bord ne propose pas la recherche de sessions. Mettez Hermes à jour sur l’hôte ou revenez à la recherche sur l’appareil.';

  @override
  String rel_svc_backup_search_redirected(int statusCode) {
    return 'Le tableau de bord a redirigé la recherche de sessions (HTTP $statusCode). Ares ne suit pas les redirections avec des identifiants enregistrés ; vérifiez l’adresse de connexion.';
  }

  @override
  String rel_svc_backup_search_http_failed(int statusCode) {
    return 'La recherche de sessions a échoué avec HTTP $statusCode.';
  }

  @override
  String get rel_svc_backup_search_malformed_response =>
      'Le tableau de bord a renvoyé une réponse de recherche incorrecte.';

  @override
  String get rel_svc_backup_search_unexpected_response =>
      'Le tableau de bord a renvoyé une réponse de recherche inattendue.';

  @override
  String get rel_svc_backup_search_too_many_results =>
      'Le tableau de bord a renvoyé plus de résultats que demandé.';

  @override
  String get rel_svc_backup_message_search_unexpected_response =>
      'Réponse de recherche de messages inattendue.';

  @override
  String get rel_svc_backup_message_search_unexpected_result =>
      'Résultat de recherche de messages inattendu.';

  @override
  String get rel_svc_backup_ai_search_api_key_rejected =>
      'L’API Hermes a refusé la clé API enregistrée.';

  @override
  String rel_svc_backup_ai_search_http_failed(int statusCode) {
    return 'La reformulation de la requête par l’IA a échoué avec HTTP $statusCode.';
  }

  @override
  String get rel_svc_backup_ai_search_no_usable_query =>
      'Le modèle sélectionné n’a renvoyé aucune requête de recherche utilisable.';

  @override
  String get rel_svc_backup_ai_search_malformed_response =>
      'Hermes a renvoyé une réponse de reformulation par l’IA incorrecte.';

  @override
  String get rel_svc_backup_space_name_already_exists =>
      'Un espace portant ce nom existe déjà';

  @override
  String get rel_svc_backup_space_name_length_invalid =>
      'Le nom de l’espace doit comporter entre 1 et 80 caractères';

  @override
  String get ng_rel_svc_backup_gateway_address_required =>
      'Saisissez l’adresse de votre tableau de bord Hermes.';

  @override
  String ng_rel_svc_backup_gateway_address_scheme(String scheme) {
    return 'L’adresse doit commencer par http:// ou https:// ($scheme reçu).';
  }

  @override
  String get ng_rel_svc_backup_gateway_address_invalid =>
      'Cette adresse n’est pas valide.';

  @override
  String get ng_rel_svc_backup_gateway_address_no_host =>
      'L’adresse ne contient aucun nom d’hôte.';

  @override
  String get ng_rel_svc_backup_sign_in_main_window =>
      'Connectez-vous dans la fenêtre principale.';

  @override
  String get rel_svc_backup_sign_in_renewal_failed =>
      'La passerelle n’a pas pu renouveler la connexion pour le moment.';

  @override
  String get rel_svc_backup_sign_in_provider_unreachable =>
      'La passerelle n’a pas pu renouveler la connexion : son fournisseur de connexion est inaccessible.';

  @override
  String get rel_svc_backup_sign_in_renewal_timed_out =>
      'Le renouvellement de la connexion a expiré.';

  @override
  String get rel_svc_backup_sign_in_no_tokens =>
      'La passerelle n’a renvoyé aucun jeton de connexion.';

  @override
  String get ng_rel_svc_backup_probe_timed_out =>
      'Délai dépassé. Vérifiez l’adresse et la connexion VPN ou Tailscale.';

  @override
  String ng_rel_svc_backup_probe_tls_failed(String error) {
    return 'Échec de la négociation TLS : $error';
  }

  @override
  String ng_rel_svc_backup_gateway_answered_http(int statusCode) {
    return 'La passerelle a répondu avec HTTP $statusCode.';
  }

  @override
  String get ng_rel_svc_backup_gateway_answer_timed_out =>
      'La passerelle a mis trop de temps à répondre.';

  @override
  String ng_rel_svc_backup_browser_callback_not_ready(String error) {
    return 'Impossible de préparer le retour du navigateur : $error';
  }

  @override
  String get ng_rel_svc_backup_browser_signed_in_body =>
      'Vous pouvez maintenant revenir à Hermes.';

  @override
  String get ng_rel_svc_backup_browser_waiting_title =>
      'En attente de connexion';

  @override
  String get ng_rel_svc_backup_browser_not_current =>
      'Cette page ne fait pas partie de la connexion en cours.';

  @override
  String get ng_rel_svc_backup_browser_open_failed =>
      'Impossible d’ouvrir le navigateur pour se connecter.';

  @override
  String get ng_rel_svc_backup_browser_sign_in_timed_out =>
      'La connexion a pris trop de temps. Réessayez.';

  @override
  String ng_rel_svc_backup_gateway_refused_sign_in(int statusCode) {
    return 'La passerelle a refusé la connexion (HTTP $statusCode).';
  }

  @override
  String get rel_svc_misc_alert_caution => 'Attention';

  @override
  String get rel_svc_misc_alert_important => 'Important';

  @override
  String get rel_svc_misc_alert_tip => 'Astuce';

  @override
  String get rel_svc_misc_alert_warning => 'Avertissement';

  @override
  String get rel_svc_misc_allow_folder_session =>
      'Autoriser ce dossier jusqu’à la fin de la session.';

  @override
  String get rel_svc_misc_allow_website_session =>
      'Autoriser ce site web jusqu’à la fin de la session.';

  @override
  String rel_svc_misc_approval_needed_title(String title) {
    return 'Approbation requise — $title';
  }

  @override
  String get rel_svc_misc_attach_file_reference =>
      'Joindre une référence de fichier';

  @override
  String get rel_svc_misc_attach_folder_reference =>
      'Joindre une référence de dossier';

  @override
  String get rel_svc_misc_attach_git_context => 'Joindre le contexte git';

  @override
  String get rel_svc_misc_attach_image_reference =>
      'Joindre une référence d’image';

  @override
  String get rel_svc_misc_attach_staged_diff => 'Joindre le diff indexé';

  @override
  String get rel_svc_misc_attach_tool_reference =>
      'Joindre une référence d’outil';

  @override
  String get rel_svc_misc_attach_unstaged_diff => 'Joindre le diff non indexé';

  @override
  String get rel_svc_misc_attach_url_reference => 'Joindre une référence d’URL';

  @override
  String get rel_svc_misc_background_task_completed =>
      'Tâche en arrière-plan terminée';

  @override
  String rel_svc_misc_background_task_named_completed(String taskId) {
    return 'Tâche en arrière-plan $taskId terminée';
  }

  @override
  String get rel_svc_misc_chat => 'Discussion';

  @override
  String get rel_svc_misc_compacting_context =>
      'Compactage du contexte de la conversation…';

  @override
  String rel_svc_misc_completed_in(String duration) {
    return 'Terminé en $duration';
  }

  @override
  String get rel_svc_misc_context_compacted =>
      'Contexte de la conversation compacté';

  @override
  String get rel_svc_misc_cron_readback_mismatch =>
      'La relecture du modèle Cron ne correspondait pas';

  @override
  String get rel_svc_misc_cron_update_rejected => 'Mise à jour Cron refusée';

  @override
  String get rel_svc_misc_deny_folder_grant =>
      'Ne pas accorder l’accès à ce dossier.';

  @override
  String get rel_svc_misc_deny_website_grant =>
      'Ne pas accorder l’accès à ce site web.';

  @override
  String rel_svc_misc_failed_after(String duration) {
    return 'Échec après $duration';
  }

  @override
  String get rel_svc_misc_gateway_folder_unnamed =>
      'La passerelle n’a indiqué aucun dossier.';

  @override
  String get rel_svc_misc_gateway_idle_unconfirmed =>
      'La passerelle est inactive. Le résultat du tour précédent n’a pas pu être confirmé.';

  @override
  String get rel_svc_misc_gateway_turn_failed =>
      'Échec du tour de la passerelle';

  @override
  String rel_svc_misc_gateway_turn_status(String status) {
    return 'Tour de la passerelle : $status';
  }

  @override
  String get rel_svc_misc_gateway_website_unnamed =>
      'La passerelle n’a indiqué aucun site web.';

  @override
  String get rel_svc_misc_hermes_review => 'Examen Hermes';

  @override
  String get rel_svc_misc_hermes_turn_failed => 'Échec du tour Hermes';

  @override
  String get rel_svc_misc_image_recovery_companion_gap =>
      'La récupération des images et du texte n’est pas disponible avec la récupération compagnon. Un envoi d’image non confirmé ne peut pas être restauré sur cette connexion et rien n’est renvoyé automatiquement.';

  @override
  String get rel_svc_misc_image_recovery_rest_gap =>
      'La récupération des images et du texte n’est pas disponible avec Classic REST/SSE. Un envoi d’image non confirmé ne peut pas être restauré sur cette connexion et rien n’est renvoyé automatiquement.';

  @override
  String rel_svc_misc_input_needed_title(String title) {
    return 'Réponse requise — $title';
  }

  @override
  String get rel_svc_misc_parallel_workspace_connection_changed =>
      'La connexion a changé. Rouvrez-la pour utiliser l’espace de travail.';

  @override
  String get rel_svc_misc_preparing => 'Préparation';

  @override
  String get rel_svc_misc_save_folder_grant =>
      'Enregistrer cette autorisation de dossier pour les demandes ultérieures.';

  @override
  String get rel_svc_misc_save_website_grant =>
      'Enregistrer cette autorisation de site web pour les demandes ultérieures.';

  @override
  String get rel_svc_misc_stored_identity_turn_conflict =>
      'Cette discussion a été ouverte via son identité enregistrée alors qu’un autre tour était admis. La requête non envoyée n’a pas été transmise ; réessayez explicitement une fois ce tour terminé.';

  @override
  String get rel_svc_misc_untitled => 'Sans titre';

  @override
  String get rel_svc_misc_wake_capture_silent =>
      'La capture d’activation du client ne détecte que du silence — vérifiez l’accès au microphone du système et réactivez le mot d’activation.';

  @override
  String get rel_svc_misc_wake_capture_stalled =>
      'La capture d’activation du client est bloquée : aucun rappel audio du microphone n’est arrivé.';

  @override
  String rel_svc_misc_wake_feed_refused(int count, String detail) {
    return 'Le flux du mot d’activation a refusé $count trames consécutives$detail — réactivez le mot d’activation.';
  }

  @override
  String rel_svc_misc_wake_microphone_failed(String error) {
    return 'Échec du flux du microphone d’activation du client : $error';
  }

  @override
  String get rel_svc_misc_wake_track_ended =>
      'La piste du microphone s’est arrêtée pendant la capture du mot d’activation — réactivez le mot d’activation.';

  @override
  String get rel_svc_misc_website => 'Site web';

  @override
  String get rel_svc_lan_timeout =>
      'Le délai de découverte sur le réseau local a expiré';

  @override
  String get rel_svc_notification_permission_denied => 'autorisation refusée';

  @override
  String get rel_svc_notifications_off => 'les notifications sont désactivées';

  @override
  String rel_chat_preview_pin_label(int number, String note) {
    return 'n° $number $note';
  }

  @override
  String rel_chat_preview_pin_number(int number) {
    return 'n° $number';
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
  String get fleet_managed_ssh_title => 'SSH géré par la passerelle';

  @override
  String get fleet_managed_ssh_intro =>
      'Gérez les hôtes SSH déjà enregistrés sur cette passerelle depuis n’importe quel appareil. Hermes doit déjà être installé sur l’hôte distant. Cette opération démarre un service distant appartenant à la passerelle ou s’y rattache, et non une connexion de discussion Ares. Les mises à jour gérées et la récupération ne sont disponibles que dans l’application de bureau native.';

  @override
  String get fleet_managed_ssh_read => 'Lire les hôtes SSH enregistrés';

  @override
  String get fleet_managed_ssh_trust =>
      'Lors de cette première connexion, la passerelle fera confiance à la clé SSH de cet hôte et la mémorisera. Toute modification ultérieure de la clé sera signalée et bloquée. La passerelle ne communique pas l’empreinte de la clé ; Ares ne peut donc ni l’afficher ni l’enregistrer. Ne continuez que si vous faites confiance à cette première connexion.';

  @override
  String get fleet_managed_ssh_changed =>
      'La clé SSH de cet hôte a changé. Connexion bloquée. Une personne ayant accès à l’hôte de la passerelle doit vérifier indépendamment l’empreinte de la nouvelle clé et y supprimer l’ancienne clé de confiance. Ne réessayez qu’après cette vérification et cette réparation. Ares ne remplace pas la clé de confiance.';

  @override
  String get fleet_managed_ssh_disconnect_warning =>
      'Déconnecter le tunnel SSH et arrêter le service distant appartenant à cette passerelle ? Cela peut interrompre d’autres clients utilisant ce service.';

  @override
  String get fleet_managed_ssh_verify => 'Vérifier plutôt la clé vous-même';

  @override
  String fleet_managed_ssh_pending(int seconds) {
    return 'En attente de la passerelle : $seconds s. Quitter cette page n’annule pas l’initialisation. Si la requête échoue, vérifiez l’état avant de réessayer.';
  }

  @override
  String fleet_managed_ssh_status(
    String host,
    int localPort,
    int remotePort,
    String version,
    String reused,
  ) {
    return 'Hôte : $host\nPort de bouclage de la passerelle : $localPort\nPort de bouclage distant : $remotePort\nHermes : $version\nRéutilisé : $reused';
  }

  @override
  String get fleet_managed_ssh_disconnect => 'Déconnecter';

  @override
  String get ng_slash_suggestions_loading => 'Chargement des commandes…';

  @override
  String get ng_slash_suggestions_empty => 'Aucune commande correspondante';

  @override
  String get ng_slash_suggestions_label => 'Suggestions de commandes';

  @override
  String get ng_slash_suggestions_skill => 'Compétence';

  @override
  String get settings_classic_title => 'Paramètres Classic';

  @override
  String get settings_nextgen_title => 'Paramètres NextGen';

  @override
  String get settings_category_general => 'Général et langue';

  @override
  String get settings_category_chat => 'Discussion et sessions';

  @override
  String get settings_category_device => 'Appareil et raccourcis';

  @override
  String get settings_category_connections => 'Connexions et modèles';

  @override
  String get settings_category_security => 'Confidentialité et sauvegarde';

  @override
  String get settings_category_about => 'À propos et aide';

  @override
  String get settings_reopen_chat =>
      'Restaurer la dernière discussion au retour vers une passerelle';

  @override
  String get settings_reopen_chat_hint =>
      'Un démarrage à froid ouvre l’accueil. Les liens et notifications ouvrent la discussion demandée.';

  @override
  String get settings_danger => 'Zone de danger';
}
