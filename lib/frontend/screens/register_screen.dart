// lib/frontend/screens/register_screen.dart

import 'package:clothing_store/frontend/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();

  bool _showPassword = false;
  bool _loading      = false;

  bool get _nameValid {
    return _nameCtrl.text.trim().length >= 2;
  }

  bool get _emailValid {
    final email = _emailCtrl.text.trim();
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return regex.hasMatch(email);
  }

  bool get _passValid {
    return _passCtrl.text.trim().length >= 6;
  }

  bool get _formValid => _nameValid && _emailValid && _passValid;

  Future<void> _register() async {
    if (!_formValid) return;
    setState(() => _loading = true);
    try {
      await AuthService.registerWithEmail(
        _emailCtrl.text.trim(),
        _passCtrl.text.trim(),
      );
      GoRouter.of(context).go('/');
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.errorPrefix} $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  InputDecoration _buildDecoration({
    required String label,
    required String hint,
    required bool valid,
    required bool touched,
    Widget? suffix,
  }) {
    final color = !touched
        ? Colors.grey
        : valid
        ? Colors.green
        : Colors.red;
    return InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: 2),
      ),
      suffixIcon: suffix,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                l10n.registerHeader,
                style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.registerSubheader,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),

              // Full Name
              TextField(
                controller: _nameCtrl,
                onChanged: (_) => setState(() {}),
                decoration: _buildDecoration(
                  label: l10n.fullNameLabel,
                  hint: l10n.fullNameHint,
                  valid: _nameValid,
                  touched: _nameCtrl.text.isNotEmpty,
                ),
              ),
              const SizedBox(height: 18),

              // Email
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() {}),
                decoration: _buildDecoration(
                  label: l10n.emailLabel,
                  hint: l10n.emailHint,
                  valid: _emailValid,
                  touched: _emailCtrl.text.isNotEmpty,
                  suffix: _emailCtrl.text.isEmpty
                      ? null
                      : Icon(
                    _emailValid ? Icons.check_circle : Icons.error,
                    color: _emailValid ? Colors.green : Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Password
              TextField(
                controller: _passCtrl,
                obscureText: !_showPassword,
                onChanged: (_) => setState(() {}),
                decoration: _buildDecoration(
                  label: l10n.passwordLabel,
                  hint: l10n.passwordHint,
                  valid: _passValid,
                  touched: _passCtrl.text.isNotEmpty,
                  suffix: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => _showPassword = !_showPassword),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Terms text
              Text.rich(
                TextSpan(
                  text: l10n.termsIntro,
                  style: TextStyle(color: Colors.grey.shade600),
                  children: [
                    TextSpan(
                      text: l10n.terms,
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()..onTap = () {/* TODO */},
                    ),
                    const TextSpan(text: ', '),
                    TextSpan(
                      text: l10n.privacyPolicy,
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()..onTap = () {/* TODO */},
                    ),
                    const TextSpan(text: ', '),
                    TextSpan(
                      text: l10n.cookieUse,
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()..onTap = () {/* TODO */},
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Create account button
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _formValid && !_loading ? _register : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _formValid ? Colors.black : Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    l10n.registerButton,
                    style: TextStyle(
                      color: _formValid ? Colors.white : Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // OR divider
              Row(
                children: <Widget>[
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(l10n.orDivider, style: const TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),

              const SizedBox(height: 24),

              // Google button
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  icon: Image.asset('assets/logo/google_logo.png', width: 24, height: 24),
                  label: Text(l10n.signUpWithGoogle),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    await AuthService.signInWithGoogle();
                    GoRouter.of(context).go('/');
                  },
                ),
              ),
              const SizedBox(height: 16),

              // GitHub button
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  icon: Image.asset('assets/logo/github-logo.png', width: 30, height: 30),
                  label: Text(l10n.signInWithGitHub),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    await AuthService.signInWithGithub();
                    GoRouter.of(context).go('/');
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Login link
              Center(
                child: RichText(
                  text: TextSpan(
                    text: l10n.alreadyHaveAccount,
                    style: TextStyle(color: Colors.grey.shade600),
                    children: [
                      TextSpan(
                        text: l10n.login,
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            GoRouter.of(context).go('/login');
                          },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
