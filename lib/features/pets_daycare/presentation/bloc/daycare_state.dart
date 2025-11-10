part of 'daycare_bloc.dart';


abstract class DaycareState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DaycareInitial extends DaycareState {}

class DaycareLoading extends DaycareState {}

class DaycareSuccess extends DaycareState {}

class DaycareLoaded extends DaycareState {
  final List<Daycare> events;
  DaycareLoaded(this.events);

  @override
  List<Object?> get props => [events];
}

class DaycareEmpty extends DaycareState {}

class DaycareError extends DaycareState {
  final String message;
  DaycareError(this.message);

  @override
  List<Object?> get props => [message];
}
