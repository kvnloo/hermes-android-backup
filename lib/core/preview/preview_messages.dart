import '../l10n/l10n.dart';
import '../l10n/workspace_strings.dart';
import '../services/attachment_draft_service.dart';
import '../services/remote_workspace.dart';
import 'reader_document.dart';

/// Retained notices contain no resolved copy, so a locale change can rebuild
/// them even if authentication or a reader request began before localization.
enum PreviewNotice { chatChanged, authenticating, addedToDraft }

String previewNoticeText(AppLocalizations l10n, Object notice) =>
    switch (notice) {
      PreviewNotice.chatChanged => l10n.release_preview_chat_changed,
      PreviewNotice.authenticating => l10n.release_preview_authenticating_chat,
      PreviewNotice.addedToDraft => l10n.release_preview_added_to_draft,
      PreviewError() => switch (notice.reason) {
        PreviewFailure.address => l10n.release_preview_address_not_approved,
        PreviewFailure.pageLimit => l10n.release_preview_page_limit,
        PreviewFailure.unreadable => l10n.release_preview_page_unreadable,
        PreviewFailure.complex => l10n.release_preview_page_complex,
        PreviewFailure.http =>
          notice.statusCode == null
              ? l10n.release_preview_operation_failed
              : l10n.release_preview_http_failed(notice.statusCode!),
        PreviewFailure.contentType => l10n.release_preview_unsupported_type,
        PreviewFailure.secureLoad => l10n.release_preview_load_insecure,
        PreviewFailure.capture => l10n.release_preview_capture_failed,
      },
      WorkspaceException() => l10n.release_preview_unavailable_reason(
        switch (notice.reason) {
          // Preview binding needs a saved, open chat, not a file operation.
          WorkspaceFailure.unbound => l10n.history_error_unbound,
          WorkspaceFailure.ineligible => l10n.history_error_denied,
          _ => workspaceFailureLabel(l10n, notice.reason),
        },
      ),
      AttachmentDraftException() => _attachmentNotice(l10n, notice),
      _ => l10n.release_preview_operation_failed,
    };

/// The shared attachment service still exposes diagnostic strings rather than
/// codes. Match its known local refusals only at the rendering boundary; never
/// display an unknown diagnostic (or an English exception prefix) to the user.
String _attachmentNotice(
  AppLocalizations l10n,
  AttachmentDraftException error,
) => switch (error.message) {
  'Preview crop exceeds its limit.' => l10n.release_preview_crop_limit,
  'The selected image is empty or unreadable.' =>
    l10n.release_preview_image_unreadable,
  'The selected image exceeds the 64 MiB draft budget.' =>
    l10n.release_preview_image_budget,
  'Unsupported image format. Choose a JPEG, PNG, or WebP image.' =>
    l10n.release_preview_image_format,
  'The selected JPEG, PNG, or WebP image could not be decoded safely.' =>
    l10n.release_preview_image_decode,
  'Unable to sanitize this image. Choose a valid JPEG, PNG, or WebP image.' =>
    l10n.release_preview_image_sanitize,
  'You can attach up to 10 items to one Remote Gateway draft.' =>
    l10n.you_can_attach_up_to_items(maxRemoteAttachmentDrafts),
  'Attachments are limited to 64 MiB total per draft.' =>
    l10n.release_preview_draft_budget,
  'Generic files are limited to 16 MiB each.' =>
    l10n.release_preview_generic_file_limit,
  'Remote images must be sanitized before upload.' =>
    l10n.release_preview_image_not_sanitized,
  _ => l10n.release_preview_stage_failed,
};
