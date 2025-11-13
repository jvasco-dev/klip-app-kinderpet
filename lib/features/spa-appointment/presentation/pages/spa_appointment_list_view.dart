import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/features/pets/data/repository/pet_repository.dart';
import 'package:kinder_pet/features/spa-appointment/cubit/spa_appointment_cubit.dart';
import 'package:kinder_pet/features/spa-appointment/data/models/spa_appointment_model.dart';
import 'package:kinder_pet/features/spa-appointment/presentation/widgets/spa_appointment_form.dart';
import 'package:kinder_pet/core/config/theme.dart';

class SpaAppointmentAddView extends StatefulWidget {
  final DateTime date; // <-- Agregamos este campo requerido

  const SpaAppointmentAddView({super.key, required this.date});

  @override
  State<SpaAppointmentAddView> createState() => _SpaAppointmentAddViewState();
}

class _SpaAppointmentAddViewState extends State<SpaAppointmentAddView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.warmBeige,
        title: const Text(
          'Nueva cita Spa',
          style: TextStyle(color: AppColors.brownText),
        ),
        iconTheme: const IconThemeData(color: AppColors.brownText),
      ),
      backgroundColor: AppColors.warmBeige,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<SpaAppointmentCubit, SpaAppointmentState>(
          listener: (context, state) {
            if (state is SpaAppointmentSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
              Navigator.pop(context);
            } else if (state is SpaAppointmentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is SpaAppointmentLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SpaAppointmentForm(
              // Pasamos la fecha inicial al formulario
              initialDate: widget.date,
              petRepository: context.read<PetRepository>(),
              onSubmit: (SpaAppointment appointment) {
                final newAppointment = appointment.copyWith(date: widget.date);
                context.read<SpaAppointmentCubit>().createAppointment(
                  newAppointment,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
