part of 'daycare_event_bloc.dart';

abstract class DaycareEventState extends Equatable {
  const DaycareEventState();

  @override
  List<Object> get props => [];
}

class DaycareEventInitial extends DaycareEventState {}

class DaycareEventLoading extends DaycareEventState {}

class DaycareEventEmpty extends DaycareEventState {
  const DaycareEventEmpty();
}

class DaycareEventLoaded extends DaycareEventState {
  final List<DaycareEvent> events;
  const DaycareEventLoaded(this.events);

  @override
  List<Object> get props => [events];
}

class DaycareEventError extends DaycareEventState {
  final String message;
  const DaycareEventError(this.message);

  @override
  List<Object> get props => [message];
}
