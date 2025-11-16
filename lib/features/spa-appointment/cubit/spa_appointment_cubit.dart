import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/features/spa-appointment/data/models/spa_appointment_model.dart';
import 'package:kinder_pet/features/spa-appointment/data/repository/spa_appointment_repository.dart';

part 'spa_appointment_state.dart';

class SpaAppointmentCubit extends Cubit<SpaAppointmentState> {
  final SpaAppointmentRepository _repository;
  SpaAppointmentCubit(this._repository) : super(SpaAppointmentInitial());

  Future<void> loadAllAppointmentsForCalendar() async {
    emit(
      SpaAppointmentLoading(
        selectedDate: state.selectedDate,
        appointments: state.appointments,
        appointmentsForSelectedDay: state.appointmentsForSelectedDay,
        appointmentsByDay: {},
      ),
    );

    try {
      final all = await _repository.getAllAppointments();
      emit(
        SpaAppointmentLoaded(
          selectedDate: state.selectedDate,
          appointments: all,
          appointmentsForSelectedDay: state.appointmentsForSelectedDay,
        ),
      );
    } catch (e) {
      emit(
        SpaAppointmentError(
          'Error: $e',
          selectedDate: state.selectedDate,
          appointments: const [],
          appointmentsByDay: {},
        ),
      );
    }
  }

  Future<void> loadAppointmentsForSelectedDay({String? date}) async {
    final dateStr =
        date ?? state.selectedDate.toIso8601String().split('T').first;
    try {
      final dayAppointments = await _repository.getAllAppointments(
        date: dateStr,
      );
      emit(
        SpaAppointmentLoaded(
          selectedDate: state.selectedDate,
          appointments: state.appointments, // ← MANTIENE las del mes
          appointmentsForSelectedDay:
              dayAppointments, // ← ACTUALIZA solo el día
        ),
      );
    } catch (e) {
      emit(
        SpaAppointmentError(
          'Error día: $e',
          selectedDate: state.selectedDate,
          appointments: state.appointments,
          appointmentsByDay: {},
        ),
      );
    }
  }

  Future<void> selectDate(DateTime date) async {
    emit(
      SpaAppointmentLoading(
        selectedDate: date,
        appointments: state.appointments,
        appointmentsForSelectedDay: state.appointmentsForSelectedDay,
        appointmentsByDay: {},
      ),
    );
    await loadAppointmentsForSelectedDay(
      date: date.toIso8601String().split('T').first,
    );
  }

  Future<void> loadCurrentSelectedDayAppointments() async {
    await loadAppointmentsForSelectedDay();
  }

  // create, update, status → recargan todo correctamente
  Future<void> createAppointment(SpaAppointment appointment) async {
    // ... crear ...
    await loadAllAppointmentsForCalendar();
  }

  Future<void> updateAppointment(SpaAppointment updated) async {
    // ... actualizar ...
    await loadAllAppointmentsForCalendar();
  }

  Future<void> _updateAppointmentStatus(String id, String status) async {
    // ... cambiar estado ...
    await loadAllAppointmentsForCalendar();
  }
}
