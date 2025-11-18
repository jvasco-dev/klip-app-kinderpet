import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/features/spa-appointment/cubit/spa_appointment_cubit.dart';
import 'package:kinder_pet/features/spa-appointment/data/models/spa_appointment_model.dart';

class SpaAppointmentDetailView extends StatelessWidget {
  final SpaAppointment appointment;
  const SpaAppointmentDetailView({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text("Detalle cita")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text("Mascota: ${appointment.pet}"),
            Text("Precio: \$${appointment.amount.toStringAsFixed(2)}"),
            Text("Fecha: ${appointment.date.toLocal()}"),
            Text("Estado: ${appointment.status}"),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text("Completar"),
                  onPressed: () {
                    final updated = appointment.copyWith(status: 'COMPLETED');
                    context.read<SpaAppointmentCubit>().updateAppointment(
                      updated,
                    );
                    Navigator.pop(context);
                  },
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.cancel),
                  label: const Text("Cancelar"),
                  onPressed: () {
                    /* context.read<SpaAppointmentCubit>()cancelAppointment(
                      appointment.id,
                    ); */ null;
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
