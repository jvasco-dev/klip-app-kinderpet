import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/features/spa-appointment/cubit/spa_appointment_cubit.dart';
import 'package:kinder_pet/features/spa-appointment/data/models/spa_appointment_model.dart';

class SpaAppointmentCard extends StatelessWidget {
  final SpaAppointment appointment;

  const SpaAppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SpaAppointmentCubit>();
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appointment.serviceName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pet: ${appointment.pet?.name ?? "Unknown"}',
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              'Owner: ${appointment.owner?.firstName ?? "Unknown"}',
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              'Date: ${appointment.date.toLocal()}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(appointment.status),
                  backgroundColor: _statusColor(appointment.status),
                ),
                const Spacer(),
                if (appointment.status == 'SCHEDULED') ...[
                  IconButton(
                    icon: const Icon(Icons.done, color: Colors.green),
                    tooltip: 'Mark as completed',
                    onPressed: () => cubit.completeAppointment(appointment.id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.redAccent),
                    tooltip: 'Cancel appointment',
                    onPressed: () => cubit.cancelAppointment(appointment.id),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'COMPLETED':
        return Colors.green.withOpacity(0.2);
      case 'CANCELLED':
        return Colors.red.withOpacity(0.2);
      default:
        return Colors.orange.withOpacity(0.2);
    }
  }
}
