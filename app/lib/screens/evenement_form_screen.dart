import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../widgets/text_scale_button.dart';
import '../widgets/theme_switch_button.dart';
import '../models/evenement.dart';
import '../models/evenement_request.dart';
import '../models/groupe_running.dart';
import '../services/evenement_service.dart';
import '../services/groupe_service.dart';
import 'lieu_picker_screen.dart';

/// Écran de création ou modification d'un événement (réservé aux admins)
class EvenementFormScreen extends StatefulWidget {
  final Evenement? evenement;

  const EvenementFormScreen({super.key, this.evenement});

  bool get isEdit => evenement != null;

  @override
  State<EvenementFormScreen> createState() => _EvenementFormScreenState();
}

class _EvenementFormScreenState extends State<EvenementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _lieuController = TextEditingController();
  final EvenementService _eventService = EvenementService();
  final GroupeService _groupeService = GroupeService();

  List<GroupeRunning> _groupes = [];
  int? _selectedGroupeId;
  String? _selectedType;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  double? _selectedLat;
  double? _selectedLng;
  bool _loading = false;
  bool _loadingGroupes = true;
  String? _error;

  List<(String, String)> _getTypes(AppLocalizations l10n) => [
    ('QUOTIDIEN', l10n.typeDaily),
    ('SORTIE_LONGUE', l10n.typeLongRun),
    ('COURSE_NATIONALE', l10n.typeNationalRace),
    ('AUTRE', l10n.typeOther),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.evenement != null) {
      final e = widget.evenement!;
      _titreController.text = e.titre;
      _descriptionController.text = e.description ?? '';
      _lieuController.text = e.lieu ?? '';
      _selectedLat = e.latitude;
      _selectedLng = e.longitude;
      _selectedType = e.type;
      _selectedDate = e.date;
      _selectedTime = e.date != null
          ? TimeOfDay(hour: e.date!.hour, minute: e.date!.minute)
          : null;
      _selectedGroupeId = e.groupe?.id;
    }
    _loadGroupes();
  }

  @override
  void dispose() {
    _titreController.dispose();
    _descriptionController.dispose();
    _lieuController.dispose();
    super.dispose();
  }

  Future<void> _loadGroupes() async {
    try {
      final page = await _groupeService.getAll(size: 100);
      if (!mounted) return;
      setState(() {
        _groupes = page.content;
        _loadingGroupes = false;
        if (_selectedGroupeId == null && _groupes.isNotEmpty) {
          _selectedGroupeId = _groupes.first.id;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingGroupes = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) return;
    if (_selectedGroupeId == null) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectGroupSnackbar)),
      );
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      DateTime? dateTime;
      if (_selectedDate != null) {
        final t = _selectedTime ?? TimeOfDay(hour: 8, minute: 0);
        dateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          t.hour,
          t.minute,
        );
      }

      final request = EvenementRequest(
        titre: _titreController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        date: dateTime,
        type: _selectedType,
        lieu: _lieuController.text.trim().isEmpty
            ? null
            : _lieuController.text.trim(),
        latitude: _selectedLat,
        longitude: _selectedLng,
        groupeId: _selectedGroupeId!,
      );

      if (widget.isEdit) {
        await _eventService.update(widget.evenement!.id, request);
      } else {
        await _eventService.create(request);
      }

      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isEdit ? l10n.eventModified : l10n.eventCreated),
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
        title: Text(widget.isEdit ? l10n.editEvent : l10n.newEvent),
        actions: const [
          TextScaleButton(),
          ThemeSwitchButton(),
        ],
      ),
      body: _loadingGroupes
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Theme.of(context).colorScheme.error, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 28),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    l10n.cannotLoadGroups,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onErrorContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _error = null;
                                  _loadingGroupes = true;
                                });
                                _loadGroupes();
                              },
                              icon: const Icon(Icons.refresh, size: 18),
                              label: Text(l10n.retry),
                            ),
                          ],
                        ),
                      ),
                    ],
                    TextFormField(
                      controller: _titreController,
                      decoration: InputDecoration(
                        labelText: '${l10n.title} *',
                        hintText: l10n.hintTitleEvent,
                        prefixIcon: const Icon(Icons.title, size: 28),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? l10n.titleRequired : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.description,
                        hintText: l10n.hintEventDetails,
                        prefixIcon: const Icon(Icons.description, size: 28),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lieuController,
                      decoration: InputDecoration(
                        labelText: 'Lieu de rencontre',
                        hintText: 'Saisir une adresse ou choisir sur la carte',
                        helperText: 'Adresse ou nom du lieu où les participants se retrouvent',
                        prefixIcon: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.place, size: 24),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.of(context).push<LieuPickerResult>(
                          MaterialPageRoute(
                            builder: (context) => LieuPickerScreen(
                              initialLat: _selectedLat,
                              initialLng: _selectedLng,
                            ),
                          ),
                        );
                        if (result != null && mounted) {
                          setState(() {
                            _lieuController.text = result.lieu;
                            _selectedLat = result.latitude;
                            _selectedLng = result.longitude;
                          });
                        }
                      },
                      icon: const Icon(Icons.map),
                      label: const Text('Choisir sur la carte'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: InputDecoration(
                        labelText: l10n.type,
                        prefixIcon: const Icon(Icons.category, size: 28),
                      ),
                      items: _getTypes(l10n)
                          .map((t) => DropdownMenuItem(
                                value: t.$1,
                                child: Text(t.$2),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedType = v),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _selectedGroupeId,
                      decoration: InputDecoration(
                        labelText: '${l10n.group} *',
                        prefixIcon: const Icon(Icons.groups, size: 28),
                      ),
                      items: [
                        ..._groupes.map((g) => DropdownMenuItem(
                              value: g.id,
                              child: Text(g.nom),
                            )),
                        if (widget.isEdit &&
                            widget.evenement!.groupe != null &&
                            !_groupes.any((g) => g.id == widget.evenement!.groupe!.id))
                          DropdownMenuItem(
                            value: widget.evenement!.groupe!.id,
                            child: Text('${widget.evenement!.groupe!.nom}'),
                          ),
                      ],
                      onChanged: _groupes.isEmpty ? null : (v) => setState(() => _selectedGroupeId = v),
                      validator: (v) =>
                          v == null ? l10n.groupRequired : null,
                    ),
                    if (_groupes.isEmpty && _error == null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          l10n.noGroupAvailable,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _pickDate,
                            icon: const Icon(Icons.calendar_today, size: 24),
                            label: Text(
                              _selectedDate != null
                                  ? '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}'
                                  : l10n.date,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _pickTime,
                            icon: const Icon(Icons.access_time, size: 24),
                            label: Text(
                              _selectedTime != null
                                  ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                                  : l10n.time,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    FilledButton(
                      onPressed: _loading ? null : _submit,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _loading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(widget.isEdit ? l10n.save : l10n.create),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
