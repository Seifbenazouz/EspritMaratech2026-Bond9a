import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../models/programme_entrainement.dart';
import '../services/programme_entrainement_service.dart';
import 'programme_form_screen.dart';

/// Détail d'un programme + actions Partager / Modifier / Supprimer.
class ProgrammeDetailScreen extends StatefulWidget {
  final ProgrammeEntrainement programme;
  final bool canManage;

  const ProgrammeDetailScreen({
    super.key,
    required this.programme,
    required this.canManage,
  });

  @override
  State<ProgrammeDetailScreen> createState() => _ProgrammeDetailScreenState();
}

class _ProgrammeDetailScreenState extends State<ProgrammeDetailScreen> {
  final ProgrammeEntrainementService _service = ProgrammeEntrainementService();
  late ProgrammeEntrainement _programme;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _programme = widget.programme;
  }

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final updated = await _service.getById(_programme.id);
      if (!mounted) return;
      setState(() {
        _programme = updated;
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

  Future<void> _partager() async {
    final texte = '📋 *${_programme.titre}*'
        '${_programme.groupe != null ? '\n📍 Groupe: ${_programme.groupe!.nom}' : ''}'
        '${_programme.dateDebut != null ? '\n📅 Du ${_formatDate(_programme.dateDebut)}' : ''}'
        '${_programme.dateFin != null ? ' au ${_formatDate(_programme.dateFin)}' : ''}'
        '${_programme.description != null && _programme.description!.isNotEmpty ? '\n\n📝 ${_programme.description}' : ''}';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Partager le programme',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _ShareOption(
                  icon: Icons.message,
                  label: 'WhatsApp',
                  color: const Color(0xFF25D366),
                  onTap: () {
                    _shareViaWhatsApp(texte);
                    Navigator.pop(ctx);
                  },
                ),
                _ShareOption(
                  icon: Icons.chat_bubble,
                  label: 'Messenger',
                  color: const Color(0xFF006AFF),
                  onTap: () {
                    _shareViaMessenger(texte);
                    Navigator.pop(ctx);
                  },
                ),
                _ShareOption(
                  icon: Icons.email,
                  label: 'Email',
                  color: Colors.red.shade500,
                  onTap: () {
                    _shareViaEmail();
                    Navigator.pop(ctx);
                  },
                ),
                _ShareOption(
                  icon: Icons.sms,
                  label: 'SMS',
                  color: Colors.blue.shade600,
                  onTap: () {
                    _shareViaSms(texte);
                    Navigator.pop(ctx);
                  },
                ),
                _ShareOption(
                  icon: Icons.share,
                  label: 'Plus',
                  color: Colors.grey.shade600,
                  onTap: () {
                    _shareGeneral(texte);
                    Navigator.pop(ctx);
                  },
                ),
                _ShareOption(
                  icon: Icons.copy,
                  label: 'Copier',
                  color: Colors.orange.shade600,
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: texte));
                    if (!mounted) return;
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Programme copié dans le presse-papiers !'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareViaWhatsApp(String texte) async {
    try {
      await Share.share(
        texte,
        subject: _programme.titre,
      );
    } catch (e) {
      _showShareError('WhatsApp');
    }
  }

  Future<void> _shareViaMessenger(String texte) async {
    try {
      final uri = Uri.parse('fb-messenger://share/?link=https://runningApp.com/programmes/${_programme.id}');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        _showShareError('Messenger');
      }
    } catch (e) {
      _showShareError('Messenger');
    }
  }

  Future<void> _shareViaEmail() async {
    try {
      final emailUri = Uri(
        scheme: 'mailto',
        path: '',
        queryParameters: {
          'subject': '📋 ${_programme.titre}',
          'body':
              'Bonjour,\n\nVoici le programme d\'entraînement ${_programme.groupe != null ? "du groupe ${_programme.groupe!.nom}" : ""}:\n\n${_programme.titre}\n\nPériode: ${_formatDate(_programme.dateDebut)} au ${_formatDate(_programme.dateFin)}\n\n${_programme.description ?? ""}',
        },
      );
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      }
    } catch (e) {
      _showShareError('Email');
    }
  }

  Future<void> _shareViaSms(String texte) async {
    try {
      final smsUri = Uri(scheme: 'sms', path: '', queryParameters: {'body': texte});
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      }
    } catch (e) {
      _showShareError('SMS');
    }
  }

  Future<void> _shareGeneral(String texte) async {
    try {
      await Share.share(texte, subject: _programme.titre);
    } catch (e) {
      _showShareError('partage');
    }
  }

  void _showShareError(String app) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('❌ Impossible de partager via $app. Vérifiez que l\'app est installée.'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _edit() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ProgrammeFormScreen(programme: _programme),
      ),
    );
    if (result == true && mounted) _refresh();
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx).deleteProgramme),
        content: Text(
          'Supprimer « ${_programme.titre} » ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(AppLocalizations.of(ctx).cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(ctx).delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await _service.delete(_programme.id);
      if (!mounted) return;
      Navigator.of(context).pop(null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).programmeDeleted)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString().replaceFirst('Exception: ', '')}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_programme.titre),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _partager,
            tooltip: AppLocalizations.of(context).shareToAdherents,
          ),
          if (widget.canManage) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _loading ? null : _edit,
              tooltip: AppLocalizations.of(context).edit,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red.shade700),
              onPressed: _loading ? null : _delete,
              tooltip: AppLocalizations.of(context).delete,
            ),
          ],
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _refresh,
            tooltip: AppLocalizations.of(context).refresh,
          ),
        ],
      ),
      body: _loading && _error == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // En-tête avec dégradé
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.primary.withOpacity(0.7),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Groupe badge
                          if (_programme.groupe != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.groups, size: 16, color: Colors.white),
                                  const SizedBox(width: 6),
                                  Text(
                                    _programme.groupe!.nom,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          // Titre
                          Text(
                            _programme.titre,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    // Contenu principal
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          if (_error != null) ...[
                            Card(
                              color: Colors.red.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Icon(Icons.error_outline, color: Colors.red.shade700, size: 24),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _error!,
                                        style: TextStyle(color: Colors.red.shade900),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          // Dates
                          if (_programme.dateDebut != null || _programme.dateFin != null) ...[
                            Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.calendar_today,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Période de formation',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: Colors.grey.shade600,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _programme.dateDebut != null && _programme.dateFin != null
                                                ? 'Du ${_formatDate(_programme.dateDebut)} au ${_formatDate(_programme.dateFin)}'
                                                : _programme.dateDebut != null
                                                    ? 'À partir du ${_formatDate(_programme.dateDebut)}'
                                                    : 'Jusqu\'au ${_formatDate(_programme.dateFin)}',
                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          // Description
                          if (_programme.description != null && _programme.description!.isNotEmpty) ...[
                            Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.description_outlined,
                                            color: Colors.blue.shade600,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Description',
                                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      _programme.description!,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            height: 1.6,
                                            color: Colors.grey.shade800,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                          // Boutons d'action
                          Column(
                            children: [
                              // Bouton Partager
                              FilledButton.icon(
                                onPressed: _partager,
                                icon: const Icon(Icons.share, size: 20),
                                label: Text(
                                  AppLocalizations.of(context).shareToAdherents,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Boutons Édition/Suppression
                              if (widget.canManage) ...[
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: _loading ? null : _edit,
                                        icon: const Icon(Icons.edit),
                                        label: Text(AppLocalizations.of(context).edit),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: _loading ? null : _delete,
                                        icon: const Icon(Icons.delete),
                                        label: Text(AppLocalizations.of(context).delete),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.red.shade600,
                                          side: BorderSide(color: Colors.red.shade600),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

/// Widget personnalisé pour les options de partage
class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
