import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/ticket_send_model.dart';
import '../Repo/ticket_send_repository.dart';

// ============================================================
// Ticket Send Provider
// ============================================================

final ticketSendControllerProvider = Provider<TicketSendController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return TicketSendController(dioClient: dioClient);
});

// ============================================================
// Ticket Send Controller
// ============================================================

class TicketSendController {
  TicketSendController({required DioClient dioClient})
    : _repository = TicketSendRepository(dioClient);

  final TicketSendRepository _repository;

  // ==========================================================
  // Send Ticket Reply
  // ==========================================================

  Future<TicketSendModel> sendTicketReply({
    required int ticketId,
    required String message,
  }) async {
    try {
      final result = await _repository.sendTicketReply(
        ticketId: ticketId,
        message: message,
      );

      return result;
    } on ApiException {
      // Existing API exception ko as-is UI tak jane dein.
      //
      // Is se statusCode, code aur validation/error details
      // preserve rehti hain.
      rethrow;
    } catch (error) {
      // Unexpected errors ko standard ApiException mein
      // convert kar rahe hain.
      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}
