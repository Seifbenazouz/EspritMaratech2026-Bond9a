import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/login_response.dart';
import '../models/permission.dart';
import '../services/permission_service.dart';
import 'permission_form_screen.dart';

/// Écran liste des permissions (ADMIN_PRINCIPAL uniquement).
class PermissionsScreen extends StatefulWidget {
  final LoginResponse? user;

  const PermissionsScreen({super.key, this.user});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  final PermissionService _service = PermissionService();
  List<Permission> _items = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).permissions),
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
        child: const Icon(Icons.add),
        tooltip: AppLocalizations.of(context).createPermission,
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
            Icon(Icons.lock_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).noPermission,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => _openForm(context),
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context).createPermission),
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
                '$_totalElements permission${_totalElements > 1 ? 's' : ''}',
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
                final p = _items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.lock, color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    title: Text(p.libelle),
                    subtitle: p.description != null && p.description!.isNotEmpty && p.description != p.nom
                        ? Text(p.nom, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600))
                        : null,
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') _openForm(context, permission: p);
                        if (value == 'delete') _confirmDelete(context, p);
                      },
                      itemBuilder: (ctx) => [
                        PopupMenuItem(value: 'edit', child: Text(AppLocalizations.of(ctx).edit)),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(AppLocalizations.of(ctx).delete, style: const TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                    onTap: () => _openForm(context, permission: p),
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

  Future<void> _openForm(BuildContext context, {Permission? permission}) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PermissionFormScreen(permission: permission),
      ),
    );
    if (result == true && mounted) _load(page: _page);
  }

  Future<void> _confirmDelete(BuildContext context, Permission p) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la permission'),
        content: Text('Supprimer « ${p.nom} » ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await _service.delete(p.id);
      if (!mounted) return;
      _load(page: _page);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission supprimée')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString().replaceFirst('Exception: ', '')}')),
      );
    }
  }
}
