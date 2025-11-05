import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kinder_pet/features/dashboard/data/models/daycare_event_model.dart';
import 'package:kinder_pet/features/dashboard/data/services/daycare_event_service.dart';

part 'daycare_event_event.dart';
part 'daycare_event_state.dart';

class DaycareEventBloc extends Bloc<DaycareEventEvent, DaycareEventState> {
  final DaycareEventService _daycareEventService;
  DaycareEventService get daycareService => _daycareEventService;

  DaycareEventBloc(this._daycareEventService) : super(DaycareEventInitial()) {
    on<FetchDaycareEvents>(_onFetchEvents);
    on<EndDaycareEvent>(_onEndEvent);
  }

  Future<void> _onFetchEvents(
    FetchDaycareEvents event,
    Emitter<DaycareEventState> emit,
  ) async {
    emit(DaycareEventLoading());
    try {
      final events = await _daycareEventService.getInProgressEvents();
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
      await _daycareEventService.endDaycareEvent(event.eventId);

      final updatedEvents = await _daycareEventService.getInProgressEvents();
      emit(DaycareEventLoaded(updatedEvents));
    } catch (e) {
      emit(DaycareEventError('Failed to end event: $e'));
    }
  }
}
