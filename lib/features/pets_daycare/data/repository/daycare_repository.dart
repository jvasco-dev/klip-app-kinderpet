import 'package:kinder_pet/features/auth/data/repositories/auth_repository.dart';
import 'package:kinder_pet/features/pets_daycare/data/models/daycare_model.dart';
import 'package:kinder_pet/features/pets_daycare/data/service/daycare_service.dart';

class DaycareRepository {
  final DaycareService _daycareService;
  final AuthRepository _authRepository;

  DaycareRepository(this._daycareService, this._authRepository);

  Future<Daycare> getActiveDaycareByPetId(String petId) async {
    final hasSession = await _authRepository.hasValidSession();

    if (!hasSession) throw Exception('Invalid session, please Sign In again');

    final token = await _authRepository.getAccessToken();

    if (token == null) throw Expando('Invalid session, please Sign In again');

    return await _daycareService.getActiveDaycareByPetId(petId, token);
  }

  Future<List<Daycare>> getAllDaycareInProgress() async {
    final hasSession = await _authRepository.hasValidSession();

    if (!hasSession) throw Exception('Invalid session, please Sign In again');

    final token = await _authRepository.getAccessToken();

    if (token == null) throw Expando('Invalid session, please Sign In again');

    return await _daycareService.getAllDaycareInProgress(token);
  }
}
