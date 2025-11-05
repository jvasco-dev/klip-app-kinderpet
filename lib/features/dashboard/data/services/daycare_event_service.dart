import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kinder_pet/features/dashboard/data/models/daycare_event_model.dart';

class DaycareEventService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:3000/api/v1',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  DaycareEventService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'accessToken');

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // if token expire, backend returns 401
          if (e.response?.statusCode == 401) {
            final refreshed = await _refreshToken();

            if (refreshed) {
              final retryRequest = await _retry(e.requestOptions);

              return handler.resolve(retryRequest);
            }
          }
        },
      ),
    );
  }

  Future<List<DaycareEvent>> getInProgressEvents() async {
    try {
      final response = await _dio.get(
        '/events',
        queryParameters: {'status': 'IN_PROGRESS'},
      );

      final List data = response.data;

      return data.map((item) => DaycareEvent.fromJson(item)).toList();
    } on DioException catch (e) {
      print(
        '❌ Error fetching daycare events: ${e.response?.data ?? e.message}',
      );
      rethrow;
    }
  }

  Future<bool> _refreshToken() async {
    final newRefreshToken = await _storage.read(key: 'refreshToken');

    if (newRefreshToken == null) return false;

    try {
      final response = await _dio.post(
        '/auth/refresh-token/',
        data: {'refreshToken': newRefreshToken},
      );

      final accessToken = response.data['accessToken'];
      final refreshToken = response.data['refreshToken'];

      await _storage.write(key: 'accessToken', value: accessToken);
      await _storage.write(key: 'refreshToken', value: refreshToken);

      return true;
    } catch (e) {
      print('Error refreshing token: $e');
      return false;
    }
  }

  /// 🔁 Reintenta la request original con el nuevo token
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final newToken = await _storage.read(key: 'accessToken');

    final newOptions = Options(
      method: requestOptions.method,
      headers: {'Authorization': 'Bearer $newToken'},
    );

    return _dio.request(
      requestOptions.path,
      options: newOptions,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
    );
  }

  /// 🧩 Manejo unificado de errores
  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet.';
    } else if (e.response != null) {
      final status = e.response?.statusCode ?? 0;
      final data = e.response?.data ?? {};
      return data['message'] ?? 'Request failed with status $status.';
    } else {
      return 'Unexpected error: ${e.message}';
    }
  }
}
