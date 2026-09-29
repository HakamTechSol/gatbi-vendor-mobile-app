import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/join_event_model.dart';
import '../Repo/join_event_Repo.dart';

// ============================================================
// Join Event Provider
// ============================================================

final joinEventControllerProvider = Provider<JoinEventController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return JoinEventController(dioClient: dioClient);
});

// ============================================================
// Join Event Controller
// ============================================================

class JoinEventController {
  JoinEventController({required DioClient dioClient})
    : _repository = JoinEventRepository(dioClient);

  final JoinEventRepository _repository;

  // ==========================================================
  // Join Event
  // ==========================================================

  Future<JoinEventModel> joinEvent({
    required int eventId,
    required List<int> productIds,
    required num requestedDiscountPercentage,
    String? notes,
  }) async {
    try {
      final result = await _repository.joinEvent(
        eventId: eventId,
        productIds: productIds,
        requestedDiscountPercentage: requestedDiscountPercentage,
        notes: notes,
      );

      return result;
    } on ApiException {
      // Existing API exception ko as-is UI tak jane dein.
      // Is se statusCode, code aur validation/error details
      // preserve rehti hain.
      rethrow;
    } catch (error) {
      // Unexpected errors ko standard ApiException mein convert
      // kar rahe hain.
      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}
