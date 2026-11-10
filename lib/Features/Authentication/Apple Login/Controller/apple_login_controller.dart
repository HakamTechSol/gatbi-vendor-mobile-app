import '../../../../Services/dio_client.dart';
import '../../Social Login/Controller/social_login_controller.dart';
import '../../Social Login/Models/social_login_result.dart';
import '../../Social Login/Models/social_provider_model.dart';

class AppleLoginController {
  AppleLoginController({required DioClient dioClient})
    : _controller = SocialLoginController(dioClient: dioClient);

  final SocialLoginController _controller;

  Future<SocialLoginResult> signInWithApple({SocialProvider? provider}) {
    return _controller.signInWithApple(provider: provider);
  }
}
