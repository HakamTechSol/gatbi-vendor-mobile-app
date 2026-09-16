import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/vendor_chat_message_model.dart';
import '../Repo/vendor_chat_message_repository.dart';
import 'vendor_chat_message_state.dart';

// ============================================================
// Provider
// ============================================================

final vendorChatMessageControllerProvider =
    StateNotifierProvider.family<
      VendorChatMessageController,
      VendorChatMessageState,
      int
    >((ref, chatId) {
      final dioClient = ref.watch(dioProvider);

      return VendorChatMessageController(dioClient: dioClient, chatId: chatId);
    });

// ============================================================
// Controller
// ============================================================

class VendorChatMessageController
    extends StateNotifier<VendorChatMessageState> {
  VendorChatMessageController({
    required DioClient dioClient,
    required int chatId,
  }) : _repository = VendorChatMessageRepository(dioClient),
       _chatId = chatId,
       super(const VendorChatMessageState());

  final VendorChatMessageRepository _repository;

  final int _chatId;

  // ============================================================
  // Internal Protection
  // ============================================================

  bool _requestInProgress = false;

  // ============================================================
  // Send Message
  // ============================================================

  Future<VendorChatMessageModel?> sendMessage({required String message}) async {
    // ----------------------------------------------------------
    // Prevent duplicate requests
    // ----------------------------------------------------------

    if (_requestInProgress) {
      debugPrint(
        'VENDOR CHAT MESSAGE: Send ignored - request already running.',
      );

      return null;
    }

    final trimmedMessage = message.trim();

    // ----------------------------------------------------------
    // Local Validation
    // ----------------------------------------------------------

    if (trimmedMessage.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Message cannot be empty.',
        clearSuccess: true,
      );

      return null;
    }

    _requestInProgress = true;

    // ----------------------------------------------------------
    // Sending State
    // ----------------------------------------------------------

    state = state.copyWith(
      isSending: true,
      clearError: true,
      clearSuccess: true,
      clearSentMessage: true,
    );

    debugPrint('');
    debugPrint('╔════════════════════════════════════════════════════╗');
    debugPrint('║ VENDOR CHAT MESSAGE: SENDING                      ║');
    debugPrint('╚════════════════════════════════════════════════════╝');

    debugPrint('CHAT ID: $_chatId');
    debugPrint('MESSAGE: $trimmedMessage');

    try {
      final result = await _repository.sendMessage(
        chatId: _chatId,
        message: trimmedMessage,
      );

      final sentMessage = result.data;

      if (sentMessage == null) {
        state = state.copyWith(
          isSending: false,
          errorMessage: 'Message data was not returned by server.',
          clearSuccess: true,
        );

        return null;
      }

      // --------------------------------------------------------
      // Success
      // --------------------------------------------------------

      state = state.copyWith(
        isSending: false,
        sentMessage: sentMessage,
        successMessage: result.message ?? 'Message sent.',
        clearError: true,
      );

      debugPrint('');
      debugPrint('╔════════════════════════════════════════════════════╗');
      debugPrint('║ VENDOR CHAT MESSAGE: SENT SUCCESSFULLY            ║');
      debugPrint('╚════════════════════════════════════════════════════╝');

      debugPrint('MESSAGE ID: ${sentMessage.id ?? 'N/A'}');
      debugPrint(
        'CONVERSATION ID: '
        '${sentMessage.conversationId ?? 'N/A'}',
      );
      debugPrint(
        'SENDER ID: '
        '${sentMessage.senderId ?? 'N/A'}',
      );
      debugPrint(
        'SENDER TYPE: '
        '${sentMessage.senderType ?? 'N/A'}',
      );
      debugPrint(
        'MESSAGE: '
        '${sentMessage.message ?? 'N/A'}',
      );
      debugPrint(
        'CREATED AT: '
        '${sentMessage.createdAt ?? 'N/A'}',
      );

      return sentMessage;
    } on ApiException catch (error) {
      state = state.copyWith(
        isSending: false,
        errorMessage: error.message,
        clearSuccess: true,
      );

      debugPrint('');
      debugPrint('╔════════════════════════════════════════════════════╗');
      debugPrint('║ VENDOR CHAT MESSAGE: API ERROR                    ║');
      debugPrint('╚════════════════════════════════════════════════════╝');
      debugPrint('ERROR: ${error.message}');

      return null;
    } catch (error) {
      state = state.copyWith(
        isSending: false,
        errorMessage: 'Unable to send message. Please try again.',
        clearSuccess: true,
      );

      if (kDebugMode) {
        debugPrint('');
        debugPrint('╔════════════════════════════════════════════════════╗');
        debugPrint('║ VENDOR CHAT MESSAGE: ERROR                        ║');
        debugPrint('╚════════════════════════════════════════════════════╝');
        debugPrint('ERROR: $error');
      }

      return null;
    } finally {
      _requestInProgress = false;
    }
  }

  // ============================================================
  // Clear Error
  // ============================================================

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  // ============================================================
  // Clear Success
  // ============================================================

  void clearSuccess() {
    state = state.copyWith(clearSuccess: true);
  }

  // ============================================================
  // Clear State
  // ============================================================

  void clearState() {
    state = const VendorChatMessageState();
  }
}
