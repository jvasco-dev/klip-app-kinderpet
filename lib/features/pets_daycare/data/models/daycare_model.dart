import 'package:kinder_pet/features/owner/data/models/owner_model.dart';
import 'package:kinder_pet/features/package/data/models/package_model.dart';
import 'package:kinder_pet/features/pet/data/models/pet_model.dart';

class Daycare {
  final String id;
  final Pet? pet;
  final Owner? owner;
  final Package? package;
  final String status;
  final double leftHours;
  final double additionalHours;

  Daycare({
    required this.id,
    this.pet,
    this.owner,
    this.package,
    required this.status,
    required this.leftHours,
    required this.additionalHours,
  });

  factory Daycare.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return Daycare(
      id: json['_id'] ?? '',
      pet: Pet.fromJson(json['pet']),
      owner: Owner.fromJson(json['owner']),
      package: Package.fromJson(json['package']),
      status: json['status'] ?? '',
      leftHours: parseDouble(json['leftHours']),
      additionalHours: parseDouble(json['additionalHours']),
    );
  }
}
