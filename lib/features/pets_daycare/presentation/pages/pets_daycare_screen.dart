import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/core/config/theme.dart';
import 'package:kinder_pet/features/auth/data/repositories/auth_repository.dart';
import 'package:kinder_pet/features/auth/data/services/auth_service.dart';
import 'package:kinder_pet/features/dashboard/data/repository/daycare_event_repository.dart';
import 'package:kinder_pet/features/dashboard/data/services/daycare_event_service.dart';
import 'package:kinder_pet/features/pets_daycare/data/repository/daycare_repository.dart';
import 'package:kinder_pet/features/pets_daycare/data/service/daycare_service.dart';
import 'package:kinder_pet/features/pets_daycare/presentation/bloc/daycare_bloc.dart';
import 'package:kinder_pet/features/dashboard/presentation/bloc/daycare_event_bloc.dart';
import 'package:kinder_pet/shared/widgets/common_daycare_event_card.dart';
import 'package:kinder_pet/shared/widgets/common_drawer.dart';
import 'package:kinder_pet/shared/functions/common_show_dialog.dart';
import 'package:recase/recase.dart';

class PetsDaycareScreen extends StatefulWidget {
  const PetsDaycareScreen({super.key});

  @override
  State<PetsDaycareScreen> createState() => _PetsDaycareScreenState();
}

class _PetsDaycareScreenState extends State<PetsDaycareScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        searchText = _searchController.text.toLowerCase();
      });
    });
  }

  Future<void> _refreshData(BuildContext context) async {
    context.read<DaycareBloc>().add(FetchDaycare());
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final authRepository = AuthRepository(authService);
    final daycareService = DaycareService();
    final daycareRepository = DaycareRepository(daycareService, authRepository);
    final daycareEventService = DaycareEventService();
    final daycareEventRepository = DaycareEventRepository(
      daycareEventService,
      authRepository,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DaycareBloc(daycareRepository)..add(FetchDaycare()),
        ),
        BlocProvider(
          create: (_) =>
              DaycareEventBloc(daycareEventRepository, daycareRepository),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.warmBeige,
        drawer: const CommonDrawer(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 🔍 Campo de búsqueda
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar mascota por nombre',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.brownText,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // 📋 Resultados
                Expanded(
                  child: BlocBuilder<DaycareBloc, DaycareState>(
                    builder: (context, state) {
                      if (state is DaycareLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is DaycareEmpty) {
                        return const Center(
                          child: Text(
                            'No hay mascotas para mostrar',
                            style: TextStyle(
                              color: AppColors.softAlert,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      } else if (state is DaycareError) {
                        return Center(
                          child: Text(
                            'Error: ${state.message}',
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        );
                      } else if (state is DaycareLoaded) {
                        final filtered = state.events.where((daycare) {
                          final petName = (daycare.pet?.name ?? '')
                              .toLowerCase();
                          final ownerName =
                              '${daycare.owner?.firstName ?? ''} ${daycare.owner?.lastName ?? ''}'
                                  .toLowerCase();
                          return petName.contains(searchText) ||
                              ownerName.contains(searchText);
                        }).toList();

                        if (filtered.isEmpty) {
                          return const Center(
                            child: Text(
                              'No hay resultados para tu búsqueda',
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }

                        return RefreshIndicator(
                          color: AppColors.dogOrange,
                          onRefresh: () => _refreshData(context),
                          child: ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final daycare = filtered[index];
                              final pet = daycare.pet;
                              final owner = daycare.owner;
                              final package = daycare.package;

                              return CommonDaycareEventCard(
                                title:
                                    '${ReCase(pet?.name ?? '').titleCase} - ${ReCase(owner?.firstName ?? '').titleCase} ${ReCase(owner?.lastName ?? '').titleCase}',
                                subtitle:
                                    'Package ${package?.hours} - AdditionalHours ${daycare.additionalHours} - LeftHours ${daycare.leftHours}',
                                imagePath: 'assets/pets/luna.png',
                                onTap: () {
                                  commonShowDialog<DaycareEventBloc>(
                                    context: context,
                                    title: 'Create Daycare Event',
                                    description:
                                        'Do you want to create the daycare for ${ReCase(pet?.name ?? '').titleCase}?',
                                    textButtonReject: 'Cancel',
                                    textButtonAccept: 'Create',
                                    onConfirm: () {
                                      context.read<DaycareEventBloc>().add(
                                        CreateDaycareEvent(pet!.id),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${ReCase(pet.name).titleCase} is now in daycare 🐶',
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
                      return const Center(
                        child: Text(
                          'Cargando datos...',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
