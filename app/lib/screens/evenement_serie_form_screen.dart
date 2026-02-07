import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/evenement_request.dart';
import '../models/groupe_running.dart';
import '../services/evenement_service.dart';
import '../services/groupe_service.dart';
import 'lieu_picker_screen.dart';

/// Création d'événements en série :
/// - Quotidien : un événement par jour pour un groupe (entraînements quotidiens)
/// - Hebdomadaire : un événement par semaine (sorties longues, etc.)
class EvenementSerieFormScreen extends StatefulWidget {
  const EvenementSerieFormScreen({super.key});

  @override
  State<EvenementSerieFormScreen> createState() => _EvenementSerieFormScreenState();
}

class _EvenementSerieFormScreenState extends State<EvenementSerieFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _lieuController = TextEditingController();
  final GroupeService _groupeService = GroupeService();
  final EvenementService _eventService = EvenementService();

  List<GroupeRunning> _groupes = [];
  int? _selectedGroupeId;
  bool _modeQuotidien = true;
  String get _type => _modeQuotidien ? 'QUOTIDIEN' : 'SORTIE_LONGUE';
  TimeOfDay _time = const TimeOfDay(hour: 6, minute: 30);
  DateTime? _dateDebut;
  DateTime? _dateFin;
  int _jourSemaine = DateTime.sunday;
  double? _selectedLat;
  double? _selectedLng;
  bool _loading = false;
  bool _loadingGroupes = true;
  String? _error;


  @override
  void initState() {
    super.initState();
    _loadGroupes();
    final now = DateTime.now();
    _dateDebut = now;
    _dateFin = now.add(const Duration(days: 6));
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

  List<DateTime> _getDatesToCreate() {
    if (_dateDebut == null || _dateFin == null) return [];
    if (_modeQuotidien) {
      final list = <DateTime>[];
      var d = DateTime(_dateDebut!.year, _dateDebut!.month, _dateDebut!.day);
      final end = DateTime(_dateFin!.year, _dateFin!.month, _dateFin!.day);
      while (!d.isAfter(end)) {
        list.add(d);
        d = d.add(const Duration(days: 1));
      }
      return list;
    } else {
      final list = <DateTime>[];
      var d = DateTime(_dateDebut!.year, _dateDebut!.month, _dateDebut!.day);
      final end = DateTime(_dateFin!.year, _dateFin!.month, _dateFin!.day);
      while (!d.isAfter(end)) {
        if (d.weekday == _jourSemaine) list.add(d);
        d = d.add(const Duration(days: 1));
      }
      return list;
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) return;
    if (_selectedGroupeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).selectGroupSnackbar)),
      );
      return;
    }
    final dates = _getDatesToCreate();
    if (dates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).noDateInRange),
        ),
      );
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    int created = 0;
    try {
      for (final day in dates) {
        final dateTime = DateTime(day.year, day.month, day.day, _time.hour, _time.minute);
        final request = EvenementRequest(
          titre: _titreController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          date: dateTime,
          type: _type,
          lieu: _lieuController.text.trim().isEmpty
              ? null
              : _lieuController.text.trim(),
          latitude: _selectedLat,
          longitude: _selectedLng,
          groupeId: _selectedGroupeId!,
        );
        await _eventService.create(request);
        created++;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).eventsCreated(created)),
          backgroundColor: Colors.green.shade700,
        ),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppLocalizations.of(context).errorAfterCreate(created)}${e.toString().replaceFirst('Exception: ', '')}')),
      );
    }
  }

  String _formatDate(BuildContext context, DateTime? d) {
    if (d == null) return AppLocalizations.of(context).choose;
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  List<(int, String)> _getJours(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      (1, l10n.dayMonday),
      (2, l10n.dayTuesday),
      (3, l10n.dayWednesday),
      (4, l10n.dayThursday),
      (5, l10n.dayFriday),
      (6, l10n.daySaturday),
      (7, l10n.daySunday),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final dates = _getDatesToCreate();
    final l10n = AppLocalizations.of(context);
    final jours = _getJours(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createSeries),
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
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red.shade700),
                            const SizedBox(width: 8),
                            Expanded(child: Text(_error!, style: TextStyle(color: Colors.red.shade700))),
                          ],
                        ),
                      ),
                    ],
                    SegmentedButton<bool>(
                      segments: [
                        ButtonSegment(value: true, label: Text(l10n.daily), icon: const Icon(Icons.today)),
                        ButtonSegment(value: false, label: Text(l10n.weekly), icon: const Icon(Icons.date_range)),
                      ],
                      selected: {_modeQuotidien},
                      onSelectionChanged: (s) => setState(() => _modeQuotidien = s.first),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titreController,
                      decoration: InputDecoration(
                        labelText: '${l10n.title} *',
                        hintText: _modeQuotidien ? l10n.hintDailyEvent : l10n.hintWeeklyEvent,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? l10n.required : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.description,
                        border: const OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _lieuController,
                      decoration: const InputDecoration(
                        labelText: 'Lieu de rencontre',
                        hintText: 'Saisir une adresse ou choisir sur la carte',
                        border: OutlineInputBorder(),
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
                    DropdownButtonFormField<int>(
                      value: _selectedGroupeId,
                      decoration: InputDecoration(
                        labelText: '${l10n.group} *',
                        border: const OutlineInputBorder(),
                      ),
                      items: _groupes
                          .map((g) => DropdownMenuItem(value: g.id, child: Text(g.nom)))
                          .toList(),
                      onChanged: _groupes.isEmpty ? null : (v) => setState(() => _selectedGroupeId = v),
                      validator: (v) => v == null ? l10n.required : null,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text(l10n.time),
                      subtitle: Text('${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}'),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final t = await showTimePicker(context: context, initialTime: _time);
                        if (t != null) setState(() => _time = t);
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      tileColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    if (_modeQuotidien) ...[
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                final d = await showDatePicker(
                                  context: context,
                                  initialDate: _dateDebut ?? DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (d != null) setState(() => _dateDebut = d);
                              },
                              child: Text('${l10n.from} ${_formatDate(context, _dateDebut)}'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                final d = await showDatePicker(
                                  context: context,
                                  initialDate: _dateFin ?? _dateDebut ?? DateTime.now(),
                                  firstDate: _dateDebut ?? DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (d != null) setState(() => _dateFin = d);
                              },
                              child: Text('${l10n.to} ${_formatDate(context, _dateFin)}'),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      DropdownButtonFormField<int>(
                        value: _jourSemaine,
                        decoration: InputDecoration(
                          labelText: l10n.dayOfWeek,
                          border: const OutlineInputBorder(),
                        ),
                        items: jours
                            .map((j) => DropdownMenuItem(value: j.$1, child: Text(j.$2)))
                            .toList(),
                        onChanged: (v) => setState(() => _jourSemaine = v ?? DateTime.sunday),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                final d = await showDatePicker(
                                  context: context,
                                  initialDate: _dateDebut ?? DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                                );
                                if (d != null) setState(() => _dateDebut = d);
                              },
                              child: Text('${l10n.from} ${_formatDate(context, _dateDebut)}'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                final d = await showDatePicker(
                                  context: context,
                                  initialDate: _dateFin ?? _dateDebut ?? DateTime.now(),
                                  firstDate: _dateDebut ?? DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                                );
                                if (d != null) setState(() => _dateFin = d);
                              },
                              child: Text('${l10n.to} ${_formatDate(context, _dateFin)}'),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (dates.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        l10n.eventsWillBeCreated(dates.length),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _loading || dates.isEmpty ? null : _submit,
                      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: _loading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(dates.isEmpty ? l10n.chooseDates : l10n.createEvents(dates.length)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
