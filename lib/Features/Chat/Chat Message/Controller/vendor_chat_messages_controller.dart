import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/vendor_chat_messages_model.dart';
import '../Repo/vendor_chat_messages_repository.dart';

// ============================================================
// Provider
// ============================================================

final vendorChatMessagesControllerProvider =
    Provider.family<VendorChatMessagesController, int>((ref, chatId) {
      final dioClient = ref.watch(dioProvider);

      return VendorChatMessagesController(dioClient: dioClient);
    });

// ============================================================
// Controller
// ============================================================

class VendorChatMessagesController {
  VendorChatMessagesController({required DioClient dioClient})
    : _repository = VendorChatMessagesRepository(dioClient);

  final VendorChatMessagesRepository _repository;

  // ============================================================
  // Get Chat Messages
  // ============================================================

  Future<VendorChatMessagesModel> getChatMessages({
    required int chatId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint('');
        debugPrint('========== CHAT MESSAGES CONTROLLER ==========');
        debugPrint('GET CHAT MESSAGES');
        debugPrint('CHAT ID: $chatId');
        debugPrint('PAGE: $page');
        debugPrint('LIMIT: $limit');
      }

      final result = await _repository.getChatMessages(
        chatId: chatId,
        page: page,
        limit: limit,
      );

      if (kDebugMode) {
        debugPrint('');
        debugPrint('CHAT MESSAGES CONTROLLER SUCCESS');
        debugPrint('CHAT ID: $chatId');
        debugPrint('MESSAGES: ${result.messages.length}');
        debugPrint('==============================================');
        debugPrint('');
      }

      return result;
    } on ApiException {
      // --------------------------------------------------------
      // Existing ApiException ko as-is UI tak jane dein.
      // --------------------------------------------------------

      rethrow;
    } catch (error) {
      if (kDebugMode) {
        debugPrint('');
        debugPrint('CHAT MESSAGES CONTROLLER ERROR');
        debugPrint('CHAT ID: $chatId');
        debugPrint('ERROR: $error');
        debugPrint('==============================================');
        debugPrint('');
      }

      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}
