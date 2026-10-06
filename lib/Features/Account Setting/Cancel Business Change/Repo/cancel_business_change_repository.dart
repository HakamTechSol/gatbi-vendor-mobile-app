import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Model/cancel_business_change_model.dart';

class CancelBusinessChangeRepository {
  const CancelBusinessChangeRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Cancel Business Change
  // ============================================================

  Future<CancelBusinessChangeModel> cancelBusinessChange(
    int requestId,
  ) async {
    final endpoint =
        '${ApiUrls.businessChange}/$requestId/cancel';

    final response =
        await _dioClient.post<Map<String, dynamic>>(
      endpoint,
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

    final result =
        CancelBusinessChangeModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint(
        '========== CANCEL BUSINESS CHANGE RESULT ==========',
      );

      // --------------------------------------------------------
      // Request
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- REQUEST ----------');
      debugPrint('REQUEST ID: $requestId');
      debugPrint('ENDPOINT: $endpoint');

      // --------------------------------------------------------
      // Response
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- RESPONSE ----------');
      debugPrint('SUCCESS: ${result.success}');
      debugPrint(
        'MESSAGE: ${result.message ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint(
        '=====================================================',
      );
      debugPrint('');
    }

    return result;
  }
}