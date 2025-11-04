abstract class SignInEvent {}

class SignInInitEvent extends SignInEvent {}

class ValidateForm extends SignInEvent {}

class EmailChanged extends SignInEvent {
  final String value;
  EmailChanged(this.value);
}

class PasswordChanged extends SignInEvent {
  final String value;
  PasswordChanged(this.value);
}

class SignInSubmitted extends SignInEvent {}
