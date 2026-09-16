
import 'package:flutter/foundation.dart';
import 'package:task_project/Services/api_url.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio_client.dart';

import '../Models/vendor_chat_detail_model.dart';

class VendorChatDetailRepository {
  const VendorChatDetailRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Chat Detail
  // ============================================================

  Future<VendorChatDetailModel> getChatDetail({
    required int chatId,
  }) async {

    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.chat(chatId),
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

    final result = VendorChatDetailModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('════════════════════════════════════════════════════');
      debugPrint('VENDOR CHAT DETAIL RESULT');
      debugPrint('════════════════════════════════════════════════════');

      debugPrint('SUCCESS: ${result.success}');
      debugPrint('CHAT ID: ${result.chat?.id ?? 'N/A'}');
      debugPrint('USER ID: ${result.chat?.userId ?? 'N/A'}');
      debugPrint('MERCHANT ID: ${result.chat?.merchantId ?? 'N/A'}');
      debugPrint('PRODUCT ID: ${result.chat?.productId ?? 'N/A'}');

      debugPrint('');
      debugPrint('---------- PRODUCT ----------');

      debugPrint(
        'PRODUCT NAME: '
        '${result.chat?.product?.name ?? 'N/A'}',
      );

      debugPrint(
        'PRODUCT PRICE: '
        '${result.chat?.product?.price ?? 0} '
        '${result.chat?.product?.currency ?? ''}',
      );

      debugPrint(
        'MERCHANT NAME: '
        '${result.chat?.product?.merchantName ?? 'N/A'}',
      );

      debugPrint('');
      debugPrint('---------- MESSAGES ----------');

      debugPrint('MESSAGE COUNT: ${result.messages.length}');

      for (final message in result.messages) {
        debugPrint(
          'MESSAGE: '
          'ID=${message.id ?? 'N/A'} | '
          'TYPE=${message.type ?? 'N/A'} | '
          'SENDER=${message.senderType ?? 'N/A'} | '
          'NAME=${message.senderName ?? 'N/A'} | '
          'TEXT=${message.message ?? ''} | '
          'READ=${message.isRead ?? 0} | '
          'DATE=${message.createdAt ?? 'N/A'}',
        );
      }

      debugPrint('');
      debugPrint('════════════════════════════════════════════════════');
      debugPrint('');
    }

    return result;
  }
}
