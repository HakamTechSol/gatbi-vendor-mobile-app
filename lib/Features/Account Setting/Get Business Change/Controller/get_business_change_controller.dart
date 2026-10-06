import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/get_business_change_model.dart';
import '../Repo/get_business_change_repository.dart';

// ============================================================
// Get Business Change Provider
// ============================================================

final getBusinessChangeControllerProvider =
    Provider<GetBusinessChangeController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return GetBusinessChangeController(
    dioClient: dioClient,
  );
});

// ============================================================
// Get Business Change Controller
// ============================================================

class GetBusinessChangeController {
  GetBusinessChangeController({
    required DioClient dioClient,
  }) : _repository = GetBusinessChangeRepository(dioClient);

  final GetBusinessChangeRepository _repository;

  // ==========================================================
  // Get Business Change
  // ==========================================================

  Future<GetBusinessChangeModel> getBusinessChange() async {
    try {
      final result =
          await _repository.getBusinessChange();

      return result;
    } on ApiException {
      // Existing ApiException ko as-is UI tak jane dein.
      //
      // Is se statusCode, code aur server validation
      // details preserve rehti hain.
      rethrow;
    } catch (error) {
      // Unexpected errors ko standard ApiException mein
      // convert kar rahe hain.
      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}