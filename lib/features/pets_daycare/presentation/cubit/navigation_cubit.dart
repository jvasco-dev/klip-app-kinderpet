import 'package:flutter_bloc/flutter_bloc.dart';

enum DaycareTab { dashboard, petsDaycare, spa }

class NavigationCubit extends Cubit<DaycareTab> {
  NavigationCubit() : super(DaycareTab.dashboard);

  void selectTab(DaycareTab tab) => emit(tab);

  String get title => switch (state) {
    DaycareTab.dashboard => 'Guardería',
    DaycareTab.petsDaycare => 'Ingresar Mascota',
    DaycareTab.spa => 'Spa & Peluquería',
  };
}
