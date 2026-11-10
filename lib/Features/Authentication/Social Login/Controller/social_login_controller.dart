import '../../../../Services/api_exception.dart';
import '../../../../Services/auth_session.dart';
import '../../../../Services/device_registration_helper.dart';
import '../../../../Services/dio_client.dart';
import '../../../../Services/token_storage.dart';
import '../../Apple Login/Repo/apple_login_repo.dart';
import '../Models/social_login_result.dart';
import '../Models/social_provider_model.dart';
import '../Repo/social_auth_repository.dart';
import '../Services/google_sign_in_service.dart';

const String _defaultGoogleServerClientId =
    '391572737407-8c5s56e0r0rkksoil3uhugfs8earbtbm.apps.googleusercontent.com';

class SocialLoginController {
  SocialLoginController({required DioClient dioClient})
    : _dioClient = dioClient,
      _repository = SocialAuthRepository(dioClient);

  final DioClient _dioClient;
  final SocialAuthRepository _repository;

  Future<SocialProvidersResponse> fetchProviders() {
    return _repository.fetchProviders();
  }

  Future<SocialLoginResult> signInWithGoogle({
    required SocialProvider provider,
  }) async {
    final serverClientId =
        provider.primaryMobileClientId ?? _defaultGoogleServerClientId;

    if (serverClientId.trim().isEmpty) {
      return SocialLoginResult.fail(
        message: 'Google sign-in is not configured. Please try again later.',
        errorCode: 'GOOGLE_CONFIG_MISSING',
      );
    }

    try {
      final account = await GoogleSignInService.signIn(
        serverClientId: serverClientId,
      );

      if (account == null) {
        return SocialLoginResult.cancelled();
      }

      final idToken = account.authentication.idToken;

      if (idToken == null || idToken.isEmpty) {
        return SocialLoginResult.fail(
          message: 'Google did not return a valid ID token. Please try again.',
          errorCode: 'GOOGLE_NO_ID_TOKEN',
        );
      }

      final result = await _repository.loginWithProvider(
        provider: 'google',
        idToken: idToken,
        email: account.email,
        name: account.displayName,
        avatar: account.photoUrl,
      );

      return _completeIfNeeded(result);
    } on ApiException catch (error) {
      return SocialLoginResult.fail(
        message: error.message,
        errorCode: error.code,
        statusCode: error.statusCode,
      );
    } catch (_) {
      return SocialLoginResult.fail(
        message: 'Google sign-in failed. Please try again.',
        errorCode: 'GOOGLE_SIGN_IN_FAILED',
      );
    }
  }

  Future<SocialLoginResult> signInWithApple({
    SocialProvider? provider,
  }) async {
    try {
      final result = await AppleLoginRepository(
        _dioClient,
      ).login(provider: provider);

      return _completeIfNeeded(result);
    } on ApiException catch (error) {
      return SocialLoginResult.fail(
        message: error.message,
        errorCode: error.code,
        statusCode: error.statusCode,
      );
    } catch (_) {
      return SocialLoginResult.fail(
        message: 'Apple sign-in failed. Please try again.',
        errorCode: 'APPLE_SIGN_IN_FAILED',
      );
    }
  }

  Future<SocialLoginResult> _completeIfNeeded(
    SocialLoginResult result,
  ) async {
    if (!result.success || !result.hasToken) {
      return result;
    }

    try {
      await SecureStorageService.instance.saveToken(result.token!);

      _dioClient.updateAuthToken(result.token);

      AuthSession.instance.markAuthenticated();

      await DeviceRegistrationHelper.registerDevice(dioClient: _dioClient);
    } catch (_) {
      return SocialLoginResult.fail(
        message:
            'Sign-in succeeded but the session could not be saved. Please try again.',
        errorCode: 'SESSION_SAVE_FAILED',
      );
    }

    return result;
  }
}
