import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/gateway_approval.dart';
import 'package:hermes_android/core/widgets/gateway_approval_dialog.dart';
import 'package:hermes_android/l10n/app_localizations.dart';

void main() {
  test('folder and website approvals keep their own fields', () {
    final folder = GatewayApprovalRequest.fromEventData({
      'kind': 'access',
      'path': '/fixture/notes',
      'access': 'read_write',
      'description': 'Read and write the notes folder',
      'choices': ['once', 'session', 'deny'],
    });
    final site = GatewayApprovalRequest.fromEventData({
      'kind': 'network',
      'host': 'https://fixture.example',
      'description': 'Open the fixture site',
    });
    final command = GatewayApprovalRequest.fromEventData({
      'command': 'echo fixture',
      'choices': ['once', 'deny'],
    });

    expect(folder.kind, GatewayApprovalKind.access);
    expect(folder.folderAccess, 'read_write');
    expect(folder.folderPath, '/fixture/notes');
    expect(site.kind, GatewayApprovalKind.network);
    expect(site.host, 'https://fixture.example');
    expect(command.kind, GatewayApprovalKind.command);
    expect(
      GatewayApprovalRequest.fromEventData({
        'kind': 'access',
        'access': 'owner',
      }).folderAccess,
      isNull,
    );
  });

  testWidgets('a folder card names the path and access and hides the command', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: GatewayApprovalDialog(
            request: GatewayApprovalRequest.fromEventData({
              'kind': 'access',
              'path': '/fixture/notes',
              'access': 'read',
              'command': 'echo fixture',
              'description': 'The sandbox wants the notes folder.',
              'choices': ['once', 'deny'],
            }),
            onRespond: (_) async {},
          ),
        ),
      ),
    );

    expect(find.text('Folder access'), findsOneWidget);
    expect(find.text('/fixture/notes'), findsOneWidget);
    expect(find.text('Read-only'), findsOneWidget);
    expect(
      find.text('Allow this folder until the sandbox is switched off.'),
      findsOneWidget,
    );
    expect(find.text('echo fixture'), findsNothing);
    expect(find.text('Approval needed'), findsNothing);
  });

  testWidgets('a website card names the host', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: GatewayApprovalDialog(
            request: GatewayApprovalRequest.fromEventData({
              'kind': 'network',
              'host': 'https://fixture.example',
              'description': 'The sandbox wants this website.',
              'choices': ['deny'],
            }),
            onRespond: (_) async {},
          ),
        ),
      ),
    );

    expect(find.text('Website access'), findsOneWidget);
    expect(find.text('https://fixture.example'), findsOneWidget);
    expect(find.text('Do not grant this website.'), findsOneWidget);
  });
}
