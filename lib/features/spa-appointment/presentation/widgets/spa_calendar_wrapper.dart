import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:kinder_pet/features/pets_daycare/presentation/cubit/navigation_cubit.dart';
import 'package:kinder_pet/features/spa-appointment/cubit/spa_appointment_cubit.dart';
import 'package:kinder_pet/features/spa-appointment/data/service/spa_appointment_service.dart';
import 'package:kinder_pet/features/spa-appointment/presentation/pages/spa_appointments_calendar_view.dart';

class SpaCalendarWrapper extends StatefulWidget {
  const SpaCalendarWrapper({Key? key}) : super(key: key);

  @override
  State<SpaCalendarWrapper> createState() => _SpaCalendarWrapperState();
}

class _SpaCalendarWrapperState extends State<SpaCalendarWrapper>
    with WidgetsBindingObserver {
  DaycareTab? _lastKnownTab;
  int _refreshCount = 0;
  DateTime? _lastRefreshTime;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    debugPrint('🔄 SpaCalendarWrapper: initState() llamado');

    // Refrescar inicial después de la construcción
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _performRefresh('init_state');
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    debugPrint('🔄 SpaCalendarWrapper: dispose() llamado');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint('🔄 SpaCalendarWrapper: Cambio de ciclo de vida: $state');

    // Refrescar cuando la app vuelve al primer plano y estamos en tab spa
    if (state == AppLifecycleState.resumed && mounted) {
      final currentTab = context.read<NavigationCubit>().state;
      if (currentTab == DaycareTab.spa) {
        debugPrint(
          '🔄 SpaCalendarWrapper: App reanudada en tab spa, refrescando',
        );
        _performRefresh('app_resumed');
      }
    }
  }

  void _performRefresh(String source) {
    if (!mounted) return;

    final now = DateTime.now();
    _refreshCount++;
    _lastRefreshTime = now;

    debugPrint(
      '🔄 SpaCalendarWrapper: Refresco #$_refreshCount desde: $source a las ${now.toIso8601String()}',
    );
    debugPrint(
      '🔄 SpaCalendarWrapper: Tab actual: ${context.read<NavigationCubit>().state}',
    );

    try {
      debugPrint('🔄 SpaCalendarWrapper: Intentando refreshOnViewAccess()');
      context.read<SpaAppointmentCubit>().refreshOnViewAccess();
      debugPrint('✅ SpaCalendarWrapper: refreshOnViewAccess() completado');
    } catch (e) {
      debugPrint('❌ SpaCalendarWrapper: Error en refreshOnViewAccess(): $e');
      debugPrint(
        '🔄 SpaCalendarWrapper: Intentando refreshOnViewAccessSimple() como fallback',
      );

      try {
        context.read<SpaAppointmentCubit>().refreshOnViewAccessSimple();
        debugPrint(
          '✅ SpaCalendarWrapper: refreshOnViewAccessSimple() completado como fallback',
        );
      } catch (e2) {
        debugPrint(
          '❌ SpaCalendarWrapper: Error también en refreshOnViewAccessSimple(): $e2',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationCubit, DaycareTab>(
      listener: (context, currentTab) {
        debugPrint(
          '🔄 SpaCalendarWrapper: Tab cambiada a: $currentTab (anterior: $_lastKnownTab)',
        );
        debugPrint(
          '🔄 SpaCalendarWrapper: Refresh count: $_refreshCount, último refresco: $_lastRefreshTime',
        );

        // Refrescar datos cuando volvemos al tab de spa
        if (currentTab == DaycareTab.spa && _lastKnownTab != DaycareTab.spa) {
          debugPrint(
            '🔄 SpaCalendarWrapper: Volviendo al tab spa, programando refresco',
          );

          // Pequeño delay para asegurar que el widget esté completamente construido
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              _performRefresh('tab_change');
            }
          });
        }

        _lastKnownTab = currentTab;
      },
      child: BlocBuilder<NavigationCubit, DaycareTab>(
        builder: (context, currentTab) {
          debugPrint(
            '🔄 SpaCalendarWrapper: Construyendo con tab: $currentTab',
          );

          // Refrescar periódicamente si estamos en tab spa (cada 30 segundos como fallback)
          if (currentTab == DaycareTab.spa && mounted) {
            if (!_isInitialized) {
              _isInitialized = true;
              // Primer refresco al entrar
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  _performRefresh('first_build');
                }
              });
            }

            // Refresco periódico como fallback
            _schedulePeriodicRefresh();
          }

          return const SpaAppointmentsCalendarView();
        },
      ),
    );
  }

  void _schedulePeriodicRefresh() {
    if (!mounted) return;

    final now = DateTime.now();
    if (_lastRefreshTime != null) {
      final timeSinceLastRefresh = now.difference(_lastRefreshTime!);
      if (timeSinceLastRefresh.inSeconds >= 30) {
        debugPrint(
          '🔄 SpaCalendarWrapper: Han pasado 30 segundos, refrescando periódicamente',
        );
        _performRefresh('periodic_fallback');
      }
    }
  }
}
