import 'package:flutter/material.dart';

import 'package:kinder_pet/features/pets/data/models/pet_model.dart';
import 'package:kinder_pet/features/pets/data/repository/pet_repository.dart';

class SpaPetSearchField extends StatefulWidget {
  final PetRepository petRepository;
  final ValueChanged<Pet> onPetSelected;

  const SpaPetSearchField({
    super.key,
    required this.petRepository,
    required this.onPetSelected,
  });

  @override
  State<SpaPetSearchField> createState() => _SpaPetSearchFieldState();
}

class _SpaPetSearchFieldState extends State<SpaPetSearchField> {
  final TextEditingController _controller = TextEditingController();
  List<Pet> results = [];
  bool loading = false;

  Future<void> _search(String query) async {
    if (query.isEmpty) return;

    setState(() => loading = true);

    try {
      final pets = await widget.petRepository.searchPets(query);
      setState(() => results = pets);
    } catch (e) {
      results = [];
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          onChanged: _search,
          decoration: const InputDecoration(
            labelText: "Buscar mascota",
            prefixIcon: Icon(Icons.search),
          ),
        ),

        const SizedBox(height: 10),

        if (loading) const CircularProgressIndicator(),

        if (!loading && results.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (_, i) {
                final pet = results[i];
                return ListTile(
                  title: Text(pet.name),
                  subtitle: Text(pet.breed ?? ''),
                  onTap: () {
                    widget.onPetSelected(pet);
                    _controller.text = pet.name;
                    setState(() => results.clear());
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
