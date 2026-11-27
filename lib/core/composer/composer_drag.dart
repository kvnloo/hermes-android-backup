/// A path dragged onto a composer.
///
/// [onGateway] paths are references (`@file:` / `@folder:`). A local path is
/// an attachment only after the device confirms the file exists.
class ComposerDrag {
  const ComposerDrag({
    required this.path,
    required this.directory,
    required this.onGateway,
  });

  final String path;
  final bool directory;
  final bool onGateway;
}
