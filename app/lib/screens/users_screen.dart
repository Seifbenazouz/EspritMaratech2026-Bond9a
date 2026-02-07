import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/login_response.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import 'user_form_screen.dart';

/// Écran liste des utilisateurs (ADMIN_PRINCIPAL uniquement).
class UsersScreen extends StatefulWidget {
  final LoginResponse? user;

  const UsersScreen({super.key, this.user});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final UserService _service = UserService();
  List<User> _items = [];
  int _page = 0;
  int _totalPages = 0;
  int _totalElements = 0;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({int page = 0}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await _service.getAll(page: page, size: 20);
      if (!mounted) return;
      setState(() {
        _items = result.content;
        _page = result.number;
        _totalPages = result.totalPages;
        _totalElements = result.totalElements;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  String _roleLabel(BuildContext context, Role? role) {
    if (role == null) return '—';
    final l10n = AppLocalizations.of(context);
    switch (role) {
      case Role.ADMIN_PRINCIPAL:
        return l10n.adminPrincipal;
      case Role.ADMIN_COACH:
        return l10n.adminCoach;
      case Role.ADMIN_GROUPE:
        return l10n.adminGroup;
      case Role.ADHERENT:
        return l10n.adherent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).users),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : () => _load(page: _page),
            tooltip: AppLocalizations.of(context).refresh,
          ),
        ],
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context),
        child: const Icon(Icons.person_add),
        tooltip: AppLocalizations.of(context).createUser,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade700),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _load(),
                icon: const Icon(Icons.refresh),
                label: Text(AppLocalizations.of(context).retry),
              ),
            ],
          ),
        ),
      );
    }
    if (_items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).noUser,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => _openForm(context),
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context).createUser),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () => _load(page: _page),
      child: Column(
        children: [
          if (_totalElements > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                '$_totalElements utilisateur${_totalElements > 1 ? 's' : ''}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _items.length + (_totalPages > 1 ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _items.length) {
                  return _buildPagination();
                }
                final u = _items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        u.nom.isNotEmpty ? u.nom[0].toUpperCase() : '?',
                      ),
                    ),
                    title: Text(u.displayName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (u.email != null && u.email!.isNotEmpty)
                          Text(u.email!, style: Theme.of(context).textTheme.bodySmall),
                        Text(
                          _roleLabel(context, u.role),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') _openForm(context, user: u);
                        if (value == 'delete') _confirmDelete(context, u);
                      },
                      itemBuilder: (ctx) => [
                        PopupMenuItem(value: 'edit', child: Text(AppLocalizations.of(ctx).edit)),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(AppLocalizations.of(ctx).delete, style: const TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                    onTap: () => _openForm(context, user: u),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _page > 0 ? () => _load(page: _page - 1) : null,
          ),
          Text('${_page + 1} / $_totalPages'),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _page < _totalPages - 1 ? () => _load(page: _page + 1) : null,
          ),
        ],
      ),
    );
  }

  Future<void> _openForm(BuildContext context, {User? user}) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => UserFormScreen(user: user),
      ),
    );
    if (result == true && mounted) _load(page: _page);
  }

  Future<void> _confirmDelete(BuildContext context, User u) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx);
        return AlertDialog(
          title: Text(l10n.deleteUser),
          content: Text(l10n.deleteUserConfirm(u.displayName)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;
    try {
      await _service.delete(u.id);
      if (!mounted) return;
      _load(page: _page);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).userDeleted)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString().replaceFirst('Exception: ', '')}')),
      );
    }
  }
}
