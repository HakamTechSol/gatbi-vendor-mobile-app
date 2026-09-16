import 'package:flutter/foundation.dart';
import 'package:task_project/Services/api_url.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio_client.dart';

import '../Models/vendor_send_message_model.dart';

class VendorChatMessageRepository {
  const VendorChatMessageRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Send Message
  // ============================================================

  Future<VendorSendMessageModel> sendMessage({
    required int chatId,
    required String message,
  }) async {

    final trimmedMessage = message.trim();

    // ----------------------------------------------------------
    // Validate Message
    // ----------------------------------------------------------

    if (trimmedMessage.isEmpty) {
      throw const ApiException(
        message: 'Message cannot be empty.',
        code: 'EMPTY_MESSAGE',
      );
    }

    // ----------------------------------------------------------
    // Debug Request
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('════════════════════════════════════════════════════');
      debugPrint('VENDOR CHAT: SEND MESSAGE');
      debugPrint('════════════════════════════════════════════════════');
      debugPrint('CHAT ID: $chatId');
      debugPrint('MESSAGE: $trimmedMessage');
    }

    // ----------------------------------------------------------
    // API Request
    // ----------------------------------------------------------

    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.sendChatMessage(chatId),
      data: {'message': trimmedMessage},
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
    // Convert JSON -> Model
    // ----------------------------------------------------------

    final result = VendorSendMessageModel.fromJson(data);

    // ----------------------------------------------------------
    // Validate API Success
    // ----------------------------------------------------------

    if (!result.success) {
      throw ApiException(
        message: result.message?.isNotEmpty == true
            ? result.message!
            : 'Unable to send message.',
        code: 'SEND_MESSAGE_FAILED',
      );
    }

    // ----------------------------------------------------------
    // Validate Message Data
    // ----------------------------------------------------------

    if (result.data == null) {
      throw const ApiException(
        message: 'Message was sent but no message data was returned.',
        code: 'MESSAGE_DATA_MISSING',
      );
    }

    // ----------------------------------------------------------
    // Debug Response
    // ----------------------------------------------------------

    if (kDebugMode) {
      final sentMessage = result.data;

      debugPrint('');
      debugPrint('---------- SEND MESSAGE RESULT ----------');
      debugPrint('SUCCESS: ${result.success}');
      debugPrint('RESPONSE MESSAGE: ${result.message ?? 'N/A'}');
      debugPrint('MESSAGE ID: ${sentMessage?.id ?? 'N/A'}');
      debugPrint(
        'CONVERSATION ID: '
        '${sentMessage?.conversationId ?? 'N/A'}',
      );
      debugPrint(
        'SENDER ID: '
        '${sentMessage?.senderId ?? 'N/A'}',
      );
      debugPrint(
        'SENDER TYPE: '
        '${sentMessage?.senderType ?? 'N/A'}',
      );
      debugPrint(
        'MESSAGE: '
        '${sentMessage?.message ?? 'N/A'}',
      );
      debugPrint(
        'IS READ: '
        '${sentMessage?.isRead ?? 0}',
      );
      debugPrint(
        'CREATED AT: '
        '${sentMessage?.createdAt ?? 'N/A'}',
      );
      debugPrint(
        'UPDATED AT: '
        '${sentMessage?.updatedAt ?? 'N/A'}',
      );
      debugPrint('════════════════════════════════════════════════════');
      debugPrint('');
    }

    return result;
  }
}
