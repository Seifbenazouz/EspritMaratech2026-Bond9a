import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/login_request.dart';
import '../widgets/language_switch_button.dart';
import '../widgets/text_scale_button.dart';
import '../widgets/theme_switch_button.dart';
import '../services/auth_service.dart';
import 'change_password_screen.dart';
import 'member_main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _authService.login(LoginRequest(
        nom: _nomController.text.trim(),
        password: _passwordController.text,
      ));

      if (!mounted) return;
      if (response.passwordChangeRequired) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => ChangePasswordScreen(user: response),
          ),
          (route) => false,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => MemberMainScreen(user: response),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppLocalizations.of(context).loginScreenLabel,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: const [
          LanguageSwitchButton(),
          TextScaleButton(),
          ThemeSwitchButton(),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.25),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  Semantics(
                    label: 'Icône connexion',
                    child: Icon(Icons.login, size: 88, color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context).login,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).loginSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 32),
                  if (_errorMessage != null) ...[
                    Semantics(
                      liveRegion: true,
                      label: 'Erreur de connexion. $_errorMessage',
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Theme.of(context).colorScheme.error, width: 2),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 32),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).error,
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          color: Theme.of(context).colorScheme.error,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _errorMessage!,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.onErrorContainer,
                                          fontSize: 18,
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
                  Semantics(
                    hint: AppLocalizations.of(context).required,
                    child: TextFormField(
                      controller: _nomController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).name,
                        hintText: 'Ex: Dupont',
                        prefixIcon: const Icon(Icons.person, size: 32),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? AppLocalizations.of(context).nameRequired : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Semantics(
                    hint: 'Champ obligatoire, 3 derniers chiffres du CIN',
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).password,
                        prefixIcon: Icon(Icons.lock, size: 32),
                      ),
                      obscureText: true,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? AppLocalizations.of(context).passwordRequired : null,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Semantics(
                    label: _isLoading ? '...' : AppLocalizations.of(context).connect,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _login,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        minimumSize: const Size.fromHeight(64),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 28,
                              width: 28,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(AppLocalizations.of(context).connect),
                    ),
                  ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}
