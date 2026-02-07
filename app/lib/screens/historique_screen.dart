import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/evenement.dart';
import '../models/historique.dart';
import '../services/evenement_service.dart';
import '../services/historique_service.dart';

/// Une ligne affichée dans l'historique : date + événement (depuis table historique ou événements passés).
class _HistoriqueRow {
  final DateTime? date;
  final Evenement? evenement;
  _HistoriqueRow(this.date, this.evenement);
}

class HistoriqueScreen extends StatefulWidget {
  final Widget? drawer;
  final List<Widget>? extraActions;

  const HistoriqueScreen({super.key, this.drawer, this.extraActions});

  @override
  State<HistoriqueScreen> createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends State<HistoriqueScreen> {
  final HistoriqueService _historiqueService = HistoriqueService();
  final EvenementService _evenementService = EvenementService();
  List<_HistoriqueRow> _items = [];
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
      final now = DateTime.now();
      final historiquePage = await _historiqueService.getHistorique(page: 0, size: 50);
      final evenementsPage = await _evenementService.getAll(page: 0, size: 100);
      if (!mounted) return;

      final listHistorique = historiquePage.content;
      final listEvenements = evenementsPage.content;

      final idsInHistorique = listHistorique
          .map((h) => h.evenement?.id)
          .whereType<int>()
          .toSet();
      final pastEvents = listEvenements
          .where((e) => e.date != null && e.date!.isBefore(now))
          .where((e) => !idsInHistorique.contains(e.id))
          .toList();

      final rows = <_HistoriqueRow>[
        ...listHistorique.map((h) => _HistoriqueRow(h.date, h.evenement)),
        ...pastEvents.map((e) => _HistoriqueRow(e.date, e)),
      ];
      rows.sort((a, b) {
        final da = a.date ?? DateTime(1970);
        final db = b.date ?? DateTime(1970);
        return db.compareTo(da);
      });

      setState(() {
        _items = rows;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: widget.drawer,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(AppLocalizations.of(context).historyTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _load,
            tooltip: AppLocalizations.of(context).refresh,
          ),
          ...?widget.extraActions,
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
      final scheme = Theme.of(context).colorScheme;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 72, color: scheme.error),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context).error,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: scheme.error,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _load,
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
            Icon(Icons.history, size: 72, color: Theme.of(context).colorScheme.onSurface),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).noEventInHistory,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Les événements passés apparaîtront ici.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Les événements passés apparaîtront ici.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                  ),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final row = _items[index];
          final ev = row.evenement;
          final date = row.date;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (ev != null) ...[
                    Text(
                      ev.titre,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (ev.description != null && ev.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        ev.description!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (date != null)
                          Text(
                            _formatDate(date),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        if (ev.groupe != null) ...[
                          const SizedBox(width: 12),
                          Chip(
                            label: Text(
                              ev.groupe!.nom,
                              style: const TextStyle(fontSize: 14),
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ],
                    ),
                  ] else if (date != null) ...[
                    Text(
                      AppLocalizations.of(context).events,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      _formatDate(date),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
