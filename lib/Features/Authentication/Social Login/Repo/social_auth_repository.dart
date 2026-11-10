import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/social_login_result.dart';
import '../Models/social_provider_model.dart';

class SocialAuthRepository {
  SocialAuthRepository(this._dioClient);

  final DioClient _dioClient;

  Future<SocialProvidersResponse> fetchProviders() async {
    try {
      final response = await _dioClient.get<dynamic>(ApiUrls.socialProviders);
      final root = _asMap(response.data);

      if (root == null) {
        return SocialProvidersResponse.fallback();
      }

      final nested = root['data'] is Map
          ? Map<String, dynamic>.from(root['data'] as Map)
          : const <String, dynamic>{};

      final source = nested.isEmpty
          ? root
          : <String, dynamic>{...root, ...nested};

      return SocialProvidersResponse.fromJson(source);
    } catch (_) {
      return SocialProvidersResponse.fallback();
    }
  }

  Future<SocialLoginResult> loginWithProvider({
    required String provider,
    String? idToken,
    String? accessToken,
    String? authorizationCode,
    String? state,
    String? nonce,
    String? email,
    String? firstName,
    String? lastName,
    String? name,
    String? avatar,
  }) async {
    final fullName = <String?>[
      firstName,
      lastName,
    ].whereType<String>().map((value) => value.trim()).where((value) {
      return value.isNotEmpty;
    }).join(' ');

    final body = <String, dynamic>{
      if (_hasValue(idToken)) 'id_token': idToken!.trim(),
      if (_hasValue(accessToken)) 'access_token': accessToken!.trim(),
      if (_hasValue(authorizationCode))
        'authorization_code': authorizationCode!.trim(),
      if (_hasValue(state)) 'state': state!.trim(),
      if (_hasValue(nonce)) 'nonce': nonce!.trim(),
      if (_hasValue(email)) 'email': email!.trim(),
      if (_hasValue(firstName)) 'first_name': firstName!.trim(),
      if (_hasValue(lastName)) 'last_name': lastName!.trim(),
      if (fullName.isNotEmpty) 'full_name': fullName,
      if (_hasValue(name)) 'name': name!.trim(),
      if (_hasValue(avatar)) 'avatar': avatar!.trim(),
    };

    try {
      final response = await _dioClient.post<dynamic>(
        ApiUrls.socialLogin(provider),
        data: body,
        options: Options(
          validateStatus: (status) {
            return status != null && status >= 200 && status < 500;
          },
        ),
      );

      var result = SocialLoginResult.fromResponse(
        response.statusCode,
        _asMap(response.data),
      );

      result = result.copyWith(
        email: _hasValue(email) ? email!.trim() : null,
        firstName: _hasValue(firstName) ? firstName!.trim() : null,
        lastName: _hasValue(lastName) ? lastName!.trim() : null,
        name: _hasValue(name) ? name!.trim() : null,
      );

      if (!result.success && !result.requiresOtp && !result.vendorNotFound) {
        return result.copyWith(
          message: _friendlyMessage(
            result.errorCode,
            result.message,
            result.reason,
          ),
        );
      }

      return result;
    } on ApiException catch (error) {
      return SocialLoginResult.fail(
        message: _friendlyMessage(error.code, error.message, null),
        errorCode: error.code,
        statusCode: error.statusCode,
      );
    } catch (_) {
      return SocialLoginResult.fail(
        message:
            'Unable to connect to the server. Please check your connection and try again.',
        errorCode: 'NETWORK_ERROR',
      );
    }
  }

  static Map<String, dynamic>? _asMap(Object? value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    if (value is String && value.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  static bool _hasValue(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  static String _friendlyMessage(
    String? code,
    String? message,
    String? reason,
  ) {
    switch (reason) {
      case 'audience_mismatch':
      case 'issuer_mismatch':
        return 'Apple/Google token is not valid for this app.';
      case 'token_expired':
        return 'Your sign-in session expired. Please try again.';
      case 'id_token_invalid':
      case 'access_token_invalid':
        return 'Social sign-in could not be verified. Please try again.';
      case 'provider_keys_unavailable':
      case 'provider_error':
        return 'Provider is temporarily unavailable. Please try again.';
    }

    if (message != null && message.trim().isNotEmpty) {
      return message.trim();
    }

    switch (code) {
      case 'SOCIAL_LOGIN_DISABLED':
        return 'Social login is currently unavailable. Please use email and password.';
      case 'ACCOUNT_DISABLED':
        return 'Your account has been disabled. Please contact support.';
      case 'VALIDATION_ERROR':
        return 'The sign-in details could not be validated. Please try again.';
      case 'USER_NOT_FOUND':
        return 'No account was found for this sign-in method.';
      case 'VENDOR_NOT_FOUND':
        return 'No vendor account was found. Please complete your registration.';
      case 'SOCIAL_LOGIN_FAILED':
        return 'Social sign-in failed. Please try again.';
      default:
        return 'Social sign-in failed. Please try again.';
    }
  }
}
