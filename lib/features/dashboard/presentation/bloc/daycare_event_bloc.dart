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
    emit(DaycareEventLoading());

    try {
      final daycare = await daycareRepository.getActiveDaycareByPetId(
        event.petId,
      );

    debugPrint(daycare.id);

      await daycareEventRepository.createDaycareEvent(daycare.id);

      emit(DaycareEventSuccess());
      add(FetchDaycareEvents());
    } catch (e) {
      emit(DaycareEventError(e.toString()));
    }
  }

  Future<void> _onFetchEvents(
    FetchDaycareEvents event,
    Emitter<DaycareEventState> emit,
  ) async {
    emit(DaycareEventLoading());
    try {
      final events = await daycareEventRepository.getInProgressEvents();
      if (events.isEmpty) {
        emit(DaycareEventEmpty());
      } else {
        emit(DaycareEventLoaded(events));
      }
    } catch (e) {
      emit(DaycareEventError(e.toString()));
    }
  }


  Future<void> _onEndEvent(
    EndDaycareEvent event,
    Emitter<DaycareEventState> emit,
  ) async {
    try {
      await daycareEventRepository.endDaycareEvent(event.eventId);

      final updatedEvents = await daycareEventRepository.getInProgressEvents();
      emit(DaycareEventLoaded(updatedEvents));
    } catch (e) {
      emit(DaycareEventError('Failed to end event: $e'));
    }
  }
}
