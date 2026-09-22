import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/create_ticket_model.dart';

class CreateTicketRepository {
  const CreateTicketRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Create Support Ticket
  // ============================================================

  Future<CreateTicketModel> createTicket({
    required String subject,
    required String category,
    required String priority,
    required String message,
  }) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.tickets,
      data: {
        'subject': subject,
        'category': category,
        'priority': priority,
        'message': message,
      },
    );

    final data = response.data;

    // ----------------------------------------------------------
    // Validate Response
    // ----------------------------------------------------------

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    // ----------------------------------------------------------
    // Convert API Response -> Create Ticket Model
    // ----------------------------------------------------------

    final result = CreateTicketModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final ticket = result.ticket;

      debugPrint('');
      debugPrint('========== CREATE TICKET RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      // --------------------------------------------------------
      // Ticket
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- TICKET ----------');
      debugPrint('TICKET ID: ${ticket?.id ?? 'N/A'}');
      debugPrint(
        'TICKET NUMBER: '
        '${ticket?.ticketNumber ?? 'N/A'}',
      );
      debugPrint(
        'SUBJECT: '
        '${ticket?.subject ?? 'N/A'}',
      );
      debugPrint(
        'CATEGORY: '
        '${ticket?.category ?? 'N/A'}',
      );
      debugPrint(
        'PRIORITY: '
        '${ticket?.priority ?? 'N/A'}',
      );
      debugPrint(
        'STATUS: '
        '${ticket?.status ?? 'N/A'}',
      );
      debugPrint(
        'CREATED AT: '
        '${ticket?.createdAt ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('==========================================');
      debugPrint('');
    }

    return result;
  }
}