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
    try {
      // Manejo robusto de datos para evitar errores de serialización
      final String id = json['_id']?.toString() ?? '';
      final String pet = json['pet']?.toString() ?? 'Mascota desconocida';
      final String? notes = json['notes']?.toString();

      // Manejo seguro del amount con validación de tipo
      double amount = 0.0;
      if (json['amount'] != null) {
        if (json['amount'] is num) {
          amount = (json['amount'] as num).toDouble();
        } else if (json['amount'] is String) {
          amount = double.tryParse(json['amount']) ?? 0.0;
        }
      }

      // Manejo robusto de la fecha con timezone
      DateTime date = DateTime.now();
      if (json['date'] != null) {
        final dateStr = json['date'].toString();
        final parsedDate = DateTime.tryParse(dateStr);
        if (parsedDate != null) {
          date = parsedDate;
        }
      }

      final String status = json['status']?.toString() ?? 'PENDING';

      return SpaAppointment(
        id: id,
        pet: pet,
        notes: notes,
        amount: amount,
        date: date,
        status: status,
      );
    } catch (e) {
      // En caso de error grave, devolver una cita con valores por defecto
      return SpaAppointment(
        id:
            json['_id']?.toString() ??
            'error-${DateTime.now().millisecondsSinceEpoch}',
        pet: 'Error en datos',
        notes: 'Error al procesar cita: $e',
        amount: 0.0,
        date: DateTime.now(),
        status: 'ERROR',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'pet': pet,
      "notes": notes,
      'amount': amount,
      'date': date
          .toUtc()
          .toIso8601String(), // Usar UTC para evitar problemas de timezone
      'status': status,
    };
  }

  /// Método para verificar si la cita es válida
  bool get isValid {
    return id.isNotEmpty && pet.isNotEmpty && amount >= 0 && status.isNotEmpty;
  }

  /// Método para obtener el estado formateado para mostrar
  String get formattedStatus {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Pendiente';
      case 'CONFIRMED':
        return 'Confirmada';
      case 'IN_PROGRESS':
        return 'En progreso';
      case 'COMPLETED':
        return 'Completada';
      case 'CANCELLED':
        return 'Cancelada';
      case 'DONE':
        return 'Realizada';
      default:
        return status;
    }
  }

  /// Método para verificar si la cita es para hoy
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Método para verificar si la cita es futura
  bool get isFuture {
    return date.isAfter(DateTime.now());
  }

  /// Método para verificar si la cita es pasada
  bool get isPast {
    return date.isBefore(DateTime.now());
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
