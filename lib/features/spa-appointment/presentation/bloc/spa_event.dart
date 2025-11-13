/* 
part of 'spa_bloc.dart';

abstract class SpaEvent extends Equatable {
  const SpaEvent();

  @override
  List<Object?> get props => [];
}

/// 🔹 Obtener todas las citas (opcionalmente por fecha o estado)
class LoadSpaAppointments extends SpaEvent {
  final String? date;
  final String? status;

  const LoadSpaAppointments({this.date, this.status});

  @override
  List<Object?> get props => [date, status];
}

/// 🔹 Crear una nueva cita
class CreateSpaAppointment extends SpaEvent {
  final SpaAppointment spa;

  const CreateSpaAppointment(this.spa);

  @override
  List<Object?> get props => [spa];
}

/// 🔹 Cancelar una cita
class CancelSpaAppointment extends SpaEvent {
  final String spaId;

  const CancelSpaAppointment(this.spaId);

  @override
  List<Object?> get props => [spaId];
}

/// 🔹 Completar una cita
class CompleteSpaAppointment extends SpaEvent {
  final String spaId;
  final bool paid;

  const CompleteSpaAppointment(this.spaId, this.paid);

  @override
  List<Object?> get props => [spaId, paid];
}
 */