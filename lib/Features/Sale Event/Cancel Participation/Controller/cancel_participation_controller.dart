import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/cancel_participation_model.dart';
import '../Repo/cancel_participation_repo.dart';

// ============================================================
// Cancel Participation Provider
// ============================================================

final cancelParticipationControllerProvider =
    Provider<CancelParticipationController>((ref) {
      final dioClient = ref.watch(dioProvider);

      return CancelParticipationController(dioClient: dioClient);
    });

// ============================================================
// Cancel Participation Controller
// ============================================================

class CancelParticipationController {
  CancelParticipationController({required DioClient dioClient})
    : _repository = CancelParticipationRepository(dioClient);

  final CancelParticipationRepository _repository;

  // ==========================================================
  // Cancel / Withdraw Participation
  // ==========================================================

  Future<CancelParticipationModel> cancelParticipation({
    required int eventId,
  }) async {
    try {
      final result = await _repository.cancelParticipation(eventId: eventId);

      return result;
    } on ApiException {
      // --------------------------------------------------------
      // Existing ApiException ko as-is UI tak jane dein.
      //
      // Is se statusCode, code aur validation/error details
      // preserve rehti hain.
      // --------------------------------------------------------

      rethrow;
    } catch (error) {
      // --------------------------------------------------------
      // Unexpected errors ko standard ApiException mein
      // convert kar rahe hain.
      // --------------------------------------------------------

      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}
