import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/login_response.dart';
import '../models/programme_entrainement.dart';
import '../services/programme_entrainement_service.dart';
import 'programme_detail_screen.dart';
import 'programme_form_screen.dart';

/// Écran liste des programmes d'entraînement. Visible par Coach, Admin principal, Adhérents.
/// Création / modification / suppression : ADMIN_COACH et ADMIN_PRINCIPAL uniquement.
class ProgrammesScreen extends StatefulWidget {
  final LoginResponse? user;

  const ProgrammesScreen({super.key, this.user});

  static bool canManageProgrammes(LoginResponse? user) {
    if (user?.role == null) return false;
    return user!.role == Role.ADMIN_PRINCIPAL || user!.role == Role.ADMIN_COACH;
  }

  @override
  State<ProgrammesScreen> createState() => _ProgrammesScreenState();
}

class _ProgrammesScreenState extends State<ProgrammesScreen> {
  final ProgrammeEntrainementService _service = ProgrammeEntrainementService();
  List<ProgrammeEntrainement> _items = [];
  int _page = 0;
  int _totalPages = 0;
  int _totalElements = 0;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({int page = 0}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await _service.getAll(page: page, size: 20);
      if (!mounted) return;
      setState(() {
        _items = result.content;
        _page = result.number;
        _totalPages = result.totalPages;
        _totalElements = result.totalElements;
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

  bool get _canManage => ProgrammesScreen.canManageProgrammes(widget.user);

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).trainingProgrammes),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : () => _load(page: _page),
            tooltip: AppLocalizations.of(context).refresh,
          ),
        ],
      ),
      body: _buildBody(context),
      floatingActionButton: _canManage
          ? FloatingActionButton(
              onPressed: () => _openForm(context),
              child: const Icon(Icons.add),
              tooltip: AppLocalizations.of(context).createProgramme,
            )
          : null,
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade700),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _load(),
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
            Icon(Icons.fitness_center, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).noProgramme,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            if (_canManage) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _openForm(context),
                icon: const Icon(Icons.add),
                label: Text(AppLocalizations.of(context).createProgramme),
              ),
            ],
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () => _load(page: _page),
      child: Column(
        children: [
          if (_totalElements > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                '$_totalElements programme${_totalElements > 1 ? 's' : ''}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _items.length + (_totalPages > 1 ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _items.length) {
                  return _buildPagination();
                }
                final p = _items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => _openDetail(p),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  p.titre,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          if (p.groupe != null) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.groups_outlined, size: 16, color: Colors.grey.shade600),
                                const SizedBox(width: 6),
                                Text(
                                  p.groupe!.nom,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey.shade600,
                                      ),
                                ),
                              ],
                            ),
                          ],
                          if (p.dateDebut != null || p.dateFin != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                                const SizedBox(width: 6),
                                Text(
                                  p.dateDebut != null && p.dateFin != null
                                      ? '${_formatDate(p.dateDebut)} → ${_formatDate(p.dateFin)}'
                                      : _formatDate(p.dateDebut ?? p.dateFin),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey.shade600,
                                      ),
                                ),
                              ],
                            ),
                          ],
                          if (p.description != null && p.description!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              p.description!.length > 100
                                  ? '${p.description!.substring(0, 100)}...'
                                  : p.description!,
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
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _page > 0 ? () => _load(page: _page - 1) : null,
          ),
          Text('${_page + 1} / $_totalPages'),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _page < _totalPages - 1 ? () => _load(page: _page + 1) : null,
          ),
        ],
      ),
    );
  }

  void _openDetail(ProgrammeEntrainement programme) async {
    await Navigator.of(context).push<ProgrammeEntrainement?>(
      MaterialPageRoute(
        builder: (_) => ProgrammeDetailScreen(
          programme: programme,
          canManage: _canManage,
        ),
      ),
    );
    if (mounted) _load(page: _page);
  }

  Future<void> _openForm(BuildContext context, [ProgrammeEntrainement? programme]) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ProgrammeFormScreen(programme: programme),
      ),
    );
    if (result == true && mounted) _load(page: _page);
  }
}
