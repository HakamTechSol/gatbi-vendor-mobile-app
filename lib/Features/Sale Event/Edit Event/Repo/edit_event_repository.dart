import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import '../Models/edit_event_model.dart';

class EditEventRepository {
  const EditEventRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Update Event Participation
  // ============================================================

  Future<EditEventModel> updateEvent({
    required int eventId,
    required List<int> productIds,
    required num requestedDiscountPercentage,
    String? notes,
  }) async {
    final requestBody = <String, dynamic>{
      'product_ids': productIds,
      'requested_discount_percentage': requestedDiscountPercentage,
      if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
    };

    // ----------------------------------------------------------
    // Debug Request
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== UPDATE EVENT REQUEST ==========');
      debugPrint('EVENT ID: $eventId');
      debugPrint('ENDPOINT: ${ApiUrls.updateEvent(eventId)}');
      debugPrint('PRODUCT IDS: $productIds');
      debugPrint('REQUESTED DISCOUNT: $requestedDiscountPercentage');
      debugPrint('NOTES: ${notes ?? 'N/A'}');
      debugPrint('REQUEST BODY: $requestBody');
      debugPrint('==========================================');
      debugPrint('');
    }

    // ----------------------------------------------------------
    // API Request
    // ----------------------------------------------------------

    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.updateEvent(eventId),
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
    // Parse Response
    // ----------------------------------------------------------

    final result = EditEventModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Response
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== UPDATE EVENT RESULT ==========');
      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');
      debugPrint('CAMPAIGN ID: ${result.campaignId ?? 'N/A'}');
      debugPrint('STATUS: ${result.status ?? 'N/A'}');
      debugPrint('PRODUCT IDS: ${result.productIds}');
      debugPrint(
        'REQUESTED DISCOUNT: '
        '${result.requestedDiscountPercentage ?? 'N/A'}',
      );
      debugPrint('PRODUCT COUNT: ${result.products.length}');
      debugPrint('=========================================');
      debugPrint('');
    }

    return result;
  }
}
