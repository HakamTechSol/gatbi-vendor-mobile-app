import 'package:flutter/foundation.dart';

import 'token_storage.dart';

class AuthSession {
  AuthSession._();

  static final AuthSession instance = AuthSession._();

  // ============================================================
  // SESSION STATE
  // ============================================================

  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  // ============================================================
  // INITIALIZE SESSION
  // ============================================================

  /// App start/restart par saved token check karta hai.
  ///
  /// Token mil jaye:
  ///     authenticated = true
  ///
  /// Token na mile:
  ///     authenticated = false
  Future<bool> initialize() async {
    try {
      final hasToken = await SecureStorageService.instance.hasToken();

      _isAuthenticated = hasToken;

      if (kDebugMode) {
        debugPrint('');
        debugPrint('========== AUTH SESSION ==========');
        debugPrint('TOKEN EXISTS: $hasToken');
        debugPrint('AUTHENTICATED: $_isAuthenticated');
        debugPrint('=================================');
        debugPrint('');
      }

      return _isAuthenticated;
    } catch (error) {
      _isAuthenticated = false;

      if (kDebugMode) {
        debugPrint('AUTH SESSION INITIALIZE ERROR: $error');
      }

      return false;
    }
  }

  // ============================================================
  // MARK AUTHENTICATED
  // ============================================================

  /// Successful OTP verification ke baad call kar sakte hain.
  void markAuthenticated() {
    _isAuthenticated = true;

    if (kDebugMode) {
      debugPrint('AUTH SESSION: AUTHENTICATED');
    }
  }

  // ============================================================
  // CHECK SESSION
  // ============================================================

  /// Storage se fresh token check karta hai.
  Future<bool> checkSession() async {
    try {
      final hasToken = await SecureStorageService.instance.hasToken();

      _isAuthenticated = hasToken;

      return _isAuthenticated;
    } catch (error) {
      _isAuthenticated = false;
      return false;
    }
  }

  // ============================================================
  // LOGOUT SESSION
  // ============================================================

  /// Local authentication session completely clear karta hai.
  Future<void> clearSession() async {
    await SecureStorageService.instance.deleteToken();

    _isAuthenticated = false;

    if (kDebugMode) {
      debugPrint('AUTH SESSION: CLEARED');
    }
  }

  // ============================================================
  // TOKEN
  // ============================================================

  Future<String?> getToken() async {
    return SecureStorageService.instance.getToken();
  }
}
