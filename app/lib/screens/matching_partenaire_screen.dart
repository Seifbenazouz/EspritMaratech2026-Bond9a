import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/login_response.dart';
import '../models/partner_match.dart';
import '../services/matching_service.dart';
import '../widgets/neumorphic_card.dart';

/// Écran « Trouver un partenaire » : matching IA des adhérents.
/// Charge les données uniquement quand l'onglet est sélectionné (évite de ralentir la connexion).
class MatchingPartenaireScreen extends StatefulWidget {
  final LoginResponse user;
  final ValueNotifier<int>? tabIndexNotifier;
  final int myTabIndex;

  const MatchingPartenaireScreen({
    super.key,
    required this.user,
    this.tabIndexNotifier,
    this.myTabIndex = 5,
  });

  @override
  State<MatchingPartenaireScreen> createState() =>
      _MatchingPartenaireScreenState();
}

class _MatchingPartenaireScreenState extends State<MatchingPartenaireScreen> {
  final MatchingService _service = MatchingService();
  List<PartnerMatch> _items = [];
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
      final list = await _service.getPartners();
      if (!mounted) return;
      setState(() {
        _items = list;
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

  Future<void> _invitePartner(String partnerId) async {
    try {
      await _service.inviterPartenaire(partnerId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).invitationEnvoyee),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).invitationErreur),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(l10n.findPartner),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loading ? null : _load,
            tooltip: l10n.refresh,
          ),
        ],
      ),
      body: _buildBody(l10n, scheme),
    );
  }

  Widget _buildBody(AppLocalizations l10n, ColorScheme scheme) {
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
              l10n.matchingInProgress,
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
                  child: Icon(Icons.error_outline_rounded,
                      size: 56, color: scheme.error),
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
                    Icons.favorite_border_rounded,
                    size: 64,
                    color: scheme.primary.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.noPartnerMatch,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.noPartnerMatchHint,
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
                      child: Icon(Icons.auto_awesome_rounded,
                          size: 32, color: scheme.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.matchFound,
                            style:
                                Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_items.length} partenaire${_items.length > 1 ? 's' : ''}',
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                  final p = _items[index];
                  return _PartnerCard(
                    partner: p,
                    onInvite: _invitePartner,
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

class _PartnerCard extends StatelessWidget {
  final PartnerMatch partner;
  final Future<void> Function(String partnerId) onInvite;

  const _PartnerCard({
    required this.partner,
    required this.onInvite,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: NeumorphicCard(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: scheme.secondary.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: scheme.secondary.withOpacity(0.2),
                child: Text(
                  (partner.nom.isNotEmpty ? partner.nom[0] : '?').toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: scheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          partner.displayName,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: scheme.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: scheme.primary.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '${partner.score}/100',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: scheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  if (partner.paceMoyenMinPerKm != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.speed_rounded,
                            size: 18, color: scheme.onSurfaceVariant),
                        const SizedBox(width: 6),
                        Text(
                          partner.paceFormatted,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ],
                  if (partner.groupeNom != null &&
                      partner.groupeNom!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.groups_rounded,
                            size: 18, color: scheme.onSurfaceVariant),
                        const SizedBox(width: 6),
                        Text(
                          partner.groupeNom! +
                              (partner.groupeNiveau != null &&
                                      partner.groupeNiveau!.isNotEmpty
                                  ? ' (${partner.groupeNiveau})'
                                  : ''),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ],
                  if (partner.scoreDetail != null &&
                      partner.scoreDetail!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      partner.scoreDetail!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.primary.withOpacity(0.9),
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: partner.id.isEmpty
                        ? null
                        : () => onInvite(partner.id),
                    icon: const Icon(Icons.directions_run_rounded, size: 20),
                    label: Text(AppLocalizations.of(context).inviterPartenaire),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
