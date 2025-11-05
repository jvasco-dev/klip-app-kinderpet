import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:3000/api/v1',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    
    try {
      final response = await _dio.post(
        '/auth/sign-in',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Invalid response status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('❌ Dio response data: ${e.response?.data}');
        print('❌ Dio response status: ${e.response?.statusCode}');
        throw Exception(e.response?.data['message'] ?? 'Invalid credentials');
      } else {
        throw Exception('Connection error: ${e.message}');
      }
    }
  }
}
