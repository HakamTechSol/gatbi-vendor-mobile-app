import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/kyc_submit_model.dart';
import '../Services/kyc_document_file.dart';

class KycSubmitRepository {
  const KycSubmitRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Submit KYC
  // ============================================================

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
    // ============================================================
    // FORM DATA
    // ============================================================

    final formData = FormData();

    // ============================================================
    // TEXT FIELDS
    // ============================================================

    formData.fields.add(MapEntry('owner_name', ownerName.trim()));

    // ------------------------------------------------------------
    // Owner Email
    // ------------------------------------------------------------

    if (ownerEmail != null && ownerEmail.trim().isNotEmpty) {
      formData.fields.add(MapEntry('owner_email', ownerEmail.trim()));
    }

    // ------------------------------------------------------------
    // Owner Phone
    // ------------------------------------------------------------

    formData.fields.add(MapEntry('owner_phone', ownerPhone.trim()));

    // ------------------------------------------------------------
    // Phone Country
    // ------------------------------------------------------------

    if (phoneCountry != null && phoneCountry.trim().isNotEmpty) {
      formData.fields.add(MapEntry('phone_country', phoneCountry.trim()));
    }

    // ------------------------------------------------------------
    // Designation
    // ------------------------------------------------------------

    if (authorizedPersonDesignation != null &&
        authorizedPersonDesignation.trim().isNotEmpty) {
      formData.fields.add(
        MapEntry(
          'authorized_person_designation',
          authorizedPersonDesignation.trim(),
        ),
      );
    }

    // ------------------------------------------------------------
    // Trade License Number
    // ------------------------------------------------------------

    formData.fields.add(
      MapEntry('trade_license_number', tradeLicenseNumber.trim()),
    );

    // ------------------------------------------------------------
    // Trade License Expiry
    // ------------------------------------------------------------

    formData.fields.add(
      MapEntry('trade_license_expiry', tradeLicenseExpiry.trim()),
    );

    // ------------------------------------------------------------
    // Tax Registration Number
    // ------------------------------------------------------------

    if (taxRegistrationNumber != null &&
        taxRegistrationNumber.trim().isNotEmpty) {
      formData.fields.add(
        MapEntry('tax_registration_number', taxRegistrationNumber.trim()),
      );
    }

    // ------------------------------------------------------------
    // Business Address
    // ------------------------------------------------------------

    formData.fields.add(MapEntry('business_address', businessAddress.trim()));

    // ------------------------------------------------------------
    // Website
    // ------------------------------------------------------------

    if (website != null && website.trim().isNotEmpty) {
      formData.fields.add(MapEntry('website', website.trim()));
    }

    // ------------------------------------------------------------
    // Notes
    // ------------------------------------------------------------

    if (notes != null && notes.trim().isNotEmpty) {
      formData.fields.add(MapEntry('notes', notes.trim()));
    }

    // ============================================================
    // REQUIRED FILES
    // ============================================================

    formData.files.add(
      MapEntry(
        'trade_license_file',
        await _createMultipartFile(tradeLicenseFile),
      ),
    );

    formData.files.add(
      MapEntry(
        'authorized_id_file',
        await _createMultipartFile(authorizedIdFile),
      ),
    );

    // ============================================================
    // OPTIONAL TAX CERTIFICATE
    // ============================================================

    if (taxCertificateFile != null) {
      formData.files.add(
        MapEntry(
          'tax_certificate_file',
          await _createMultipartFile(taxCertificateFile),
        ),
      );
    }

    // ============================================================
    // OPTIONAL SUPPORTING DOCUMENT
    // ============================================================

    if (supportingDocumentFile != null) {
      formData.files.add(
        MapEntry(
          'supporting_document_file',
          await _createMultipartFile(supportingDocumentFile),
        ),
      );
    }

    // ============================================================
    // DEBUG REQUEST LOG
    // ============================================================

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== KYC SUBMIT REQUEST ==========');

      debugPrint('ENDPOINT: ${ApiUrls.kycSubmit}');

      debugPrint('');
      debugPrint('---------- FIELDS ----------');

      for (final field in formData.fields) {
        debugPrint('${field.key}: ${field.value}');
      }

      debugPrint('');
      debugPrint('---------- FILES ----------');

      for (final file in formData.files) {
        debugPrint(
          '${file.key}: '
          '${file.value.filename ?? 'N/A'}',
        );
      }

      debugPrint('');
      debugPrint('========================================');
      debugPrint('');
    }

    // ============================================================
    // API REQUEST
    // ============================================================

    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.kycSubmit,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    final data = response.data;

    // ============================================================
    // VALIDATE RESPONSE
    // ============================================================

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    // ============================================================
    // CONVERT RESPONSE -> MODEL
    // ============================================================

    final result = KycSubmitModel.fromJson(data);

    // ============================================================
    // DEBUG RESPONSE LOG
    // ============================================================

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== KYC SUBMIT RESULT ==========');

      debugPrint('SUCCESS: ${result.success}');

      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      debugPrint('KYC STATUS: ${result.kycStatus ?? 'N/A'}');

      debugPrint('');
      debugPrint('=======================================');
      debugPrint('');
    }

    return result;
  }

  // ============================================================
  // CREATE MULTIPART FILE
  // ============================================================

  Future<MultipartFile> _createMultipartFile(KycDocumentFile file) async {
    return MultipartFile.fromFile(file.path, filename: file.name);
  }
}
