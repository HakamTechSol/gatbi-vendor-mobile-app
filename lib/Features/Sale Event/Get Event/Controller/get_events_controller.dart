import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/get_events_model.dart';
import '../Repo/get_events_repository.dart';

// ============================================================
// Events Provider
// ============================================================

final eventsControllerProvider = Provider<EventsController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return EventsController(
    dioClient: dioClient,
  );
});

// ============================================================
// Events Controller
// ============================================================

class EventsController {
  EventsController({
    required DioClient dioClient,
  }) : _repository = EventsRepository(dioClient);

  final EventsRepository _repository;

  // ==========================================================
  // Get Events
  // ==========================================================

  Future<EventsModel> getEvents() async {
    try {
      final result = await _repository.getEvents();

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