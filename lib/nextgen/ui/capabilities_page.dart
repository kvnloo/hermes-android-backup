import 'package:flutter/material.dart';

import '../../core/capabilities/capability_admin.dart';
import '../../core/capabilities/capability_pages.dart';
import 'nextgen_scope.dart';

/// Skills, plugins, connectors and tool backends for the connected profile.
class NgCapabilitiesPage extends StatelessWidget {
  const NgCapabilitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final gateway = NgScope.of(context).gateway;
    return CapabilityAdminScreen(
      admin: CapabilityAdmin.fromDashboard(
        gateway.dashboard,
        profile: gateway.profile,
        rpc: (method, params) async {
          await gateway.connected();
          return gateway.call(
            method,
            params,
            timeout: const Duration(seconds: 45),
          );
        },
      ),
    );
  }
}
