import '../Models/vendor_chat_message_model.dart';

class VendorChatMessageState {
  const VendorChatMessageState({
    this.isSending = false,
    this.sentMessage,
    this.errorMessage,
    this.successMessage,
  });

  final bool isSending;

  final VendorChatMessageModel? sentMessage;

  final String? errorMessage;

  final String? successMessage;

  // ============================================================
  // Copy With
  // ============================================================

  VendorChatMessageState copyWith({
    bool? isSending,
    VendorChatMessageModel? sentMessage,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearSentMessage = false,
  }) {
    return VendorChatMessageState(
      isSending: isSending ?? this.isSending,
      sentMessage: clearSentMessage ? null : (sentMessage ?? this.sentMessage),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
    );
  }
}
