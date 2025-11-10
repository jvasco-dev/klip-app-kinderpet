import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/core/config/theme.dart';
import 'package:kinder_pet/core/utils/date_formatter.dart';
import 'package:kinder_pet/features/auth/data/repositories/auth_repository.dart';
import 'package:kinder_pet/features/auth/data/services/auth_service.dart';
import 'package:kinder_pet/features/dashboard/data/repository/daycare_event_repository.dart';
import 'package:kinder_pet/features/pets_daycare/data/repository/daycare_repository.dart';
import 'package:kinder_pet/features/dashboard/data/services/daycare_event_service.dart';
import 'package:kinder_pet/features/pets_daycare/data/service/daycare_service.dart';
import 'package:kinder_pet/features/dashboard/presentation/bloc/daycare_event_bloc.dart';
import 'package:kinder_pet/shared/functions/common_show_dialog.dart';
import 'package:kinder_pet/shared/widgets/common_daycare_event_card.dart';
import 'package:kinder_pet/shared/widgets/index.dart';
import 'package:kinder_pet/features/dashboard/presentation/widgets/create_event_button_widget.dart';
import 'package:recase/recase.dart';

class DaycareDashboardScreen extends StatelessWidget {
  const DaycareDashboardScreen({super.key});

  Future<void> _refreshData(BuildContext context) async {
    context.read<DaycareEventBloc>().add(FetchDaycareEvents());
    await Future.delayed(const Duration(milliseconds: 500));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Daycare list updated successfully 🐾'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final authRepository = AuthRepository(authService);
    final daycareEventService = DaycareEventService();
    final daycareEventRepository = DaycareEventRepository(
      daycareEventService,
      authRepository,
    );
    final daycareService = DaycareService();
    final daycareRepository = DaycareRepository(daycareService, authRepository);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authService),
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: daycareEventService),
        RepositoryProvider.value(value: daycareService),
      ],
      child: BlocProvider(
        create: (_) =>
            DaycareEventBloc(daycareEventRepository, daycareRepository)
              ..add(FetchDaycareEvents()),
        child: Scaffold(
          backgroundColor: AppColors.warmBeige,
          drawer: const CommonDrawer(),
          body: SafeArea(
            child: BlocBuilder<DaycareEventBloc, DaycareEventState>(
              builder: (context, state) {
                if (state is DaycareEventLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DaycareEventEmpty) {
                  return const Center(
                    child: Text(
                      'There are no pets in daycare',
                      style: TextStyle(
                        color: AppColors.softAlert,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                } else if (state is DaycareEventError) {
                  return Center(
                    child: Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  );
                } else if (state is DaycareEventLoaded) {
                  return RefreshIndicator(
                    color: AppColors.dogOrange,
                    onRefresh: () => _refreshData(context),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: state.events.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final event = state.events[index];
                        final pet = event.pet;

                        final formattedCheckInTime = formatDateToColombia(
                          event.startDate,
                        );

                        return CommonDaycareEventCard(
                          title: ReCase(pet.name).titleCase,
                          subtitle: 'CheckInTime: $formattedCheckInTime',
                          imagePath: 'assets/pets/luna.png',
                          onTap: () {
                            commonShowDialog<DaycareEventBloc>(
                              context: context,
                              title: 'Finish Daycare Event',
                              description:
                                  'Do you want to end the daycare for ${ReCase(pet.name).titleCase}?',
                              textButtonReject: 'Cancel',
                              textButtonAccept: 'Finish',
                              onConfirm: () {
                                context.read<DaycareEventBloc>().add(
                                  EndDaycareEvent(event.id),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Daycare for ${ReCase(pet.name).titleCase} has ended 🐶',
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          floatingActionButton: const CreateDaycareEventButton(),
        ),
      ),
    );
  }
}
