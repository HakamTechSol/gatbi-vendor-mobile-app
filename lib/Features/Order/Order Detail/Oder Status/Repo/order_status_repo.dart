import 'package:flutter/foundation.dart';

import '../../../../../Services/api_exception.dart';
import '../../../../../Services/api_url.dart';
import '../../../../../Services/dio_client.dart';
import '../Models/order_status_update_response_model.dart';

class VendorOrderStatusRepository {
  const VendorOrderStatusRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Update Order Status
  // ============================================================

  Future<VendorOrderStatusUpdateResponseModel> updateOrderStatus({
    required int orderId,
    required String status,
    String? notes,
    String? trackingNumber,
    String? carrier,
    String? trackingUrl,
    String? estimatedDelivery,
  }) async {
    // ----------------------------------------------------------
    // Validate Order ID
    // ----------------------------------------------------------

    if (orderId <= 0) {
      throw const ApiException(
        message: 'Invalid order ID.',
        code: 'INVALID_ORDER_ID',
      );
    }

    // ----------------------------------------------------------
    // Validate Status
    // ----------------------------------------------------------

    final cleanStatus = status.trim().toLowerCase();

    if (cleanStatus.isEmpty) {
      throw const ApiException(
        message: 'Order status is required.',
        code: 'INVALID_STATUS',
      );
    }

    // ----------------------------------------------------------
    // Build Request Body
    // ----------------------------------------------------------

    final body = <String, dynamic>{'status': cleanStatus};

    // ----------------------------------------------------------
    // Notes
    // ----------------------------------------------------------

    final cleanNotes = notes?.trim();

    if (cleanNotes != null && cleanNotes.isNotEmpty) {
      body['notes'] = cleanNotes;
    }

    // ----------------------------------------------------------
    // Tracking Number
    // ----------------------------------------------------------

    final cleanTrackingNumber = trackingNumber?.trim();

    if (cleanTrackingNumber != null && cleanTrackingNumber.isNotEmpty) {
      body['tracking_number'] = cleanTrackingNumber;
    }

    // ----------------------------------------------------------
    // Carrier
    // ----------------------------------------------------------

    final cleanCarrier = carrier?.trim();

    if (cleanCarrier != null && cleanCarrier.isNotEmpty) {
      body['carrier'] = cleanCarrier;
    }

    // ----------------------------------------------------------
    // Tracking URL
    // ----------------------------------------------------------

    final cleanTrackingUrl = trackingUrl?.trim();

    if (cleanTrackingUrl != null && cleanTrackingUrl.isNotEmpty) {
      body['tracking_url'] = cleanTrackingUrl;
    }

    // ----------------------------------------------------------
    // Estimated Delivery
    // ----------------------------------------------------------

    final cleanEstimatedDelivery = estimatedDelivery?.trim();

    if (cleanEstimatedDelivery != null && cleanEstimatedDelivery.isNotEmpty) {
      body['estimated_delivery'] = cleanEstimatedDelivery;
    }

    // ----------------------------------------------------------
    // Endpoint
    // ----------------------------------------------------------

    final endpoint = ApiUrls.updateOrderStatus(orderId);

    // ----------------------------------------------------------
    // Debug Request
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint(
        '════════════════════════════════════════════════════════════',
      );
      debugPrint('UPDATE ORDER STATUS API');
      debugPrint(
        '════════════════════════════════════════════════════════════',
      );

      debugPrint('METHOD: POST');
      debugPrint('ENDPOINT: $endpoint');
      debugPrint('ORDER ID: $orderId');
      debugPrint('STATUS: $cleanStatus');
      debugPrint('NOTES: ${cleanNotes ?? 'N/A'}');
      debugPrint(
        'TRACKING NUMBER: '
        '${cleanTrackingNumber ?? 'N/A'}',
      );
      debugPrint(
        'CARRIER: '
        '${cleanCarrier ?? 'N/A'}',
      );
      debugPrint(
        'TRACKING URL: '
        '${cleanTrackingUrl ?? 'N/A'}',
      );
      debugPrint(
        'ESTIMATED DELIVERY: '
        '${cleanEstimatedDelivery ?? 'N/A'}',
      );

      debugPrint('');
      debugPrint('REQUEST BODY:');
      debugPrint(body.toString());

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );
      debugPrint('');
    }

    // ----------------------------------------------------------
    // API Request
    // ----------------------------------------------------------

    final response = await _dioClient.post<Map<String, dynamic>>(
      endpoint,
      data: body,
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

    final result = VendorOrderStatusUpdateResponseModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Response
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== UPDATE ORDER STATUS RESULT ==========');

      debugPrint('SUCCESS: ${result.success}');

      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      debugPrint('ORDER ID: ${result.order?.id ?? 'N/A'}');

      debugPrint(
        'ORDER NUMBER: '
        '${result.order?.orderNumber ?? 'N/A'}',
      );

      debugPrint(
        'OLD/NEW STATUS: '
        '${result.order?.status ?? 'N/A'}',
      );

      debugPrint(
        'PAYMENT STATUS: '
        '${result.order?.paymentStatus ?? 'N/A'}',
      );

      debugPrint(
        'PAYMENT METHOD: '
        '${result.order?.paymentMethod ?? 'N/A'}',
      );

      debugPrint(
        'ITEMS: '
        '${result.order?.items.length ?? 0}',
      );

      debugPrint(
        'STATUS HISTORY: '
        '${result.order?.statusHistory.length ?? 0}',
      );


      debugPrint('================================================');
      debugPrint('');
    }

    return result;
  }
}
