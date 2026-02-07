import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/login_response.dart';
import 'permissions_screen.dart';
import 'users_screen.dart';

/// Menu Administration (ADMIN_PRINCIPAL) : accès Utilisateurs et Permissions.
class AdministrationScreen extends StatelessWidget {
  final LoginResponse? user;

  const AdministrationScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.administration),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.people),
              ),
              title: Text(l10n.userManagement),
              subtitle: Text(l10n.userManagementSubtitle),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => UsersScreen(user: user),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.onPrimary),
              ),
              title: Text(l10n.permissionsManagement),
              subtitle: Text(l10n.permissionsManagementSubtitle),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PermissionsScreen(user: user),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
