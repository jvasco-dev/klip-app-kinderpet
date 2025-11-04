import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:kinder_pet/features/auth/presentation/pages/auth/signin/models/email.dart';
import 'package:kinder_pet/features/auth/presentation/pages/auth/signin/models/password.dart';

class SignInState extends Equatable {
  final Email email;
  final Password password;
  final FormzSubmissionStatus status;
  final bool isValid;

  const SignInState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
  });

  SignInState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
    bool? isValid,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [email, password, status, isValid];
}
