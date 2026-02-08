import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/groupe_running.dart';
import '../models/login_response.dart';
import '../services/groupe_service.dart';
import '../widgets/neumorphic_card.dart';
import 'groupe_detail_screen.dart';
import 'groupe_form_screen.dart';

/// Écran liste des groupes de running (gestionnaires).
/// Visible pour ADMIN_PRINCIPAL et ADMIN_GROUPE.
class GroupesScreen extends StatefulWidget {
  final LoginResponse? user;

  const GroupesScreen({super.key, this.user});

  static bool canManageGroupes(LoginResponse? user) {
    if (user?.role == null) return false;
    return user!.role == Role.ADMIN_PRINCIPAL || user.role == Role.ADMIN_GROUPE;
  }

  static bool canCreateEditGroupes(LoginResponse? user) {
    return user?.role == Role.ADMIN_PRINCIPAL;
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
      final page = await _service.getMesGroupes();
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
  bool get _canCreateEdit => GroupesScreen.canCreateEditGroupes(widget.user);

  Future<void> _openCreateGroup() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const GroupeFormScreen()),
    );
    if (created == true && mounted) _load();
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
        title: Text(
          l10n.groups,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          IconButton.filledTonal(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loading ? null : _load,
            tooltip: l10n.refresh,
          ),
        ],
      ),
      body: _buildBody(l10n),
      floatingActionButton: _canCreateEdit
          ? FloatingActionButton.extended(
              onPressed: _loading ? null : _openCreateGroup,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.createGroup),
              backgroundColor: scheme.primary,
              foregroundColor: scheme.onPrimary,
              elevation: 4,
            )
          : null,
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    final scheme = Theme.of(context).colorScheme;

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

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: NeumorphicCard(
            padding: const EdgeInsets.all(32),
            margin: const EdgeInsets.symmetric(horizontal: 20),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
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
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        scheme.primary.withOpacity(0.15),
                        scheme.secondary.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.groups_outlined,
                    size: 64,
                    color: scheme.primary.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.noGroupAvailable,
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

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _buildHeader(l10n),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final g = _items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _GroupCard(
                    groupe: g,
                    l10n: l10n,
                    onTap: () => _openDetail(g),
                  ),
                );
              },
              childCount: _items.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;
    final secondary = scheme.secondary;

    return NeumorphicCard(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
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
                  l10n.groups,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.groupCount(_items.length),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openDetail(GroupeRunning groupe) async {
    final result = await Navigator.of(context).push<Object?>(
      MaterialPageRoute(
        builder: (_) => GroupeDetailScreen(
          groupe: groupe,
          canManage: _canManage,
          canEdit: _canCreateEdit,
        ),
      ),
    );
    if (!mounted) return;
    if (result is Map && result['deleted'] == true) {
      setState(() => _items.removeWhere((e) => e.id == groupe.id));
      return;
    }
    if (result is GroupeRunning) {
      setState(() {
        final i = _items.indexWhere((e) => e.id == result.id);
        if (i >= 0) _items[i] = result;
      });
    }
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

    return NeumorphicCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        if (groupe.niveau != null && groupe.niveau!.isNotEmpty)
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
