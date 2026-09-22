import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/vendor_kyc_model.dart';
import '../Repo/vendor_kyc_repository.dart';

// ============================================================
// Vendor KYC Provider
// ============================================================

final vendorKycControllerProvider = Provider<VendorKycController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return VendorKycController(dioClient: dioClient);
});

// ============================================================
// Vendor KYC Controller
// ============================================================

class VendorKycController {
  VendorKycController({required DioClient dioClient})
    : _repository = VendorKycRepository(dioClient);

  final VendorKycRepository _repository;

  // ==========================================================
  // Get Vendor KYC
  // ==========================================================

  Future<VendorKycModel> getVendorKyc() async {
    try {
      final result = await _repository.getVendorKyc();

      return result;
    } on ApiException {
      // Existing ApiException ko as-is UI tak jane dein.
      // Is se statusCode, code aur error details preserve
      // rehti hain.
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
