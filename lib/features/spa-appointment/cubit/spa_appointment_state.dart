part of 'spa_appointment_cubit.dart';

abstract class SpaAppointmentState {
  final DateTime selectedDate;
  final List<SpaAppointment> appointments; // ← TODAS las citas del mes
  final List<SpaAppointment>
  appointmentsForSelectedDay; // ← SOLO las del día seleccionado
  final Map<String, int> appointmentsByDay;

  const SpaAppointmentState({
    required this.selectedDate,
    required this.appointments,
    this.appointmentsForSelectedDay = const [],
    required this.appointmentsByDay,
  });

  // copyWith para todos los estados
  SpaAppointmentState copyWith({
    DateTime? selectedDate,
    List<SpaAppointment>? appointments,
    List<SpaAppointment>? appointmentsForSelectedDay,
    Map<String, int>? appointmentsByDay,
  });
}

class SpaAppointmentInitial extends SpaAppointmentState {
  SpaAppointmentInitial()
    : super(
        selectedDate: DateTime.now(),
        appointments: const [],
        appointmentsForSelectedDay: const [],
        appointmentsByDay: const {},
      );

  @override
  SpaAppointmentState copyWith({
    DateTime? selectedDate,
    List<SpaAppointment>? appointments,
    List<SpaAppointment>? appointmentsForSelectedDay,
    Map<String, int>? appointmentsByDay,
  }) {
    return SpaAppointmentInitial();
  }
}

class SpaAppointmentLoading extends SpaAppointmentState {
  const SpaAppointmentLoading({
    required super.selectedDate,
    required super.appointments,
    super.appointmentsForSelectedDay,
    required super.appointmentsByDay,
  });

  @override
  SpaAppointmentState copyWith({
    DateTime? selectedDate,
    List<SpaAppointment>? appointments,
    List<SpaAppointment>? appointmentsForSelectedDay,
    Map<String, int>? appointmentsByDay,
  }) {
    return SpaAppointmentLoading(
      selectedDate: selectedDate ?? this.selectedDate,
      appointments: appointments ?? this.appointments,
      appointmentsForSelectedDay:
          appointmentsForSelectedDay ?? this.appointmentsForSelectedDay,
      appointmentsByDay: appointmentsByDay ?? this.appointmentsByDay,
    );
  }
}

class SpaAppointmentLoaded extends SpaAppointmentState {
  const SpaAppointmentLoaded({
    required super.selectedDate,
    required super.appointments,
    super.appointmentsForSelectedDay,
  }) : super(appointmentsByDay:const {});

  // Recalculamos appointmentsByDay basado en appointments
  Map<String, int> get appointmentsByDay {
    final map = <String, int>{};
    for (final app in appointments) {
      final key = "${app.date.year}-${app.date.month}-${app.date.day}";
      map[key] = (map[key] ?? 0) + 1;
    }
    return map;
  }

  @override
  SpaAppointmentState copyWith({
    DateTime? selectedDate,
    List<SpaAppointment>? appointments,
    List<SpaAppointment>? appointmentsForSelectedDay,
    Map<String, int>? appointmentsByDay,
  }) {
    return SpaAppointmentLoaded(
      selectedDate: selectedDate ?? this.selectedDate,
      appointments: appointments ?? this.appointments,
      appointmentsForSelectedDay:
          appointmentsForSelectedDay ?? this.appointmentsForSelectedDay,
    );
  }
}

class SpaAppointmentError extends SpaAppointmentState {
  final String message;
  const SpaAppointmentError(
    this.message, {
    required super.selectedDate,
    required super.appointments,
    super.appointmentsForSelectedDay,
    required super.appointmentsByDay,
  });

  @override
  SpaAppointmentState copyWith({
    DateTime? selectedDate,
    List<SpaAppointment>? appointments,
    List<SpaAppointment>? appointmentsForSelectedDay,
    Map<String, int>? appointmentsByDay,
  }) {
    return SpaAppointmentError(
      message,
      selectedDate: selectedDate ?? this.selectedDate,
      appointments: appointments ?? this.appointments,
      appointmentsForSelectedDay:
          appointmentsForSelectedDay ?? this.appointmentsForSelectedDay,
      appointmentsByDay: appointmentsByDay ?? this.appointmentsByDay,
    );
  }
}

class SpaAppointmentSuccess extends SpaAppointmentState {
  final String message;
  const SpaAppointmentSuccess(
    this.message, {
    required super.selectedDate,
    required super.appointments,
    super.appointmentsForSelectedDay,
    required super.appointmentsByDay,
  });

  @override
  SpaAppointmentState copyWith({
    DateTime? selectedDate,
    List<SpaAppointment>? appointments,
    List<SpaAppointment>? appointmentsForSelectedDay,
    Map<String, int>? appointmentsByDay,
  }) {
    return SpaAppointmentSuccess(
      message,
      selectedDate: selectedDate ?? this.selectedDate,
      appointments: appointments ?? this.appointments,
      appointmentsForSelectedDay:
          appointmentsForSelectedDay ?? this.appointmentsForSelectedDay,
      appointmentsByDay: appointmentsByDay ?? this.appointmentsByDay,
    );
  }
}
