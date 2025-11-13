import 'package:kinder_pet/features/owner/data/models/owner_model.dart';
import 'package:kinder_pet/features/pets/data/models/pet_model.dart';

class SpaAppointment {
  final String id;
  final Pet? pet;
  final Owner? owner;
  final String serviceName;
  final String? description;
  final double price;
  final DateTime date;
  final bool paid;
  final String status;

  SpaAppointment({
    required this.id,
    this.pet,
    this.owner,
    required this.serviceName,
    this.description,
    required this.price,
    required this.date,
    this.paid = false,
    required this.status,
  });

  factory SpaAppointment.fromJson(Map<String, dynamic> json) {
    return SpaAppointment(
      id: json['_id'] ?? '',
      pet: json['pet'] != null ? Pet.fromJson(json['pet']) : null,
      owner: json['owner'] != null ? Owner.fromJson(json['owner']) : null,
      serviceName: json['serviceName'] ?? 'Baño',
      description: json['description'],
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      paid: json['paid'] ?? false,
      status: json['status'] ?? 'SCHEDULED',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'pet': pet?.toJson(),
      'owner': owner?.toJson(),
      'serviceName': serviceName,
      'description': description,
      'price': price,
      'date': date.toIso8601String(),
      'paid': paid,
      'status': status,
    };
  }

  /// ✅ Nuevo método copyWith
  SpaAppointment copyWith({
    String? id,
    Pet? pet,
    Owner? owner,
    String? serviceName,
    String? description,
    double? price,
    DateTime? date,
    bool? paid,
    String? status,
  }) {
    return SpaAppointment(
      id: id ?? this.id,
      pet: pet ?? this.pet,
      owner: owner ?? this.owner,
      serviceName: serviceName ?? this.serviceName,
      description: description ?? this.description,
      price: price ?? this.price,
      date: date ?? this.date,
      paid: paid ?? this.paid,
      status: status ?? this.status,
    );
  }
}
