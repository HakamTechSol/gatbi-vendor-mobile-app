import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio_client.dart';

import '../Models/vendor_chat_messages_model.dart';

class VendorChatMessagesRepository {
  const VendorChatMessagesRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Chat Messages
  // ============================================================

  Future<VendorChatMessagesModel> getChatMessages({
    required int chatId,
    int page = 1,
    int limit = 50,
  }) async {
    final endpoint = '/api/mobile/vendor/chat/$chatId/messages';

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== VENDOR CHAT MESSAGES API ==========');
      debugPrint('METHOD: GET');
      debugPrint('ENDPOINT: $endpoint');
      debugPrint('CHAT ID: $chatId');
      debugPrint('PAGE: $page');
      debugPrint('LIMIT: $limit');
    }

    final response = await _dioClient.get<Map<String, dynamic>>(
      endpoint,
      queryParameters: {'page': page, 'limit': limit},
    );

    final data = response.data;

    // ==========================================================
    // Validate Response
    // ==========================================================

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    // ==========================================================
    // Convert JSON -> Model
    // ==========================================================

    final result = VendorChatMessagesModel.fromJson(data);

    // ==========================================================
    // Debug Logs
    // ==========================================================

    if (kDebugMode) {
      debugPrint('');
      debugPrint('---------- CHAT MESSAGES RESULT ----------');

      debugPrint('SUCCESS: ${result.success}');

      debugPrint('CHAT ID: $chatId');

      debugPrint('MESSAGES COUNT: ${result.messages.length}');

      debugPrint(
        'CURRENT PAGE: '
        '${result.pagination?.currentPage ?? 1}',
      );

      debugPrint(
        'TOTAL ITEMS: '
        '${result.pagination?.totalItems ?? 0}',
      );

      debugPrint(
        'LIMIT: '
        '${result.pagination?.limit ?? limit}',
      );

      if (result.messages.isNotEmpty) {
        debugPrint('');
        debugPrint('---------- MESSAGES ----------');

        for (final message in result.messages) {
          debugPrint(
            'MESSAGE: '
            'ID=${message.id ?? 'N/A'} | '
            'SENDER=${message.senderName ?? 'N/A'} | '
            'TYPE=${message.type ?? 'N/A'} | '
            'MESSAGE=${message.message ?? ''} | '
            'DATE=${message.createdAt ?? 'N/A'}',
          );
        }
      }

      debugPrint('============================================');
      debugPrint('');
    }

    return result;
  }
}
