// lib/features/spa/presentation/pages/spa_appointments_calendar_view.dart

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
    extends State<SpaAppointmentsCalendarView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // ← Mantiene el estado del widget

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final cubit = context.read<SpaAppointmentCubit>();

    // Forzamos carga de TODAS las citas si no hay datos
    if (cubit.state.appointments.isEmpty) {
      cubit.loadAppointments();
    }

    // También cargamos las citas del día seleccionado
    cubit.loadCurrentSelectedDayAppointments();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // ← NECESARIO por AutomaticKeepAliveClientMixin

    return BlocBuilder<SpaAppointmentCubit, SpaAppointmentState>(
      // ← ESCUCHA TODOS los cambios del Cubit
      builder: (context, state) {
        final selected = state.selectedDate;

        // Construcción del mapa de citas por día
        final Map<String, int> appointmentsByDay = {};

        for (final appointment in state.appointments) {
          final key = appointment.date.toIso8601String().split('T').first;
          appointmentsByDay[key] = (appointmentsByDay[key] ?? 0) + 1;
        }

        return Column(
          children: [
            // Loading mientras carga por primera vez
            if (state is SpaAppointmentLoading && state.appointments.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),

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
