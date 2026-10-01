import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/get_notifications_model.dart';
import '../Repo/get_notifications_repository.dart';

// ============================================================
// Get Notifications Provider
// ============================================================

final getNotificationsControllerProvider = Provider<GetNotificationsController>(
  (ref) {
    final dioClient = ref.watch(dioProvider);

    return GetNotificationsController(dioClient: dioClient);
  },
);

// ============================================================
// Get Notifications Controller
// ============================================================

class GetNotificationsController {
  GetNotificationsController({required DioClient dioClient})
    : _repository = GetNotificationsRepository(dioClient);

  final GetNotificationsRepository _repository;

  // ==========================================================
  // Get Notifications
  // ==========================================================

  Future<GetNotificationsModel> getNotifications({
    int? page,
    int? limit,
    String? filter,
    String? type,
  }) async {
    try {
      final result = await _repository.getNotifications(
        page: page,
        limit: limit,
        filter: filter,
        type: type,
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
