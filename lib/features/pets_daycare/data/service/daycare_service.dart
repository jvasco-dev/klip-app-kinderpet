import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kinder_pet/features/pets_daycare/data/models/daycare_model.dart';

class DaycareService {
  final Dio _dio = Dio(
    BaseOptions(
      // baseUrl: 'http://10.0.2.2:3000/api/v1',
      baseUrl: 'http://192.168.20.3:3000/api/v1',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<List<Daycare>> getAllDaycareInProgress(String token) async {
    try {
      final response = await _dio.get(
        '/daycare',
        queryParameters: {'status': 'IN_PROGRESS'},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final dataRaw = response.data;

        // Asegurarnos de que sea una lista
        final List<dynamic> jsonList = dataRaw is List ? dataRaw : [];

        final List<Daycare> daycares = [];
        for (var item in jsonList) {
          try {
            if (item is Map<String, dynamic>) {
              daycares.add(Daycare.fromJson(item));
            } else {
              debugPrint("⚠️ Skipping invalid item: $item");
            }
          } catch (e, stack) {
            debugPrint("❌ Failed to parse daycare item: $e\n$stack");
          }
        }
        return daycares;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("❌ Error fetching daycares: $e");
      throw Exception("Error fetching daycares");
    }
  }

  Future<Daycare> getActiveDaycareByPetId(String petId, String token) async {
    try {
      final response = await _dio.get(
        '/daycare',
        queryParameters: {'pet': petId, 'status': 'IN_PROGRESS'},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 &&
          response.data != null &&
          response.data is List) {
        return Daycare.fromJson(response.data.first);
      } else {
        throw Exception('Error trying to get daycare from Pet');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

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
