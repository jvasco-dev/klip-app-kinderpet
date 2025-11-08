part of 'daycare_event_bloc.dart';

abstract class DaycareEventState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DaycareEventInitial extends DaycareEventState {}

class DaycareEventLoading extends DaycareEventState {}

class DaycareEventSuccess extends DaycareEventState {}

class DaycareEventLoaded extends DaycareEventState {
  final List<DaycareEvent> events;
  DaycareEventLoaded(this.events);

  @override
  List<Object?> get props => [events];
}

class DaycareEventEmpty extends DaycareEventState {}

class DaycareEventError extends DaycareEventState {
  final String message;
  DaycareEventError(this.message);

  @override
  List<Object?> get props => [message];
}
