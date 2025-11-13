// lib/features/spa_appointment/presentation/widgets/spa_pet_search_field.dart
import 'package:flutter/material.dart';
import 'package:kinder_pet/features/pets/data/models/pet_model.dart';
import 'package:kinder_pet/features/pets/data/repository/pet_repository.dart';

class SpaPetSearchField extends StatefulWidget {
  final PetRepository petRepository;
  final void Function(Pet) onPetSelected;

  const SpaPetSearchField({
    super.key,
    required this.petRepository,
    required this.onPetSelected,
  });

  @override
  State<SpaPetSearchField> createState() => _SpaPetSearchFieldState();
}

class _SpaPetSearchFieldState extends State<SpaPetSearchField> {
  final TextEditingController _ctrl = TextEditingController();
  List<Pet> _results = [];
  bool _loading = false;
  String? _error;

  void _search(String q) async {
    if (q.trim().length < 2) {
      setState(() => _results = []);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await widget.petRepository.searchByName(q.trim());
      setState(() => _results = res);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _ctrl,
          decoration: const InputDecoration(
            labelText: 'Buscar mascota',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: _search,
        ),
        if (_loading)
          const Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(_error!, style: const TextStyle(color: Colors.red)),
          ),
        if (_results.isNotEmpty)
          Container(
            height: 160,
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (ctx, i) {
                final pet = _results[i];
                return ListTile(
                  leading: CircleAvatar(
                    child: pet.photo != null && pet.photo!.isNotEmpty
                        ? null
                        : const Icon(Icons.pets),
                  ),
                  title: Text(pet.name),
                  subtitle: Text(
                    '${pet.owner?.firstName ?? ''} ${pet.owner?.lastName ?? ''}'
                        .trim(),
                  ),
                  onTap: () => widget.onPetSelected(pet),
                );
              },
            ),
          ),
      ],
    );
  }
}
