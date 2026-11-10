import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio_client.dart';
import '../../Social Login/Models/social_login_result.dart';
import '../../Social Login/Models/social_provider_model.dart';
import '../../Social Login/Repo/social_auth_repository.dart';

const String _defaultAppleServiceId = String.fromEnvironment(
  'APPLE_SERVICE_ID',
  defaultValue: 'com.gatbi.app.auth',
);
const String _appleRedirectUri = String.fromEnvironment(
  'APPLE_REDIRECT_URI',
  defaultValue: 'https://gatbi.ae/auth/apple/callback',
);
const String _androidStatePrefix = 'vendor_';

class AppleLoginRepository {
  AppleLoginRepository(this._dioClient);

  final DioClient _dioClient;

  Future<SocialLoginResult> login({SocialProvider? provider}) async {
    final serviceId = _serviceId(provider);
    final webAuthenticationOptions = _webAuthenticationOptions(serviceId);

    if (kDebugMode) {
      debugPrint(
        '[AppleLogin] platform=${kIsWeb ? 'web' : defaultTargetPlatform.name}',
      );
    }

    if (!kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android &&
        webAuthenticationOptions == null) {
      throw const ApiException(
        message:
            'Apple login on Android needs Apple Service ID and Redirect URI. '
            'Please enable and configure Apple on the backend first.',
        code: 'APPLE_CONFIG_MISSING',
      );
    }

    final state = webAuthenticationOptions == null
        ? _generateRandomToken()
        : '$_androidStatePrefix${_generateRandomToken()}';
    final nonce = _generateRandomToken();

    AuthorizationCredentialAppleID appleCredential;

    try {
      appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: webAuthenticationOptions,
        state: state,
        nonce: nonce,
      ).timeout(const Duration(minutes: 2));
    } on TimeoutException {
      throw const ApiException(
        message:
            'Apple sign-in timed out. Please try again. If you were shown a '
            'web page instead of returning to the app, the Apple callback is '
            'not configured correctly.',
        code: 'APPLE_SIGN_IN_TIMEOUT',
      );
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('========== APPLE SIGN-IN ERROR ==========');
        debugPrint('ERROR: $error');
        debugPrint('STACK: $stackTrace');
        debugPrint('=========================================');
      }
      throw ApiException(
        message: kDebugMode
            ? 'Apple sign-in failed: $error'
            : 'Apple sign-in was cancelled or failed. Please try again.',
        code: 'APPLE_SIGN_IN_FAILED',
        originalError: error,
      );
    }

    if (kDebugMode) {
      debugPrint('=== AFTER APPLE SIGN IN ===');
      debugPrint('STATE MATCH: ${appleCredential.state == state}');
      debugPrint(
        'HAS IDENTITY_TOKEN: ${appleCredential.identityToken != null}',
      );
      debugPrint('===============================');
    }

    if (appleCredential.state != state) {
      throw const ApiException(
        message: 'Apple sign-in could not be verified. Please try again.',
        code: 'APPLE_STATE_MISMATCH',
      );
    }

    final idToken = appleCredential.identityToken;

    if (idToken == null || idToken.isEmpty) {
      throw const ApiException(
        message: 'No Apple ID credential received.',
        code: 'APPLE_NO_CREDENTIAL',
      );
    }

    final email = appleCredential.email;
    final firstName = appleCredential.givenName ?? '';
    final lastName = appleCredential.familyName ?? '';
    final fullName = '$firstName $lastName'.trim();

    return SocialAuthRepository(_dioClient).loginWithProvider(
      provider: 'apple',
      idToken: idToken,
      authorizationCode: appleCredential.authorizationCode,
      state: appleCredential.state ?? state,
      nonce: nonce,
      email: email,
      firstName: firstName,
      lastName: lastName,
      name: fullName,
    );
  }

  String _serviceId(SocialProvider? provider) {
    final providerClientId = provider?.clientId?.trim();
    if (providerClientId != null && providerClientId.isNotEmpty) {
      return providerClientId;
    }
    return _defaultAppleServiceId;
  }

  String _generateRandomToken() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  WebAuthenticationOptions? _webAuthenticationOptions(String serviceId) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return null;
    }

    if (serviceId.isEmpty || _appleRedirectUri.isEmpty) {
      return null;
    }

    return WebAuthenticationOptions(
      clientId: serviceId,
      redirectUri: Uri.parse(_appleRedirectUri),
    );
  }
}
