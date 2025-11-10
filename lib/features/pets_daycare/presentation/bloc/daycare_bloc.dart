import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/features/pets_daycare/data/models/daycare_model.dart';
import 'package:kinder_pet/features/pets_daycare/data/repository/daycare_repository.dart';

part 'daycare_event.dart';
part 'daycare_state.dart';

class DaycareBloc extends Bloc<DaycareEvent, DaycareState> {
  final DaycareRepository daycareRepository;

  DaycareBloc(this.daycareRepository) : super(DaycareInitial()) {
    on<FetchDaycare>(_onFetchDaycare);
  }

  Future<void> _onFetchDaycare(
    FetchDaycare event,
    Emitter<DaycareState> emit,
  ) async {
    emit(DaycareLoading());

    try {
      final events = await this.daycareRepository.getAllDaycareInProgress();

      if (events.isEmpty) {
        emit(DaycareEmpty());
      } else {
        emit(DaycareLoaded(events));
      }
    } catch (e) {
      emit(DaycareError(e.toString()));
    }
  }
}
