import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/order_detail_response_model.dart';
import '../Repo/order_detail_repository.dart';

final vendorOrderDetailControllerProvider =
    Provider<VendorOrderDetailController>((ref) {
      final dioClient = ref.watch(dioProvider);

      return VendorOrderDetailController(dioClient: dioClient);
    });

class VendorOrderDetailController {
  VendorOrderDetailController({required DioClient dioClient})
    : _repository = VendorOrderDetailRepository(dioClient);

  final VendorOrderDetailRepository _repository;

  // ============================================================
  // Get Order Detail
  // ============================================================

  Future<VendorOrderDetailResponseModel> getOrderDetail({
    required int orderId,
  }) async {
    try {
      final result = await _repository.getOrderDetail(orderId: orderId);

      return result;
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }

  // ============================================================
  // Request Pickup  ("Ready for Pickup")
  // POST /api/mobile/vendor/orders/{id}/request-pickup
  //
  // Returns the raw JSON response so the UI can:
  //   - branch on result['success']
  //   - show result['message'] (server is human-readable)
  //   - optionally read result['courier_shipment'] immediately
  //
  // Throws ApiException on 4xx/5xx/network errors.
  // ============================================================

  Future<Map<String, dynamic>> requestPickup({required int orderId}) async {
    try {
      return await _repository.requestPickup(orderId: orderId);
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}