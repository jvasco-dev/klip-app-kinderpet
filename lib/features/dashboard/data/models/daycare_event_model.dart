import 'package:kinder_pet/features/package/data/models/package_model.dart';
import 'package:kinder_pet/features/pet/data/models/pet_model.dart';
import 'package:kinder_pet/features/pets_daycare/data/models/daycare_model.dart';

class DaycareEvent {
  final String id;
  final String status;
  final DateTime startDate;
  final Pet pet;
  final Package package;
  final Daycare daycare;

  DaycareEvent({
    required this.id,
    required this.status,
    required this.startDate,
    required this.pet,
    required this.package,
    required this.daycare,
  });

  factory DaycareEvent.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      return DateTime.now();
    }

    return DaycareEvent(
      id: json['_id'] ?? '',
      status: json['status'] ?? '',
      startDate: parseDate(json['startDate']),
      pet: Pet.fromJson(json['pet']),
      package: Package.fromJson(json['package']),
      daycare: Daycare.fromJson(json['daycare']),
    );
  }
}
