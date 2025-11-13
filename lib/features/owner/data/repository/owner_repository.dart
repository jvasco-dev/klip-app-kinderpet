import 'package:kinder_pet/features/auth/data/repositories/auth_repository.dart';
import 'package:kinder_pet/features/owner/data/models/owner_model.dart';
import 'package:kinder_pet/features/owner/data/service/owner_service.dart';


class OwnerRepository {
  final OwnerService _ownerService;
  final AuthRepository _authRepository;

  OwnerRepository(this._ownerService, this._authRepository);

  /// 🔍 Buscar owners por apellido (lastName)
  Future<List<Owner>> getOwnersByLastName(String lastName) async {
    try {
      final hasSession = await _authRepository.hasValidSession();
      if (!hasSession) {
        throw Exception('Invalid session, please sign in again.');
      }

      final token = await _authRepository.getAccessToken();
      if (token == null) {
        throw Exception('Invalid session, please sign in again.');
      }

      final owners = await _ownerService.getOwnersByLastName(lastName, token);
      return owners;
    } catch (e) {
      throw Exception('Error fetching owners: $e');
    }
  }
}
