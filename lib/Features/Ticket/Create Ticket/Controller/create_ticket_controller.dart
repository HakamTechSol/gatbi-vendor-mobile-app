
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/create_ticket_model.dart';
import '../Repo/create_ticket_repository.dart';

// ============================================================
// Create Ticket Provider
// ============================================================

final createTicketControllerProvider =
    Provider<CreateTicketController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return CreateTicketController(
    dioClient: dioClient,
  );
});

// ============================================================
// Create Ticket Controller
// ============================================================

class CreateTicketController {
  CreateTicketController({
    required DioClient dioClient,
  }) : _repository = CreateTicketRepository(dioClient);

  final CreateTicketRepository _repository;

  // ==========================================================
  // Create Ticket
  // ==========================================================

  Future<CreateTicketModel> createTicket({
    required String subject,
    required String category,
    required String priority,
    required String message,
  }) async {
    try {
      final result = await _repository.createTicket(
        subject: subject,
        category: category,
        priority: priority,
        message: message,
      );

      return result;
    } on ApiException {
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