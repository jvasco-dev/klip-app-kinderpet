import 'package:dio/dio.dart';
import 'package:kinder_pet/features/auth/data/repositories/auth_repository.dart';
import 'package:kinder_pet/features/dashboard/data/models/daycare_event_model.dart';

class DaycareEventService {
  final Dio _dio;
  final AuthRepository _authRepository;

  DaycareEventService(this._authRepository)
    : _dio = Dio(
        BaseOptions(
          baseUrl: 'http://10.0.2.2:3000/api/v1',
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await _authRepository.getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // Si el token expiró, intenta refrescarlo
          if (e.response?.statusCode == 401) {
            final refreshed = await _authRepository.hasValidSession();
            if (refreshed) {
              final newToken = await _authRepository.getAccessToken();
              if (newToken != null) {
                final retryResponse = await _retry(e.requestOptions, newToken);
                return handler.resolve(retryResponse);
              }
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  /// 🔹 Obtiene los eventos en progreso
  Future<List<DaycareEvent>> getInProgressEvents() async {
    try {
      final response = await _dio.get(
        '/events',
        queryParameters: {'status': 'IN_PROGRESS'},
      );

      final List data = response.data;
      return data.map((item) => DaycareEvent.fromJson(item)).toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// 🔹 Finaliza un evento de guardería
  Future<void> endDaycareEvent(String eventId) async {
    try {
      final now = DateTime.now().toUtc().toIso8601String();

      await _dio.patch('/events/$eventId', data: {'endDate': now});
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// 🔁 Reintenta una request fallida con un nuevo token
  Future<Response<dynamic>> _retry(
    RequestOptions requestOptions,
    String token,
  ) {
    final newOptions = Options(
      method: requestOptions.method,
      headers: {'Authorization': 'Bearer $token'},
    );

    return _dio.request(
      requestOptions.path,
      options: newOptions,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
    );
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
