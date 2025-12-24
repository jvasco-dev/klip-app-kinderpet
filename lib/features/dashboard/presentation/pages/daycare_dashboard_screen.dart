import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/core/config/theme.dart';
import 'package:kinder_pet/core/utils/date_formatter.dart';
import 'package:kinder_pet/features/dashboard/presentation/bloc/daycare_event_bloc.dart';
import 'package:kinder_pet/features/dashboard/data/models/daycare_event_model.dart';
import 'package:kinder_pet/features/pets_daycare/presentation/cubit/navigation_cubit.dart';
import 'package:kinder_pet/shared/widgets/common_daycare_event_card.dart';
import 'package:kinder_pet/shared/widgets/index.dart';
import 'package:kinder_pet/features/dashboard/presentation/widgets/create_event_button_widget.dart';

class DaycareDashboardScreen extends StatefulWidget {
  const DaycareDashboardScreen({super.key});

  @override
  State<DaycareDashboardScreen> createState() => _DaycareDashboardScreenState();
}

class _DaycareDashboardScreenState extends State<DaycareDashboardScreen>
    with WidgetsBindingObserver {
  bool _isInitialized = false;
  DaycareTab? _lastKnownTab;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    debugPrint('🔄 DaycareDashboardScreen: initState() llamado');

    // Refrescar datos después de que el widget esté completamente inicializado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        debugPrint('🔄 DaycareDashboardScreen: Refrescando datos en initState');
        _refreshData(context);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    debugPrint('🔄 DaycareDashboardScreen: dispose() llamado');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint('🔄 DaycareDashboardScreen: Cambio de ciclo de vida: $state');

    // Refrescar datos cuando la app vuelve al primer plano
    if (state == AppLifecycleState.resumed && mounted) {
      debugPrint('🔄 DaycareDashboardScreen: App reanudada, refrescando datos');
      _refreshData(context);
    }
  }

  void _onNavigationTabChanged(DaycareTab currentTab) {
    debugPrint('🔄 DaycareDashboardScreen: Tab cambiada a: $currentTab');

    // Refrescar datos cuando volvemos al tab del dashboard
    if (currentTab == DaycareTab.dashboard &&
        _lastKnownTab != DaycareTab.dashboard &&
        mounted) {
      debugPrint(
        '🔄 DaycareDashboardScreen: Volviendo al dashboard, refrescando datos',
      );
      _refreshData(context);
    }

    _lastKnownTab = currentTab;
  }

  Future<void> _refreshData(BuildContext context) async {
    debugPrint('🔄 Iniciando refresco de datos del dashboard...');
    try {
      context.read<DaycareEventBloc>().add(FetchDaycareEvents());
      debugPrint('✅ Evento FetchDaycareEvents enviado al BLoC');
    } catch (e) {
      debugPrint('❌ Error durante el refresco: $e');
      rethrow;
    }
  }

  void _showEndEventConfirmationDialog(
    BuildContext context,
    DaycareEvent event,
  ) {
    debugPrint('🔔 Mostrando diálogo de confirmación para evento: ${event.id}');
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Finalización'),
          content: Text(
            '¿Estás seguro de que deseas finalizar el evento de ${event.pet.name}?\n\nEsta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                debugPrint('❌ Usuario canceló la finalización del evento');
                Navigator.of(
                  dialogContext,
                ).pop(); // Cerrar diálogo sin hacer nada
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                debugPrint('✅ Usuario confirmó la finalización del evento');
                Navigator.of(dialogContext).pop(); // Cerrar diálogo
                // Ejecutar la acción de finalizar evento
                context.read<DaycareEventBloc>().add(EndDaycareEvent(event.id));
              },
              child: const Text(
                'Confirmar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      drawer: const CommonDrawer(),
      body: SafeArea(
        child: BlocListener<NavigationCubit, DaycareTab>(
          listener: (context, currentTab) {
            _onNavigationTabChanged(currentTab);
          },
          child: Builder(
            // 👈 ESTE Builder crea un nuevo contexto seguro
            builder: (context) {
              return BlocBuilder<DaycareEventBloc, DaycareEventState>(
                builder: (context, state) {
                  debugPrint('🔄 Estado actual del BLoC: ${state.runtimeType}');

                  if (state is DaycareEventLoading) {
                    debugPrint('⏳ Mostrando indicador de carga...');
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Cargando datos...'),
                        ],
                      ),
                    );
                  }

                  if (state is DaycareEventEmpty) {
                    debugPrint('📭 Mostrando estado vacío');
                    return RefreshIndicator(
                      onRefresh: () => _refreshData(context),
                      child: ListView(
                        children: const [
                          SizedBox(height: 100),
                          Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.pets_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No hay mascotas en guardería',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Desliza hacia abajo para actualizar',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is DaycareEventError) {
                    debugPrint('❌ Mostrando estado de error: ${state.message}');
                    return RefreshIndicator(
                      onRefresh: () => _refreshData(context),
                      child: ListView(
                        children: [
                          SizedBox(height: 100),
                          Center(
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Error: ${state.message}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Desliza hacia abajo para reintentar',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is DaycareEventLoaded) {
                    debugPrint(
                      '✅ Mostrando ${state.events.length} eventos cargados',
                    );
                    return RefreshIndicator(
                      onRefresh: () => _refreshData(context),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.events.length,
                        itemBuilder: (context, index) {
                          final event = state.events[index];
                          final pet = event.pet;

                          return CommonDaycareEventCard(
                            title: pet.name,
                            subtitle: formatDateToColombia(event.startDate),
                            imagePath: 'assets/pets/luna.png',
                            onTap: () {
                              debugPrint(
                                '🔹 Usuario presionó tarjeta del evento: ${event.id}',
                              );
                              _showEndEventConfirmationDialog(context, event);
                            },
                          );
                        },
                      ),
                    );
                  }

                  debugPrint('⚠️ Estado no manejado: ${state.runtimeType}');
                  return const SizedBox.shrink();
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: Builder(
        // 👈 ESTE Builder garantiza acceso al Bloc
        builder: (context) {
          return const CreateDaycareEventButton();
        },
      ),
    );
  }
}
