import 'package:formz/formz.dart';

enum PasswordValidationError {
  empty,
  tooShort,
  noUppercase,
  noNumber,
  noSpecial,
}

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) return PasswordValidationError.empty;
    if (value.length < 8) return PasswordValidationError.tooShort;
    /* if (!value.contains(RegExp(r'[A-Z]')))
      return PasswordValidationError.noUppercase; */
    /* if (!value.contains(RegExp(r'[0-9]')))
      return PasswordValidationError.noNumber; 
    if (!value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      return PasswordValidationError.noSpecial;
    } */
    return null;
  }
}
