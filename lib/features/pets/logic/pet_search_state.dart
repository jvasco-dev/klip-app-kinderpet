part of 'pet_search_cubit.dart';

abstract class PetSearchState {
  const PetSearchState();
}

class PetSearchInitial extends PetSearchState {}

class PetSearchLoading extends PetSearchState {}

class PetSearchSuccess extends PetSearchState {
  final List<Pet> pets;
  const PetSearchSuccess(this.pets);
}

class PetSearchEmpty extends PetSearchState {
  final String message;
  const PetSearchEmpty(this.message);
}

class PetSearchError extends PetSearchState {
  final String message;
  const PetSearchError(this.message);
}
