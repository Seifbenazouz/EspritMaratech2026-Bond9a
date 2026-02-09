import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/login_response.dart';
import '../models/user.dart';
import '../services/user_service.dart';

/// Formulaire création / modification d'un utilisateur (ADMIN_PRINCIPAL).
class UserFormScreen extends StatefulWidget {
  final User? user;

  const UserFormScreen({super.key, this.user});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

/// Expression régulière pour valider le format email.
final RegExp _emailRegex = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
);

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cinController = TextEditingController();

  Role _selectedRole = Role.ADHERENT;
  bool _loading = false;

  bool get _isEdit => widget.user != null;

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context).required;
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return AppLocalizations.of(context).invalidEmail;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      final u = widget.user!;
      _nomController.text = u.nom;
      _prenomController.text = u.prenom ?? '';
      _emailController.text = u.email ?? '';
      _phoneController.text = u.phone?.toString() ?? '';
      _cinController.text = u.cin?.toString() ?? '';
      _selectedRole = u.role ?? Role.ADHERENT;
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final service = UserService();
    try {
      if (_isEdit) {
        final phone = int.tryParse(_phoneController.text.trim());
        await service.update(
          id: widget.user!.id,
          nom: _nomController.text.trim(),
          prenom: _prenomController.text.trim(),
          email: _emailController.text.trim(),
          phone: phone,
          role: _selectedRole.name,
        );
      } else {
        final cin = int.tryParse(_cinController.text.trim());
        if (cin == null || cin.abs() < 100) {
          setState(() => _loading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Le CIN doit contenir au moins 3 chiffres')),
          );
          return;
        }
        final phone = int.tryParse(_phoneController.text.trim());
        await service.create(
          nom: _nomController.text.trim(),
          prenom: _prenomController.text.trim(),
          email: _emailController.text.trim(),
          phone: phone,
          cin: cin,
          role: _selectedRole.name,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEdit ? AppLocalizations.of(context).userModified : AppLocalizations.of(context).userCreated)),
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

  String _roleLabel(BuildContext context, Role r) {
    final l10n = AppLocalizations.of(context);
    switch (r) {
      case Role.ADMIN_PRINCIPAL:
        return l10n.adminPrincipal;
      case Role.ADMIN_COACH:
        return l10n.adminCoach;
      case Role.ADMIN_GROUPE:
        return l10n.adminGroup;
      case Role.ADHERENT:
        return l10n.adherent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? AppLocalizations.of(context).editUser : AppLocalizations.of(context).newUser),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nomController,
              decoration: InputDecoration(
                labelText: '${AppLocalizations.of(context).name} *',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) => v == null || v.trim().isEmpty ? AppLocalizations.of(context).required : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _prenomController,
              decoration: InputDecoration(
                labelText: '${AppLocalizations.of(context).firstName} *',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) => v == null || v.trim().isEmpty ? AppLocalizations.of(context).required : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: '${AppLocalizations.of(context).email} *',
                hintText: 'ex: nom@domaine.com',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                    width: 2.5,
                  ),
                ),
                errorStyle: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              validator: _validateEmail,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).phone,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cinController,
              decoration: InputDecoration(
                labelText: '${AppLocalizations.of(context).cin} *',
                hintText: 'cin',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              enabled: !_isEdit,
              validator: _isEdit ? null : (v) {
                if (v == null || v.trim().isEmpty) return 'Requis';
                final n = int.tryParse(v.trim());
                if (n == null || n.abs() < 10000000) return 'Au moins 8 chiffres';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Role>(
              value: _selectedRole,
              decoration: InputDecoration(
                labelText: '${AppLocalizations.of(context).role} *',
                border: OutlineInputBorder(),
              ),
              items: Role.values
                  .map((r) => DropdownMenuItem(value: r, child: Text(_roleLabel(context, r))))
                  .toList(),
              onChanged: (r) => setState(() => _selectedRole = r!),
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
