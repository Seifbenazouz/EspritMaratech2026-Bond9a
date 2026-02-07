import 'package:flutter/material.dart';

import '../models/permission.dart';
import '../services/permission_service.dart';

/// Formulaire création / modification d'une permission (ADMIN_PRINCIPAL).
class PermissionFormScreen extends StatefulWidget {
  final Permission? permission;

  const PermissionFormScreen({super.key, this.permission});

  @override
  State<PermissionFormScreen> createState() => _PermissionFormScreenState();
}

class _PermissionFormScreenState extends State<PermissionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _loading = false;

  bool get _isEdit => widget.permission != null;

  @override
  void initState() {
    super.initState();
    if (widget.permission != null) {
      _nomController.text = widget.permission!.nom;
      _descriptionController.text = widget.permission!.description ?? '';
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final service = PermissionService();
    final desc = _descriptionController.text.trim();
    try {
      if (_isEdit) {
        await service.update(
          widget.permission!.id,
          _nomController.text.trim(),
          description: desc.isEmpty ? null : desc,
        );
      } else {
        await service.create(
          _nomController.text.trim(),
          description: desc.isEmpty ? null : desc,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEdit ? 'Permission modifiée' : 'Permission créée')),
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
        title: Text(_isEdit ? 'Modifier la permission' : 'Nouvelle permission'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: 'Code (nom technique) *',
                hintText: 'Ex: GESTION_EVENEMENTS',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.characters,
              validator: (v) => v == null || v.trim().isEmpty ? 'Requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Phrase lisible (description)',
                hintText: 'Ex: Créer, modifier et supprimer les événements',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 2,
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
                  : Text(_isEdit ? 'Enregistrer' : 'Créer'),
            ),
          ],
        ),
      ),
    );
  }
}
