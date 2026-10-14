
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../Services/api_exception.dart';
import '../../../../../Services/dio.dart';
import '../../../../../Services/dio_client.dart';
import '../Models/get_edit_product_model.dart';
import '../Repo/get_edit_product_repo.dart';

final getEditProductControllerProvider =
    Provider<GetEditProductController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return GetEditProductController(
    dioClient: dioClient,
  );
});

class GetEditProductController {
  GetEditProductController({
    required DioClient dioClient,
  }) : _repository = GetEditProductRepository(dioClient);

  final GetEditProductRepository _repository;

  Future<GetEditProductModel> getEditProduct(int productId) async {
    try {
      return await _repository.getEditProduct(productId);
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException(
        message: 'Something went wrong while loading product details.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}
