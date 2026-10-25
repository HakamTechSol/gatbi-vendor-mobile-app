import 'package:dio/dio.dart'; // ⬅️ Ye import zaroori hai Options ke liye
import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../../../../Services/token_storage.dart';
import '../Models/order_detail_response_model.dart';

class VendorOrderDetailRepository {
  const VendorOrderDetailRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Order Detail
  // ============================================================

  Future<VendorOrderDetailResponseModel> getOrderDetail({
    required int orderId,
  }) async {
    if (orderId <= 0) {
      throw const ApiException(
        message: 'Invalid order ID.',
        code: 'INVALID_ORDER_ID',
      );
    }

    final endpoint = ApiUrls.order(orderId);

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== VENDOR ORDER DETAIL REQUEST ==========');
      debugPrint('ENDPOINT: $endpoint');
      debugPrint('METHOD: GET');
      debugPrint('ORDER ID: $orderId');
      debugPrint('=================================================');
      debugPrint('');
    }

    final response = await _dioClient.get<Map<String, dynamic>>(endpoint);

    final data = response.data;

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    final result = VendorOrderDetailResponseModel.fromJson(data);

    if (kDebugMode) {
      _logResult(result);
    }

    return result;
  }

  // ============================================================
  // Request Pickup  ("Ready for Pickup" — vendor app only)
  // POST /api/mobile/vendor/orders/{id}/request-pickup
  // ============================================================

  Future<Map<String, dynamic>> requestPickup({required int orderId}) async {
    if (orderId <= 0) {
      throw const ApiException(
        message: 'Invalid order ID.',
        code: 'INVALID_ORDER_ID',
      );
    }

    final endpoint = '${ApiUrls.order(orderId)}/request-pickup';

    // SecureStorage se token nikalo
    final token = await SecureStorageService.instance.getToken();

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== VENDOR REQUEST-PICKUP ==========');
      debugPrint('ENDPOINT: $endpoint');
      debugPrint('METHOD: POST');
      debugPrint(
        'TOKEN: ${token != null ? 'FOUND (${token.length} chars)' : 'NULL'}',
      );
      debugPrint('===========================================');
      debugPrint('');
    }

    if (token == null || token.isEmpty) {
      throw const ApiException(
        message: 'Your session has expired. Please log in again.',
        code: 'UNAUTHORIZED',
      );
    }

    Map<String, dynamic>? data;

    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        endpoint,
        data: const <String, dynamic>{},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          // 🔥 FIX: Timeout 20s se badha kar 45s kar diya hai kyunki backend EMX call mein time le raha hai
          receiveTimeout: const Duration(seconds: 45),
          sendTimeout: const Duration(seconds: 45),
        ),
      );

      data = response.data;
    } on ApiException {
      rethrow;
    } on DioException catch (error) {
      // 🔥 FIX: Specific DioException handling for better UI messages
      String msg = 'Unable to request pickup. Please try again.';

      if (error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionTimeout) {
        msg =
            'The server is taking too long to respond. Please try again later.';
      } else if (error.response?.data is Map) {
        final respData = error.response!.data as Map;
        final serverMsg = respData['message']?.toString();
        if (serverMsg != null && serverMsg.trim().isNotEmpty) {
          msg = serverMsg.trim();
        }
      }

      throw ApiException(
        message: msg,
        code: 'PICKUP_REQUEST_FAILED',
        originalError: error,
      );
    } catch (error) {
      final msg = _extractErrorMessage(error);
      throw ApiException(
        message: msg,
        code: 'PICKUP_REQUEST_FAILED',
        originalError: error,
      );
    }

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== REQUEST-PICKUP RESULT ==========');
      debugPrint('SUCCESS: ${data['success']}');
      debugPrint('MESSAGE: ${data['message']}');
      debugPrint('ERROR CODE: ${data['error_code']}');

      final cs = data['courier_shipment'];
      if (cs is Map) {
        debugPrint('---------- SHIPMENT ----------');
        debugPrint('SHIPMENT NO: ${cs['shipment_no']}');
        debugPrint('CARRIER: ${cs['carrier']}');
        debugPrint('STATUS: ${cs['status']}');
        debugPrint('CARRIER STATUS: ${cs['carrier_status']}');
        debugPrint('AWB NUMBER: ${cs['awb_number']}');
      } else {
        debugPrint('SHIPMENT: NULL');
      }
      debugPrint('===========================================');
      debugPrint('');
    }

    return data;
  }

  /// Pull a human-readable message out of a DioException / generic error.
  String _extractErrorMessage(Object error) {
    try {
      final dyn = error as dynamic;
      final resp = dyn?.response;
      final respData = resp?.data;
      if (respData is Map) {
        final m1 = respData['message'];
        if (m1 is String && m1.trim().isNotEmpty) return m1.trim();
        final err = respData['error'];
        if (err is Map) {
          final m2 = err['message'];
          if (m2 is String && m2.trim().isNotEmpty) return m2.trim();
        }
      }
      final msg = dyn?.message;
      if (msg is String && msg.trim().isNotEmpty) return msg.trim();
    } catch (_) {
      // ignore
    }
    return 'Unable to request pickup. Please try again.';
  }

  // ============================================================
  // Debug Logging
  // ============================================================

  void _logResult(VendorOrderDetailResponseModel result) {
    final order = result.order;
    final paymentProof = result.paymentProof;

    debugPrint('');
    debugPrint('========== VENDOR ORDER DETAIL RESULT ==========');

    debugPrint('SUCCESS: ${result.success}');
    debugPrint('');

    // ----------------------------------------------------------
    // Order
    // ----------------------------------------------------------

    debugPrint('---------- ORDER ----------');

    if (order == null) {
      debugPrint('ORDER: NULL');
    } else {
      debugPrint('ID: ${order.id ?? 'N/A'}');

      debugPrint('ORDER NUMBER: ${order.orderNumber ?? 'N/A'}');

      debugPrint('STATUS: ${order.status ?? 'N/A'}');

      debugPrint('PAYMENT STATUS: ${order.paymentStatus ?? 'N/A'}');

      debugPrint('PAYMENT METHOD: ${order.paymentMethod ?? 'N/A'}');

      debugPrint('CURRENCY: ${order.currency ?? 'N/A'}');

      debugPrint('CURRENCY SYMBOL: ${order.currencySymbol ?? 'N/A'}');

      debugPrint('SUBTOTAL: ${order.subtotal ?? 'N/A'}');

      debugPrint('SHIPPING: ${order.shipping ?? 'N/A'}');

      debugPrint('TAX: ${order.tax ?? 'N/A'}');

      debugPrint('TOTAL: ${order.total ?? 'N/A'}');

      debugPrint('CREATED AT: ${order.createdAt ?? 'N/A'}');

      // --------------------------------------------------------
      // Ready-for-Pickup (NEW)
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- READY-FOR-PICKUP ----------');
      debugPrint('CAN REQUEST PICKUP: ${order.canRequestPickup}');
      debugPrint('PICKUP BLOCK REASON: ${order.pickupBlockReason ?? 'N/A'}');
      debugPrint('PICKUP PROVIDER: ${order.pickupProvider ?? 'N/A'}');

      // --------------------------------------------------------
      // Courier Shipment (NEW)
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- COURIER SHIPMENT ----------');

      final shipment = order.courierShipment;

      if (shipment == null) {
        debugPrint('COURIER SHIPMENT: NULL');
      } else {
        debugPrint('SHIPMENT NO: ${shipment.shipmentNo ?? 'N/A'}');
        debugPrint('PROVIDER NAME: ${shipment.providerName ?? 'N/A'}');
        debugPrint('PROVIDER: ${shipment.provider ?? 'N/A'}');
        debugPrint('CARRIER: ${shipment.carrier ?? 'N/A'}');
        debugPrint('CARRIER STATUS: ${shipment.carrierStatus ?? 'N/A'}');
        debugPrint('STATUS: ${shipment.status ?? 'N/A'}');
        debugPrint('AWB NUMBER: ${shipment.awbNumber ?? 'N/A'}');
        debugPrint('TRACKING URL: ${shipment.trackingUrl ?? 'N/A'}');
        debugPrint('RIDER NAME: ${shipment.riderName ?? 'N/A'}');
        debugPrint('RIDER PHONE: ${shipment.riderPhone ?? 'N/A'}');
        debugPrint('COD AMOUNT: ${shipment.codAmount ?? 'N/A'}');
        debugPrint('COD COLLECTED: ${shipment.codCollected ?? 'N/A'}');
        debugPrint('RECEIVER NAME: ${shipment.receiverName ?? 'N/A'}');
        debugPrint('FAILURE REASON: ${shipment.failureReason ?? 'N/A'}');
        debugPrint(
          'PICKUP SCHEDULED AT: ${shipment.pickupScheduledAt ?? 'N/A'}',
        );
        debugPrint('PICKED UP AT: ${shipment.pickedUpAt ?? 'N/A'}');
        debugPrint('DELIVERED AT: ${shipment.deliveredAt ?? 'N/A'}');
        debugPrint('IS EMX: ${shipment.isEmx}');
        debugPrint('IS INTERNAL: ${shipment.isInternal}');
        debugPrint('IS ACTIVE: ${shipment.isActive}');
        debugPrint('IS TERMINAL: ${shipment.isTerminal}');
        debugPrint('IS BOOKING FAILED: ${shipment.isBookingFailed}');
      }

      // --------------------------------------------------------
      // Items
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('ITEMS COUNT: ${order.items.length}');

      if (order.items.isNotEmpty) {
        for (final item in order.items) {
          debugPrint(
            'ITEM: '
            'ID=${item.id ?? 'N/A'} | '
            'PRODUCT ID=${item.productId ?? 'N/A'} | '
            'NAME=${item.name ?? 'N/A'} | '
            'PRICE=${item.price ?? 'N/A'} | '
            'QTY=${item.quantity ?? 'N/A'} | '
            'TOTAL=${item.total ?? 'N/A'}',
          );
        }
      } else {
        debugPrint('ITEMS: EMPTY');
      }

      // --------------------------------------------------------
      // Status History
      // --------------------------------------------------------

      debugPrint('');
      debugPrint(
        'STATUS HISTORY COUNT: '
        '${order.statusHistory.length}',
      );

      if (order.statusHistory.isNotEmpty) {
        for (final history in order.statusHistory) {
          debugPrint(
            'HISTORY: '
            'ID=${history.id ?? 'N/A'} | '
            'STATUS=${history.status ?? 'N/A'} | '
            'NOTES=${history.notes ?? 'N/A'} | '
            'UPDATED BY=${history.updatedBy ?? 'N/A'} | '
            'TYPE=${history.updatedByType ?? 'N/A'} | '
            'CREATED=${history.createdAt ?? 'N/A'} | '
            'UPDATED=${history.updatedAt ?? 'N/A'}',
          );
        }
      } else {
        debugPrint('STATUS HISTORY: EMPTY');
      }

      // --------------------------------------------------------
      // Tracking
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- TRACKING ----------');

      final tracking = order.tracking;

      if (tracking == null) {
        debugPrint('TRACKING: NULL');
      } else {
        debugPrint('ID: ${tracking.id ?? 'N/A'}');

        debugPrint('ORDER ID: ${tracking.orderId ?? 'N/A'}');

        debugPrint(
          'TRACKING NUMBER: '
          '${tracking.trackingNumber ?? 'N/A'}',
        );

        debugPrint(
          'CARRIER: '
          '${tracking.carrier ?? 'N/A'}',
        );

        debugPrint(
          'TRACKING URL: '
          '${tracking.trackingUrl ?? 'N/A'}',
        );

        debugPrint(
          'ESTIMATED DELIVERY: '
          '${tracking.estimatedDelivery ?? 'N/A'}',
        );

        debugPrint(
          'LAST LOCATION: '
          '${tracking.lastLocation ?? 'N/A'}',
        );

        debugPrint(
          'LAST UPDATE: '
          '${tracking.lastUpdate ?? 'N/A'}',
        );

        debugPrint(
          'VALID TRACKING: '
          '${tracking.hasValidTracking}',
        );
      }

      // --------------------------------------------------------
      // Shipping Address
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- SHIPPING ADDRESS ----------');

      final address = order.shippingAddress;

      if (address == null) {
        debugPrint('SHIPPING ADDRESS: NULL');
      } else {
        debugPrint('ID: ${address.id ?? 'N/A'}');

        debugPrint('USER ID: ${address.userId ?? 'N/A'}');

        debugPrint('FULL NAME: ${address.fullName ?? 'N/A'}');

        debugPrint('PHONE: ${address.phone ?? 'N/A'}');

        debugPrint(
          'ADDRESS LINE 1: '
          '${address.addressLine1 ?? 'N/A'}',
        );

        debugPrint(
          'ADDRESS LINE 2: '
          '${address.addressLine2 ?? 'N/A'}',
        );

        debugPrint('CITY: ${address.city ?? 'N/A'}');

        debugPrint('STATE: ${address.state ?? 'N/A'}');

        debugPrint('POSTAL CODE: ${address.postalCode ?? 'N/A'}');

        debugPrint('COUNTRY: ${address.country ?? 'N/A'}');

        debugPrint('IS DEFAULT: ${address.isDefault ?? 'N/A'}');

        debugPrint('CREATED AT: ${address.createdAt ?? 'N/A'}');

        debugPrint('UPDATED AT: ${address.updatedAt ?? 'N/A'}');
      }

      // --------------------------------------------------------
      // Customer
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- CUSTOMER ----------');

      final customer = order.customer;

      if (customer == null) {
        debugPrint('CUSTOMER: NULL');
      } else {
        debugPrint('FIRST NAME: ${customer.firstName ?? 'N/A'}');

        debugPrint('LAST NAME: ${customer.lastName ?? 'N/A'}');

        debugPrint('EMAIL: ${customer.email ?? 'N/A'}');
      }
    }

    // ----------------------------------------------------------
    // Payment Proof
    // ----------------------------------------------------------

    debugPrint('');
    debugPrint('---------- PAYMENT PROOF ----------');

    if (paymentProof == null) {
      debugPrint('PAYMENT PROOF: NULL');
    } else {
      debugPrint('ID: ${paymentProof.id ?? 'N/A'}');

      debugPrint('ORDER ID: ${paymentProof.orderId ?? 'N/A'}');

      debugPrint(
        'PAYMENT METHOD: '
        '${paymentProof.paymentMethod ?? 'N/A'}',
      );

      debugPrint(
        'TRANSACTION REFERENCE: '
        '${paymentProof.transactionReference ?? 'N/A'}',
      );

      debugPrint('AMOUNT: ${paymentProof.amount ?? 'N/A'}');

      debugPrint(
        'PAYMENT DATE: '
        '${paymentProof.paymentDate ?? 'N/A'}',
      );

      debugPrint(
        'BANK NAME: '
        '${paymentProof.bankName ?? 'N/A'}',
      );

      debugPrint(
        'ACCOUNT HOLDER: '
        '${paymentProof.accountHolderName ?? 'N/A'}',
      );

      debugPrint(
        'VERIFICATION STATUS: '
        '${paymentProof.verificationStatus ?? 'N/A'}',
      );

      debugPrint(
        'REJECTION REASON: '
        '${paymentProof.rejectionReason ?? 'N/A'}',
      );

      debugPrint('NOTES: ${paymentProof.notes ?? 'N/A'}');

      debugPrint(
        'PROOF IMAGE URL: '
        '${paymentProof.proofImageUrl ?? 'N/A'}',
      );

      debugPrint(
        'CREATED AT: '
        '${paymentProof.createdAt ?? 'N/A'}',
      );
    }

    debugPrint('');
    debugPrint('=================================================');
    debugPrint('');
  }
}
