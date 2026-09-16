import '../Models/vendor_chat_model.dart';

class VendorChatState {
  const VendorChatState({
    this.chats = const [],
    this.filteredChats = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.hasMore = false,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.limit = 20,
    this.unreadTotal = 0,
    this.searchQuery = '',
    this.errorMessage,
  });

  // ============================================================
  // Data
  // ============================================================

  final List<VendorChatModel> chats;
  final List<VendorChatModel> filteredChats;

  // ============================================================
  // Loading
  // ============================================================

  final bool isLoading;
  final bool isLoadingMore;
  final bool isRefreshing;

  // ============================================================
  // Pagination
  // ============================================================

  final bool hasMore;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int limit;

  // ============================================================
  // Summary
  // ============================================================

  final int unreadTotal;

  // ============================================================
  // Search
  // ============================================================

  final String searchQuery;

  // ============================================================
  // Error
  // ============================================================

  final String? errorMessage;

  // ============================================================
  // Copy With
  // ============================================================

  VendorChatState copyWith({
    List<VendorChatModel>? chats,
    List<VendorChatModel>? filteredChats,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    bool? hasMore,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? limit,
    int? unreadTotal,
    String? searchQuery,
    String? errorMessage,
    bool clearError = false,
  }) {
    return VendorChatState(
      chats: chats ?? this.chats,
      filteredChats: filteredChats ?? this.filteredChats,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      limit: limit ?? this.limit,
      unreadTotal: unreadTotal ?? this.unreadTotal,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
