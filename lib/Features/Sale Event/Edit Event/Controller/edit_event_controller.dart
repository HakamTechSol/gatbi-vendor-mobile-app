import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/edit_event_model.dart';
import '../Repo/edit_event_repository.dart';

// ============================================================
// Edit Event Provider
// ============================================================

final editEventControllerProvider = Provider<EditEventController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return EditEventController(dioClient: dioClient);
});

// ============================================================
// Edit Event Controller
// ============================================================

class EditEventController {
  EditEventController({required DioClient dioClient})
    : _repository = EditEventRepository(dioClient);

  final EditEventRepository _repository;

  // ==========================================================
  // Update Event
  // ==========================================================

  Future<EditEventModel> updateEvent({
    required int eventId,
    required List<int> productIds,
    required num requestedDiscountPercentage,
    String? notes,
  }) async {
    try {
      final result = await _repository.updateEvent(
        eventId: eventId,
        productIds: productIds,
        requestedDiscountPercentage: requestedDiscountPercentage,
        notes: notes,
      );

      return result;
    } on ApiException {
      // Existing ApiException ko as-is UI tak jane dein.
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
