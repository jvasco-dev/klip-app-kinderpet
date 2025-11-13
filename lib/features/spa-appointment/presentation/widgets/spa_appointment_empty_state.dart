import 'package:flutter/material.dart';

class SpaAppointmentEmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const SpaAppointmentEmptyState({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.spa, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No hay citas registradas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Crear nueva cita'),
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }
}
