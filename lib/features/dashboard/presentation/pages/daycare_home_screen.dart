import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/features/pets_daycare/presentation/cubit/navigation_cubit.dart';
import 'package:kinder_pet/features/spa-appointment/presentation/widgets/spa_calendar_wrapper.dart';
import 'package:kinder_pet/shared/widgets/common_drawer.dart';
import 'package:kinder_pet/features/dashboard/presentation/pages/daycare_dashboard_screen.dart';
import 'package:kinder_pet/features/pets_daycare/presentation/pages/pets_daycare_screen.dart';
import 'package:kinder_pet/shared/widgets/common_keep_alive_wrapper.dart';

class DaycareHomeScreen extends StatelessWidget {
  DaycareHomeScreen({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _pages = const [
    DaycareDashboardScreen(),
    PetsDaycareScreen(),
    SpaCalendarWrapper(), // ahora mantiene estado perfecto
  ];

  @override
  Widget build(BuildContext context) {
    final currentTab = context.watch<NavigationCubit>().state;

    return PopScope(
      canPop: false,
      onPopInvoked: (_) {
        if (currentTab != DaycareTab.dashboard) {
          context.read<NavigationCubit>().selectTab(DaycareTab.dashboard);
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const CommonDrawer(),
        appBar: AppBar(
          title: Text(context.watch<NavigationCubit>().title),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ),
        body: IndexedStack(
          index: currentTab.index,
          children: _pages
              .map((page) => KeepAliveWrapper(child: page))
              .toList(),
        ),
      ),
    );
  }
}
