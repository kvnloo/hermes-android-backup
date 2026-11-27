/// A localized UI refusal without the English prefix added by [StateError].
///
/// Protocol and parser exceptions retain their technical types; this is only
/// for client-authored messages already intended for a user-facing notice.
class UiMessageException implements Exception {
  const UiMessageException(this.message);

  final String message;

  @override
  String toString() => message;
}
