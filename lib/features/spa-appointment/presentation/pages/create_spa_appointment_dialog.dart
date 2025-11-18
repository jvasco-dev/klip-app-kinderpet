// lib/features/spa/presentation/widgets/create_spa_appointment_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kinder_pet/core/config/theme.dart';
import 'package:kinder_pet/features/spa-appointment/cubit/spa_appointment_cubit.dart';
import 'package:kinder_pet/features/spa-appointment/data/models/spa_appointment_model.dart';

class CreateSpaAppointmentDialog extends StatefulWidget {
  final DateTime selectedDate;
  const CreateSpaAppointmentDialog({super.key, required this.selectedDate});

  @override
  State<CreateSpaAppointmentDialog> createState() =>
      _CreateSpaAppointmentDialogState();
}

class _CreateSpaAppointmentDialogState
    extends State<CreateSpaAppointmentDialog> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para capturar los valores reales
  final _petNameController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _petNameController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat(
      'd MMMM yyyy',
      'es',
    ).format(widget.selectedDate);

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.lightBeigeAccent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(
                  Icons.pets_outlined,
                  color: AppColors.dogOrange,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nueva cita",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.brownText,
                        ),
                      ),
                      Text(
                        dateFormatted,
                        style: const TextStyle(color: AppColors.warmBrown),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 1. Nombre de la mascota
            TextFormField(
              controller: _petNameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: "Nombre de la mascota",
                prefixIcon: const Icon(Icons.pets, color: AppColors.dogOrange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: "Ej: Benji, Luna, Rocky...",
              ),
              validator: (value) =>
                  value?.trim().isEmpty ?? true ? "Ingresa el nombre" : null,
            ),
            const SizedBox(height: 16),

            // 2. Monto
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Monto",
                prefixIcon: const Icon(Icons.paid, color: AppColors.dogOrange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: "Ej: 47000",
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty)
                  return "Ingresa el monto";
                if (double.tryParse(value.replaceAll('.', '').trim()) == null) {
                  return "Monto inválido";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 3. Hora
            InkWell(
              onTap: _selectTime,
              borderRadius: BorderRadius.circular(16),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: "Hora",
                  prefixIcon: const Icon(
                    Icons.access_time,
                    color: AppColors.dogOrange,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                child: Text(
                  _selectedTime?.format(context) ?? "Toca para seleccionar",
                  style: TextStyle(
                    color: _selectedTime != null
                        ? AppColors.hardText
                        : AppColors.grayNeutral,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 4. Observaciones
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Observaciones (opcional)",
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 28),

            // Botón Crear
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _createAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dogOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Crear cita",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.dogOrange),
        ),
        child: child!,
      ),
    );
    if (time != null) setState(() => _selectedTime = time);
  }

  // AQUÍ ESTÁ LA ÚNICA CORRECCIÓN QUE NECESITABAS
  void _createAppointment() {
    if (!_formKey.currentState!.validate() || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Completa todos los campos"),
          backgroundColor: AppColors.softAlert,
        ),
      );
      return;
    }

    final petName = _petNameController.text.trim();
    final amount =
        double.tryParse(_amountController.text.replaceAll('.', '').trim()) ??
        0.0;
    final notes = _notesController.text.trim().isEmpty
        ? null
        : _notesController.text.trim();

    final dateTime = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final appointment = SpaAppointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      pet: petName,
      amount: amount, // double, como tu modelo
      date: dateTime,
      status: "PENDING",
      // tu modelo lo acepta
      notes: notes,
    );

    context.read<SpaAppointmentCubit>().createAppointment(appointment);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Cita creada para $petName a las ${_selectedTime!.format(context)}",
        ),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }
}
