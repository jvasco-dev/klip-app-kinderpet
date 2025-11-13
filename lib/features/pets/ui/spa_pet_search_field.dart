import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/features/pets/data/models/pet_model.dart';
import 'package:kinder_pet/features/pets/logic/pet_search_cubit.dart';

class SpaPetSearchField extends StatefulWidget {
  final Function(Pet) onPetSelected;

  const SpaPetSearchField({super.key, required this.onPetSelected});

  @override
  State<SpaPetSearchField> createState() => _SpaPetSearchFieldState();
}

class _SpaPetSearchFieldState extends State<SpaPetSearchField> {
  final TextEditingController _controller = TextEditingController();

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      context.read<PetSearchCubit>().searchByName(query);
    } else {
      context.read<PetSearchCubit>().reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Buscar mascota por nombre',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          onChanged: _onSearchChanged,
        ),
        const SizedBox(height: 8),
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: BlocBuilder<PetSearchCubit, PetSearchState>(
            builder: (context, state) {
              if (state is PetSearchLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PetSearchSuccess) {
                final pets = state.pets;
                return ListView.builder(
                  itemCount: pets.length,
                  itemBuilder: (context, index) {
                    final pet = pets[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            (pet.photo != null && pet.photo!.isNotEmpty)
                            ? NetworkImage(pet.photo!)
                            : null,
                        child: (pet.photo == null || pet.photo!.isEmpty)
                            ? const Icon(Icons.pets)
                            : null,
                      ),
                      title: Text(pet.name),
                      subtitle: Text(
                        pet.owner != null
                            ? '${pet.owner!.firstName ?? ''} ${pet.owner!.lastName ?? ''}'
                                  .trim()
                            : 'Sin propietario',
                      ),
                      onTap: () {
                        widget.onPetSelected(pet);
                        _controller.text = pet.name;
                      },
                    );
                  },
                );
              } else if (state is PetSearchEmpty) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.grey),
                  ),
                );
              } else if (state is PetSearchError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else {
                return const Center(
                  child: Text(
                    'Empieza a escribir para buscar mascotas...',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
