import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../Services/api_exception.dart';
import '../../../../../Services/dio.dart';
import '../../../../../Services/dio_client.dart';
import '../Models/order_status_update_response_model.dart';
import '../Repo/order_status_repo.dart';

final vendorOrderStatusControllerProvider =
    Provider<VendorOrderStatusController>((ref) {
      final dioClient = ref.watch(dioProvider);
      return VendorOrderStatusController(dioClient: dioClient);
    });

class VendorOrderStatusController {
  VendorOrderStatusController({required DioClient dioClient})
    : _repository = VendorOrderStatusRepository(dioClient);

  final VendorOrderStatusRepository _repository;

  Future<VendorOrderStatusUpdateResponseModel> updateOrderStatus({
    required int orderId,
    required String status,
    String? notes,
    String? trackingNumber,
    String? carrier,
    String? trackingUrl,
    String? estimatedDelivery,
  }) async {
    try {
      final result = await _repository.updateOrderStatus(
        orderId: orderId,
        status: status,
        notes: notes,
        trackingNumber: trackingNumber,
        carrier: carrier,
        trackingUrl: trackingUrl,
        estimatedDelivery: estimatedDelivery,
      );

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
}