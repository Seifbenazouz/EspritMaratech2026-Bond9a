import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/login_response.dart';
import '../services/auth_service.dart';
import 'member_main_screen.dart';

/// Écran obligatoire pour changer le mot de passe (premier login après création par admin).
/// L'utilisateur ne peut pas continuer sans définir un mot de passe conforme.
class ChangePasswordScreen extends StatefulWidget {
  final LoginResponse user;

  const ChangePasswordScreen({super.key, required this.user});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  final AuthService _auth = AuthService();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _loading = false;
  String? _error;

  static final RegExp _hasUpper = RegExp(r'[A-Z]');
  static final RegExp _hasLower = RegExp(r'[a-z]');
  static final RegExp _hasDigit = RegExp(r'[0-9]');
  static final RegExp _hasSpecial = RegExp(r'[^A-Za-z0-9]');

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context).passwordRequired;
    }
    if (value.length < 8) {
      return AppLocalizations.of(context).passwordRequirements;
    }
    if (!_hasUpper.hasMatch(value)) {
      return AppLocalizations.of(context).passwordRequirements;
    }
    if (!_hasLower.hasMatch(value)) {
      return AppLocalizations.of(context).passwordRequirements;
    }
    if (!_hasDigit.hasMatch(value)) {
      return AppLocalizations.of(context).passwordRequirements;
    }
    if (!_hasSpecial.hasMatch(value)) {
      return AppLocalizations.of(context).passwordRequirements;
    }
    return null;
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    _error = null;
    if (!_formKey.currentState!.validate()) return;

    final newPwd = _newController.text;
    if (_confirmController.text != newPwd) {
      setState(() => _error = AppLocalizations.of(context).passwordsDoNotMatch);
      return;
    }

    setState(() => _loading = true);
    try {
      await _auth.changePassword(
        currentPassword: _currentController.text,
        newPassword: newPwd,
      );
      if (!mounted) return;
      await _auth.updateStoredUser(widget.user.copyWith(passwordChangeRequired: false));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).passwordChanged)),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => MemberMainScreen(user: widget.user.copyWith(passwordChangeRequired: false))),
        (route) => false,
      );
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
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: Text(l10n.changePasswordTitle),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Icon(
                  Icons.lock_reset_rounded,
                  size: 64,
                  color: scheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.changePasswordSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: scheme.primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded, size: 20, color: scheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.passwordRequirements,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: scheme.onPrimaryContainer,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _currentController,
                  obscureText: _obscureCurrent,
                  decoration: InputDecoration(
                    labelText: '${l10n.currentPassword} *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: scheme.error, width: 2),
                    ),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureCurrent ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                    ),
                  ),
                  validator: (v) => v == null || v.isEmpty ? l10n.required : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _newController,
                  obscureText: _obscureNew,
                  decoration: InputDecoration(
                    labelText: '${l10n.newPassword} *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: scheme.error, width: 2),
                    ),
                    prefixIcon: const Icon(Icons.lock_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureNew ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscureNew = !_obscureNew),
                    ),
                  ),
                  validator: _validateNewPassword,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmController,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    labelText: '${l10n.confirmPassword} *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: scheme.error, width: 2),
                    ),
                    prefixIcon: const Icon(Icons.lock_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return l10n.required;
                    if (v != _newController.text) return l10n.passwordsDoNotMatch;
                    return null;
                  },
                ),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: scheme.errorContainer.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: scheme.error),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _error!,
                            style: TextStyle(color: scheme.onErrorContainer),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _loading ? null : _submit,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.save),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
