import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import '../Models/join_event_model.dart';

class JoinEventRepository {
  const JoinEventRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Join Event
  // ============================================================

  Future<JoinEventModel> joinEvent({
    required int eventId,
    required List<int> productIds,
    required num requestedDiscountPercentage,
    String? notes,
  }) async {
    // ----------------------------------------------------------
    // Request Body
    // ----------------------------------------------------------

    final requestBody = <String, dynamic>{
      'product_ids': productIds,
      'requested_discount_percentage': requestedDiscountPercentage,
      if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
    };

    // ----------------------------------------------------------
    // API Request
    // ----------------------------------------------------------

    final response = await _dioClient.post<Map<String, dynamic>>(
      '${ApiUrls.getEvents}/$eventId/join',
      data: requestBody,
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
    // Convert Response -> Model
    // ----------------------------------------------------------

    final result = JoinEventModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== JOIN EVENT RESULT ==========');

      debugPrint('');
      debugPrint('---------- REQUEST ----------');
      debugPrint('EVENT ID: $eventId');
      debugPrint('PRODUCT IDS: $productIds');
      debugPrint(
        'REQUESTED DISCOUNT PERCENTAGE: '
        '$requestedDiscountPercentage',
      );
      debugPrint(
        'NOTES: '
        '${notes != null && notes.trim().isNotEmpty ? notes.trim() : 'N/A'}',
      );

      debugPrint('');
      debugPrint('---------- RESPONSE ----------');
      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');
      debugPrint('CAMPAIGN ID: ${result.campaignId ?? 'N/A'}');
      debugPrint('TICKET ID: ${result.ticketId ?? 'N/A'}');
      debugPrint('STATUS: ${result.status ?? 'N/A'}');

      debugPrint('');
      debugPrint('======================================');
      debugPrint('');
    }

    return result;
  }
}
