class DaycareEvent {
  final String id;
  final String status;
  final DateTime startDate;
  final Pet pet;
  final Daycare daycare;
  final Package package;

  DaycareEvent({
    required this.id,
    required this.status,
    required this.startDate,
    required this.pet,
    required this.daycare,
    required this.package,
  });

  factory DaycareEvent.fromJson(Map<String, dynamic> json) {
    return DaycareEvent(
      id: json['_id'] ?? '',
      status: json['status'] ?? '',
      startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      pet: Pet.fromJson(json['pet'] ?? {}),
      daycare: Daycare.fromJson(json['daycare'] ?? {}),
      package: Package.fromJson(json['package'] ?? {}),
    );
  }
}

class Pet {
  final String id;
  final String name;
  final String species;
  final String breed;
  final String photo;

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.photo,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      species: json['species'] ?? '',
      breed: json['breed'] ?? '',
      photo: json['photo'] ?? '',
    );
  }
}

class Daycare {
  final String id;
  final double leftHours;
  final double additionalHours;

  Daycare({
    required this.id,
    required this.leftHours,
    required this.additionalHours,
  });

  factory Daycare.fromJson(Map<String, dynamic> json) {
    return Daycare(
      id: json['_id'] ?? '',
      leftHours: (json['leftHours'] ?? 0).toDouble(),
      additionalHours: (json['additionalHours'] ?? 0).toDouble(),
    );
  }
}

class Package {
  final String id;
  final String name;
  final int hours;

  Package({required this.id, required this.name, required this.hours});

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      hours: json['hours'] ?? 0,
    );
  }
}
