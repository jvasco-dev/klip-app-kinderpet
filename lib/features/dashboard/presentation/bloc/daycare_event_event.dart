
part of 'daycare_event_bloc.dart';


abstract class DaycareEventEvent extends Equatable {

  const DaycareEventEvent();

  @override
  List<Object> get props => [];

}

class FetchDaycareEvents extends DaycareEventEvent {}