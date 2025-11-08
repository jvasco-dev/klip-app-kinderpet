import 'package:dio/dio.dart';
import 'package:kinder_pet/features/dashboard/data/models/daycare_event_model.dart';

class DaycareEventService {
  final Dio _dio = Dio(
    BaseOptions(
      // baseUrl: 'http://10.0.2.2:3000/api/v1',
      baseUrl: 'http://192.168.20.3:3000/api/v1',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<void> createDaycareEvent(String daycareId, String token) async {
    try {
      await _dio.post(
        '/events',
        data: {'daycare': daycareId},
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

  /// 🔹 Obtiene los eventos en progreso
  Future<List<DaycareEvent>> getInProgressEvents(String token) async {
    try {
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

      final List data = response.data;
      return data.map((item) => DaycareEvent.fromJson(item)).toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// 🔹 Finaliza un evento de guardería
  Future<void> endDaycareEvent(String eventId, String token) async {
    try {
      final now = DateTime.now().toUtc().toIso8601String();

      await _dio.patch(
        '/events/$eventId',
        data: {'endDate': now},
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
