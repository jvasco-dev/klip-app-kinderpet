import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/features/spa-appointment/data/models/spa_appointment_model.dart';
import 'package:kinder_pet/features/spa-appointment/data/repository/spa_appointment_repository.dart';

part 'spa_appointment_state.dart';

class SpaAppointmentCubit extends Cubit<SpaAppointmentState> {
  final SpaAppointmentRepository _repository;

  SpaAppointmentCubit(this._repository) : super(SpaAppointmentInitial());

  // -------------------------------------------------------------
  //  Selección de fecha desde el calendario
  // -------------------------------------------------------------

  Future<void> selectDate(DateTime date) async {
    emit(
      SpaAppointmentLoading(
        selectedDate: date,
        appointments: state.appointments, appointmentsByDay: {},
      ),
    );

    await loadAppointments(date: date.toIso8601String().split('T').first);
  }

  // -------------------------------------------------------------
  //  Carga inicial del día actual (usado en initState del calendario)
  // -------------------------------------------------------------

  Future<void> loadCurrentSelectedDayAppointments() async {
    final dateStr = state.selectedDate.toIso8601String().split('T').first;
    await loadAppointments(date: dateStr);
  }

  // -------------------------------------------------------------
  //  Cargar citas desde el backend (solo por fecha)
  // -------------------------------------------------------------

  Future<void> loadAppointments({String? date}) async {
    emit(
      SpaAppointmentLoading(
        selectedDate: state.selectedDate,
        appointments: state.appointments, appointmentsByDay: {},
      ),
    );

    try {
      final list = await _repository.getAllAppointments(date: date);

      emit(
        SpaAppointmentLoaded(
          selectedDate: state.selectedDate,
          appointments: list,
        ),
      );
    } catch (e) {
      emit(
        SpaAppointmentError(
          'Failed to load appointments: ${e.toString()}',
          selectedDate: state.selectedDate,
          appointments: state.appointments, appointmentsByDay: {},
        ),
      );
    }
  }

  // -------------------------------------------------------------
  //  Actualizar cita
  // -------------------------------------------------------------

  Future<void> updateAppointment(SpaAppointment updatedAppointment) async {
    emit(
      SpaAppointmentLoading(
        selectedDate: state.selectedDate,
        appointments: state.appointments, appointmentsByDay: {},
      ),
    );

    try {
      final data = updatedAppointment.toJson();

      final updated = await _repository.updateAppointment(
        updatedAppointment.id,
        data,
      );

      emit(
        SpaAppointmentSuccess(
          'Appointment updated successfully',
          selectedDate: state.selectedDate,
          appointments: state.appointments, appointmentsByDay: {},
        ),
      );

      await loadAppointments(
        date: updated.date.toIso8601String().split('T').first,
      );
    } catch (e) {
      emit(
        SpaAppointmentError(
          'Failed to update appointment: ${e.toString()}',
          selectedDate: state.selectedDate,
          appointments: state.appointments, appointmentsByDay: {},
        ),
      );
    }
  }

  // -------------------------------------------------------------
  //  Crear cita
  // -------------------------------------------------------------

  Future<void> createAppointment(SpaAppointment appointment) async {
    emit(
      SpaAppointmentLoading(
        selectedDate: state.selectedDate,
        appointments: state.appointments, appointmentsByDay: {},
      ),
    );

    try {
      await _repository.createAppointment(appointment);

      emit(
        SpaAppointmentSuccess(
          'Appointment created successfully',
          selectedDate: state.selectedDate,
          appointments: state.appointments, appointmentsByDay: {},
        ),
      );

      await loadAppointments(
        date: appointment.date.toIso8601String().split('T').first,
      );
    } catch (e) {
      emit(
        SpaAppointmentError(
          'Failed to create appointment: ${e.toString()}',
          selectedDate: state.selectedDate,
          appointments: state.appointments, appointmentsByDay: {},
        ),
      );
    }
  }

  // -------------------------------------------------------------
  //  Cambiar estado de cita
  // -------------------------------------------------------------

  Future<void> completeAppointment(String id) async {
    await _updateAppointmentStatus(id, 'COMPLETED');
  }

  Future<void> cancelAppointment(String id) async {
    await _updateAppointmentStatus(id, 'CANCELLED');
  }

  Future<void> _updateAppointmentStatus(String id, String status) async {
    emit(
      SpaAppointmentLoading(
        selectedDate: state.selectedDate,
        appointments: state.appointments, appointmentsByDay: {},
      ),
    );

    try {
      await _repository.updateAppointmentStatus(id, status);

      emit(
        SpaAppointmentSuccess(
          'Appointment status changed to $status',
          selectedDate: state.selectedDate,
          appointments: state.appointments, appointmentsByDay: {},
        ),
      );

      await loadAppointments(
        date: state.selectedDate.toIso8601String().split('T').first,
      );
    } catch (e) {
      emit(
        SpaAppointmentError(
          'Failed to update status to $status: ${e.toString()}',
          selectedDate: state.selectedDate,
          appointments: state.appointments, appointmentsByDay: {},
        ),
      );
    }
  }
}
