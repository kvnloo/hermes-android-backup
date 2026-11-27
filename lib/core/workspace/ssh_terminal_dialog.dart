import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

typedef SshLogin = ({
  String host,
  int port,
  String user,
  String pin,
  String password,
});

/// Credentials entered here are never saved or borrowed from a gateway.
class SshTerminalDialog extends StatefulWidget {
  const SshTerminalDialog({super.key});
  @override
  State<SshTerminalDialog> createState() => _SshState();
}

class _SshState extends State<SshTerminalDialog> {
  final values = List.generate(
    5,
    (i) => TextEditingController(text: i == 1 ? '22' : ''),
  );
  @override
  void dispose() {
    for (final c in values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.sharedL10n.rel_ops_term_ssh_dialog_title),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.sharedL10n.rel_ops_term_ssh_dialog_body),
          for (final (i, label) in [
            context.sharedL10n.rel_ops_term_ssh_host,
            context.sharedL10n.rel_ops_term_ssh_port,
            context.sharedL10n.rel_ops_term_ssh_user,
            context.sharedL10n.rel_ops_term_ssh_fingerprint,
            context.sharedL10n.rel_ops_term_ssh_password,
          ].indexed)
            TextField(
              controller: values[i],
              obscureText: i == 4,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(labelText: label),
            ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.sharedL10n.rel_ops_term_cancel),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, (
          host: values[0].text,
          port: int.tryParse(values[1].text) ?? 0,
          user: values[2].text,
          pin: values[3].text,
          password: values[4].text,
        )),
        child: Text(context.sharedL10n.rel_ops_term_connect),
      ),
    ],
  );
}
