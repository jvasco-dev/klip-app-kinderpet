
part of 'daycare_bloc.dart';

abstract class DaycareEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchDaycare extends DaycareEvent {}

