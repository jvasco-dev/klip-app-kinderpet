import 'package:kinder_pet/features/auth/data/repositories/auth_repository.dart';
import 'package:kinder_pet/features/pets/data/models/pet_model.dart';
import 'package:kinder_pet/features/pets/data/service/pet_service.dart';

class PetRepository {
  final PetService _service;
  final AuthRepository _auth;

  PetRepository(this._service, this._auth);

  Future<List<Pet>> searchByName(String name) async {
    final hasSession = await _auth.hasValidSession();
    if (!hasSession) throw Exception('Invalid session, sign in again');
    final token = await _auth.getAccessToken();
    if (token == null) throw Exception('Invalid session, sign in again');
    return await _service.searchByName(name, token);
  }
}
