// lib/features/spa_appointment/data/service/spa_appointment_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/spa_appointment_model.dart';

class SpaAppointmentService {
  Dio get _dio => Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_URL']!,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  final String _baseUrl = '/spa-appointments';

  SpaAppointmentService(Dio dio);

  /// Obtener todas las citas (opcionalmente filtradas por fecha)
  Future<List<SpaAppointment>> getAllAppointments({
    String? date,
    required String token,
  }) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: date != null ? {'date': date} : null,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final raw = response.data;
        final List<dynamic> jsonList = raw is List ? raw : [];
        final List<SpaAppointment> appointments = [];

        for (var item in jsonList) {
          try {
            if (item is Map<String, dynamic>) {
              appointments.add(SpaAppointment.fromJson(item));
            } else {
              debugPrint("⚠️ Skipping invalid item: $item");
            }
          } catch (e, stack) {
            debugPrint("❌ Failed to parse appointment item: $e\n$stack");
          }
        }

        return appointments;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("❌ Error fetching appointments: $e");
      throw Exception("Error fetching appointments");
    }
  }

  /// Crear una nueva cita
  Future<SpaAppointment> createAppointment({
    required SpaAppointment appointment,
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        _baseUrl,
        data: appointment.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return SpaAppointment.fromJson(response.data);
      } else {
        throw Exception('Failed to create appointment');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Actualizar estado de una cita (por ejemplo: COMPLETED o CANCELLED)
  Future<void> updateAppointmentStatus({
    required String id,
    required String status,
    bool? paid,
    required String token,
  }) async {
    try {
      await _dio.patch(
        '$_baseUrl/$id',
        data: {'status': status, if (paid != null) 'paid': paid},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Actualizar detalles de una cita
  Future<SpaAppointment> updateAppointment({
    required String id,
    required Map<String, dynamic> data,
    required String token,
  }) async {
    try {
      final response = await _dio.patch(
        '$_baseUrl/$id',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return SpaAppointment.fromJson(response.data);
      } else {
        throw Exception('Error updating appointment');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Manejo centralizado de errores Dio
  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    } else if (e.response != null) {
      final status = e.response?.statusCode ?? 0;
      final data = e.response?.data ?? {};
      return data['message'] ?? 'Request failed with status code $status.';
    } else {
      return 'Unexpected error: ${e.message}';
    }
  }
}
