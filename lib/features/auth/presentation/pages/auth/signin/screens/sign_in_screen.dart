import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:kinder_pet/core/config/routes.dart';
import 'package:kinder_pet/core/config/theme.dart';
import 'package:kinder_pet/features/auth/data/services/auth_service.dart';
import 'package:kinder_pet/features/auth/presentation/pages/auth/signin/bloc/sign_in_bloc.dart';
import 'package:kinder_pet/features/auth/presentation/pages/auth/signin/models/email.dart';
import 'package:kinder_pet/features/auth/presentation/pages/auth/signin/models/password.dart';
import 'package:kinder_pet/shared/widgets/common_button.dart';
import 'package:kinder_pet/shared/widgets/common_text_field.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInBloc(AuthService()),
      child: BlocListener<SignInBloc, SignInState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          // if navigation successful, navigate to dashboard
          if (state.status == FormzSubmissionStatus.success) {
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
          }

          if (state.status == FormzSubmissionStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error trying to Sign In, try again'),
                backgroundColor: AppColors.softAlert,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.warmBeige,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome Back...',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            color: AppColors.brownText,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.goldenTan,
                      ),
                    ),
                    const SizedBox(height: 32),

                    //Email textbox
                    BlocBuilder<SignInBloc, SignInState>(
                      buildWhen: (previous, current) =>
                          previous.email != current.email,
                      builder: (context, state) {
                        return CommonTextField(
                          hintText: 'Email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) => context.read<SignInBloc>().add(
                            EmailChanged(value),
                          ),
                          validator: (_) {
                            if (state.email.displayError ==
                                EmailValidationError.empty) {
                              return 'Email is required';
                            } else if (state.email.displayError ==
                                EmailValidationError.invalid) {
                              return 'Invalid email format';
                            } else if (state.email.displayError ==
                                EmailValidationError.domainNotAllowed) {
                              return 'Email domain not allowed';
                            }
                            return null;
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    //Password textbox
                    BlocBuilder<SignInBloc, SignInState>(
                      buildWhen: (previous, current) =>
                          previous.password.value != current.password.value ||
                          previous.password.displayError !=
                              current.password.displayError,
                      builder: (context, state) {
                        return CommonTextField(
                          hintText: 'Password',
                          icon: Icons.lock_outlined,
                          obscureText: true,
                          onChanged: (value) => context.read<SignInBloc>().add(
                            PasswordChanged(value),
                          ),
                          validator: (_) {
                            if (state.password.displayError != null) {
                              switch (state.password.displayError!) {
                                case PasswordValidationError.empty:
                                  return 'Password cannot be empty';
                                case PasswordValidationError.tooShort:
                                  return 'Password must be at least 8 characters';
                                default:
                                  return 'Invalid password';
                              }
                            }
                            return null;
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // SignIn Button
                    BlocBuilder<SignInBloc, SignInState>(
                      buildWhen: (previous, current) =>
                          previous.status != current.status,
                      builder: (context, state) {
                        return CommonButton(
                          label:
                              state.status == FormzSubmissionStatus.inProgress
                              ? 'Signing In...'
                              : 'Sign In',
                          onPressed: () {
                            final bloc = context.read<SignInBloc>();
                            bloc.add(ValidateForm());

                            Future.delayed(
                              const Duration(milliseconds: 50),
                              () {
                                final state = bloc.state;
                                if (state.isValid) {
                                  bloc.add(SignInSubmitted());
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please fill in all fields correctly',
                                      ),
                                      backgroundColor: AppColors.darkOrangeHover,
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                    /* const SizedBox(height: 16),
    
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.signUp),
                        child: const Text("Don't have an account? Sign up"),
                      ), */
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
