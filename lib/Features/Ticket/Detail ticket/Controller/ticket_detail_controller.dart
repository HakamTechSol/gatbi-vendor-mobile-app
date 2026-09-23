import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/ticket_detail_model.dart';
import '../Repo/ticket_detail_repository.dart';

// ============================================================
// Ticket Detail Provider
// ============================================================

final ticketDetailControllerProvider = Provider<TicketDetailController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return TicketDetailController(dioClient: dioClient);
});

// ============================================================
// Ticket Detail Controller
// ============================================================

class TicketDetailController {
  TicketDetailController({required DioClient dioClient})
    : _repository = TicketDetailRepository(dioClient);

  final TicketDetailRepository _repository;

  // ==========================================================
  // Get Ticket Detail
  // ==========================================================

  Future<TicketDetailModel> getTicketDetail({required int ticketId}) async {
    try {
      final result = await _repository.getTicketDetail(ticketId: ticketId);

      return result;
    } on ApiException {
      // Existing API exception ko as-is UI tak jane dein.
      //
      // Is se statusCode, code aur original API
      // error information preserve rehti hai.
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
