// spa_day_appointments_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/core/config/theme.dart';
import 'package:kinder_pet/features/spa-appointment/cubit/spa_appointment_cubit.dart';
import 'package:kinder_pet/features/spa-appointment/data/models/spa_appointment_model.dart';
import 'package:kinder_pet/features/spa-appointment/presentation/pages/create_spa_appointment_dialog.dart';

class SpaDayAppointmentsScreen extends StatefulWidget {
  final DateTime date;
  const SpaDayAppointmentsScreen({super.key, required this.date});

  @override
  State<SpaDayAppointmentsScreen> createState() =>
      _SpaDayAppointmentsScreenState();
}

class _SpaDayAppointmentsScreenState extends State<SpaDayAppointmentsScreen> {
  @override
  void initState() {
    super.initState();
    // Cargamos las citas del día seleccionado
    context.read<SpaAppointmentCubit>().selectDate(widget.date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Citas del ${widget.date.day}/${widget.date.month}/${widget.date.year}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.warmBeige,
        foregroundColor: AppColors.brownText,
      ),

      body: BlocBuilder<SpaAppointmentCubit, SpaAppointmentState>(
        builder: (context, state) {
          final appointments = state.appointmentsForSelectedDay;

          if (state is SpaAppointmentLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.dogOrange),
            );
          }

          if (appointments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, size: 80, color: AppColors.grayNeutral),
                  const SizedBox(height: 16),
                  Text(
                    "No hay citas para este día",
                    style: TextStyle(fontSize: 18, color: AppColors.warmBrown),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "¡Programa la primera!",
                    style: TextStyle(color: AppColors.goldenTan),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return _buildAppointmentCard(appointment);
            },
          );
        },
      ),

      // FAB PERFECTO: solo aparece en el día específico
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: CreateSpaAppointmentDialog(selectedDate: widget.date),
            ),
          );
        },
        backgroundColor: AppColors.dogOrange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          "Nueva cita",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildAppointmentCard(SpaAppointment item) {
    final hour = item.date.hour.toString().padLeft(2, '0');
    final minute = item.date.minute.toString().padLeft(2, '0');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.lightDogOrange,
          backgroundImage:  null,
          child: null,
        ),
        title: Text(
          item.pet,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("$hour:$minute"),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: item.status == "COMPLETED"
                ? AppColors.successGreen.withOpacity(0.2)
                : AppColors.warningAmber.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            item.status,
            style: TextStyle(
              color: item.status == "COMPLETED"
                  ? AppColors.successGreen
                  : AppColors.warningAmber,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
  
}

