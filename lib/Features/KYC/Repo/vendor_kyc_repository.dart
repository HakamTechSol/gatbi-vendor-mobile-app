import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/vendor_kyc_model.dart';

class VendorKycRepository {
  const VendorKycRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Vendor KYC
  // ============================================================

  Future<VendorKycModel> getVendorKyc() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.kyc,
    );

    final data = response.data;

    // ----------------------------------------------------------
    // Validate Response
    // ----------------------------------------------------------

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    // ----------------------------------------------------------
    // Convert API Response -> Model
    // ----------------------------------------------------------

    final result = VendorKycModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final kyc = result.kyc;
      final detail = kyc?.detail;

      debugPrint('');
      debugPrint('========== VENDOR KYC RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      // --------------------------------------------------------
      // KYC
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- KYC ----------');

      debugPrint('MERCHANT ID: ${kyc?.merchantId ?? 'N/A'}');

      debugPrint('STATUS: ${kyc?.status ?? 'N/A'}');

      debugPrint('STATUS LABEL: ${kyc?.statusLabel ?? 'N/A'}');

      debugPrint('SUBMISSION COUNT: ${kyc?.submissionCount ?? 0}');

      debugPrint('CAN RESUBMIT: ${kyc?.canResubmit ?? false}');

      debugPrint(
        'REJECTION REASON: '
        '${kyc?.rejectionReason ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // Detail
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- KYC DETAIL ----------');

      debugPrint('DETAIL AVAILABLE: ${detail != null}');

      debugPrint('ID: ${detail?.id ?? 'N/A'}');

      debugPrint('OWNER NAME: ${detail?.ownerName ?? 'N/A'}');

      debugPrint('OWNER EMAIL: ${detail?.ownerEmail ?? 'N/A'}');

      debugPrint('OWNER PHONE: ${detail?.ownerPhone ?? 'N/A'}');

      debugPrint(
        'DESIGNATION: '
        '${detail?.authorizedPersonDesignation ?? 'N/A'}',
      );

      debugPrint(
        'TRADE LICENSE: '
        '${detail?.tradeLicenseNumber ?? 'N/A'}',
      );

      debugPrint(
        'TRADE LICENSE EXPIRY: '
        '${detail?.tradeLicenseExpiry ?? 'N/A'}',
      );

      debugPrint(
        'TRN: '
        '${detail?.taxRegistrationNumber ?? 'N/A'}',
      );

      debugPrint(
        'BUSINESS ADDRESS: '
        '${detail?.businessAddress ?? 'N/A'}',
      );

      debugPrint(
        'WEBSITE: '
        '${detail?.website ?? 'N/A'}',
      );

      debugPrint(
        'NOTES: '
        '${detail?.notes ?? 'N/A'}',
      );

      debugPrint(
        'CREATED AT: '
        '${detail?.createdAt ?? 'N/A'}',
      );

      debugPrint(
        'UPDATED AT: '
        '${detail?.updatedAt ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // Field Reviews
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- FIELD REVIEWS ----------');

      debugPrint(
        'FIELD REVIEWS COUNT: '
        '${kyc?.fieldReviews.length ?? 0}',
      );

      if (kyc?.fieldReviews.isNotEmpty == true) {
        for (final review in kyc!.fieldReviews) {
          debugPrint(
            'FIELD: ${review.field ?? 'N/A'} | '
            'STATUS: ${review.status ?? 'N/A'} | '
            'COMMENT: ${review.comment ?? 'N/A'}',
          );
        }
      }

      // --------------------------------------------------------
      // Documents
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- DOCUMENTS ----------');

      debugPrint(
        'DOCUMENTS COUNT: '
        '${kyc?.documents.length ?? 0}',
      );

      if (kyc?.documents.isNotEmpty == true) {
        for (final document in kyc!.documents) {
          debugPrint(
            'DOCUMENT: '
            '${document.documentType ?? 'N/A'} | '
            'ID: ${document.id ?? 'N/A'} | '
            'STATUS: ${document.status ?? 'N/A'} | '
            'REJECTION: '
            '${document.rejectionReason ?? 'N/A'} | '
            'URL: ${document.fileUrl ?? 'N/A'} | '
            'UPLOADED: '
            '${document.uploadedAt ?? 'N/A'}',
          );
        }
      }

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('======================================');
      debugPrint('');
    }

    return result;
  }
}
