// spa_day_appointments_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/features/spa-appointment/cubit/spa_appointment_cubit.dart';
import 'package:kinder_pet/features/spa-appointment/data/models/spa_appointment_model.dart';
import 'package:kinder_pet/features/spa-appointment/presentation/pages/spa_appointment_add_view.dart';
import 'package:recase/recase.dart';
import 'package:kinder_pet/core/config/theme.dart';

class SpaDayAppointmentsScreen extends StatefulWidget {
  final DateTime date;

  const SpaDayAppointmentsScreen({Key? key, required this.date})
    : super(key: key);

  @override
  State<SpaDayAppointmentsScreen> createState() =>
      _SpaDayAppointmentsScreenState();
}

class _SpaDayAppointmentsScreenState extends State<SpaDayAppointmentsScreen> {
  late final String _isoDate;

  @override
  void initState() {
    super.initState();
    // Convertimos a yyyy-MM-dd para consultas al backend
    _isoDate = widget.date.toIso8601String().split('T').first;

    // Llamamos al cubit después del primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<SpaAppointmentCubit>();
      cubit.loadAppointments(date: _isoDate);
    });
  }

  void _onCreateAppointmentPressed() {
    // Navega a la vista para crear cita, proveyendo el Cubit existente
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<SpaAppointmentCubit>(),
          child: SpaAppointmentAddView(date: widget.date),
        ),
      ),
    ).then((_) {
      // Al volver, recargamos las citas para ver los cambios.
      context.read<SpaAppointmentCubit>().loadAppointments(date: _isoDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final readableDate =
        "${widget.date.day.toString().padLeft(2, '0')}/${widget.date.month.toString().padLeft(2, '0')}/${widget.date.year}";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.warmBeige,
        title: Text(
          'Citas Spa - $readableDate',
          style: const TextStyle(color: AppColors.brownText),
        ),
        iconTheme: const IconThemeData(color: AppColors.brownText),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onCreateAppointmentPressed,
        backgroundColor: AppColors.dogOrange,
        child: const Icon(Icons.add),
      ),
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<SpaAppointmentCubit, SpaAppointmentState>(
            listener: (context, state) {
              if (state is SpaAppointmentSuccess) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
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

              if (state is SpaAppointmentLoaded) {
                final List<SpaAppointment> appointments = state.appointments;

                // Filtramos por la fecha actual (aseguremos que service/ repository devuelvan por fecha si se solicita)
                final todays = appointments.where((a) {
                  final aDate = a.date.toIso8601String().split('T').first;
                  return aDate == _isoDate;
                }).toList();

                if (todays.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.event_busy,
                          size: 56,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No hay citas para $readableDate',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: todays.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final spa = todays[index];
                    return _SpaAppointmentTile(
                      appointment: spa,
                      onComplete: () async {
                        await context
                            .read<SpaAppointmentCubit>()
                            .completeAppointment(spa.id);
                      },
                      onCancel: () async {
                        await context
                            .read<SpaAppointmentCubit>()
                            .cancelAppointment(spa.id);
                      },
                    );
                  },
                );
              }

              if (state is SpaAppointmentError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _SpaAppointmentTile extends StatelessWidget {
  final SpaAppointment appointment;
  final VoidCallback onComplete;
  final VoidCallback onCancel;

  const _SpaAppointmentTile({
    Key? key,
    required this.appointment,
    required this.onComplete,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final petName = appointment.pet?.name.isNotEmpty == true
        ? ReCase(appointment.pet!.name).titleCase
        : 'Genérica';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          radius: 26,
          backgroundImage:
              appointment.pet?.photo != null &&
                  appointment.pet!.photo!.isNotEmpty
              ? NetworkImage(appointment.pet!.photo!)
              : null,
          child:
              (appointment.pet?.photo == null ||
                  appointment.pet!.photo!.isEmpty)
              ? const Icon(Icons.pets)
              : null,
        ),
        title: Text(
          '$petName — ${appointment.serviceName}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${appointment.date.toLocal().toIso8601String().split("T").last.substring(0, 5)} • ${appointment.owner != null ? "${ReCase(appointment.owner!.firstName ?? '').titleCase} ${ReCase(appointment.owner!.lastName ?? '').titleCase}" : "Sin dueño"}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (appointment.status != 'COMPLETED')
              IconButton(
                icon: const Icon(Icons.check_circle, color: Colors.green),
                tooltip: 'Marcar como completada',
                onPressed: onComplete,
              ),
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.redAccent),
              tooltip: 'Cancelar cita',
              onPressed: onCancel,
            ),
          ],
        ),
      ),
    );
  }
}
