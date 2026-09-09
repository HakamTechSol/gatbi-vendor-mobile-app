import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService._();

  static final SecureStorageService instance = SecureStorageService._();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';

  // ============================================================
  // Save Token
  // ============================================================

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // ============================================================
  // Get Token
  // ============================================================

  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  // ============================================================
  // Delete Token
  // ============================================================

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // ============================================================
  // Clear Storage
  // ============================================================

  Future<void> clear() async {
    await _storage.deleteAll();
  }

  // ============================================================
  // Has Token
  // ============================================================

  Future<bool> hasToken() async {
    final token = await getToken();

    return token != null && token.isNotEmpty;
  }
}
