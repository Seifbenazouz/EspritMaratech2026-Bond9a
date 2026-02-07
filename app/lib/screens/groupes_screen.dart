import 'package:flutter/material.dart';

import '../models/groupe_running.dart';
import '../models/login_response.dart';
import '../services/groupe_service.dart';
import 'groupe_detail_screen.dart';

/// Écran liste des groupes de running.
/// Visible pour ADMIN_PRINCIPAL et ADMIN_GROUPE (gestion des membres).
class GroupesScreen extends StatefulWidget {
  final LoginResponse? user;

  const GroupesScreen({super.key, this.user});

  static bool canManageGroupes(LoginResponse? user) {
    if (user?.role == null) return false;
    return user!.role == Role.ADMIN_PRINCIPAL || user.role == Role.ADMIN_GROUPE;
  }

  @override
  State<GroupesScreen> createState() => _GroupesScreenState();
}

class _GroupesScreenState extends State<GroupesScreen> {
  final GroupeService _service = GroupeService();
  List<GroupeRunning> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await _service.getAll();
      if (!mounted) return;
      setState(() {
        _items = page.content;
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

  bool get _canManage => GroupesScreen.canManageGroupes(widget.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groupes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _load,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
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
                onPressed: _load,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
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
            Icon(Icons.groups_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Aucun groupe',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final g = _items[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => _openDetail(g),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            g.nom,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        if (g.niveau != null && g.niveau!.isNotEmpty)
                          Chip(
                            label: Text(
                              g.niveau!,
                              style: const TextStyle(fontSize: 11),
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                    if (g.membres.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.people_outline, size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 6),
                          Text(
                            '${g.membres.length} membre${g.membres.length > 1 ? 's' : ''}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                          ),
                        ],
                      ),
                    ],
                    if (g.description != null && g.description!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        g.description!.length > 80
                            ? '${g.description!.substring(0, 80)}...'
                            : g.description!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openDetail(GroupeRunning groupe) async {
    final updated = await Navigator.of(context).push<GroupeRunning?>(
      MaterialPageRoute(
        builder: (_) => GroupeDetailScreen(
          groupe: groupe,
          canManage: _canManage,
        ),
      ),
    );
    if (updated != null && mounted) {
      setState(() {
        final i = _items.indexWhere((e) => e.id == updated.id);
        if (i >= 0) _items[i] = updated;
      });
    }
  }
}
