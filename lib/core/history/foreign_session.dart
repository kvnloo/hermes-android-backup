/// A host-mediated Claude/Codex turn as shown in the preview list.
class ForeignTurn {
  const ForeignTurn({required this.role, required this.text});

  final String role;
  final String text;
}
