import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/actualite_service.dart';

/// Écran de publication d'une actualité (réservé ADMIN_PRINCIPAL)
class ActualiteFormScreen extends StatefulWidget {
  const ActualiteFormScreen({super.key});

  @override
  State<ActualiteFormScreen> createState() => _ActualiteFormScreenState();
}

class _ActualiteFormScreenState extends State<ActualiteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _contenuController = TextEditingController();
  final ActualiteService _service = ActualiteService();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _titreController.dispose();
    _contenuController.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await _service.createActualite(
        titre: _titreController.text.trim(),
        contenu: _contenuController.text.trim().isEmpty ? null : _contenuController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).newsPublished),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      Navigator.of(context).pop(true);
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
      appBar: AppBar(
        title: Text(l10n.publishNews),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titreController,
                decoration: InputDecoration(
                  labelText: l10n.title,
                  hintText: l10n.hintTitleEvent,
                  border: const OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return l10n.titleRequired;
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _contenuController,
                decoration: InputDecoration(
                  labelText: l10n.description,
                  hintText: l10n.hintEventDetails,
                  alignLabelWithHint: true,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 6,
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _error!,
                          style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _loading ? null : _publish,
                icon: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.publish),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(l10n.publishNews),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
