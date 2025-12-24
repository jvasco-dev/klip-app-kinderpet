import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:kinder_pet/features/spa-appointment/data/models/spa_appointment_model.dart';
import 'package:kinder_pet/features/spa-appointment/data/repository/spa_appointment_repository.dart';

part 'spa_appointment_state.dart';

class SpaAppointmentCubit extends Cubit<SpaAppointmentState> {
  final SpaAppointmentRepository _repository;
  SpaAppointmentCubit(this._repository) : super(SpaAppointmentInitial()) {
    debugPrint('🔄 SpaAppointmentCubit inicializado');
  }

  Future<void> loadAllAppointmentsForCalendar() async {
    debugPrint('🔄 Cargando todas las citas para el calendario...');

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
      debugPrint('✅ Se obtuvieron ${all.length} citas totales');

      emit(
        SpaAppointmentLoaded(
          selectedDate: state.selectedDate,
          appointments: all,
          appointmentsForSelectedDay: state.appointmentsForSelectedDay,
        ),
      );
    } catch (e) {
      debugPrint('❌ Error cargando citas del calendario: $e');
      emit(
        SpaAppointmentError(
          'Error al cargar citas: $e',
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
    debugPrint('🔄 Cargando citas para el día: $dateStr');

    try {
      final dayAppointments = await _repository.getAllAppointments(
        date: dateStr,
      );
      debugPrint(
        '✅ Se obtuvieron ${dayAppointments.length} citas para el día $dateStr',
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
      debugPrint('❌ Error cargando citas del día: $e');
      emit(
        SpaAppointmentError(
          'Error al cargar citas del día: $e',
          selectedDate: state.selectedDate,
          appointments: state.appointments,
          appointmentsByDay: {},
        ),
      );
    }
  }

  Future<void> selectDate(DateTime date) async {
    debugPrint('🔄 Seleccionando fecha: ${date.toIso8601String()}');

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
    debugPrint('🔹 Creando cita: ${appointment.pet} para ${appointment.date}');
    try {
      // ... crear ...
      await loadAllAppointmentsForCalendar();
      debugPrint('✅ Cita creada y calendario recargado');
    } catch (e) {
      debugPrint('❌ Error creando cita: $e');
      rethrow;
    }
  }

  Future<void> updateAppointment(SpaAppointment updated) async {
    debugPrint('🔹 Actualizando cita: ${updated.id}');
    try {
      // ... actualizar ...
      await loadAllAppointmentsForCalendar();
      debugPrint('✅ Cita actualizada y calendario recargado');
    } catch (e) {
      debugPrint('❌ Error actualizando cita: $e');
      rethrow;
    }
  }

  Future<void> _updateAppointmentStatus(String id, String status) async {
    debugPrint('🔹 Cambiando estado de cita $id a: $status');
    try {
      // ... cambiar estado ...
      await loadAllAppointmentsForCalendar();
      debugPrint('✅ Estado de cita actualizado y calendario recargado');
    } catch (e) {
      debugPrint('❌ Error cambiando estado de cita: $e');
      rethrow;
    }
  }

  /// Método para refrescar datos cuando se navega a la vista
  Future<void> refreshOnViewAccess() async {
    debugPrint('🔄 REFRESH ON VIEW ACCESS: Iniciando refresco completo');
    debugPrint(
      '🔄 REFRESH ON VIEW ACCESS: Estado actual: ${state.runtimeType}',
    );
    debugPrint(
      '🔄 REFRESH ON VIEW ACCESS: Citas actuales: ${state.appointments.length}',
    );

    try {
      debugPrint(
        '🔄 REFRESH ON VIEW ACCESS: Llamando a loadAllAppointmentsForCalendar()',
      );
      await loadAllAppointmentsForCalendar();
      debugPrint(
        '🔄 REFRESH ON VIEW ACCESS: loadAllAppointmentsForCalendar completado',
      );

      debugPrint(
        '🔄 REFRESH ON VIEW ACCESS: Llamando a loadCurrentSelectedDayAppointments()',
      );
      await loadCurrentSelectedDayAppointments();
      debugPrint(
        '🔄 REFRESH ON VIEW ACCESS: loadCurrentSelectedDayAppointments completado',
      );

      debugPrint('🔄 REFRESH ON VIEW ACCESS: Refresco completado exitosamente');
    } catch (e) {
      debugPrint('❌ REFRESH ON VIEW ACCESS: Error durante el refresco: $e');
      rethrow;
    }
  }

  /// Método para refrescar datos cuando se navega a la vista (versión simplificada)
  Future<void> refreshOnViewAccessSimple() async {
    debugPrint('🔄 REFRESH SIMPLE: Iniciando refresco directo');

    try {
      emit(
        SpaAppointmentLoading(
          selectedDate: state.selectedDate,
          appointments: state.appointments,
          appointmentsForSelectedDay: state.appointmentsForSelectedDay,
          appointmentsByDay: {},
        ),
      );

      debugPrint('🔄 REFRESH SIMPLE: Llamando directamente al repositorio');
      final all = await _repository.getAllAppointments();
      debugPrint(
        '🔄 REFRESH SIMPLE: Se obtuvieron ${all.length} citas del repositorio',
      );

      emit(
        SpaAppointmentLoaded(
          selectedDate: state.selectedDate,
          appointments: all,
          appointmentsForSelectedDay: state.appointmentsForSelectedDay,
        ),
      );

      debugPrint('🔄 REFRESH SIMPLE: Refresco directo completado');
    } catch (e) {
      debugPrint('❌ REFRESH SIMPLE: Error: $e');
      emit(
        SpaAppointmentError(
          'Error en refresco simple: $e',
          selectedDate: state.selectedDate,
          appointments: const [],
          appointmentsByDay: {},
        ),
      );
    }
  }
}
