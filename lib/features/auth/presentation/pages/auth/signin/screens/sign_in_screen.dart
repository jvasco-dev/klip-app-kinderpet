import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:kinder_pet/core/config/routes.dart';
import 'package:kinder_pet/shared/widgets/index.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      _emailCtrl.text = 'test@example.com';
      _passwordCtrl.text = '123456';
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      // Simula autenticación
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      });
    }
  }

  @override
  void dispose() {
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
                  'Sign In',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 32),
                CommonTextField(
                  hintText: 'Email',
                  controller: _emailCtrl,
                   icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required field';
                    }
                    if (!value.contains('@')) return 'Invalid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CommonTextField(
                  hintText: 'Password',
                  controller: _passwordCtrl,
                  icon: Icons.password_outlined,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6)
                      return 'Min length 6';
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                CommonButton(
                  label: 'Sign In',
                  isLoading: _isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.signUp);
                  },
                  child: const Text("Don't have account? Sign up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
