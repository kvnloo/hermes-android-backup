import '../l10n/l10n.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/connection.dart';
import '../workspace/profile_presentation.dart';
import '../workspace/profile_presentation_store.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../services/connection_mutation_barrier.dart';
import '../services/portable_profile_bundle.dart';
import '../services/profile_file_save.dart';
import '../services/remote_workspace.dart';
import 'profile_admin_panel.dart' show profileError;

class ProfileBundleScreen extends StatefulWidget {
  const ProfileBundleScreen({
    super.key,
    required this.admin,
    required this.gateway,
    required this.connection,
    required this.nextGen,
  });
  final RemoteProfileAdmin admin;
  final String gateway;
  final SavedConnection connection;
  final bool nextGen;
  @override
  State<ProfileBundleScreen> createState() => _BundleState();
}

class _BundleState extends State<ProfileBundleScreen> {
  PortableProfileBundle? bundle;
  final checked = <String>{};
  final dest = TextEditingController();
  String message = '';
  bool importing = false, busy = false;
  bool adopt = false;
  ProfilePresentation? preview;
  @override
  void initState() {
    super.initState();
    ConnectionMutationBarrier.addListener(_changed);
  }

  void _changed() {
    final l = context.sharedL10n;
    try {
      widget.admin.check();
    } catch (_) {
      if (mounted) {
        setState(() {
          bundle = null;
          checked.clear();
          preview = null;
          adopt = false;
          message = l.rel_admin_connection_changed_reopen_profiles;
        });
      }
    }
  }

  @override
  void dispose() {
    ConnectionMutationBarrier.removeListener(_changed);
    dest.dispose();
    super.dispose();
  }

  void check() {
    if (!mounted || ModalRoute.of(context)?.isCurrent != true) {
      throw const WorkspaceException(WorkspaceFailure.stale);
    }
    widget.admin.check();
  }

