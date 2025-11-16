import 'package:dio/dio.dart';
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

  SpaAppointmentService();

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
        // ✅ CORRECCIÓN CLAVE: Aseguramos que 'raw' es una lista de dynamic
        final List<dynamic> jsonList = raw is List ? raw : [];

        final List<SpaAppointment> appointments = jsonList
            .map(
              (json) => SpaAppointment.fromJson(json as Map<String, dynamic>),
            )
            .toList();

        return appointments;
      } else {
        throw Exception(
          'Error fetching appointments: Received unexpected status code ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      // Manejo de errores de serialización o de tipo que puede ser la causa original
      throw Exception('Deserialization error: $e');
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

      if (response.statusCode == 201 && response.data != null) {
        return SpaAppointment.fromJson(response.data);
      } else {
        throw Exception(
          'Error creating appointment: Received status code ${response.statusCode}',
        );
      }
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

  /// Actualizar el estado de una cita (CANCELLED o COMPLETED)
  Future<void> updateAppointmentStatus({
    required String id,
    required String status,
    required String token,
  }) async {
    try {
      await _dio.patch(
        '$_baseUrl/$id/status',
        data: {'status': status},
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
