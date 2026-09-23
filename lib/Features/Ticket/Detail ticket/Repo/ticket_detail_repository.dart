import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import '../Models/ticket_detail_model.dart';

class TicketDetailRepository {
  const TicketDetailRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Ticket Detail
  // ============================================================

  Future<TicketDetailModel> getTicketDetail({
    required int ticketId,
  }) async {
    final response =
        await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.ticket(ticketId),
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
    // Convert API Response -> Ticket Detail Model
    // ----------------------------------------------------------

    final result = TicketDetailModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final ticket = result.ticket;

      debugPrint('');
      debugPrint(
        '========== TICKET DETAIL RESULT ==========',
      );

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');
      debugPrint('REQUEST TICKET ID: $ticketId');

      // --------------------------------------------------------
      // Ticket
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- TICKET ----------');

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
        for (final message in ticket!.messages) {
          debugPrint(
            'MESSAGE: '
            '${message.message ?? 'N/A'} | '
            'SENDER TYPE: '
            '${message.senderType ?? 'N/A'} | '
            'SENDER NAME: '
            '${message.senderName ?? 'N/A'} | '
            'CREATED: '
            '${message.createdAt ?? 'N/A'} | '
            'ID: '
            '${message.id ?? 'N/A'}',
          );
        }
      }

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint(
        '============================================',
      );
      debugPrint('');
    }

    return result;
  }
}