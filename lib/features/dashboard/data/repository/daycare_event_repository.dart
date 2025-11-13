import 'package:kinder_pet/features/auth/data/repositories/auth_repository.dart';
import 'package:kinder_pet/features/dashboard/data/models/daycare_event_model.dart';
import 'package:kinder_pet/features/dashboard/data/service/daycare_event_service.dart';

class DaycareEventRepository {
  final DaycareEventService _daycareEventService;
  final AuthRepository _authRepository;

  DaycareEventRepository(this._daycareEventService, this._authRepository);

  Future<void> createDaycareEvent(String daycareId) async {
    final hasSession = await _authRepository.hasValidSession();

    if (!hasSession) throw Exception('Invalid session, please Sign In again');

    final token = await _authRepository.getAccessToken();

    if (token == null) throw Expando('Invalid session, please Sign In again');

    await _daycareEventService.createDaycareEvent(daycareId, token);
  }

  Future<List<DaycareEvent>> getInProgressEvents() async {
    final hasSession = await _authRepository.hasValidSession();

    if (!hasSession) throw Exception('Invalid session, please Sign In again');

    final token = await _authRepository.getAccessToken();

    if (token == null) throw Expando('Invalid session, please Sign In again');

    return await _daycareEventService.getInProgressEvents(token);
  }

  Future<void> endDaycareEvent(String eventId) async {
    final hasSession = await _authRepository.hasValidSession();

    if (!hasSession) throw Exception('Invalid session, please Sign In again');

    final token = await _authRepository.getAccessToken();

    if (token == null) throw Expando('Invalid session, please Sign In again');

    await _daycareEventService.endDaycareEvent(eventId, token);
  }
}
