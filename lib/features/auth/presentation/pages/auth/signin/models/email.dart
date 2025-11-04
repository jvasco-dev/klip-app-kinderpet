import 'package:formz/formz.dart';

enum EmailValidationError { empty, invalid, domainNotAllowed }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([super.value = '']) : super.dirty();

  static final _regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final _allowedDomains = ['gmail.com', 'hotmail.com', 'outlook.com'];

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) return EmailValidationError.empty;
    if (!_regex.hasMatch(value)) return EmailValidationError.invalid;

    final domain = value.split('@').last;
    if (!_allowedDomains.contains(domain)) {
      return EmailValidationError.domainNotAllowed;
    }

    return null;
  }
}
