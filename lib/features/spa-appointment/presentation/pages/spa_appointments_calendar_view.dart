// lib/features/spa/presentation/pages/spa_appointments_calendar_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/features/spa-appointment/cubit/spa_appointment_cubit.dart';
import 'package:kinder_pet/features/spa-appointment/presentation/pages/spa_day_appointments_screen.dart';
import 'package:kinder_pet/features/spa-appointment/presentation/widgets/custom_spa_calendar.dart';

class SpaAppointmentsCalendarView extends StatefulWidget {
  const SpaAppointmentsCalendarView({super.key});

  @override
  State<SpaAppointmentsCalendarView> createState() =>
      _SpaAppointmentsCalendarViewState();
}

class _SpaAppointmentsCalendarViewState
    extends State<SpaAppointmentsCalendarView>
    with AutomaticKeepAliveClientMixin<SpaAppointmentsCalendarView> {
  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('🔄 SpaAppointmentsCalendarView: didChangeDependencies llamado');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<SpaAppointmentCubit>();
      debugPrint('🔄 Refrescando citas al acceder a la vista del calendario');

      // Siempre recargamos TODAS las citas al entrar o volver al calendario
      cubit.refreshOnViewAccess();
    });
  }

  @override
  void didUpdateWidget(SpaAppointmentsCalendarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint('🔄 SpaAppointmentsCalendarView: didUpdateWidget llamado');

    // Refrescar datos cuando el widget se actualiza (por ejemplo, al volver a la vista)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final cubit = context.read<SpaAppointmentCubit>();
        debugPrint('🔄 Refrescando citas en didUpdateWidget');
        cubit.refreshOnViewAccess();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    debugPrint('🔄 SpaAppointmentsCalendarView: initState() llamado');

    // Refrescar inicial después de la construcción
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final cubit = context.read<SpaAppointmentCubit>();
        debugPrint('🔄 Refrescando citas en initState de la vista');
        cubit.refreshOnViewAccess();
      }
    });
  }

  // Añadir un método público para refrescar manualmente
  void forceRefresh() {
    debugPrint('🔄 SpaAppointmentsCalendarView: Force refresh solicitado');
    final cubit = context.read<SpaAppointmentCubit>();
    cubit.refreshOnViewAccess();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    debugPrint('🔄 Construyendo SpaAppointmentsCalendarView');

    return BlocBuilder<SpaAppointmentCubit, SpaAppointmentState>(
      builder: (context, state) {
        debugPrint(
          '🔄 Estado actual del SpaAppointmentCubit: ${state.runtimeType}',
        );

        // Manejar estados de carga
        if (state is SpaAppointmentLoading) {
          debugPrint('⏳ Mostrando estado de carga en calendario');
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        "Cargando citas del mes...",
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        // Manejar estados de error
        if (state is SpaAppointmentError) {
          debugPrint(
            '❌ Mostrando estado de error en calendario: ${state.message}',
          );
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${state.message}',
                        style: const TextStyle(fontSize: 16, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          debugPrint('🔄 Usuario solicitó reintentar carga');
                          context
                              .read<SpaAppointmentCubit>()
                              .refreshOnViewAccess();
                        },
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        // Calcular appointmentsByDay para el calendario
        final Map<String, int> appointmentsByDay = {};
        final now = DateTime.now();
        final currentMonth = now.month;
        final currentYear = now.year;

        // Filtrar citas solo del mes actual para el conteo
        int currentMonthAppointmentsCount = 0;
        for (final a in state.appointments) {
          final key = "${a.date.year}-${a.date.month}-${a.date.day}";
          appointmentsByDay[key] = (appointmentsByDay[key] ?? 0) + 1;

          // Contar solo las del mes actual
          if (a.date.year == currentYear && a.date.month == currentMonth) {
            currentMonthAppointmentsCount++;
          }
        }

        debugPrint(
          '📊 Total de citas en el calendario: ${state.appointments.length}',
        );
        debugPrint(
          '📊 Citas del mes actual ($currentMonth/$currentYear): $currentMonthAppointmentsCount',
        );

        return Column(
          children: [
            // Indicador de estado o mensaje informativo
            if (state.appointments.isEmpty && state is! SpaAppointmentLoading)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No hay citas programadas',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Las citas aparecerán aquí cuando se programen',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              Column(
                children: [
                  // Información del mes actual
                  if (currentMonthAppointmentsCount > 0)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$currentMonthAppointmentsCount citas este mes',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // Calendario
                  SizedBox(
                    height:
                        420, // ← Tú eliges: 380, 400, 420, 450... (420 queda perfecto en casi todos los teléfonos)
                    child: CustomSpaCalendar(
                      selectedDate: state.selectedDate,
                      appointmentsByDay: appointmentsByDay,
                      onDaySelected: (date) {
                        debugPrint(
                          '🔹 Usuario seleccionó fecha: ${date.toIso8601String()}',
                        );

                        // Verificar si hay citas para el día seleccionado
                        final key = "${date.year}-${date.month}-${date.day}";
                        final count = appointmentsByDay[key] ?? 0;

                        if (count > 0) {
                          debugPrint('📅 Navegando a día con $count citas');
                          context.read<SpaAppointmentCubit>().selectDate(date);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SpaDayAppointmentsScreen(date: date),
                            ),
                          );
                        } else {
                          debugPrint(
                            '📅 Día seleccionado sin citas, mostrando snackbar',
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'No hay citas programadas para este día',
                              ),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
