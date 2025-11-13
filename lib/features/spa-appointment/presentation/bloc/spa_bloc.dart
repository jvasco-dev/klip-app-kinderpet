/* import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/features/spa-appointment/data/models/spa_appointment_model.dart';
import 'package:kinder_pet/features/spa-appointment/data/repository/spa_appointment_repository.dart';

part 'spa_event.dart';
part 'spa_state.dart';

class SpaBloc extends Bloc<SpaEvent, SpaState> {
  final SpaRepository _spaRepository;

  SpaBloc(this._spaRepository) : super(SpaInitial()) {
    on<LoadSpaAppointments>(_onLoadSpaAppointments);
    on<CreateSpaAppointment>(_onCreateSpaAppointment);
    on<CancelSpaAppointment>(_onCancelSpaAppointment);
    on<CompleteSpaAppointment>(_onCompleteSpaAppointment);
  }

  Future<void> _onLoadSpaAppointments(
    LoadSpaAppointments event,
    Emitter<SpaState> emit,
  ) async {
    emit(SpaLoading());
    try {
      final appointments = await _spaRepository.getAllSpaAppointments(
        date: event.date,
        status: event.status,
      );
      emit(SpaLoaded(appointments));
    } catch (e) {
      emit(SpaError(e.toString()));
    }
  }

  Future<void> _onCreateSpaAppointment(
    CreateSpaAppointment event,
    Emitter<SpaState> emit,
  ) async {
    emit(SpaLoading());
    try {
      final spa = await _spaRepository.createSpaAppointment(event.spa);
      emit(SpaSuccess('Spa appointment created successfully!'));
      // Se puede recargar la lista si se desea:
      final appointments = await _spaRepository.getAllSpaAppointments();
      emit(SpaLoaded(appointments));
    } catch (e) {
      emit(SpaError('Failed to create Spa appointment: $e'));
    }
  }

  Future<void> _onCancelSpaAppointment(
    CancelSpaAppointment event,
    Emitter<SpaState> emit,
  ) async {
    emit(SpaLoading());
    try {
      await _spaRepository.cancelSpaAppointment(event.spaId);
      emit(SpaSuccess('Spa appointment cancelled successfully!'));
      final appointments = await _spaRepository.getAllSpaAppointments();
      emit(SpaLoaded(appointments));
    } catch (e) {
      emit(SpaError('Failed to cancel Spa appointment: $e'));
    }
  }

  Future<void> _onCompleteSpaAppointment(
    CompleteSpaAppointment event,
    Emitter<SpaState> emit,
  ) async {
    emit(SpaLoading());
    try {
      await _spaRepository.completeSpaAppointment(event.spaId, event.paid);
      emit(SpaSuccess('Spa appointment completed successfully!'));
      final appointments = await _spaRepository.getAllSpaAppointments();
      emit(SpaLoaded(appointments));
    } catch (e) {
      emit(SpaError('Failed to complete Spa appointment: $e'));
    }
  }
}
 */