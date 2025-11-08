import 'package:kinder_pet/features/auth/data/repositories/auth_repository.dart';
import 'package:kinder_pet/features/dashboard/data/services/daycare_service.dart';

class DaycareRepository {
  final DaycareService _daycareService;
  final AuthRepository _authRepository;

  DaycareRepository(this._daycareService, this._authRepository);

  Future<dynamic> getActiveDaycareByPetId(String petId) async {
    final hasSession = await _authRepository.hasValidSession();

    if (!hasSession) throw Exception('Invalid session, please Sign In again');

    final token = await _authRepository.getAccessToken();

    if (token == null) throw Expando('Invalid session, please Sign In again');

    return await _daycareService.getActiveDaycareByPetId(petId, token);
  }
}
