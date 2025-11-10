class Pet {
  final String id;
  final String name;
  final String species;
  final String breed;
  final String? photo;

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    this.photo,
  });

  factory Pet.fromJson(dynamic json) {
    if (json == null) {
      return Pet(id: '', name: '', species: '', breed: '');
    }

    if (json is String) {
      // Es solo un ID de referencia
      return Pet(id: json, name: '', species: '', breed: '');
    }

    if (json is Map<String, dynamic>) {
      return Pet(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        species: json['species'] ?? '',
        breed: json['breed'] ?? '',
        photo: json['photo'],
      );
    }

    // fallback
    return Pet(id: '', name: '', species: '', breed: '');
  }
}
