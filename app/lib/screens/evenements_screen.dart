import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../models/evenement.dart';
import '../models/login_response.dart';
import '../services/evenement_service.dart';
import 'evenement_form_screen.dart';
import 'evenement_serie_form_screen.dart';

class EvenementsScreen extends StatefulWidget {
  final LoginResponse? user;

  const EvenementsScreen({super.key, this.user});

  static bool canManageEvents(LoginResponse? user) {
    if (user?.role == null) return false;
    switch (user!.role!) {
      case Role.ADMIN_PRINCIPAL:
      case Role.ADMIN_COACH:
      case Role.ADMIN_GROUPE:
        return true;
      case Role.ADHERENT:
        return false;
    }
  }

  @override
  State<EvenementsScreen> createState() => _EvenementsScreenState();
}

class _EvenementsScreenState extends State<EvenementsScreen> {
  final EvenementService _service = EvenementService();
  List<Evenement> _items = [];
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

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  bool get _canManage => EvenementsScreen.canManageEvents(widget.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(AppLocalizations.of(context).events),
        actions: [
          if (_canManage)
            TextButton.icon(
              onPressed: () => _navigateToSerie(context),
              icon: const Icon(Icons.repeat, size: 20),
              label: Text(AppLocalizations.of(context).createSeries),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _load,
            tooltip: AppLocalizations.of(context).refresh,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _canManage
          ? FloatingActionButton(
              onPressed: () => _navigateToForm(context),
              child: const Icon(Icons.add, size: 28),
              tooltip: AppLocalizations.of(context).createEvent,
              mini: false,
            )
          : null,
    );
  }

  Future<void> _navigateToForm(BuildContext context, [Evenement? event]) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => EvenementFormScreen(evenement: event),
      ),
    );
    if (result == true && mounted) _load();
  }

  Future<void> _navigateToSerie(BuildContext context) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const EvenementSerieFormScreen(),
      ),
    );
    if (result == true && mounted) _load();
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
                'Erreur',
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
            Icon(Icons.event, size: 72, color: Theme.of(context).colorScheme.onSurface),
            const SizedBox(height: 16),
            Text(
              'Aucun événement à venir',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
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
          final e = _items[index];
          return Card(
            child: InkWell(
              onTap: () => _showDetail(context, e, _canManage),
              borderRadius: BorderRadius.circular(28),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            e.titre,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        if (e.type != null && e.type!.isNotEmpty)
                          Chip(
                            label: Text(
                              e.type!,
                              style: const TextStyle(fontSize: 14),
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                    if (e.date != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                        Icon(Icons.calendar_today, size: 24, color: Theme.of(context).colorScheme.onSurface),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(e.date),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                        ),
                        ],
                      ),
                    ],
                    if (e.groupe != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                        Icon(Icons.groups, size: 24, color: Theme.of(context).colorScheme.onSurface),
                        const SizedBox(width: 8),
                        Text(
                          e.groupe!.nom,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                        ),
                        ],
                      ),
                    ],
                    if (e.lieu != null && e.lieu!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _LieuChip(lieu: e.lieu!, compact: true),
                    ],
                    if (e.description != null && e.description!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        e.description!.length > 100
                            ? '${e.description!.substring(0, 100)}...'
                            : e.description!,
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

  void _showDetail(BuildContext context, Evenement e, bool canManage) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: ListView(
            controller: controller,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      e.titre,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  if (canManage) ...[
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _navigateToForm(context, e);
                      },
                      tooltip: 'Modifier',
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                      onPressed: () => _confirmDelete(ctx, e),
                      tooltip: 'Supprimer',
                    ),
                  ],
                ],
              ),
              if (e.type != null && e.type!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Chip(label: Text(e.type!)),
              ],
              if (e.date != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 24, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(_formatDate(e.date!), style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ],
              if (e.groupe != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.groups, size: 24, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(e.groupe!.nom, style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ],
              if (e.lieu != null && e.lieu!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _LieuChip(
                  lieu: e.lieu!,
                  compact: false,
                  onOpenMaps: () => _openInMaps(ctx, e.lieu!),
                ),
              ],
              if (e.description != null && e.description!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  e.description!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openInMaps(BuildContext context, String address) async {
    // geo: ouvre l'app Carte du téléphone (Google Maps, etc.)
    final geoUri = Uri.parse(
      'geo:0,0?q=${Uri.encodeComponent(address)}',
    );
    final webUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
    );
    try {
      await launchUrl(geoUri, mode: LaunchMode.externalApplication);
    } catch (_) {
      try {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossible d\'ouvrir la carte: ${e.toString().replaceFirst('Exception: ', '')}')),
        );
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, Evenement e) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer l\'événement'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer « ${e.titre} » ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    Navigator.of(context).pop();
    try {
      await _service.delete(e.id);
      if (!mounted) return;
      _load();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Événement supprimé')),
      );
    } catch (err) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${err.toString().replaceFirst('Exception: ', '')}')),
      );
    }
  }
}

/// Bloc lieu de rencontre : label + icône + adresse, optionnellement bouton « Ouvrir dans Maps ».
class _LieuChip extends StatelessWidget {
  final String lieu;
  final bool compact;
  final VoidCallback? onOpenMaps;

  const _LieuChip({
    required this.lieu,
    this.compact = true,
    this.onOpenMaps,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.place, size: 20, color: colorScheme.onPrimaryContainer),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Lieu de rencontre',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lieu,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.place, size: 24, color: colorScheme.onPrimaryContainer),
              ),
              const SizedBox(width: 12),
              Text(
                'Lieu de rencontre',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            lieu,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
              height: 1.4,
            ),
          ),
          if (onOpenMaps != null) ...[
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: onOpenMaps,
              icon: const Icon(Icons.map, size: 20),
              label: const Text('Ouvrir dans Maps'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
