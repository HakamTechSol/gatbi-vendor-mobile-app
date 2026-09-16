import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
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

    final response =
        await _dioClient.get<Map<String, dynamic>>(
      endpoint,
    );

    final data = response.data;

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    final result =
        VendorOrderDetailResponseModel.fromJson(data);

    if (kDebugMode) {
      _logResult(result);
    }

    return result;
  }

  // ============================================================
  // Debug Logging
  // ============================================================

  void _logResult(
    VendorOrderDetailResponseModel result,
  ) {
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
      debugPrint(
        'ORDER NUMBER: ${order.orderNumber ?? 'N/A'}',
      );
      debugPrint(
        'STATUS: ${order.status ?? 'N/A'}',
      );
      debugPrint(
        'PAYMENT STATUS: ${order.paymentStatus ?? 'N/A'}',
      );
      debugPrint(
        'PAYMENT METHOD: ${order.paymentMethod ?? 'N/A'}',
      );
      debugPrint(
        'CURRENCY: ${order.currency ?? 'N/A'}',
      );
      debugPrint(
        'CURRENCY SYMBOL: ${order.currencySymbol ?? 'N/A'}',
      );
      debugPrint(
        'SUBTOTAL: ${order.subtotal ?? 'N/A'}',
      );
      debugPrint(
        'SHIPPING: ${order.shipping ?? 'N/A'}',
      );
      debugPrint(
        'TAX: ${order.tax ?? 'N/A'}',
      );
      debugPrint(
        'TOTAL: ${order.total ?? 'N/A'}',
      );
      debugPrint(
        'CREATED AT: ${order.createdAt ?? 'N/A'}',
      );

      debugPrint('');
      debugPrint(
        'ITEMS COUNT: ${order.items.length}',
      );

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

      debugPrint('');
      debugPrint(
        'TRACKING COUNT: ${order.tracking.length}',
      );

      if (order.tracking.isNotEmpty) {
        for (final tracking in order.tracking) {
          debugPrint(
            'TRACKING: ${tracking.data}',
          );
        }
      } else {
        debugPrint('TRACKING: EMPTY');
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
        debugPrint(
          'ID: ${address.id ?? 'N/A'}',
        );
        debugPrint(
          'USER ID: ${address.userId ?? 'N/A'}',
        );
        debugPrint(
          'FULL NAME: ${address.fullName ?? 'N/A'}',
        );
        debugPrint(
          'PHONE: ${address.phone ?? 'N/A'}',
        );
        debugPrint(
          'ADDRESS LINE 1: '
          '${address.addressLine1 ?? 'N/A'}',
        );
        debugPrint(
          'ADDRESS LINE 2: '
          '${address.addressLine2 ?? 'N/A'}',
        );
        debugPrint(
          'CITY: ${address.city ?? 'N/A'}',
        );
        debugPrint(
          'STATE: ${address.state ?? 'N/A'}',
        );
        debugPrint(
          'POSTAL CODE: ${address.postalCode ?? 'N/A'}',
        );
        debugPrint(
          'COUNTRY: ${address.country ?? 'N/A'}',
        );
        debugPrint(
          'IS DEFAULT: ${address.isDefault ?? 'N/A'}',
        );
        debugPrint(
          'CREATED AT: ${address.createdAt ?? 'N/A'}',
        );
        debugPrint(
          'UPDATED AT: ${address.updatedAt ?? 'N/A'}',
        );
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
        debugPrint(
          'FIRST NAME: ${customer.firstName ?? 'N/A'}',
        );
        debugPrint(
          'LAST NAME: ${customer.lastName ?? 'N/A'}',
        );
        debugPrint(
          'EMAIL: ${customer.email ?? 'N/A'}',
        );
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
      debugPrint(
        'ID: ${paymentProof.id ?? 'N/A'}',
      );
      debugPrint(
        'ORDER ID: ${paymentProof.orderId ?? 'N/A'}',
      );
      debugPrint(
        'PAYMENT METHOD: '
        '${paymentProof.paymentMethod ?? 'N/A'}',
      );
      debugPrint(
        'TRANSACTION REFERENCE: '
        '${paymentProof.transactionReference ?? 'N/A'}',
      );
      debugPrint(
        'AMOUNT: ${paymentProof.amount ?? 'N/A'}',
      );
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
      debugPrint(
        'NOTES: ${paymentProof.notes ?? 'N/A'}',
      );
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