import 'package:flutter/material.dart';

import '../models/login_response.dart';
import '../models/session_course.dart';
import '../services/session_course_service.dart';
import 'session_record_screen.dart';

/// Liste des sessions de course (suivi GPS / sorties) de l'adhérent.
class SessionsScreen extends StatefulWidget {
  final LoginResponse? user;

  const SessionsScreen({super.key, this.user});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  final SessionCourseService _service = SessionCourseService();
  List<SessionCourse> _sessions = [];
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
      final page = await _service.getMySessions(page: 0, size: 50);
      if (!mounted) return;
      setState(() {
        _sessions = page.content;
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
    if (d == null) return '—';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  Future<void> _openRecord() async {
    final added = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => const SessionRecordScreen(),
      ),
    );
    if (added == true && mounted) _load();
  }

  Future<void> _deleteSession(SessionCourse session) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la session ?'),
        content: Text(
          '${session.distanceKm.toStringAsFixed(1)} km le ${_formatDate(session.startedAt)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    try {
      await _service.delete(session.id);
      if (mounted) _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ma sortie'),
            Text(
              'Enregistrez vos sorties (pour tous les membres)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _load,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_error!, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _load,
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                )
              : _sessions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.directions_run,
                            size: 64,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Aucune sortie enregistrée',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Appuyez sur + pour enregistrer une sortie\n(avec ou sans GPS)',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                        itemCount: _sessions.length,
                        itemBuilder: (context, index) {
                          final s = _sessions[index];
                          final allure = s.allureMinPerKm;
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primaryContainer,
                                child: Icon(
                                  Icons.directions_run,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              title: Text(
                                '${s.distanceKm.toStringAsFixed(1)} km · ${s.formattedDuration}',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                [
                                  _formatDate(s.startedAt),
                                  if (allure != null)
                                    'Allure ${allure.toStringAsFixed(1)} min/km',
                                  if (s.evenement != null) s.evenement!.titre,
                                ].where((e) => e.isNotEmpty).join(' · '),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _deleteSession(s),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
      floatingActionButton: widget.user != null
          ? FloatingActionButton.extended(
              onPressed: _openRecord,
              icon: const Icon(Icons.add),
              label: const Text('Enregistrer une sortie'),
            )
          : null,
    );
  }
}
