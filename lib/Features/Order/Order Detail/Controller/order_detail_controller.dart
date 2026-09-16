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
}
