import 'package:dio/dio.dart';
import 'package:kinder_pet/features/dashboard/data/models/daycare_event_model.dart';

class DaycareEventService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:3000/api/v1',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

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
}
