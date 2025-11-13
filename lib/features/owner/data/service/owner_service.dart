import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kinder_pet/features/owner/data/models/owner_model.dart';

class OwnerService {
  Dio get _dio => Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_URL']!,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<List<Owner>> getOwnersByLastName(String lastName, String token) async {
    try {
      final response = await _dio.get(
        '/owners',
        queryParameters: {'lastName': lastName},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final dataRaw = response.data;
        final List<dynamic> jsonList = dataRaw is List ? dataRaw : [];

        final List<Owner> owners = [];
        for (var item in jsonList) {
          try {
            if (item is Map<String, dynamic>) {
              owners.add(Owner.fromJson(item));
            } else {
              debugPrint("⚠️ Skipping invalid owner item: $item");
            }
          } catch (e, stack) {
            debugPrint("❌ Failed to parse owner item: $e\n$stack");
          }
        }
        return owners;
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception("Unexpected error: $e");
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
