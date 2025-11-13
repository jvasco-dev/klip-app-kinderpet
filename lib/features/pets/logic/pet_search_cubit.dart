import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/features/pets/data/models/pet_model.dart';
import 'package:kinder_pet/features/pets/data/repository/pet_repository.dart';


part 'pet_search_state.dart';

class PetSearchCubit extends Cubit<PetSearchState> {
  final PetRepository _petRepository;

  PetSearchCubit(this._petRepository) : super(PetSearchInitial());

  Future<void> searchByName(String name) async {
    emit(PetSearchLoading());
    try {
      final pets = await _petRepository.searchByName(name);
      if (pets.isEmpty) {
        emit(const PetSearchEmpty('No pets found for the given name.'));
      } else {
        emit(PetSearchSuccess(pets));
      }
    } catch (e) {
      emit(PetSearchError(e.toString()));
    }
  }

  void reset() => emit(PetSearchInitial());
}
