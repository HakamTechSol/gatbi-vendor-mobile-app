import '../Models/vendor_chat_detail_message_model.dart';
import '../Models/vendor_chat_detail_model.dart';

class VendorChatDetailState {
  const VendorChatDetailState({
    this.chatId,
    this.chat,
    this.messages = const [],
    this.currentPage = 1,
    this.limit = 50,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.errorMessage,
  });

  final int? chatId;

  final VendorChatDetailChatInfoModel? chat;

  final List<VendorChatDetailMessageModel> messages;

  final int currentPage;

  final int limit;

  final bool hasMore;

  final bool isLoading;

  final bool isLoadingMore;

  final bool isRefreshing;

  final String? errorMessage;

  // ============================================================
  // Copy With
  // ============================================================

  VendorChatDetailState copyWith({
    int? chatId,
    VendorChatDetailChatInfoModel? chat,
    List<VendorChatDetailMessageModel>? messages,
    int? currentPage,
    int? limit,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? errorMessage,
    bool clearError = false,
    bool clearChat = false,
  }) {
    return VendorChatDetailState(
      chatId: chatId ?? this.chatId,
      chat: clearChat ? null : (chat ?? this.chat),
      messages: messages ?? this.messages,
      currentPage: currentPage ?? this.currentPage,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
