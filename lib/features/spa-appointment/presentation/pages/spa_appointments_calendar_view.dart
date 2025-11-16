import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/features/spa-appointment/cubit/spa_appointment_cubit.dart';
import 'package:kinder_pet/features/spa-appointment/presentation/pages/spa_day_appointments_screen.dart';
import 'package:kinder_pet/features/spa-appointment/presentation/widgets/custom_spa_calendar.dart';

class SpaAppointmentsCalendarView extends StatefulWidget {
  const SpaAppointmentsCalendarView({super.key});

  @override
  State<SpaAppointmentsCalendarView> createState() =>
      _SpaAppointmentsCalendarViewState();
}

class _SpaAppointmentsCalendarViewState
    extends State<SpaAppointmentsCalendarView> {
  @override
  void initState() {
    super.initState();
    context.read<SpaAppointmentCubit>().loadCurrentSelectedDayAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpaAppointmentCubit, SpaAppointmentState>(
      builder: (context, state) {
        final selected = state.selectedDate;

        // ---------------------------
        // Construir appointmentsByDay
        // ---------------------------
        final Map<String, int> appointmentsByDay = {};
        try {
          for (final a in state.appointments) {
            // clave en formato yyyy-M-d o yyyy-MM-dd (consistente con tu backend)
            final key = a.date.toIso8601String().split('T').first;
            appointmentsByDay[key] = (appointmentsByDay[key] ?? 0) + 1;
          }
        } catch (_) {
          // Si state.appointments no existe o viene null, se queda vacío
        }

        return Column(
          children: [
            Expanded(
              child: CustomSpaCalendar(
                selectedDate: selected,
                appointmentsByDay: appointmentsByDay,
                onDaySelected: (date) {
                  context.read<SpaAppointmentCubit>().selectDate(date);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SpaDayAppointmentsScreen(date: date),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
