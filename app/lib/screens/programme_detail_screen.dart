import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import '../models/programme_entrainement.dart';
import '../services/programme_entrainement_service.dart';
import 'programme_form_screen.dart';

/// Détail d'un programme + actions Partager / Modifier / Supprimer.
class ProgrammeDetailScreen extends StatefulWidget {
  final ProgrammeEntrainement programme;
  final bool canManage;

  const ProgrammeDetailScreen({
    super.key,
    required this.programme,
    required this.canManage,
  });

  @override
  State<ProgrammeDetailScreen> createState() => _ProgrammeDetailScreenState();
}

class _ProgrammeDetailScreenState extends State<ProgrammeDetailScreen> {
  final ProgrammeEntrainementService _service = ProgrammeEntrainementService();
  late ProgrammeEntrainement _programme;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _programme = widget.programme;
  }

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final updated = await _service.getById(_programme.id);
      if (!mounted) return;
      setState(() {
        _programme = updated;
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

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  Future<void> _partager() async {
    final texte = '${_programme.titre}'
        '${_programme.groupe != null ? '\nGroupe: ${_programme.groupe!.nom}' : ''}'
        '${_programme.dateDebut != null ? '\nDu ${_formatDate(_programme.dateDebut)}' : ''}'
        '${_programme.dateFin != null ? ' au ${_formatDate(_programme.dateFin)}' : ''}'
        '${_programme.description != null && _programme.description!.isNotEmpty ? '\n\n${_programme.description}' : ''}';
    await Clipboard.setData(ClipboardData(text: texte));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Programme copié. Vous pouvez le partager aux adhérents (message, email, etc.).'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _edit() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ProgrammeFormScreen(programme: _programme),
      ),
    );
    if (result == true && mounted) _refresh();
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx).deleteProgramme),
        content: Text(
          'Supprimer « ${_programme.titre} » ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(AppLocalizations.of(ctx).cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(ctx).delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await _service.delete(_programme.id);
      if (!mounted) return;
      Navigator.of(context).pop(null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).programmeDeleted)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString().replaceFirst('Exception: ', '')}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_programme.titre),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _partager,
            tooltip: AppLocalizations.of(context).shareToAdherents,
          ),
          if (widget.canManage) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _loading ? null : _edit,
              tooltip: AppLocalizations.of(context).edit,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red.shade700),
              onPressed: _loading ? null : _delete,
              tooltip: AppLocalizations.of(context).delete,
            ),
          ],
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _refresh,
            tooltip: AppLocalizations.of(context).refresh,
          ),
        ],
      ),
      body: _loading && _error == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refresh,
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
                    if (_programme.groupe != null) ...[
                      Row(
                        children: [
                          Icon(Icons.groups, size: 20, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            _programme.groupe!.nom,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (_programme.dateDebut != null || _programme.dateFin != null) ...[
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 20, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            _programme.dateDebut != null && _programme.dateFin != null
                                ? 'Du ${_formatDate(_programme.dateDebut)} au ${_formatDate(_programme.dateFin)}'
                                : _programme.dateDebut != null
                                    ? 'À partir du ${_formatDate(_programme.dateDebut)}'
                                    : 'Jusqu\'au ${_formatDate(_programme.dateFin)}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (_programme.description != null && _programme.description!.isNotEmpty) ...[
                      Text(
                        AppLocalizations.of(context).description,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _programme.description!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _partager,
                      icon: const Icon(Icons.share),
                      label: Text(AppLocalizations.of(context).shareToAdherents),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
