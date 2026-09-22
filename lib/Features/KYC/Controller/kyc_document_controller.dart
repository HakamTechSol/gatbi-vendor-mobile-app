import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/kyc_document_download_result.dart';
import '../Models/vendor_kyc_document_model.dart';
import '../Repo/kyc_document_repository.dart';

// ============================================================
// Provider
// ============================================================

final kycDocumentDownloadControllerProvider =
    Provider<KycDocumentDownloadController>((ref) {
      final dioClient = ref.watch(dioProvider);

      return KycDocumentDownloadController(
        dioClient: dioClient,
      );
    });

// ============================================================
// Controller
// ============================================================

class KycDocumentDownloadController {
  KycDocumentDownloadController({
    required DioClient dioClient,
  }) : _repository = KycDocumentDownloadRepository(dioClient);

  final KycDocumentDownloadRepository _repository;

  // ==========================================================
  // Download KYC Document
  // ==========================================================

  Future<KycDocumentDownloadResult> downloadDocument({
    required VendorKycDocumentModel document,
  }) async {
    try {
      final endpoint = document.documentEndpoint;

      if (endpoint == null || endpoint.trim().isEmpty) {
        throw const ApiException(
          message: 'Document URL is not available.',
          code: 'MISSING_DOCUMENT_URL',
        );
      }

      if (kDebugMode) {
        debugPrint('');
        debugPrint('==========================================');
        debugPrint('       KYC DOCUMENT DOWNLOAD REQUEST      ');
        debugPrint('==========================================');
        debugPrint('DOCUMENT ID   : ${document.id ?? 'N/A'}');
        debugPrint(
          'DOCUMENT TYPE : ${document.documentType ?? 'N/A'}',
        );
        debugPrint('STATUS        : ${document.status ?? 'N/A'}');
        debugPrint('ENDPOINT      : $endpoint');
        debugPrint('==========================================');
        debugPrint('');
      }

      final result = await _repository.downloadDocument(
        endpoint: endpoint,
        fallbackFileName: document.resolvedFileName,
        mimeType: document.resolvedMimeType,
      );

      if (result.bytes.isEmpty) {
        throw const ApiException(
          message: 'Downloaded document is empty.',
          code: 'EMPTY_DOCUMENT',
        );
      }

      if (kDebugMode) {
        debugPrint('');
        debugPrint('==========================================');
        debugPrint('       KYC DOCUMENT DOWNLOAD SUCCESS      ');
        debugPrint('==========================================');
        debugPrint('FILE NAME : ${result.fileName}');
        debugPrint('MIME TYPE : ${result.mimeType}');
        debugPrint('BYTES     : ${result.bytes.length}');
        debugPrint('==========================================');
        debugPrint('');
      }

      return result;
    } on ApiException {
      rethrow;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('');
        debugPrint('==========================================');
        debugPrint('    KYC DOCUMENT CONTROLLER ERROR         ');
        debugPrint('==========================================');
        debugPrint('ERROR: $error');
        debugPrint('STACK TRACE:');
        debugPrint('$stackTrace');
        debugPrint('==========================================');
        debugPrint('');
      }

      throw ApiException(
        message: 'Unable to download document. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}