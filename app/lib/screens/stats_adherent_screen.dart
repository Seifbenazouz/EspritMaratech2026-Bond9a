import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/login_response.dart';
import '../models/stats_adherent.dart';
import '../services/stats_adherent_service.dart';
import '../widgets/neumorphic_card.dart';
import 'session_record_screen.dart';

/// Écran « Mes statistiques » pour les adhérents.
/// Affiche : km parcourus, pace moyen, nombre de sorties, événements, etc.
class StatsAdherentScreen extends StatefulWidget {
  final LoginResponse user;
  final ValueNotifier<int>? tabIndexNotifier;
  final int myTabIndex;

  const StatsAdherentScreen({
    super.key,
    required this.user,
    this.tabIndexNotifier,
    this.myTabIndex = 6,
  });

  @override
  State<StatsAdherentScreen> createState() => _StatsAdherentScreenState();
}

class _StatsAdherentScreenState extends State<StatsAdherentScreen> {
  final StatsAdherentService _service = StatsAdherentService();
  StatsAdherent? _stats;
  bool _loading = false;
  bool _hasLoaded = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    widget.tabIndexNotifier?.addListener(_onTabChanged);
    _onTabChanged();
  }

  @override
  void dispose() {
    widget.tabIndexNotifier?.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    if (widget.tabIndexNotifier?.value == widget.myTabIndex && !_hasLoaded) {
      _hasLoaded = true;
      _load();
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final stats = await _service.getMe();
      if (!mounted) return;
      setState(() {
        _stats = stats;
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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildHeader(context, l10n),
          SliverFillRemaining(
            hasScrollBody: true,
            child: _buildBody(l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;
    final secondary = scheme.secondary;

    return SliverToBoxAdapter(
      child: NeumorphicCard(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primary.withOpacity(0.2),
                    secondary.withOpacity(0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.bar_chart_rounded,
                size: 36,
                color: primary,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.statsTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _loading ? '...' : l10n.statsEmptyHint,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (!_loading && _error == null)
              IconButton.filledTonal(
                onPressed: _load,
                icon: const Icon(Icons.refresh_rounded),
                tooltip: l10n.refresh,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading && _stats == null) {
      return _buildLoadingState();
    }
    if (_error != null) {
      return _buildErrorState(l10n);
    }
    if (_stats != null) {
      final s = _stats!;
      final hasAnyData = s.nbSorties > 0 || s.nbEvenements > 0;
      if (!hasAnyData) {
        return _buildEmptyState(l10n);
      }
      return _buildStatsGrid(l10n, s);
    }
    return const SizedBox.shrink();
  }

  Widget _buildLoadingState() {
    final scheme = Theme.of(context).colorScheme;
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
          const SizedBox(height: 24),
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

  Widget _buildErrorState(AppLocalizations l10n) {
    final scheme = Theme.of(context).colorScheme;
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
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    final scheme = Theme.of(context).colorScheme;
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
                  Icons.directions_run_outlined,
                  size: 64,
                  color: scheme.primary.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.statsEmptyHint,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 24),
              FilledButton.tonalIcon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SessionRecordScreen(),
                  ),
                ).then((_) => _load()),
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.statsRecordRunHint),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(AppLocalizations l10n, StatsAdherent s) {
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;

    return RefreshIndicator(
      onRefresh: _load,
      color: primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StatCard(
              icon: Icons.straighten_rounded,
              label: l10n.statsTotalKm,
              value: '${s.totalDistanceKm.toStringAsFixed(1)} km',
              color: primary,
            ),
            const SizedBox(height: 12),
            _StatCard(
              icon: Icons.directions_run_rounded,
              label: l10n.statsNbSorties,
              value: '${s.nbSorties}',
              color: primary,
            ),
            if (s.paceMoyenMinPerKm != null) ...[
              const SizedBox(height: 12),
              _StatCard(
                icon: Icons.speed_rounded,
                label: l10n.statsPaceMoyen,
                value: '${s.paceMoyenMinPerKm!.toStringAsFixed(1)} min/km',
                color: primary,
              ),
            ],
            const SizedBox(height: 12),
            _StatCard(
              icon: Icons.event_rounded,
              label: l10n.statsNbEvenements,
              value: '${s.nbEvenements}',
              color: primary,
            ),
            if (s.plusLongueSortieKm != null && s.plusLongueSortieKm! > 0) ...[
              const SizedBox(height: 12),
              _StatCard(
                icon: Icons.route_rounded,
                label: l10n.statsPlusLongueSortie,
                value: '${s.plusLongueSortieKm!.toStringAsFixed(1)} km',
                color: primary,
              ),
            ],
            if (s.meilleurPaceMinPerKm != null) ...[
              const SizedBox(height: 12),
              _StatCard(
                icon: Icons.emoji_events_rounded,
                label: l10n.statsMeilleurPace,
                value: '${s.meilleurPaceMinPerKm!.toStringAsFixed(1)} min/km',
                color: primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 28, color: color),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
