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
    with AutomaticKeepAliveClientMixin<SpaAppointmentsCalendarView> {
  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<SpaAppointmentCubit>();

      // Siempre recargamos TODAS las citas al entrar o volver al calendario
      cubit.loadAllAppointmentsForCalendar();

      // Y cargamos las del día seleccionado
      cubit.loadCurrentSelectedDayAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<SpaAppointmentCubit, SpaAppointmentState>(
      buildWhen: (prev, current) =>
          prev.appointments.length != current.appointments.length,
      builder: (context, state) {
        final Map<String, int> appointmentsByDay = {};
        for (final a in state.appointments) {
          final key = DateTime(
            a.date.year,
            a.date.month,
            a.date.day,
          ).toIso8601String().substring(0, 10);
          appointmentsByDay[key] = (appointmentsByDay[key] ?? 0) + 1;
        }

        return Column(
          children: [
            if (state.appointments.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Cargando citas del mes..."),
                  ],
                ),
              ),

            SizedBox(
              height:
                  420, // ← Tú eliges: 380, 400, 420, 450... (420 queda perfecto en casi todos los teléfonos)
              child: CustomSpaCalendar(
                selectedDate: state.selectedDate,
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
