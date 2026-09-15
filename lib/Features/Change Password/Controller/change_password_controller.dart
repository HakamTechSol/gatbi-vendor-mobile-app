import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/change_password_model.dart';
import '../Repo/change_password_repo.dart';

// ============================================================
// Change Password Provider
// ============================================================

final changePasswordControllerProvider = Provider<ChangePasswordController>((
  ref,
) {
  final dioClient = ref.watch(dioProvider);

  return ChangePasswordController(dioClient: dioClient);
});

// ============================================================
// Change Password Controller
// ============================================================

class ChangePasswordController {
  ChangePasswordController({required DioClient dioClient})
    : _repository = ChangePasswordRepository(dioClient);

  final ChangePasswordRepository _repository;

  // ==========================================================
  // Change Password
  // ==========================================================

  Future<ChangePasswordModel> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final result = await _repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );

      return result;
    } on ApiException {
      // Existing API exception ko as-is UI tak jane dein.
      // Is se statusCode, code aur validation/error details
      // preserve rehti hain.
      rethrow;
    } catch (error) {
      // Unexpected errors ko standard ApiException mein convert
      // kar rahe hain.
      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}
