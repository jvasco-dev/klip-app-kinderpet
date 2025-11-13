import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/features/owner/data/models/owner_model.dart';
import 'package:kinder_pet/features/owner/data/repository/owner_repository.dart';

part 'owner_search_state.dart';

class OwnerSearchCubit extends Cubit<OwnerSearchState> {
  final OwnerRepository _ownerRepository;

  OwnerSearchCubit(this._ownerRepository) : super(OwnerSearchInitial());

  Future<void> searchByLastName(String lastName) async {
    emit(OwnerSearchLoading());
    try {
      final owners = await _ownerRepository.getOwnersByLastName(lastName);
      if (owners.isEmpty) {
        emit(
          const OwnerSearchEmpty('No owners found for the given last name.'),
        );
      } else {
        emit(OwnerSearchSuccess(owners));
      }
    } catch (e) {
      emit(OwnerSearchError(e.toString()));
    }
  }

  void reset() => emit(OwnerSearchInitial());
}
