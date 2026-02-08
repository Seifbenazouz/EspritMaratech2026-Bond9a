import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/groupe_running.dart';
import '../models/user.dart';
import '../services/groupe_service.dart';
import '../services/user_service.dart';

/// Formulaire création / modification d'un groupe (ADMIN_PRINCIPAL uniquement).
class GroupeFormScreen extends StatefulWidget {
  final GroupeRunning? groupe;

  const GroupeFormScreen({super.key, this.groupe});

  @override
  State<GroupeFormScreen> createState() => _GroupeFormScreenState();
}

class _GroupeFormScreenState extends State<GroupeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _descriptionController = TextEditingController();
  final GroupeService _groupeService = GroupeService();
  final UserService _userService = UserService();

  String? _selectedNiveau;
  User? _selectedResponsable;
  List<User> _adminsGroupe = [];
  bool _loading = false;
  bool _loadingAdmins = true;
  String? _error;

  bool get _isEdit => widget.groupe != null;

  List<MapEntry<String, String>> _getNiveaux(AppLocalizations l10n) => [
    MapEntry('Débutant', l10n.groupLevelBeginner),
    MapEntry('Intermédiaire', l10n.groupLevelIntermediate),
    MapEntry('Avancé', l10n.groupLevelAdvanced),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.groupe != null) {
      final g = widget.groupe!;
      _nomController.text = g.nom;
      _descriptionController.text = g.description ?? '';
      _selectedNiveau = g.niveau;
      _selectedResponsable = g.responsable;
    }
    _loadAdminsGroupe();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadAdminsGroupe() async {
    try {
      final list = await _userService.getByRole('ADMIN_GROUPE');
      if (!mounted) return;
      setState(() {
        _adminsGroupe = list;
        _loadingAdmins = false;
        if (_selectedResponsable == null && list.isNotEmpty && !_isEdit) {
          _selectedResponsable = null; // laisser vide par défaut
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingAdmins = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final l10n = AppLocalizations.of(context);
      if (_isEdit) {
        await _groupeService.update(
          id: widget.groupe!.id,
          nom: _nomController.text.trim(),
          niveau: _selectedNiveau,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          responsableId: _selectedResponsable?.id,
        );
        if (!mounted) return;
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.groupModified)),
        );
      } else {
        await _groupeService.create(
          nom: _nomController.text.trim(),
          niveau: _selectedNiveau,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          responsableId: _selectedResponsable?.id,
        );
        if (!mounted) return;
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.groupCreated)),
        );
      }
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
        title: Text(_isEdit ? l10n.editGroup : l10n.createGroup),
      ),
      body: _loadingAdmins
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nomController,
                      decoration: InputDecoration(
                        labelText: '${l10n.group} *',
                        hintText: 'Ex: Débutants',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return l10n.required;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedNiveau,
                      decoration: const InputDecoration(
                        labelText: 'Niveau',
                        border: OutlineInputBorder(),
                      ),
                      items: _getNiveaux(l10n).map((e) {
                        return DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => _selectedNiveau = v),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.description,
                        hintText: l10n.hintEventDetails,
                        alignLabelWithHint: true,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<User?>(
                      value: _selectedResponsable,
                      decoration: InputDecoration(
                        labelText: l10n.selectResponsable,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<User?>(
                          value: null,
                          child: Text('— Aucun —'),
                        ),
                        ..._adminsGroupe.map((u) => DropdownMenuItem<User?>(
                              value: u,
                              child: Text(u.displayName),
                            )),
                      ],
                      onChanged: (v) => setState(() => _selectedResponsable = v),
                    ),
                    if (_adminsGroupe.isEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Créez d\'abord un utilisateur avec le rôle "Admin groupe" dans Gestion des utilisateurs.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                    if (_error != null) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline,
                                color: Theme.of(context).colorScheme.error),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _error!,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _loading ? null : _submit,
                      icon: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(l10n.save),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
