import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  GoogleSignInService._();

  static Future<void>? _initialization;
  static String? _initializedServerClientId;

  static Future<GoogleSignInAccount?> signIn({
    required String serverClientId,
  }) async {
    await _ensureInitialized(serverClientId);

    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}

    try {
      return await GoogleSignIn.instance.authenticate(
        scopeHint: const ['email', 'profile'],
      );
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      rethrow;
    }
  }

  static Future<void> _ensureInitialized(String serverClientId) {
    if (_initialization != null &&
        _initializedServerClientId == serverClientId) {
      return _initialization!;
    }

    _initializedServerClientId = serverClientId;
    _initialization = _initialize(serverClientId);
    return _initialization!;
  }

  static Future<void> _initialize(String serverClientId) async {
    try {
      await GoogleSignIn.instance.initialize(
        serverClientId: serverClientId,
      );
    } catch (_) {
      _initialization = null;
      _initializedServerClientId = null;
      rethrow;
    }
  }
}
