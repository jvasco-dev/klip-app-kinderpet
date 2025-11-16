import 'package:kinder_pet/features/auth/data/repositories/auth_repository.dart';
import 'package:kinder_pet/features/spa-appointment/data/models/spa_appointment_model.dart';
import 'package:kinder_pet/features/spa-appointment/data/service/spa_appointment_service.dart';

class SpaAppointmentRepository {
  final SpaAppointmentService _service;
  final AuthRepository _authRepository;

  SpaAppointmentRepository(this._service, this._authRepository);

  Future<List<SpaAppointment>> getAllAppointments({String? date}) async {
    final token = await _authRepository.getAccessToken();
    if (token == null) throw Exception('No authentication token found');

    return await _service.getAllAppointments(date: date, token: token);
  }

  Future<SpaAppointment> createAppointment(SpaAppointment appointment) async {
    final token = await _authRepository.getAccessToken();
    if (token == null) throw Exception('No authentication token found');

    return await _service.createAppointment(
      appointment: appointment,
      token: token,
    );
  }

  Future<SpaAppointment> updateAppointment(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final token = await _authRepository.getAccessToken();
      if (token == null) {
        throw Exception('Invalid session, please Sign In again');
      }

      final updated = await _service.updateAppointment(
        id: id,
        data: data,
        token: token,
      );
      return updated;
    } catch (e) {
      // mantener el patrón de manejo de errores: re-lanzar con mensaje claro
      throw Exception('Failed to update appointment: $e');
    }
  }

  // MODIFICACIÓN CRUCIAL AQUÍ: Ahora devuelve SpaAppointment
  Future<SpaAppointment> updateAppointmentStatus(
    String id,
    String status,
  ) async {
    final token = await _authRepository.getAccessToken();
    if (token == null) throw Exception('No authentication token found');

    // Usamos el servicio de actualización con solo el campo de estado
    return await _service.updateAppointment(
      id: id,
      data: {'status': status},
      token: token,
    );
  }
}
