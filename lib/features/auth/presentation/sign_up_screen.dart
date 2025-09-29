import 'package:batch10auth/common/validators.dart';
import 'package:batch10auth/data/auth_repository.dart';
import 'package:batch10auth/data/database_repository.dart';
import 'package:batch10auth/features/auth/presentation/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  final AuthRepository auth;
  final DatabaseRepository db;

  const SignupScreen({super.key, required this.auth, required this.db});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _submitting = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  String? _confirmValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != _passCtrl.text) return 'Passwords do not match';
    return null;
  }

  Future<void> _submit() async {
    final form = _formKey.currentState!;
    if (!form.validate()) return;

    setState(() => _submitting = true);

    try {
      String userId = await widget.auth.createUserWithEmailAndPassword(
        _emailCtrl.text.trim(),
        _passCtrl.text,
      );
      //Firestore Nutzer erstellen
      await widget.db.addUser(userId, _emailCtrl.text.trim());

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
    }

    setState(() => _submitting = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Signed up as ${_emailCtrl.text.trim()}')),
    );
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'you@example.com',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: validateEmail,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passCtrl,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      helperText: 'Min 8 chars, include a letter & number',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscure1 = !_obscure1),
                        icon: Icon(
                          _obscure1 ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    obscureText: _obscure1,
                    validator: validatePassword,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmCtrl,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscure2 = !_obscure2),
                        icon: Icon(
                          _obscure2 ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    obscureText: _obscure2,
                    validator: _confirmValidator,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submitting ? null : _submit,
                      child: _submitting
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Create Account'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(auth: widget.auth,db: widget.db),
                      ),
                    ),
                    child: const Text('Already have an account? Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
