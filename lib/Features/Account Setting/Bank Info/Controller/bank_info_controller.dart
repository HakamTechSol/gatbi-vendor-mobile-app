import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/bank_info_model.dart';
import '../Repo/bank_info_repo.dart';

// ============================================================
// Bank Info Provider
// ============================================================

final bankInfoControllerProvider = Provider<BankInfoController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return BankInfoController(dioClient: dioClient);
});

// ============================================================
// Bank Info Controller
// ============================================================

class BankInfoController {
  BankInfoController({required DioClient dioClient})
    : _repository = BankInfoRepository(dioClient);

  final BankInfoRepository _repository;

  // ==========================================================
  // Update Bank Information
  // ==========================================================

  Future<BankInfoModel> updateBankInfo({
    required String bankAccountName,
    required String bankAccountNumber,
  }) async {
    try {
      final result = await _repository.updateBankInfo(
        bankAccountName: bankAccountName,
        bankAccountNumber: bankAccountNumber,
      );

      return result;
    } on ApiException {
      // Existing API exception ko as-is UI tak jane dein.
      // Is se statusCode, code aur validation/error details
      // preserve rehti hain.
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
