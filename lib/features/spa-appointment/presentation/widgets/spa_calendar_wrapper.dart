import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/features/spa-appointment/cubit/spa_appointment_cubit.dart';
import 'package:kinder_pet/features/spa-appointment/data/repository/spa_appointment_repository.dart';
import 'package:kinder_pet/features/spa-appointment/presentation/pages/spa_appointments_calendar_view.dart';

class SpaCalendarWrapper extends StatelessWidget {
  final SpaAppointmentRepository spaRepository;

  const SpaCalendarWrapper({super.key, required this.spaRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SpaAppointmentCubit>(
      create: (context) =>
          SpaAppointmentCubit(spaRepository)..loadAppointments(),
      child: const SpaAppointmentsCalendarView(),
    );
  }
}
