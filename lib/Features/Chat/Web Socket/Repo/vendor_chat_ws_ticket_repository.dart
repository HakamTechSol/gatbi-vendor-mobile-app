import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio_client.dart';
import '../Models/vendor_chat_ws_ticket_model.dart';

class VendorChatWsTicketRepository {
  VendorChatWsTicketRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get WebSocket Ticket
  // ============================================================

  Future<VendorChatWsTicketModel> getWsTicket() async {
    const endpoint = '/api/mobile/vendor/chat/ws-ticket';

    try {
      if (kDebugMode) {
        debugPrint('');
        debugPrint('====================================================');
        debugPrint('VENDOR CHAT WS TICKET API');
        debugPrint('====================================================');
        debugPrint('Method   : GET');
        debugPrint('Endpoint : $endpoint');
      }

      final response = await _dioClient.get<Map<String, dynamic>>(endpoint);

      if (response.data == null) {
        throw ApiException(
          message: 'WebSocket ticket response is empty.',
          code: 'WS_TICKET_EMPTY_RESPONSE',
        );
      }

      final result = VendorChatWsTicketModel.fromJson(response.data);

      if (kDebugMode) {
        debugPrint('Response Success : ${result.success}');
        debugPrint('Token Available  : ${result.token != null}');
        debugPrint('Expires In       : ${result.expiresIn}');
        debugPrint('Public URL       : ${result.publicUrl}');
        debugPrint('====================================================');
        debugPrint('');
      }

      if (!result.success) {
        throw ApiException(
          message: 'Unable to get WebSocket ticket.',
          code: 'WS_TICKET_FAILED',
        );
      }

      if (result.token == null || result.token!.isEmpty) {
        throw ApiException(
          message: 'WebSocket ticket token is missing.',
          code: 'WS_TICKET_TOKEN_MISSING',
        );
      }

      if (result.publicUrl == null || result.publicUrl!.isEmpty) {
        throw ApiException(
          message: 'WebSocket public URL is missing.',
          code: 'WS_TICKET_URL_MISSING',
        );
      }

      return result;
    } on ApiException {
      rethrow;
    } catch (error) {
      if (kDebugMode) {
        debugPrint('WS Ticket Repository Error: $error');
      }

      throw ApiException(
        message: 'Failed to get WebSocket ticket.',
        code: 'WS_TICKET_ERROR',
      );
    }
  }
}
