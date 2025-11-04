import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:formz/formz.dart';
import 'package:kinder_pet/features/auth/data/services/auth_service.dart';
import 'package:kinder_pet/features/auth/presentation/pages/auth/signin/bloc/sign_in_event.dart';
import 'package:kinder_pet/features/auth/presentation/pages/auth/signin/bloc/sign_in_state.dart';
import 'package:kinder_pet/features/auth/presentation/pages/auth/signin/models/email.dart';
import 'package:kinder_pet/features/auth/presentation/pages/auth/signin/models/password.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthService _authService;

  SignInBloc(this._authService) : super(const SignInState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<SignInSubmitted>(_onSignInSubmitted);
    on<ValidateForm>(_onValidateForm);
  }

  void _onEmailChanged(EmailChanged event, Emitter<SignInState> emit) {
    final email = Email.dirty(event.value);

    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email, state.password]),
      ),
    );
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<SignInState> emit) {
    final password = Password.dirty(event.value);

    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([state.email, password]),
      ),
    );
  }

  void _onValidateForm(ValidateForm event, Emitter<SignInState> emit) {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    emit(
      state.copyWith(
        email: email,
        password: password,
        isValid: Formz.validate([email, password]),
      ),
    );
  }

  Future<void> _onSignInSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final isValid = Formz.validate([email, password]);
    
    

    emit(state.copyWith(email: email, password: password, isValid: isValid));

    if (!isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {

      final response = await _authService.signIn(
        email: email.value,
        password: password.value,
      );

      final accessToken = response['accessToken'];
      final refreshToken = response['refreshToken'];

      final storage = FlutterSecureStorage();
      await storage.write(key: 'accessToken', value: accessToken);
      await storage.write(key: 'refreshToken', value: refreshToken);

      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
