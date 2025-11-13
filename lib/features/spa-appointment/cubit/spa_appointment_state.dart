part of 'spa_appointment_cubit.dart';

abstract class SpaAppointmentState extends Equatable {
  const SpaAppointmentState();

  @override
  List<Object?> get props => [];
}

class SpaAppointmentInitial extends SpaAppointmentState {}

class SpaAppointmentLoading extends SpaAppointmentState {}

class SpaAppointmentLoaded extends SpaAppointmentState {
  final List<SpaAppointment> appointments;
  const SpaAppointmentLoaded(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

class SpaAppointmentSuccess extends SpaAppointmentState {
  final String message;
  const SpaAppointmentSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class SpaAppointmentError extends SpaAppointmentState {
  final String message;
  const SpaAppointmentError(this.message);

  @override
  List<Object?> get props => [message];
}