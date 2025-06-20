// lib/frontend/screens/login_screen.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();

  bool _loading      = false;
  bool _showPassword = false;
  String? _errorMsg;

  bool get _emailValid {
    final e = _emailCtrl.text.trim();
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return regex.hasMatch(e);
  }

  bool get _passValid {
    return _passCtrl.text.trim().length >= 6;
  }

  bool get _formValid => _emailValid && _passValid;

  Future<void> _login() async {
    if (!_formValid) return;
    setState(() {
      _loading  = true;
      _errorMsg = null;
    });
    try {
      await AuthService.signInWithEmail(
        _emailCtrl.text.trim(),
        _passCtrl.text.trim(),
      );
      GoRouter.of(context).go('/');
    } catch (e) {
      setState(() => _errorMsg = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      _loading  = true;
      _errorMsg = null;
    });
    try {
      await AuthService.signInWithGoogle();
      GoRouter.of(context).go('/');
    } catch (e) {
      setState(() => _errorMsg = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _loginWithGithub() async {
    setState(() {
      _loading  = true;
      _errorMsg = null;
    });
    try {
      await AuthService.signInWithGithub();
      GoRouter.of(context).go('/');
    } catch (e) {
      setState(() => _errorMsg = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _loginWithFacebook() async {
    setState(() {
      _loading  = true;
      _errorMsg = null;
    });
    try {
      await AuthService.signInWithFacebook();
      GoRouter.of(context).go('/');
    } catch (e) {
      setState(() => _errorMsg = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  InputDecoration _inputDecoration({
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
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),

              // Header
              Text(
                l10n.loginHeader,
                style: const TextStyle(
                    fontSize: 34, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.loginSubheader,
                style: TextStyle(
                    color: Colors.grey.shade600, fontSize: 16),
              ),
              const SizedBox(height: 24),

              // Email
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() {}),
                decoration: _inputDecoration(
                  label: l10n.emailLabel,
                  hint: l10n.emailHint,
                  valid: _emailValid,
                  touched: _emailCtrl.text.isNotEmpty,
                  suffix: _emailCtrl.text.isEmpty
                      ? null
                      : Icon(
                    _emailValid
                        ? Icons.check_circle
                        : Icons.error,
                    color: _emailValid
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password
              TextField(
                controller: _passCtrl,
                obscureText: !_showPassword,
                onChanged: (_) => setState(() {}),
                decoration: _inputDecoration(
                  label: l10n.passwordLabel,
                  hint: l10n.passwordHint,
                  valid: _passValid,
                  touched: _passCtrl.text.isNotEmpty,
                  suffix: IconButton(
                    icon: Icon(
                      _showPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(
                            () => _showPassword = !_showPassword),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Error message
              if (_errorMsg != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    _errorMsg!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              const SizedBox(height: 16),

              // Login button
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed:
                  _formValid && !_loading ? _login : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _formValid
                        ? Colors.black
                        : Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(
                      color: Colors.white)
                      : Text(
                    l10n.loginButton,
                    style: TextStyle(
                      color: _formValid
                          ? Colors.white
                          : Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // OR divider
              Row(children: [
                Expanded(
                    child: Divider(color: Colors.grey.shade300)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    l10n.orDivider,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                Expanded(
                    child: Divider(color: Colors.grey.shade300)),
              ]),
              const SizedBox(height: 24),

              // Google sign in
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  icon: Image.asset(
                    'assets/logo/google_logo.png',
                    width: 40,
                    height: 40,
                  ),
                  label: Text(l10n.signInWithGoogle),
                  style: OutlinedButton.styleFrom(
                    side:
                    BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed:
                  _loading ? null : _loginWithGoogle,
                ),
              ),
              const SizedBox(height: 16),

              // GitHub sign in
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  icon: Image.asset(
                    'assets/logo/github-logo.png',
                    width: 30,
                    height: 30,
                  ),
                  label: Text(l10n.signInWithGitHub),
                  style: OutlinedButton.styleFrom(
                    side:
                    BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed:
                  _loading ? null : _loginWithGithub,
                ),
              ),
              const SizedBox(height: 16),

              // Register link
              Center(
                child: RichText(
                  text: TextSpan(
                    text: l10n.noAccount,
                    style: TextStyle(color: Colors.grey.shade600),
                    children: [
                      TextSpan(
                        text: l10n.register,
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            GoRouter.of(context).go('/register');
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
