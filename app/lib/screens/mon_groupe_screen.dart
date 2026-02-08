import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/groupe_running.dart';
import '../models/login_response.dart';
import '../services/groupe_service.dart';
import '../theme/theme_mode_provider.dart';
import 'groupe_detail_screen.dart';

/// Écran « Mon groupe » / « Mes groupes » pour les adhérents.
/// Charge les données uniquement quand l'onglet est sélectionné.
class MonGroupeScreen extends StatefulWidget {
  final LoginResponse user;
  final ValueNotifier<int>? tabIndexNotifier;
  final int myTabIndex;

  const MonGroupeScreen({
    super.key,
    required this.user,
    this.tabIndexNotifier,
    this.myTabIndex = 4,
  });

  @override
  State<MonGroupeScreen> createState() => _MonGroupeScreenState();
}

class _MonGroupeScreenState extends State<MonGroupeScreen>
    with SingleTickerProviderStateMixin {
  final GroupeService _service = GroupeService();
  List<GroupeRunning> _items = [];
  bool _loading = false;
  bool _hasLoaded = false;
  String? _error;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    widget.tabIndexNotifier?.addListener(_onTabChanged);
    _onTabChanged();
  }

  @override
  void dispose() {
    widget.tabIndexNotifier?.removeListener(_onTabChanged);
    _animController.dispose();
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
      final page = await _service.getGroupesByMembreId(widget.user.id);
      if (!mounted) return;
      setState(() {
        _items = page.content;
        _loading = false;
      });
      _animController.forward(from: 0);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  void _openDetail(GroupeRunning groupe) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GroupeDetailScreen(
          groupe: groupe,
          canManage: false,
          canEdit: false,
        ),
      ),
    );
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
      child: _NeumorphicCard(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                    Icons.groups_rounded,
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
                        l10n.monGroupe,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _loading ? '...' : l10n.groupCount(_items.length),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                if (!_loading && _error == null)
                  IconButton.filled(
                    onPressed: _load,
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: l10n.refresh,
                    style: IconButton.styleFrom(
                      backgroundColor: primary.withOpacity(0.15),
                      foregroundColor: primary,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading) {
      return _buildLoadingState();
    }
    if (_error != null) {
      return _buildErrorState(l10n);
    }
    if (_items.isEmpty) {
      return _buildEmptyState(l10n);
    }
    return _buildGroupList(l10n);
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
            'Chargement...',
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
        child: _NeumorphicCard(
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
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 56,
                  color: scheme.error,
                ),
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
        child: _NeumorphicCard(
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
                  Icons.groups_outlined,
                  size: 64,
                  color: scheme.primary.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.noGroupsForMember,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.5,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupList(AppLocalizations l10n) {
    return RefreshIndicator(
      onRefresh: _load,
      color: Theme.of(context).colorScheme.primary,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return _AnimatedGroupCard(
            index: index,
            animation: _animController,
            child: _GroupCard(
              groupe: _items[index],
              l10n: l10n,
              onTap: () => _openDetail(_items[index]),
            ),
          );
        },
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final GroupeRunning groupe;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  const _GroupCard({
    required this.groupe,
    required this.l10n,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;
    final secondary = scheme.secondary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: _NeumorphicCard(
        padding: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Accent gradient bar + icon
                    Container(
                      width: 4,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primary, secondary],
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
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  groupe.nom,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -0.3,
                                      ),
                                ),
                              ),
                              if (groupe.niveau != null &&
                                  groupe.niveau!.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primary.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: primary.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    groupe.niveau!,
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                          color: primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                            ],
                          ),
                          if (groupe.responsable != null) ...[
                            const SizedBox(height: 12),
                            _InfoRow(
                              icon: Icons.person_outline_rounded,
                              label: '${l10n.responsableLabel}: ${groupe.responsable!.displayName}',
                              color: scheme.onSurfaceVariant,
                            ),
                          ],
                          if (groupe.membres.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            _InfoRow(
                              icon: Icons.people_outline_rounded,
                              label: l10n.membersCount(groupe.membres.length),
                              color: scheme.onSurfaceVariant,
                            ),
                          ],
                          if (groupe.description != null &&
                              groupe.description!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              groupe.description!.length > 100
                                  ? '${groupe.description!.substring(0, 100)}...'
                                  : groupe.description!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                    height: 1.4,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: scheme.onSurfaceVariant.withOpacity(0.6),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _AnimatedGroupCard extends StatelessWidget {
  final int index;
  final Animation<double> animation;
  final Widget child;

  const _AnimatedGroupCard({
    required this.index,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final delay = (index * 0.08).clamp(0.0, 0.5);
        final value = Curves.easeOutCubic.transform(
          ((animation.value - delay) / (1 - delay)).clamp(0.0, 1.0),
        );
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
    );
  }
}

class _NeumorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const _NeumorphicCard({
    required this.child,
    required this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isHighContrast =
        ThemeModeProvider.of(context) == AppThemeMode.highContrast;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: isHighContrast
            ? Border.all(color: scheme.outline, width: 2)
            : null,
        boxShadow: isHighContrast
            ? null
            : [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 20,
                  offset: const Offset(-6, -6),
                ),
                BoxShadow(
                  color: scheme.outline.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(6, 6),
                ),
              ],
      ),
      child: padding == EdgeInsets.zero
          ? child
          : Padding(padding: padding, child: child),
    );
  }
}
