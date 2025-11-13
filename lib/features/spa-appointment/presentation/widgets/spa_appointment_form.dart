import 'package:flutter/material.dart';
import 'package:kinder_pet/features/pets/data/repository/pet_repository.dart';
import 'package:kinder_pet/features/spa-appointment/data/models/spa_appointment_model.dart';
import 'package:kinder_pet/core/config/theme.dart';

class SpaAppointmentForm extends StatefulWidget {
  final PetRepository petRepository;
  final void Function(SpaAppointment) onSubmit;
  final DateTime? initialDate; // <-- nuevo campo opcional

  const SpaAppointmentForm({
    super.key,
    required this.petRepository,
    required this.onSubmit,
    this.initialDate,
  });

  @override
  State<SpaAppointmentForm> createState() => _SpaAppointmentFormState();
}

class _SpaAppointmentFormState extends State<SpaAppointmentForm> {
  final _formKey = GlobalKey<FormState>();
  final _serviceController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            controller: _serviceController,
            decoration: const InputDecoration(labelText: 'Servicio'),
            validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
          ),
          TextFormField(
            controller: _descController,
            decoration: const InputDecoration(labelText: 'Descripción'),
          ),
          TextFormField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Precio'),
            validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.dogOrange,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final appointment = SpaAppointment(
                  id: '',
                  serviceName: _serviceController.text,
                  description: _descController.text,
                  price: double.tryParse(_priceController.text) ?? 0.0,
                  date: _selectedDate!,
                  status: 'SCHEDULED',
                  paid: false,
                  owner: null,
                  pet: null,
                );
                widget.onSubmit(appointment);
              }
            },
            child: const Text('Guardar cita'),
          ),
        ],
      ),
    );
  }
}
