
class SpaAppointment {
  final String id;
  final String pet;
  final String? notes;
  final double amount;
  final DateTime date;
  final String status;

  SpaAppointment({
    required this.id,
    required this.pet,
    this.notes,
    required this.amount,
    required this.date,
    required this.status,
  });

  factory SpaAppointment.fromJson(Map<String, dynamic> json) {
    return SpaAppointment(
      id: json['_id'] ?? '',
      pet: json['pet'].toString() ,
      notes: json['notes']?.toString(),
      amount: (json['amount'] is num) ? (json['amount'] as num).toDouble() : 0.0,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'DONE',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'pet': pet,
      "notes": notes,
      'amount': amount,
      'date': date.toIso8601String(),
      'status': status,
    };
  }

  /// ✅ Nuevo método copyWith
  SpaAppointment copyWith({
    String? id,
    String? pet,
    String? notes,
    double? amount,
    DateTime? date,
    bool? paid,
    String? status,
  }) {
    return SpaAppointment(
      id: id ?? this.id,
      pet: this.pet,
      notes: notes ?? this.notes,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }
}
