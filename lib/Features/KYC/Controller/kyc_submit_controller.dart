import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/kyc_submit_model.dart';
import '../Repo/kyc_submit_repo.dart';
import '../Services/kyc_document_file.dart';

// ============================================================
// KYC Submit Provider
// ============================================================

final kycSubmitControllerProvider =
    Provider<KycSubmitController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return KycSubmitController(
    dioClient: dioClient,
  );
});

// ============================================================
// KYC Submit Controller
// ============================================================

class KycSubmitController {
  KycSubmitController({
    required DioClient dioClient,
  }) : _repository = KycSubmitRepository(
          dioClient,
        );

  final KycSubmitRepository _repository;

  // ==========================================================
  // Submit KYC
  // ==========================================================

  Future<KycSubmitModel> submitKyc({
    required String ownerName,
    String? ownerEmail,
    required String ownerPhone,
    String? phoneCountry,
    String? authorizedPersonDesignation,
    required String tradeLicenseNumber,
    required String tradeLicenseExpiry,
    String? taxRegistrationNumber,
    required String businessAddress,
    String? website,
    String? notes,
    required KycDocumentFile tradeLicenseFile,
    required KycDocumentFile authorizedIdFile,
    KycDocumentFile? taxCertificateFile,
    KycDocumentFile? supportingDocumentFile,
  }) async {
    try {
      final result = await _repository.submitKyc(
        ownerName: ownerName,
        ownerEmail: ownerEmail,
        ownerPhone: ownerPhone,
        phoneCountry: phoneCountry,
        authorizedPersonDesignation:
            authorizedPersonDesignation,
        tradeLicenseNumber:
            tradeLicenseNumber,
        tradeLicenseExpiry:
            tradeLicenseExpiry,
        taxRegistrationNumber:
            taxRegistrationNumber,
        businessAddress:
            businessAddress,
        website: website,
        notes: notes,
        tradeLicenseFile:
            tradeLicenseFile,
        authorizedIdFile:
            authorizedIdFile,
        taxCertificateFile:
            taxCertificateFile,
        supportingDocumentFile:
            supportingDocumentFile,
      );

      return result;
    } on ApiException {
      // --------------------------------------------------------
      // Existing API exception ko as-is UI tak jane dein.
      //
      // Is se statusCode, code aur server error details
      // preserve rehti hain.
      // --------------------------------------------------------

      rethrow;
    } catch (error) {
      // --------------------------------------------------------
      // Unexpected errors
      // --------------------------------------------------------

      throw ApiException(
        message:
            'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}