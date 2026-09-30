import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/cancel_participation_model.dart';

class CancelParticipationRepository {
  const CancelParticipationRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Cancel / Withdraw Participation
  // ============================================================

  Future<CancelParticipationModel> cancelParticipation({
    required int eventId,
  }) async {
    // ----------------------------------------------------------
    // Debug Request
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('==========================================');
      debugPrint('CANCEL PARTICIPATION API REQUEST');
      debugPrint('==========================================');
      debugPrint('EVENT ID: $eventId');
      debugPrint('ENDPOINT: ${ApiUrls.cancelParticipation(eventId)}');
      debugPrint('METHOD: POST');
      debugPrint('REQUEST BODY: NONE');
      debugPrint('==========================================');
      debugPrint('');
    }

    // ----------------------------------------------------------
    // API Call
    // ----------------------------------------------------------

    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.cancelParticipation(eventId),
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

    final result = CancelParticipationModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== CANCEL PARTICIPATION RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      // --------------------------------------------------------
      // Event
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- EVENT ----------');
      debugPrint('EVENT ID: ${result.eventId ?? 'N/A'}');

      // --------------------------------------------------------
      // Campaign
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- CAMPAIGN ----------');
      debugPrint('CAMPAIGN ID: ${result.campaignId ?? 'N/A'}');

      // --------------------------------------------------------
      // Status
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- STATUS ----------');
      debugPrint('STATUS: ${result.status ?? 'N/A'}');

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('=================================================');
      debugPrint('');
    }

    return result;
  }
}
