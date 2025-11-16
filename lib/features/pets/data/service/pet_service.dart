import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kinder_pet/features/pets/data/models/pet_model.dart';

class PetService {
  Dio get _dio => Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_URL']!,
      connectTimeout: const Duration(seconds: 7),
      receiveTimeout: const Duration(seconds: 7),
    ),
  );

  Future<List<Pet>> searchByName(String name, String token) async {
    try {
      final resp = await _dio.get(
        '/pets',
        queryParameters: {'name': name},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final dataRaw = resp.data;
      final list = dataRaw is List ? dataRaw : (dataRaw['data'] ?? []);
      final List<Pet> pets = [];
      for (var item in list) {
        try {
          pets.add(Pet.fromJson(Map<String, dynamic>.from(item)));
        } catch (e, st) {
          debugPrint('pet parse skip $e\n$st');
        }
      }
      return pets;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<Pet>> searchPets(String query, String token) async {
    try {
      final resp = await _dio.get(
        '/pets',
        queryParameters: {'name': query},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final dataRaw = resp.data;
      final list = dataRaw is List ? dataRaw : (dataRaw['data'] ?? []);
      final List<Pet> pets = [];
      for (var item in list) {
        try {
          pets.add(Pet.fromJson(Map<String, dynamic>.from(item)));
        } catch (e, st) {
          debugPrint('pet parse skip $e\n$st');
        }
      }
      return pets;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout.';
    } else if (e.response != null) {
      final data = e.response?.data ?? {};
      if (data is Map && data['message'] != null) return data['message'];
      return 'Request failed with status ${e.response?.statusCode}';
    } else {
      return 'Unexpected error: ${e.message}';
    }
  }
}
