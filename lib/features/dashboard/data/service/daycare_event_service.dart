import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kinder_pet/features/dashboard/data/models/daycare_event_model.dart';

class DaycareEventService {
  Dio get _dio => Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_URL']!,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  Future<void> createDaycareEvent(String daycareId, String token) async {
    try {
      debugPrint('🔹 Creando evento de guardería para daycare: $daycareId');
      final response = await _dio.post(
        '/events',
        data: {'daycare': daycareId},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      debugPrint(
        '✅ Evento creado exitosamente. Status: ${response.statusCode}',
      );
    } on DioException catch (e) {
      debugPrint('❌ Error en createDaycareEvent: ${e.message}');
      debugPrint('❌ Response: ${e.response?.data}');
      throw Exception(_handleDioError(e));
    }
  }

  /// 🔹 Obtiene los eventos en progreso
  Future<List<DaycareEvent>> getInProgressEvents(String token) async {
    try {
      debugPrint('🔹 Obteniendo eventos en progreso...');
      final response = await _dio.get(
        '/events',
        queryParameters: {'status': 'IN_PROGRESS'},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint(
        '✅ Petición getInProgressEvents exitosa. Status: ${response.statusCode}',
      );

      final List<dynamic> jsonList = response.data;
      final List<DaycareEvent> data = jsonList
          .map((json) => DaycareEvent.fromJson(json))
          .toList();

      debugPrint('📊 Se obtuvieron ${data.length} eventos en progreso');
      return data;
    } on DioException catch (e) {
      debugPrint('❌ Error en getInProgressEvents: ${e.message}');
      debugPrint('❌ Response: ${e.response?.data}');
      throw Exception(_handleDioError(e));
    }
  }

  /// 🔹 Finaliza un evento de guardería
  Future<void> endDaycareEvent(String eventId, String token) async {
    try {
      final now = DateTime.now().toUtc().toIso8601String();
      debugPrint('🔹 Finalizando evento: $eventId a las $now');

      final response = await _dio.patch(
        '/events/$eventId',
        data: {'endDate': now},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      debugPrint(
        '✅ Evento finalizado exitosamente. Status: ${response.statusCode}',
      );
    } on DioException catch (e) {
      debugPrint('❌ Error en endDaycareEvent: ${e.message}');
      debugPrint('❌ Response: ${e.response?.data}');
      throw Exception(_handleDioError(e));
    }
  }

  /// ⚙️ Manejo de errores detallado
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
