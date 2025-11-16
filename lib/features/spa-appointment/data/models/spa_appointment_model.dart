import 'package:kinder_pet/features/pets/data/models/pet_model.dart';

class SpaAppointment {
  final String id;
  final Pet? pet;
  final String service;
  final String? notes;
  final double amount;
  final DateTime date;
  final String status;

  SpaAppointment({
    required this.id,
    this.pet,
    required this.service,
    this.notes,
    required this.amount,
    required this.date,
    required this.status,
  });

  factory SpaAppointment.fromJson(Map<String, dynamic> json) {
    return SpaAppointment(
      id: json['_id'] ?? '',
      pet: json['pet'] != null ? Pet.fromJson(json['pet']) : null,
      service: json['service'] ?? 'Baño',
      notes: json['notes']?.toString(),
      amount: (json['amount'] is num) ? (json['amount'] as num).toDouble() : 0.0,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'SCHEDULED',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'pet': pet?.toJson(),
      'service': service,
      "notes": notes,
      'amount': amount,
      'date': date.toIso8601String(),
      'status': status,
    };
  }

  /// ✅ Nuevo método copyWith
  SpaAppointment copyWith({
    String? id,
    Pet? pet,
    String? service,
    String? notes,
    double? amount,
    DateTime? date,
    bool? paid,
    String? status,
  }) {
    return SpaAppointment(
      id: id ?? this.id,
      pet: pet ?? this.pet,
      service: service ?? this.service,
      notes: notes ?? this.notes,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }
}
