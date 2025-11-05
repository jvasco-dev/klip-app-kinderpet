import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/features/dashboard/data/models/daycare_event_model.dart';
import 'package:kinder_pet/features/dashboard/data/services/daycare_event_service.dart';

part 'daycare_event_event.dart';
part 'daycare_event_state.dart';

class DaycareEventBloc extends Bloc<DaycareEventEvent, DaycareEventState> {
  final DaycareEventService daycareEventService;

  DaycareEventBloc(this.daycareEventService) : super(DaycareEventInitial()) {
    on<FetchDaycareEvents>(_onFetchDaycareEvents);
  }

  Future<void> _onFetchDaycareEvents(
    FetchDaycareEvents event,
    Emitter<DaycareEventState> emit,
  ) async {
    emit(DaycareEventLoading());
    try {
      final events = await daycareEventService.getInProgressEvents();

      if (events.isEmpty) {
        emit(const DaycareEventEmpty());
      } else {
        emit(DaycareEventLoaded(events));
      }
    } catch (e) {
      emit(DaycareEventError(e.toString()));
    }
  }
}
