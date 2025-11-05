part of 'daycare_event_bloc.dart';

abstract class DaycareEventEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchDaycareEvents extends DaycareEventEvent {}

class EndDaycareEvent extends DaycareEventEvent {
  final String eventId;

  EndDaycareEvent(this.eventId);

  @override
  List<Object?> get props => [eventId];
}
