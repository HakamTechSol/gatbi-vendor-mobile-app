import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/business_change_model.dart';
import '../Repo/business_change_repository.dart';

// ============================================================
// Business Change Provider
// ============================================================

final businessChangeControllerProvider =
    Provider<BusinessChangeController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return BusinessChangeController(
    dioClient: dioClient,
  );
});

// ============================================================
// Business Change Controller
// ============================================================

class BusinessChangeController {
  BusinessChangeController({
    required DioClient dioClient,
  }) : _repository = BusinessChangeRepository(dioClient);

  final BusinessChangeRepository _repository;

  // ==========================================================
  // Submit Business Change
  // ==========================================================

  Future<BusinessChangeModel> submitBusinessChange({
    required String fieldName,
    required String requestedValue,
    required String reason,
    File? document,
  }) async {
    try {
      final result =
          await _repository.submitBusinessChange(
        fieldName: fieldName,
        requestedValue: requestedValue,
        reason: reason,
        document: document,
      );

      return result;
    } on ApiException {
      // Server/API error ko as-is UI tak bhejenge.
      rethrow;
    } catch (error) {
      // Unexpected error.
      throw ApiException(
        message:
            'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}