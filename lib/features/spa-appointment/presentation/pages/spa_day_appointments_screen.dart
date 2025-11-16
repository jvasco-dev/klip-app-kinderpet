// spa_day_appointments_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/features/spa-appointment/cubit/spa_appointment_cubit.dart';
import 'package:kinder_pet/features/spa-appointment/data/models/spa_appointment_model.dart';

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

    // Cargar las citas del día
    context.read<SpaAppointmentCubit>().selectDate(widget.date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Citas Spa - ${widget.date.toString().split(' ').first}"),
      ),
      body: BlocBuilder<SpaAppointmentCubit, SpaAppointmentState>(
        builder: (context, state) {
          // ⛔ Corrección: eliminar state.isInitial
          if (state is SpaAppointmentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SpaAppointmentError) {
            return Center(child: Text(state.message));
          }

          final appointments = state.appointments;

          if (appointments.isEmpty) {
            return const Center(child: Text("No hay citas para este día."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            itemBuilder: (_, index) {
              return _appointmentCard(appointments[index]);
            },
          );
        },
      ),
    );
  }

  // ⛔ Corrección: el método fue eliminado y era requerido por la UI
Widget _appointmentCard(SpaAppointment item) {
    final hour = item.date.hour.toString().padLeft(2, '0');
    final minute = item.date.minute.toString().padLeft(2, '0');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: item.pet?.photo != null
              ? NetworkImage(item.pet!.photo!)
              : null,
          child: item.pet?.photo == null ? const Icon(Icons.pets) : null,
        ),
        title: Text(item.pet?.name ?? "Mascota"),
        subtitle: Text("Hora: $hour:$minute\nEstado: ${item.status}"),
        trailing: Text(item.service),
      ),
    );
  }
}
