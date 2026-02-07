import 'package:flutter/material.dart';

import '../models/groupe_running.dart';
import '../models/user.dart';
import '../services/groupe_service.dart';
import '../services/user_service.dart';

/// Écran détail d'un groupe : infos, liste des membres, ajout/retrait si canManage.
class GroupeDetailScreen extends StatefulWidget {
  final GroupeRunning groupe;
  final bool canManage;

  const GroupeDetailScreen({
    super.key,
    required this.groupe,
    required this.canManage,
  });

  @override
  State<GroupeDetailScreen> createState() => _GroupeDetailScreenState();
}

class _GroupeDetailScreenState extends State<GroupeDetailScreen> {
  final GroupeService _groupeService = GroupeService();
  final UserService _userService = UserService();
  late GroupeRunning _groupe;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _groupe = widget.groupe;
  }

  Future<void> _refreshGroupe() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final updated = await _groupeService.getById(_groupe.id);
      if (!mounted) return;
      setState(() {
        _groupe = updated;
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

  Future<void> _addMembre() async {
    List<User> adherents;
    try {
      adherents = await _userService.getAdherents();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString().replaceFirst('Exception: ', '')}')),
      );
      return;
    }
    final alreadyInGroupe = _groupe.membres.map((e) => e.id).toSet();
    final available = adherents.where((a) => !alreadyInGroupe.contains(a.id)).toList();
    if (available.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun adhérent disponible à ajouter')),
      );
      return;
    }
    final selected = await showModalBottomSheet<User>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.8,
        expand: false,
        builder: (_, controller) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Ajouter un membre',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: available.length,
                itemBuilder: (context, index) {
                  final u = available[index];
                  return ListTile(
                    title: Text(u.displayName),
                    subtitle: u.email != null && u.email!.isNotEmpty ? Text(u.email!) : null,
                    onTap: () => Navigator.of(ctx).pop(u),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
    if (selected == null || !mounted) return;
    setState(() => _loading = true);
    try {
      final updated = await _groupeService.addMembre(_groupe.id, selected.id);
      if (!mounted) return;
      setState(() {
        _groupe = updated;
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${selected.displayName} a été ajouté au groupe')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString().replaceFirst('Exception: ', '')}')),
      );
    }
  }

  Future<void> _removeMembre(User membre) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Retirer du groupe'),
        content: Text(
          'Retirer ${membre.displayName} du groupe ${_groupe.nom} ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Retirer'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _loading = true);
    try {
      final updated = await _groupeService.removeMembre(_groupe.id, membre.id);
      if (!mounted) return;
      setState(() {
        _groupe = updated;
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Membre retiré du groupe')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString().replaceFirst('Exception: ', '')}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_groupe.nom),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _refreshGroupe,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: _loading && _groupe.membres.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshGroupe,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_error != null) ...[
                      Card(
                        color: Colors.red.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red.shade700),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _error!,
                                  style: TextStyle(color: Colors.red.shade900),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (_groupe.niveau != null && _groupe.niveau!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Chip(label: Text(_groupe.niveau!)),
                      ),
                    if (_groupe.description != null && _groupe.description!.isNotEmpty) ...[
                      Text(
                        _groupe.description!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4),
                      ),
                      const SizedBox(height: 24),
                    ],
                    if (_groupe.responsable != null) ...[
                      Text(
                        'Responsable',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          child: Text(_groupe.responsable!.nom.isNotEmpty ? _groupe.responsable!.nom[0].toUpperCase() : '?'),
                        ),
                        title: Text(_groupe.responsable!.displayName),
                        subtitle: _groupe.responsable!.email != null ? Text(_groupe.responsable!.email!) : null,
                      ),
                      const SizedBox(height: 24),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Membres (${_groupe.membres.length})',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (widget.canManage)
                          TextButton.icon(
                            onPressed: _loading ? null : _addMembre,
                            icon: const Icon(Icons.person_add, size: 20),
                            label: const Text('Ajouter'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_groupe.membres.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            'Aucun membre',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      )
                    else
                      ..._groupe.membres.map((m) => Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(m.nom.isNotEmpty ? m.nom[0].toUpperCase() : '?'),
                              ),
                              title: Text(m.displayName),
                              subtitle: m.email != null && m.email!.isNotEmpty ? Text(m.email!) : null,
                              trailing: widget.canManage
                                  ? IconButton(
                                      icon: Icon(Icons.person_remove, color: Colors.red.shade700),
                                      onPressed: () => _removeMembre(m),
                                      tooltip: 'Retirer du groupe',
                                    )
                                  : null,
                            ),
                          )),
                  ],
                ),
              ),
            ),
      floatingActionButton: widget.canManage
          ? FloatingActionButton(
              onPressed: _loading ? null : _addMembre,
              child: const Icon(Icons.person_add),
              tooltip: 'Ajouter un membre',
            )
          : null,
    );
  }
}
