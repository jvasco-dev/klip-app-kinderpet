import 'package:flutter/material.dart';
import 'package:kinder_pet/core/config/routes.dart';
import 'package:kinder_pet/shared/widgets/index.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      // Simula registro
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        Navigator.pushReplacementNamed(context, AppRoutes.signIn);
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign Up',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 32),
                CommonTextField(
                  hintText: 'Fullname',
                  controller: _nameCtrl,
                  icon: Icons.password_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required field';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CommonTextField(
                  hintText: 'Email',
                  controller: _emailCtrl,
                  icon: Icons.password_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required field';
                    }
                    if (!value.contains('@')) return 'Correo inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CommonTextField(
                  hintText: 'Contraseña',
                  controller: _passwordCtrl,
                  obscureText: true,
                  icon: Icons.password_outlined,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Min length 6';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                CommonButton(
                  label: 'Sign Up',
                  isLoading: _isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.signIn);
                  },
                  child: const Text('Do you have account? Sign In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
