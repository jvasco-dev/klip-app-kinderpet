/* part of 'spa_bloc.dart';

abstract class SpaState extends Equatable {
  const SpaState();

  @override
  List<Object?> get props => [];
}

class SpaInitial extends SpaState {}

class SpaLoading extends SpaState {}

class SpaLoaded extends SpaState {
  final List<SpaAppointment> appointments;

  const SpaLoaded(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

class SpaSuccess extends SpaState {
  final String message;

  const SpaSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class SpaError extends SpaState {
  final String message;

  const SpaError(this.message);

  @override
  List<Object?> get props => [message];
}
 */