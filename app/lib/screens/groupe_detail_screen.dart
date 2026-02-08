import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/groupe_running.dart';
import '../models/user.dart';
import '../services/groupe_service.dart';
import '../services/user_service.dart';
import '../theme/theme_mode_provider.dart';
import 'groupe_form_screen.dart';

/// Écran détail d'un groupe : infos, liste des membres, ajout/retrait si canManage.
/// Design créatif et professionnel, cohérent avec l'application.
class GroupeDetailScreen extends StatefulWidget {
  final GroupeRunning groupe;
  final bool canManage;
  final bool canEdit;

  const GroupeDetailScreen({
    super.key,
    required this.groupe,
    required this.canManage,
    this.canEdit = false,
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
        SnackBar(content: Text(AppLocalizations.of(context).noAdherentAvailable)),
      );
      return;
    }
    final selected = await showModalBottomSheet<User>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BuildAddMemberSheet(
        available: available,
        onSelect: (u) => Navigator.of(ctx).pop(u),
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

  Future<void> _editGroupe() async {
    final success = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => GroupeFormScreen(groupe: _groupe),
      ),
    );
    if (success == true && mounted) {
      await _refreshGroupe();
    }
  }

  Future<void> _removeMembre(User membre) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.removeMemberTitle),
        content: Text(l10n.removeMemberConfirm(membre.displayName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(l10n.remove),
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
        SnackBar(content: Text(AppLocalizations.of(context).memberRemoved)),
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
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          _groupe.nom,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          if (widget.canEdit)
            IconButton(
              icon: const Icon(Icons.edit_rounded),
              onPressed: _loading ? null : _editGroupe,
              tooltip: l10n.editGroup,
            ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loading ? null : _refreshGroupe,
            tooltip: l10n.refresh,
          ),
        ],
      ),
      body: _loading && _groupe.membres.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: scheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    '...',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _refreshGroupe,
              color: scheme.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_error != null) _buildErrorCard(),
                    const SizedBox(height: 20),
                    _buildHeaderCard(scheme),
                    if (_groupe.description != null &&
                        _groupe.description!.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _buildDescriptionCard(scheme),
                    ],
                    if (_groupe.responsable != null) ...[
                      const SizedBox(height: 20),
                      _buildResponsableCard(scheme, l10n),
                    ],
                    const SizedBox(height: 24),
                    _buildMembersSection(scheme, l10n),
                  ],
                ),
              ),
            ),
      floatingActionButton: widget.canManage
          ? FloatingActionButton.extended(
              onPressed: _loading ? null : _addMembre,
              icon: const Icon(Icons.person_add_rounded),
              label: Text(AppLocalizations.of(context).addMember),
              backgroundColor: scheme.primary,
              foregroundColor: scheme.onPrimary,
            )
          : null,
    );
  }

  Widget _buildErrorCard() {
    final scheme = Theme.of(context).colorScheme;
    return _NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: scheme.errorContainer.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error_outline_rounded, color: scheme.error, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              _error!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onErrorContainer,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(ColorScheme scheme) {
    return _NeumorphicCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
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
            child: Icon(
              Icons.groups_rounded,
              size: 40,
              color: scheme.primary,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _groupe.nom,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                if (_groupe.niveau != null && _groupe.niveau!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: scheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: scheme.primary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _groupe.niveau!,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(ColorScheme scheme) {
    return _NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description_outlined, size: 22, color: scheme.primary),
              const SizedBox(width: 10),
              Text(
                AppLocalizations.of(context).description,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _groupe.description!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsableCard(ColorScheme scheme, AppLocalizations l10n) {
    final r = _groupe.responsable!;
    return _NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline_rounded, size: 22, color: scheme.primary),
              const SizedBox(width: 10),
              Text(
                l10n.responsableLabel,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: scheme.primary.withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: scheme.primary.withOpacity(0.15),
                  child: Text(
                    (r.nom.isNotEmpty ? r.nom[0] : '?').toUpperCase(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: scheme.primary,
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
                    Text(
                      r.displayName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (r.email != null && r.email!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        r.email!,
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
        ],
      ),
    );
  }

  Widget _buildMembersSection(ColorScheme scheme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.people_rounded, size: 24, color: scheme.primary),
                const SizedBox(width: 10),
                Text(
                  '${l10n.members} (${_groupe.membres.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            if (widget.canManage)
              TextButton.icon(
                onPressed: _loading ? null : _addMembre,
                icon: const Icon(Icons.person_add_rounded, size: 20),
                label: Text(AppLocalizations.of(context).addMember),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (_groupe.membres.isEmpty)
          _NeumorphicCard(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.people_outline_rounded,
                    size: 56,
                    color: scheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noMembers,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          )
        else
          ..._groupe.membres.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _MemberCard(
                member: m,
                canManage: widget.canManage,
                onRemove: () => _removeMembre(m),
              ),
            ),
          ),
      ],
    );
  }
}

class _MemberCard extends StatelessWidget {
  final User member;
  final bool canManage;
  final VoidCallback onRemove;

  const _MemberCard({
    required this.member,
    required this.canManage,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return _NeumorphicCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: scheme.secondary.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: scheme.secondary.withOpacity(0.15),
              child: Text(
                (member.nom.isNotEmpty ? member.nom[0] : '?').toUpperCase(),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
                Text(
                  member.displayName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (member.email != null && member.email!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    member.email!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (canManage)
            IconButton(
              onPressed: onRemove,
              icon: Icon(Icons.person_remove_rounded, color: scheme.error),
              tooltip: AppLocalizations.of(context).remove,
              style: IconButton.styleFrom(
                backgroundColor: scheme.errorContainer.withOpacity(0.3),
              ),
            ),
        ],
      ),
    );
  }
}

class _BuildAddMemberSheet extends StatelessWidget {
  final List<User> available;
  final void Function(User) onSelect;

  const _BuildAddMemberSheet({
    required this.available,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.85,
      minChildSize: 0.3,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: scheme.onSurfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                l10n.addMember,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: available.length,
                itemBuilder: (context, index) {
                  final u = available[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: scheme.primary.withOpacity(0.15),
                        child: Text(
                          (u.nom.isNotEmpty ? u.nom[0] : '?').toUpperCase(),
                          style: TextStyle(
                            color: scheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(u.displayName),
                      subtitle: u.email != null && u.email!.isNotEmpty
                          ? Text(u.email!)
                          : null,
                      trailing: const Icon(Icons.add_circle_outline_rounded),
                      onTap: () => onSelect(u),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NeumorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const _NeumorphicCard({
    required this.child,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isHighContrast =
        ThemeModeProvider.of(context) == AppThemeMode.highContrast;

    return Container(
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
      padding: padding,
      child: child,
    );
  }
}
