import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kinder_pet/features/dashboard/data/models/daycare_event_model.dart';
import 'package:kinder_pet/features/dashboard/data/repository/daycare_event_repository.dart';
import 'package:kinder_pet/features/pets_daycare/data/repository/daycare_repository.dart';

part 'daycare_event_event.dart';
part 'daycare_event_state.dart';

class DaycareEventBloc extends Bloc<DaycareEventEvent, DaycareEventState> {
  final DaycareEventRepository daycareEventRepository;
  final DaycareRepository daycareRepository;

  /* final DaycareEventService _daycareEventService;
  DaycareEventService get daycareService => _daycareEventService; */

  DaycareEventBloc(this.daycareEventRepository, this.daycareRepository)
    : super(DaycareEventInitial()) {
    on<FetchDaycareEvents>(_onFetchEvents);
    on<EndDaycareEvent>(_onEndEvent);
    on<CreateDaycareEvent>(_onCreateEvent);
  }

  Future<void> _onCreateEvent(
    CreateDaycareEvent event,
    Emitter<DaycareEventState> emit,
  ) async {
    debugPrint('🔹 Creando evento para pet: ${event.petId}');
    emit(DaycareEventLoading());

    try {
      final daycare = await daycareRepository.getActiveDaycareByPetId(
        event.petId,
      );

      debugPrint('📋 Pet ID: ${event.petId}');
      debugPrint('🏢 Daycare ID: ${daycare.id}');

      await daycareEventRepository.createDaycareEvent(daycare.id);

      debugPrint('✅ Evento creado exitosamente');
      emit(DaycareEventSuccess());
      add(FetchDaycareEvents());
    } catch (e) {
      debugPrint('❌ Error creando evento: $e');
      emit(DaycareEventError(e.toString()));
    }
  }

  Future<void> _onFetchEvents(
    FetchDaycareEvents event,
    Emitter<DaycareEventState> emit,
  ) async {
    debugPrint('🔄 Iniciando obtención de eventos en progreso...');
    emit(DaycareEventLoading());
    try {
      final events = await daycareEventRepository.getInProgressEvents();
      debugPrint('📊 Se obtuvieron ${events.length} eventos del repositorio');

      if (events.isEmpty) {
        debugPrint('📭 No hay eventos en progreso');
        emit(DaycareEventEmpty());
      } else {
        debugPrint('✅ Eventos cargados exitosamente');
        emit(DaycareEventLoaded(events));
      }
    } catch (e) {
      debugPrint('❌ Error obteniendo eventos: $e');
      emit(DaycareEventError(e.toString()));
    }
  }

  Future<void> _onEndEvent(
    EndDaycareEvent event,
    Emitter<DaycareEventState> emit,
  ) async {
    debugPrint('🔹 Finalizando evento: ${event.eventId}');
    try {
      await daycareEventRepository.endDaycareEvent(event.eventId);
      debugPrint('✅ Evento finalizado, obteniendo eventos actualizados...');

      final updatedEvents = await daycareEventRepository.getInProgressEvents();
      debugPrint(
        '📊 Se obtuvieron ${updatedEvents.length} eventos actualizados',
      );
      emit(DaycareEventLoaded(updatedEvents));
    } catch (e) {
      debugPrint('❌ Error finalizando evento: $e');
      emit(DaycareEventError('Failed to end event: $e'));
    }
  }
}
