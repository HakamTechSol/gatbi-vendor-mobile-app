import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import '../Models/ticket_send_model.dart';

class TicketSendRepository {
  const TicketSendRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Send Ticket Reply
  // ============================================================

  Future<TicketSendModel> sendTicketReply({
    required int ticketId,
    required String message,
  }) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.replyTicket(ticketId),
      data: {'message': message},
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
    // Convert API Response -> Ticket Send Model
    // ----------------------------------------------------------

    final result = TicketSendModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final ticket = result.ticket;

      debugPrint('');
      debugPrint('========== TICKET SEND RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      debugPrint(
        'RESPONSE MESSAGE: '
        '${result.message ?? 'N/A'}',
      );

      debugPrint('REQUEST TICKET ID: $ticketId');

      debugPrint('REQUEST MESSAGE: $message');

      // --------------------------------------------------------
      // Updated Ticket
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- UPDATED TICKET ----------');

      debugPrint(
        'TICKET ID: '
        '${ticket?.id ?? 'N/A'}',
      );

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

      debugPrint(
        'UPDATED AT: '
        '${ticket?.updatedAt ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // Messages
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- MESSAGES ----------');

      debugPrint(
        'MESSAGES COUNT: '
        '${ticket?.messages.length ?? 0}',
      );

      if (ticket?.messages.isNotEmpty ?? false) {
        for (final item in ticket!.messages) {
          debugPrint(
            'MESSAGE: '
            '${item.message ?? 'N/A'} | '
            'SENDER TYPE: '
            '${item.senderType ?? 'N/A'} | '
            'SENDER NAME: '
            '${item.senderName ?? 'N/A'} | '
            'CREATED: '
            '${item.createdAt ?? 'N/A'} | '
            'ID: '
            '${item.id ?? 'N/A'}',
          );
        }
      }

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('========================================');
      debugPrint('');
    }

    return result;
  }
}
