import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/features/spa-appointment/data/models/spa_appointment_model.dart';
import 'package:kinder_pet/features/spa-appointment/data/repository/spa_appointment_repository.dart';

part 'spa_appointment_state.dart';

class SpaAppointmentCubit extends Cubit<SpaAppointmentState> {
  final SpaAppointmentRepository _repository;

  SpaAppointmentCubit(this._repository) : super(SpaAppointmentInitial());

  /// Carga todas las citas (opcionalmente por fecha en formato ISO yyyy-MM-dd)
  Future<void> loadAppointments({String? date}) async {
    emit(SpaAppointmentLoading());
    try {
      final appointments = await _repository.getAllAppointments(date: date);
      emit(SpaAppointmentLoaded(appointments));
    } catch (e) {
      emit(SpaAppointmentError('Failed to load appointments: $e'));
    }
  }

  Future<void> updateAppointment(SpaAppointment appointment) async {
    emit(SpaAppointmentLoading());
    try {
      // Construye el payload que tu API espera. Ejemplo:
      final data = {
        if (appointment.serviceName.isNotEmpty)
          'serviceName': appointment.serviceName,
        if (appointment.description != null)
          'description': appointment.description,
        'price': appointment.price,
        'date': appointment.date.toIso8601String(),
        'paid': appointment.paid,
        'status': appointment.status,
        if (appointment.pet != null) 'pet': appointment.pet!.id,
        if (appointment.owner != null) 'owner': appointment.owner!.id,
      };

      final updated = await _repository.updateAppointment(appointment.id, data);

      emit(SpaAppointmentSuccess('Appointment updated successfully'));
      // refrescar lista para la fecha afectada
      await loadAppointments(
        date: updated.date.toIso8601String().split('T').first,
      );
    } catch (e) {
      emit(SpaAppointmentError('Failed to update appointment: $e'));
    }
  }

  

  /// Crear cita
  Future<void> createAppointment(SpaAppointment appointment) async {
    emit(SpaAppointmentLoading());
    try {
      await _repository.createAppointment(appointment);
      // Emito success correctamente
      emit(const SpaAppointmentSuccess('Appointment created successfully'));
      // Recargo la lista (pasando la fecha de la cita para que el refresco sea más eficiente)
      await loadAppointments(
        date: appointment.date.toIso8601String().split('T').first,
      );
    } catch (e) {
      emit(SpaAppointmentError('Failed to create appointment: $e'));
    }
  }

  /// Completar cita
  Future<void> completeAppointment(String id) async {
    await _updateAppointmentStatus(id, 'COMPLETED', paid: true);
  }

  /// Cancelar cita
  Future<void> cancelAppointment(String id) async {
    await _updateAppointmentStatus(id, 'CANCELLED');
  }

  Future<void> _updateAppointmentStatus(
    String id,
    String status, {
    bool? paid,
  }) async {
    emit(SpaAppointmentLoading());
    try {
      await _repository.updateAppointmentStatus(id, status, paid: paid);
      emit(SpaAppointmentSuccess('Appointment $status successfully'));
      await loadAppointments();
    } catch (e) {
      emit(SpaAppointmentError('Failed to update appointment: $e'));
    }
  }
}
