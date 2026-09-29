import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/event_detail_model.dart';
import '../Repo/event_detail_repository.dart';

// ============================================================
// Event Detail Provider
// ============================================================

final eventDetailControllerProvider = Provider<EventDetailController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return EventDetailController(dioClient: dioClient);
});

// ============================================================
// Event Detail Controller
// ============================================================

class EventDetailController {
  EventDetailController({required DioClient dioClient})
    : _repository = EventDetailRepository(dioClient);

  final EventDetailRepository _repository;

  // ==========================================================
  // Get Event Detail
  // ==========================================================

  Future<EventDetailModel> getEventDetail(int eventId) async {
    try {
      final result = await _repository.getEventDetail(eventId);

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
