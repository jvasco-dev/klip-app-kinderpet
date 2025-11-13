import 'package:kinder_pet/features/owner/data/models/owner_model.dart';

class Pet {
  final String id;
  final String name;
  final String? gender;
  final String? species;
  final String? color;
  final String? size;
  final String? breed;
  final DateTime? birthday;
  final String? microchip;
  final String? photo;
  final Owner? owner;

  Pet({
    required this.id,
    required this.name,
    this.gender,
    this.species,
    this.color,
    this.size,
    this.breed,
    this.birthday,
    this.microchip,
    this.photo,
    this.owner,
  });

  factory Pet.fromJson(dynamic json) {
    if (json == null) {
      return Pet(id: '', name: '');
    }

    // ✅ Si el backend envía solo el ID
    if (json is String) {
      return Pet(id: json, name: '');
    }

    // ✅ Si el backend envía el objeto completo
    return Pet(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'],
      species: json['species'],
      color: json['color'],
      size: json['size'],
      breed: json['breed'],
      birthday: json['birthday'] != null
          ? DateTime.tryParse(json['birthday'])
          : null,
      microchip: json['microchip'],
      photo: json['photo'],
      owner: json['owner'] != null ? Owner.fromJson(json['owner']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'gender': gender,
      'species': species,
      'color': color,
      'size': size,
      'breed': breed,
      'birthday': birthday?.toIso8601String(),
      'microchip': microchip,
      'photo': photo,
      'owner': owner?.toJson(),
    };
  }
}
