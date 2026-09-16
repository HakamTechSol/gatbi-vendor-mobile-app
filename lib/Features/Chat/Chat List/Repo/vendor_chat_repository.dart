import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/vendor_chats_model.dart';

class VendorChatRepository {
  const VendorChatRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Vendor Chats
  // ============================================================

  Future<VendorChatsModel> getChats({int page = 1, int limit = 20}) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.venderChats,
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
    // Convert API Response -> Model
    // ----------------------------------------------------------

    final result = VendorChatsModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== VENDOR CHATS RESULT ==========');

      debugPrint('SUCCESS: ${result.success}');
      debugPrint('REQUEST PAGE: $page');
      debugPrint('REQUEST LIMIT: $limit');

      debugPrint('');
      debugPrint('---------- CHATS ----------');
      debugPrint('CHATS COUNT: ${result.chats.length}');

      for (final chat in result.chats) {
        debugPrint(
          'CHAT: '
          'ID=${chat.id ?? 'N/A'} | '
          'USER=${chat.user?.name ?? 'N/A'} | '
          'PRODUCT=${chat.product?.name ?? 'N/A'} | '
          'MESSAGE=${chat.lastMessage ?? 'N/A'} | '
          'DATE=${chat.lastMessageAt ?? 'N/A'} | '
          'UNREAD=${chat.unreadCount}',
        );
      }

      debugPrint('');
      debugPrint('---------- SUMMARY ----------');
      debugPrint('UNREAD TOTAL: ${result.unreadTotal}');

      debugPrint('');
      debugPrint('---------- PAGINATION ----------');

      debugPrint(
        'CURRENT PAGE: '
        '${result.pagination?.currentPage ?? 'N/A'}',
      );

      debugPrint(
        'TOTAL PAGES: '
        '${result.pagination?.totalPages ?? 'N/A'}',
      );

      debugPrint(
        'TOTAL ITEMS: '
        '${result.pagination?.totalItems ?? 'N/A'}',
      );

      debugPrint(
        'LIMIT: '
        '${result.pagination?.limit ?? 'N/A'}',
      );

      debugPrint('');
      debugPrint('========================================');
      debugPrint('');
    }

    return result;
  }
}
