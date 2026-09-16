import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import '../Models/orders_response_model.dart';

class VendorOrdersRepository {
  const VendorOrdersRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // GET VENDOR ORDERS
  // ============================================================

  Future<VendorOrdersResponseModel> getOrders({
    int page = 1,
    int limit = 20,
    String? status,
    String? search,
  }) async {
    final queryParameters = <String, dynamic>{'page': page, 'limit': limit};

    // ------------------------------------------------------------
    // Status Filter
    // ------------------------------------------------------------

    if (status != null && status.trim().isNotEmpty) {
      queryParameters['status'] = status.trim().toLowerCase();
    }

    // ------------------------------------------------------------
    // Search
    // ------------------------------------------------------------

    if (search != null && search.trim().isNotEmpty) {
      queryParameters['search'] = search.trim();
    }

    if (kDebugMode) {
      debugPrint('');
      debugPrint('════════════════════════════════════════');
      debugPrint('        VENDOR ORDERS API REQUEST');
      debugPrint('════════════════════════════════════════');
      debugPrint('METHOD       : GET');
      debugPrint('ENDPOINT     : ${ApiUrls.orders}');
      debugPrint('PAGE         : $page');
      debugPrint('LIMIT        : $limit');
      debugPrint('STATUS       : ${status ?? 'ALL'}');
      debugPrint(
        'SEARCH       : ${search?.isNotEmpty == true ? search : 'NONE'}',
      );
      debugPrint('QUERY        : $queryParameters');
      debugPrint('════════════════════════════════════════');
      debugPrint('');
    }

    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.orders,
      queryParameters: queryParameters,
    );

    final data = response.data;

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    final result = VendorOrdersResponseModel.fromJson(data);

    if (kDebugMode) {
      final pagination = result.pagination;

      debugPrint('');
      debugPrint('════════════════════════════════════════');
      debugPrint('        VENDOR ORDERS API RESPONSE');
      debugPrint('════════════════════════════════════════');
      debugPrint('SUCCESS      : ${result.success}');
      debugPrint('ORDERS       : ${result.orders.length}');
      debugPrint('');
      debugPrint('CURRENT PAGE : ${pagination?.currentPage ?? 'N/A'}');
      debugPrint('TOTAL PAGES  : ${pagination?.totalPages ?? 'N/A'}');
      debugPrint('TOTAL ITEMS  : ${pagination?.totalItems ?? 'N/A'}');
      debugPrint('LIMIT        : ${pagination?.limit ?? 'N/A'}');
      debugPrint('');

      for (final order in result.orders) {
        debugPrint(
          'ORDER → '
          '${order.orderNumber ?? 'N/A'} | '
          'STATUS: ${order.status ?? 'N/A'} | '
          'CUSTOMER: ${order.customer?.name ?? 'N/A'} | '
          'TOTAL: ${order.vendorTotal ?? 0} | '
          'QTY: ${order.vendorQuantity ?? 0}',
        );
      }

      debugPrint('════════════════════════════════════════');
      debugPrint('');
    }

    return result;
  }

  // ============================================================
  // STATUS FILTER
  // ============================================================

  Future<VendorOrdersResponseModel> getOrdersByStatus({
    required String status,
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    return getOrders(page: page, limit: limit, status: status, search: search);
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Future<VendorOrdersResponseModel> searchOrders({
    required String search,
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    return getOrders(page: page, limit: limit, status: status, search: search);
  }
}
