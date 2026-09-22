import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/ticket_list_model.dart';

class TicketListRepository {
  const TicketListRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Ticket List
  // ============================================================

  Future<TicketListModel> getTickets({int page = 1, int limit = 20}) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.tickets,
      queryParameters: {'page': page, 'limit': limit},
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
    // Convert API Response -> Ticket List Model
    // ----------------------------------------------------------

    final result = TicketListModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final pagination = result.pagination;

      debugPrint('');
      debugPrint('========== TICKET LIST RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      // --------------------------------------------------------
      // Request Pagination
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- REQUEST PAGINATION ----------');
      debugPrint('REQUEST PAGE: $page');
      debugPrint('REQUEST LIMIT: $limit');

      // --------------------------------------------------------
      // Response Pagination
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- RESPONSE PAGINATION ----------');
      debugPrint(
        'CURRENT PAGE: '
        '${pagination?.currentPage ?? 'N/A'}',
      );
      debugPrint(
        'TOTAL PAGES: '
        '${pagination?.totalPages ?? 'N/A'}',
      );
      debugPrint(
        'TOTAL ITEMS: '
        '${pagination?.totalItems ?? 'N/A'}',
      );
      debugPrint(
        'LIMIT: '
        '${pagination?.limit ?? 'N/A'}',
      );
      debugPrint(
        'HAS NEXT PAGE: '
        '${pagination?.hasNextPage ?? false}',
      );

      // --------------------------------------------------------
      // Tickets
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- TICKETS ----------');
      debugPrint(
        'TICKETS COUNT: '
        '${result.tickets.length}',
      );

      if (result.tickets.isNotEmpty) {
        for (final ticket in result.tickets) {
          debugPrint(
            'TICKET: '
            '${ticket.ticketNumber ?? 'N/A'} | '
            'ID: ${ticket.id ?? 'N/A'} | '
            'SUBJECT: ${ticket.subject ?? 'N/A'} | '
            'CATEGORY: ${ticket.category ?? 'N/A'} | '
            'PRIORITY: ${ticket.priority ?? 'N/A'} | '
            'STATUS: ${ticket.status ?? 'N/A'} | '
            'CREATED: ${ticket.createdAt ?? 'N/A'} | '
            'UPDATED: ${ticket.updatedAt ?? 'N/A'}',
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
