import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import '../models/spa_appointment_model.dart';

class SpaAppointmentService {
  Dio get _dio => Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_URL']!,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  final String _baseUrl = '/spa-appointments';

  SpaAppointmentService();

  Future<List<SpaAppointment>> getAllAppointments({
    String? date,
    required String token,
  }) async {
    debugPrint(
      '🔹 Obteniendo citas${date != null ? ' para la fecha: $date' : ' de todos los tiempos'}...',
    );
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

      debugPrint(
        '✅ Petición getAllAppointments exitosa. Status: ${response.statusCode}',
      );

      if (response.statusCode == 200 && response.data != null) {
        final raw = response.data;
        // ✅ CORRECCIÓN CLAVE: Aseguramos que 'raw' es una lista de dynamic
        final List<dynamic> jsonList = raw is List ? raw : [];

        final List<SpaAppointment> appointments = jsonList
            .map(
              (json) => SpaAppointment.fromJson(json as Map<String, dynamic>),
            )
            .toList();

        debugPrint('📊 Se obtuvieron ${appointments.length} citas');
        return appointments;
      } else {
        throw Exception(
          'Error fetching appointments: Received unexpected status code ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      debugPrint('❌ Error en getAllAppointments: ${e.message}');
      debugPrint('❌ Response: ${e.response?.data}');
      throw Exception(_handleDioError(e));
    } catch (e) {
      // Manejo de errores de serialización o de tipo que puede ser la causa original
      debugPrint('❌ Error de deserialización: $e');
      throw Exception('Deserialization error: $e');
    }
  }

  /// Crear una nueva cita
  Future<SpaAppointment> createAppointment({
    required SpaAppointment appointment,
    required String token,
  }) async {
    debugPrint('🔹 Creando cita para: ${appointment.pet}');
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

      debugPrint('✅ Cita creada exitosamente. Status: ${response.statusCode}');
      if (response.statusCode == 201 && response.data != null) {
        return SpaAppointment.fromJson(response.data);
      } else {
        throw Exception(
          'Error creating appointment: Received status code ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      debugPrint('❌ Error en createAppointment: ${e.message}');
      debugPrint('❌ Response: ${e.response?.data}');
      throw Exception(_handleDioError(e));
    }
  }

  /// Actualizar detalles de una cita
  Future<SpaAppointment> updateAppointment({
    required String id,
    required Map<String, dynamic> data,
    required String token,
  }) async {
    debugPrint('🔹 Actualizando cita: $id con datos: $data');
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

      debugPrint(
        '✅ Cita actualizada exitosamente. Status: ${response.statusCode}',
      );
      if (response.statusCode == 200 && response.data != null) {
        return SpaAppointment.fromJson(response.data);
      } else {
        throw Exception('Error updating appointment');
      }
    } on DioException catch (e) {
      debugPrint('❌ Error en updateAppointment: ${e.message}');
      debugPrint('❌ Response: ${e.response?.data}');
      throw Exception(_handleDioError(e));
    }
  }

  /// Actualizar el estado de una cita (CANCELLED o COMPLETED)
  Future<void> updateAppointmentStatus({
    required String id,
    required String status,
    required String token,
  }) async {
    debugPrint('🔹 Actualizando estado de cita: $id a: $status');
    try {
      final response = await _dio.patch(
        '$_baseUrl/$id/status',
        data: {'status': status},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      debugPrint(
        '✅ Estado de cita actualizado exitosamente. Status: ${response.statusCode}',
      );
    } on DioException catch (e) {
      debugPrint('❌ Error en updateAppointmentStatus: ${e.message}');
      debugPrint('❌ Response: ${e.response?.data}');
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
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        return '$status: ${data['message']}';
      } else if (data is String && data.isNotEmpty) {
        return '$status: $data';
      }
      return 'Server error $status: ${e.message}';
    } else {
      return 'Network error: ${e.message}';
    }
  }
}
