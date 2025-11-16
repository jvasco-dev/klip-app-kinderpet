part of 'spa_appointment_cubit.dart';

abstract class SpaAppointmentState {
  final DateTime selectedDate;
  final List<SpaAppointment> appointments;
  final Map<String, int> appointmentsByDay;

  SpaAppointmentState({
    required this.selectedDate,
    required this.appointments,
    required this.appointmentsByDay,
  });
}

 Map<String, int> _buildAppointmentsByDay(List<SpaAppointment> appointments) {
  final map = <String, int>{};

  for (final app in appointments) {
    final key = "${app.date.year}-${app.date.month}-${app.date.day}";
    map[key] = (map[key] ?? 0) + 1;
  }
  return map;
}

class SpaAppointmentInitial extends SpaAppointmentState {
  SpaAppointmentInitial()
      : super(
          selectedDate: DateTime.now(),
          appointments: const [],
          appointmentsByDay: const {},
        );
}

class SpaAppointmentLoading extends SpaAppointmentState {
  SpaAppointmentLoading({
    required super.selectedDate,
    required super.appointments,
    required super.appointmentsByDay,
  });
}

class SpaAppointmentLoaded extends SpaAppointmentState {
  SpaAppointmentLoaded({
    required super.selectedDate,
    required super.appointments,
  }) : super(
          appointmentsByDay: _buildAppointmentsByDay(appointments),
        );
}

class SpaAppointmentError extends SpaAppointmentState {
  final String message;

  SpaAppointmentError(
    this.message, {
    required super.selectedDate,
    required super.appointments,
    required super.appointmentsByDay,
  });
}

class SpaAppointmentSuccess extends SpaAppointmentState {
  final String message;

  SpaAppointmentSuccess(
    this.message, {
    required super.selectedDate,
    required super.appointments,
    required super.appointmentsByDay,
  });
}

