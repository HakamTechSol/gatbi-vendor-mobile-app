import 'token_storage.dart';

class SessionManager {
  SessionManager._();

  /// Called when token expires or API returns 401.
  static Future<void> handleSessionExpired() async {
    // Remove authentication token.
    await SecureStorageService.instance.deleteToken();

    // UI/navigation layer can handle redirect to login.
  }
}
