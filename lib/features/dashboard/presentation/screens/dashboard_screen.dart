import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/core/config/theme.dart';
import 'package:kinder_pet/features/auth/data/repositories/auth_repository.dart';
import 'package:kinder_pet/features/auth/data/services/auth_service.dart';
import 'package:kinder_pet/features/dashboard/data/services/daycare_event_service.dart';
import 'package:kinder_pet/features/dashboard/presentation/bloc/daycare_event_bloc.dart';
import 'package:kinder_pet/features/dashboard/presentation/screens/PetCard.dart';
import 'package:kinder_pet/shared/widgets/index.dart';

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
    final daycareEventService = DaycareEventService(authRepository);

    return FutureBuilder<bool>(
      future: authRepository.hasValidSession(),
      builder: (context, snapshot) {
        // Muestra loader mientras se valida sesión
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Si no hay sesión válida, redirige al login
        if (snapshot.data == false) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/signin');
          });
          return const SizedBox.shrink();
        }

        // ✅ Si hay sesión válida, carga dashboard normalmente
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: authService),
            RepositoryProvider.value(value: authRepository),
            RepositoryProvider.value(value: daycareEventService),
          ],
          child: BlocProvider(
            create: (_) =>
                DaycareEventBloc(daycareEventService)
                  ..add(FetchDaycareEvents()),
            child: Scaffold(
              backgroundColor: AppColors.warmBeige,
              drawer: const CommonDrawer(),
              appBar: AppBar(
                backgroundColor: AppColors.warmBeige,
                elevation: 0,
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: AppColors.brownText),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                centerTitle: true,
                title: const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Daycare Pets',
                    style: TextStyle(
                      color: AppColors.brownText,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                actions: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(
                        Icons.refresh,
                        color: AppColors.brownText,
                      ),
                      tooltip: 'Refresh daycare list',
                      onPressed: () {
                        context.read<DaycareEventBloc>().add(
                          FetchDaycareEvents(),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: GestureDetector(
                      onTap: () {
                        // TODO: navegar a configuración de perfil
                      },
                      child: const CircleAvatar(
                        backgroundColor: AppColors.lightBeigeAccent,
                        radius: 18,
                        child: Icon(Icons.person, color: AppColors.brownText),
                      ),
                    ),
                  ),
                ],
              ),

              // BODY
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
                      // 🌀 Pull-to-refresh
                      return RefreshIndicator(
                        color: AppColors.dogOrange,
                        onRefresh: () => _refreshData(context),
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          itemCount: state.events.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final event = state.events[index];
                            return PetCard(
                              name: event.pet.name,
                              checkInTime: event.startDate,
                              imagePath: 'assets/pets/luna.png',
                              eventId: event.id,
                              onFinish: () async {
                                final daycareService = context
                                    .read<DaycareEventBloc>()
                                    .daycareService;

                                try {
                                  await daycareService.endDaycareEvent(
                                    event.id,
                                  );
                                  // Refrescar la lista
                                  context.read<DaycareEventBloc>().add(
                                    FetchDaycareEvents(),
                                  );

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Daycare event finished successfully 🎉',
                                        ),
                                        duration: Duration(seconds: 2),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Error finishing event: $e',
                                        ),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  }
                                }
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
            ),
          ),
        );
      },
    );
  }
}