  Future<void> run(Future<void> Function() task) async {
    final l = context.sharedL10n;
    if (busy) return;
    setState(() {
      busy = true;
      message = '';
    });
    try {
      check();
      await task();
    } catch (e) {
      message = e is FormatException
          ? l.rel_admin_unsupported_or_oversized_profile_archive
          : profileError(e, l);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> selectLocal() async {
    final pick = await FilePicker.platform.pickFiles(
      withReadStream: true,
      withData: false,
    );
    check();
    if (pick == null) return;
    final file = pick.files.single;
    if (file.size > PortableProfileBundle.compressedLimit) {
      throw const FormatException();
    }
    final stream =
        file.readStream ??
        (file.path == null ? null : File(file.path!).openRead());
    if (stream == null) throw const FormatException();
    final bytes = await PortableProfileBundle.bounded(
      stream,
      PortableProfileBundle.compressedLimit,
    );
    check();
    final b = await PortableProfileBundle.inspect(bytes);
    check();
    bundle = b.withDesktop(
      ProfilePresentation.parseText(b.files['desktop.json'])?.encode(),
    );
    importing = true;
    preview = null;
    adopt = false;
    checked.clear();
  }

  String _layoutLabel(ProfilePresentation style) => switch (style.geometry) {
    null => context.sharedL10n.rel_admin_current_layout,
    (paired: false, stacked: _, percent: _) =>
      context.sharedL10n.rel_admin_one_pane,
    final g => context.sharedL10n.rel_admin_layout_first_pane(
      g.stacked
          ? context.sharedL10n.rel_admin_stacked
          : context.sharedL10n.rel_admin_side_by_side,
      g.percent.toString(),
    ),
  };

  String _skinLabel(String? value) => switch (value) {
    null => context.sharedL10n.rel_admin_unchanged,
    'classic' => context.sharedL10n.rel_admin_skin_classic,
    'midnight' => context.sharedL10n.rel_admin_skin_midnight,
    'ember' => context.sharedL10n.rel_admin_skin_ember,
    'mono' => context.sharedL10n.rel_admin_skin_mono,
    'cyberpunk' => context.sharedL10n.rel_admin_skin_cyberpunk,
    'slate' => context.sharedL10n.rel_admin_skin_slate,
    // Theme/product names and imported theme IDs remain identifiable.
    _ => value,
  };

  String _modeLabel(ThemeMode? mode) => switch (mode) {
    null => context.sharedL10n.rel_admin_unchanged,
    ThemeMode.system => context.sharedL10n.rel_admin_mode_system,
    ThemeMode.light => context.sharedL10n.rel_admin_mode_light,
    ThemeMode.dark => context.sharedL10n.rel_admin_mode_dark,
  };

  @override
  Widget build(BuildContext context) {
    final l = context.sharedL10n;
    final b = bundle;
    return Scaffold(
      appBar: AppBar(title: Text(l.rel_admin_portable_profile_bundle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('${widget.gateway} / ${widget.admin.name}'),
          if (busy) const LinearProgressIndicator(),
          if (message.isNotEmpty) Text(message),
          if (b == null) ...[
            TextButton(
              onPressed: busy
                  ? null
                  : () => run(() async {
                      final style = ProfilePresentation.parse(
                        await widget.admin.bundledPresentation(),
                      );
                      check();
                      preview = style;
                      if (preview == null) {
                        message =
                            l.rel_admin_no_supported_appearance_in_this_profile;
                      }
                    }),
              child: Text(
                l.rel_admin_review_appearance_saved_with_this_profile,
              ),
            ),
            if (preview case final style?) ...[
              Text(
                l.rel_admin_appearance_summary(
                  _skinLabel(style.skin),
                  _modeLabel(style.mode),
                  _layoutLabel(style),
                ),
              ),
              Text(
                l.rel_admin_applies_only_to_this_named_profile_on_this_device,
              ),
              FilledButton(
                onPressed: busy
                    ? null
                    : () => run(() async {
                        final store = ProfilePresentationStore(
                          await SharedPreferences.getInstance(),
                        );
                        await store.apply(widget.connection, style, check);
                        preview = null;
                        message = l.rel_admin_appearance_applied(
                          widget.gateway,
                          widget.admin.name,
                        );
                      }),
                child: Text(l.rel_admin_apply_to_this_profile_on_this_device),
              ),
            ],
            Text(l.rel_admin_export_prepares_a_tar_gz_on_the_gateway_review),
            FilledButton(
              onPressed: busy
                  ? null
                  : () => run(() async {
                      final data = await widget.admin.portableExport(check);
                      check();
                      final store = ProfilePresentationStore(
                        await SharedPreferences.getInstance(),
                      );
                      check();
                      bundle = data.withDesktop(
                        store
                            .snapshot(widget.connection, widget.nextGen)
                            .encode(),
                      );
                      preview = null;
                      importing = false;
                      checked.clear();
                    }),
              child: Text(l.rel_admin_prepare_profile_export),
            ),
            TextButton(
              onPressed: busy ? null : () => run(selectLocal),
              child: Text(l.rel_admin_open_tar_gz_from_this_device),
            ),
          ] else ...[
            Text(
              l.rel_admin_bundle_summary(
                b.profile,
                b.files.length.toString(),
                b.omitted.toString(),
              ),
            ),
            Text(
              l.rel_admin_only_selected_text_files_travel_review_for_secrets_and,
            ),
            for (final entry in b.files.entries)
              ExpansionTile(
                title: Text(entry.key),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(entry.value),
                  ),
                  CheckboxListTile(
                    title: Text(l.rel_admin_include_this_reviewed_file),
                    value: checked.contains(entry.key),
                    onChanged: busy
                        ? null
                        : (v) => setState(() {
                            if (v == true) {
                              checked.add(entry.key);
                            } else {
                              checked.remove(entry.key);
                            }
                          }),
                  ),
                ],
              ),
            if (importing) ...[
              if (checked.contains('desktop.json'))
                CheckboxListTile(
                  value: adopt,
                  onChanged: busy
                      ? null
                      : (v) => setState(() => adopt = v == true),
                  title: Text(
                    l.rel_admin_apply_appearance_to_the_new_profile_on_this_device,
                  ),
                  subtitle: Text(
                    l.rel_admin_imports_colours_and_pane_sizes_never_chats_tools_or_session_ids,
                  ),
                ),
              Text(
                l.rel_admin_the_gateway_retains_a_private_staged_copy_import_creates,
              ),
              TextField(
                controller: dest,
                enabled: !busy,
                decoration: InputDecoration(
                  labelText: l.rel_admin_new_profile_id,
                ),
              ),
            ],
            FilledButton(
              onPressed: busy || checked.isEmpty
                  ? null
                  : () => run(() async {
                      if (importing) {
                        final name = dest.text;
                        final receipt = await widget.admin.importPortable(
                          b,
                          Set.of(checked),
                          name,
                          check,
                        );
                        check();
                        message = l.rel_admin_imported_on(name, widget.gateway);
                        if (adopt && checked.contains('desktop.json')) {
                          final actual = ProfilePresentation.parse(receipt);
                          if (actual == null ||
                              actual.encode() != b.files['desktop.json']) {
                            message += l
                                .rel_admin_appearance_not_applied_the_gateway_did_not_confirm_the;
                          } else {
                            try {
                              final store = ProfilePresentationStore(
                                await SharedPreferences.getInstance(),
                              );
                              await store.apply(
                                widget.connection.copyWith(
                                  gatewayProfile: name,
                                ),
                                actual,
                                check,
                              );
                              message +=
                                  l.rel_admin_appearance_applied_on_this_device;
                            } catch (_) {
                              check();
                              message += l
                                  .rel_admin_appearance_was_not_saved_on_this_device;
                            }
                          }
                        }
                      } else {
                        final bytes = b.encode(checked);
                        check();
                        final path = await saveProfileFile(
                          title: l.rel_admin_save_reviewed_profile_bundle,
                          filename: '${b.profile}.tar.gz',
                          check: check,
                          bytes: bytes,
                        );
                        check();
                        message = path == null
                            ? l.rel_admin_save_cancelled
                            : l.rel_admin_profile_bundle_saved;
                      }
                      checked.clear();
                      bundle = null;
                    }),
              child: Text(
                importing
                    ? l.rel_admin_import_selected_files
                    : l.rel_admin_save_selected_files_to_device,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
