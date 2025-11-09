import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/core/config/theme.dart';
import 'package:kinder_pet/features/auth/data/repositories/auth_repository.dart';
import 'package:kinder_pet/features/auth/data/services/auth_service.dart';
import 'package:kinder_pet/features/pets_daycare/data/repository/daycare_repository.dart';
import 'package:kinder_pet/features/pets_daycare/data/service/daycare_service.dart';
import 'package:kinder_pet/features/pets_daycare/presentation/bloc/daycare_bloc.dart';
import 'package:kinder_pet/shared/widgets/index.dart'; // si tienes componentes comunes como AppBar
import 'package:kinder_pet/shared/widgets/common_drawer.dart';
import 'package:recase/recase.dart'; // tu drawer

class PetsDaycareScreen extends StatefulWidget {
  const PetsDaycareScreen({super.key});

  @override
  State<PetsDaycareScreen> createState() => _PetsDaycareScreenState();
}

Future<void> _refreshData(BuildContext context) async {
  context.read<DaycareBloc>().add(FetchDaycare());
  await Future.delayed(const Duration(microseconds: 500));
}

class _PetsDaycareScreenState extends State<PetsDaycareScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearch() {}

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final authRepository = AuthRepository(authService);
    final daycareService = DaycareService();
    final daycareRepository = DaycareRepository(daycareService, authRepository);
    return BlocProvider(
      create: (_) => DaycareBloc(daycareRepository)..add(FetchDaycare()),
      child: Scaffold(
        backgroundColor: AppColors.warmBeige,
        drawer: const CommonDrawer(),

        // BODY
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
                  onSubmitted: (_) => _onSearch(),
                ),
                const SizedBox(height: 16),

                // 🔘 Botón buscar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _onSearch,
                    icon: const Icon(Icons.pets, color: Colors.white),
                    label: const Text(
                      'Buscar Mascota',
                      style: TextStyle(color: AppColors.lightBeigeAccent),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dogOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

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
                        return RefreshIndicator(
                          color: AppColors.dogOrange,
                          onRefresh: () => _refreshData(context),
                          child: Center(
                            child: ListView.builder(
                              itemCount: state.events.length,
                              itemBuilder: (context, index) {
                                final daycare = state.events[index];
                                final pet = daycare.pet;
                                final owner = daycare.owner;
                                final package = daycare.package;
                                return Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: ListTile(
                                    leading: const CircleAvatar(
                                      backgroundImage: AssetImage(
                                        'assets/pets/luna.png',
                                      ),
                                      radius: 24,
                                    ),
                                    title: Text(
                                      '${ReCase(pet?.name ?? '').titleCase} -  ${ReCase(owner?.firstName ?? '').titleCase} ${ReCase(owner?.lastName ?? '').titleCase}',
                                      style: const TextStyle(
                                        color: AppColors.brownText,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Package ${package?.hours} - AdditionalHours ${daycare.additionalHours} - leftHours ${daycare.leftHours}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    /* trailing: ElevatedButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Evento de guardería creado para ${pet["name"]}!',
                                            ),
                                            duration: const Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.dogOrange,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text('Crear evento'),
                                    ), */
                                  ),
                                );
                              },
                            ),
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
