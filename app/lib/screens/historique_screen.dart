import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/evenement.dart';
import '../models/historique.dart';
import '../services/evenement_service.dart';
import '../services/historique_service.dart';
import '../widgets/neumorphic_card.dart';

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
      List<Evenement> pastEventsFromApi = [];
      try {
        final evenementsPage = await _evenementService.getPastEvents(page: 0, size: 200);
        pastEventsFromApi = evenementsPage.content;
      } catch (_) {
        // Si non connecté ou erreur API : on affiche uniquement l'historique manuel
      }
      if (!mounted) return;

      final listHistorique = historiquePage.content;
      final idsInHistorique = listHistorique
          .map((h) => h.evenement?.id)
          .whereType<int>()
          .toSet();
      final pastEvents = pastEventsFromApi
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
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    if (_loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: scheme.primary,
                backgroundColor: scheme.primaryContainer.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '...',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: NeumorphicCard(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: scheme.errorContainer.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.error_outline_rounded, size: 56, color: scheme.error),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.error,
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
                  color: scheme.onErrorContainer,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
    );
    }
    if (_items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: NeumorphicCard(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.history_rounded,
                    size: 64,
                    color: scheme.primary.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.noEventInHistory,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Les événements terminés apparaîtront ici.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      color: scheme.primary,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: NeumorphicCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            scheme.primary.withOpacity(0.2),
                            scheme.secondary.withOpacity(0.15),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(Icons.history_rounded, size: 32, color: scheme.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.historyTitle,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_items.length} événement${_items.length > 1 ? 's' : ''}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final row = _items[index];
                  final ev = row.evenement;
                  final date = row.date;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _HistoriqueEventCard(
                      event: ev,
                      date: date,
                      formatDate: _formatDate,
                      l10n: l10n,
                    ),
                  );
                },
                childCount: _items.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Carte événement historique au design moderne
class _HistoriqueEventCard extends StatelessWidget {
  final Evenement? event;
  final DateTime? date;
  final String Function(DateTime?) formatDate;
  final AppLocalizations l10n;

  const _HistoriqueEventCard({
    required this.event,
    required this.date,
    required this.formatDate,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [scheme.primary, scheme.secondary],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (event != null) ...[
                  Text(
                    event!.titre,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (event!.description != null &&
                      event!.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      event!.description!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (date != null) ...[
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 18,
                          color: scheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          formatDate(date),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                      if (event!.groupe != null) ...[
                        if (date != null) const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: scheme.primary.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            event!.groupe!.nom,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: scheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ] else if (date != null) ...[
                  Text(
                    l10n.events,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatDate(date),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
