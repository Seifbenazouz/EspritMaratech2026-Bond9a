import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/groupe_running.dart';
import '../models/programme_entrainement.dart';
import '../services/groupe_service.dart';
import '../services/programme_entrainement_service.dart';

/// Formulaire création / modification d'un programme d'entraînement (ADMIN_COACH, ADMIN_PRINCIPAL).
class ProgrammeFormScreen extends StatefulWidget {
  final ProgrammeEntrainement? programme;

  const ProgrammeFormScreen({super.key, this.programme});

  @override
  State<ProgrammeFormScreen> createState() => _ProgrammeFormScreenState();
}

class _ProgrammeFormScreenState extends State<ProgrammeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<GroupeRunning> _groupes = [];
  GroupeRunning? _selectedGroupe;
  DateTime? _dateDebut;
  DateTime? _dateFin;
  bool _loading = false;
  bool _loadingGroupes = true;
  String? _errorGroupes;

  bool get _isEdit => widget.programme != null;

  @override
  void initState() {
    super.initState();
    if (widget.programme != null) {
      final p = widget.programme!;
      _titreController.text = p.titre;
      _descriptionController.text = p.description ?? '';
      _dateDebut = p.dateDebut;
      _dateFin = p.dateFin;
      if (p.groupe != null) _selectedGroupe = p.groupe;
    }
    _loadGroupes();
  }

  Future<void> _loadGroupes() async {
    try {
      final page = await GroupeService().getAll(size: 200);
      if (!mounted) return;
      setState(() {
        _groupes = page.content;
        _loadingGroupes = false;
        if (widget.programme?.groupe != null && _groupes.isNotEmpty) {
          final id = widget.programme!.groupe!.id;
          try {
            _selectedGroupe = _groupes.firstWhere((g) => g.id == id);
          } catch (_) {
            _selectedGroupe = _groupes.first;
          }
        } else if (_groupes.isNotEmpty && _selectedGroupe == null) {
          _selectedGroupe = _groupes.first;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorGroupes = e.toString().replaceFirst('Exception: ', '');
        _loadingGroupes = false;
      });
    }
  }

  @override
  void dispose() {
    _titreController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDateDebut() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _dateDebut ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (d != null) setState(() => _dateDebut = d);
  }

  Future<void> _pickDateFin() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _dateFin ?? _dateDebut ?? DateTime.now(),
      firstDate: _dateDebut ?? DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (d != null) setState(() => _dateFin = d);
  }

  String _formatDate(BuildContext context, DateTime? d) {
    if (d == null) return AppLocalizations.of(context).notDefined;
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGroupe == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).selectGroupSnackbar)),
      );
      return;
    }
    setState(() => _loading = true);
    final service = ProgrammeEntrainementService();
    try {
      if (_isEdit) {
        await service.update(
          id: widget.programme!.id,
          titre: _titreController.text.trim(),
          description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
          dateDebut: _dateDebut,
          dateFin: _dateFin,
          groupeId: _selectedGroupe!.id,
        );
      } else {
        await service.create(
          titre: _titreController.text.trim(),
          description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
          dateDebut: _dateDebut,
          dateFin: _dateFin,
          groupeId: _selectedGroupe!.id,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEdit ? AppLocalizations.of(context).programmeModified : AppLocalizations.of(context).programmeCreated)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString().replaceFirst('Exception: ', '')}')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? AppLocalizations.of(context).editProgramme : AppLocalizations.of(context).newProgramme),
      ),
      body: _loadingGroupes
          ? const Center(child: CircularProgressIndicator())
          : _errorGroupes != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_errorGroupes!, textAlign: TextAlign.center, style: TextStyle(color: Colors.red.shade700)),
                        const SizedBox(height: 16),
                        FilledButton.icon(onPressed: _loadGroupes, icon: const Icon(Icons.refresh), label: Text(AppLocalizations.of(context).retry)),
                      ],
                    ),
                  ),
                )
              : Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      TextFormField(
                        controller: _titreController,
                        decoration: InputDecoration(
                          labelText: '${AppLocalizations.of(context).title} *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? AppLocalizations.of(context).required : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<GroupeRunning>(
                        value: _selectedGroupe,
                        decoration: InputDecoration(
                          labelText: '${AppLocalizations.of(context).group} *',
                          border: OutlineInputBorder(),
                        ),
                        items: _groupes
                            .map((g) => DropdownMenuItem(value: g, child: Text(g.nom)))
                            .toList(),
                        onChanged: (g) => setState(() => _selectedGroupe = g),
                        validator: (v) => v == null ? AppLocalizations.of(context).selectGroup : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).description,
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 4,
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        title: Text(AppLocalizations.of(context).startDate),
                        subtitle: Text(_formatDate(context, _dateDebut)),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: _pickDateDebut,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        tileColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        title: Text(AppLocalizations.of(context).endDate),
                        subtitle: Text(_formatDate(context, _dateFin)),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: _pickDateFin,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        tileColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _loading ? null : _submit,
                        child: _loading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(_isEdit ? AppLocalizations.of(context).save : AppLocalizations.of(context).create),
                      ),
                    ],
                  ),
                ),
    );
  }
}
