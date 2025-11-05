import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kinder_pet/features/auth/data/services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthRepository(this._authService);

  /// Inicia sesión y guarda los tokens en almacenamiento seguro
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final response = await _authService.signIn(
      email: email,
      password: password,
    );

    if (response['accessToken'] != null && response['refreshToken'] != null) {
      await _storage.write(key: 'accessToken', value: response['accessToken']);
      await _storage.write(
        key: 'refreshToken',
        value: response['refreshToken'],
      );
    }

    return response;
  }

  /// Elimina los tokens del almacenamiento seguro (logout)
  Future<void> signOut() async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
  }

  /// Verifica si hay tokens guardados
  Future<bool> isLoggedIn() async {
    final accessToken = await _storage.read(key: 'accessToken');
    final refreshToken = await _storage.read(key: 'refreshToken');
    return accessToken != null && refreshToken != null;
  }

  /// Verifica si hay sesión válida y renueva tokens si es necesario
  Future<bool> hasValidSession() async {
    final refreshToken = await _storage.read(key: 'refreshToken');
    if (refreshToken == null) return false;

    try {
      final newTokens = await _authService.refreshToken(refreshToken);
      if (newTokens['accessToken'] != null) {
        await _storage.write(
          key: 'accessToken',
          value: newTokens['accessToken'],
        );
        if (newTokens['refreshToken'] != null) {
          await _storage.write(
            key: 'refreshToken',
            value: newTokens['refreshToken'],
          );
        }
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

}
