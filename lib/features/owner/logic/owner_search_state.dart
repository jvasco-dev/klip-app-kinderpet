part of 'owner_search_cubit.dart';

abstract class OwnerSearchState {
  const OwnerSearchState();
}

class OwnerSearchInitial extends OwnerSearchState {}

class OwnerSearchLoading extends OwnerSearchState {}

class OwnerSearchSuccess extends OwnerSearchState {
  final List<Owner> owners;
  const OwnerSearchSuccess(this.owners);
}

class OwnerSearchEmpty extends OwnerSearchState {
  final String message;
  const OwnerSearchEmpty(this.message);
}

class OwnerSearchError extends OwnerSearchState {
  final String message;
  const OwnerSearchError(this.message);
}
