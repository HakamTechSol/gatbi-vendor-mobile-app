import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/vendor_chat_model.dart';
import '../Repo/vendor_chat_repository.dart';
import 'vendor_chat_state.dart';

// ============================================================
// Provider
// ============================================================

final vendorChatControllerProvider =
    StateNotifierProvider<VendorChatController, VendorChatState>((ref) {
      final dioClient = ref.watch(dioProvider);

      return VendorChatController(dioClient: dioClient);
    });

// ============================================================
// Controller
// ============================================================

class VendorChatController extends StateNotifier<VendorChatState> {
  VendorChatController({required DioClient dioClient})
    : _repository = VendorChatRepository(dioClient),
      super(const VendorChatState());

  final VendorChatRepository _repository;

  // ============================================================
  // Constants
  // ============================================================

  static const int _defaultLimit = 20;

  // ============================================================
  // Internal Protection
  // ============================================================

  bool _requestInProgress = false;

  // ============================================================
  // Initial Load
  // ============================================================

  Future<void> loadChats() async {
    if (_requestInProgress) {
      return;
    }

    _requestInProgress = true;

    debugPrint('');
    debugPrint('════════════════════════════════════════════════════');
    debugPrint('VENDOR CHAT: INITIAL LOAD');
    debugPrint('Page: 1');
    debugPrint('Limit: $_defaultLimit');
    debugPrint('════════════════════════════════════════════════════');

    // IMPORTANT:
    // isLoading = true -> ChatListScreen shows full shimmer.
    state = state.copyWith(
      isLoading: true,
      isLoadingMore: false,
      isRefreshing: false,
      clearError: true,
    );

    try {
      final result = await _repository.getChats(page: 1, limit: _defaultLimit);

      final chats = _sortChats(result.chats);

      final pagination = result.pagination;

      final currentPage = pagination?.currentPage ?? 1;
      final totalPages = pagination?.totalPages ?? 1;
      final totalItems = pagination?.totalItems ?? chats.length;
      final limit = pagination?.limit ?? _defaultLimit;

      state = state.copyWith(
        chats: chats,
        filteredChats: _applySearch(chats, state.searchQuery),
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        currentPage: currentPage,
        totalPages: totalPages,
        totalItems: totalItems,
        limit: limit,
        unreadTotal: result.unreadTotal,
        hasMore: currentPage < totalPages,
        clearError: true,
      );

      debugPrint('');
      debugPrint('VENDOR CHAT: INITIAL LOAD SUCCESS');
      debugPrint('Chats: ${chats.length}');
      debugPrint('Current Page: $currentPage');
      debugPrint('Total Pages: $totalPages');
      debugPrint('Total Items: $totalItems');
      debugPrint('Has More: ${currentPage < totalPages}');
      debugPrint('Unread Total: ${result.unreadTotal}');
      debugPrint('════════════════════════════════════════════════════');
    } on ApiException catch (error) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        errorMessage: error.message,
      );

      debugPrint('');
      debugPrint('VENDOR CHAT: INITIAL LOAD API ERROR');
      debugPrint('Error: ${error.message}');
      debugPrint('════════════════════════════════════════════════════');
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        errorMessage: 'Something went wrong. Please try again.',
      );

      if (kDebugMode) {
        debugPrint('');
        debugPrint('VENDOR CHAT: INITIAL LOAD ERROR');
        debugPrint('Error: $error');
        debugPrint('════════════════════════════════════════════════════');
      }
    } finally {
      _requestInProgress = false;
    }
  }

  // ============================================================
  // Load More
  // ============================================================

  Future<void> loadMoreChats() async {
    if (_requestInProgress) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    if (state.isLoadingMore) {
      return;
    }

    if (!state.hasMore) {
      return;
    }

    final nextPage = state.currentPage + 1;

    _requestInProgress = true;

    debugPrint('');
    debugPrint('════════════════════════════════════════════════════');
    debugPrint('VENDOR CHAT: LOAD MORE');
    debugPrint('Page: $nextPage');
    debugPrint('Limit: ${state.limit > 0 ? state.limit : _defaultLimit}');
    debugPrint('════════════════════════════════════════════════════');

    // Pagination should NOT show the full-screen shimmer.
    // ChatListScreen will show compact loader at bottom.
    state = state.copyWith(isLoadingMore: true, clearError: true);

    try {
      final result = await _repository.getChats(
        page: nextPage,
        limit: state.limit > 0 ? state.limit : _defaultLimit,
      );

      final newChats = result.chats;

      // --------------------------------------------------------
      // Merge + Remove Duplicates
      // --------------------------------------------------------

      final mergedChats = _mergeChats(state.chats, newChats);

      final sortedChats = _sortChats(mergedChats);

      final pagination = result.pagination;

      final currentPage = pagination?.currentPage ?? nextPage;

      final totalPages = pagination?.totalPages ?? state.totalPages;

      final totalItems = pagination?.totalItems ?? state.totalItems;

      final limit = pagination?.limit ?? state.limit;

      state = state.copyWith(
        chats: sortedChats,
        filteredChats: _applySearch(sortedChats, state.searchQuery),
        isLoadingMore: false,
        currentPage: currentPage,
        totalPages: totalPages,
        totalItems: totalItems,
        limit: limit,
        unreadTotal: result.unreadTotal,
        hasMore: currentPage < totalPages,
        clearError: true,
      );

      debugPrint('');
      debugPrint('VENDOR CHAT: LOAD MORE SUCCESS');
      debugPrint('New Chats: ${newChats.length}');
      debugPrint('Total Chats: ${sortedChats.length}');
      debugPrint('Current Page: $currentPage');
      debugPrint('Total Pages: $totalPages');
      debugPrint('Has More: ${currentPage < totalPages}');
      debugPrint('════════════════════════════════════════════════════');
    } on ApiException catch (error) {
      state = state.copyWith(isLoadingMore: false, errorMessage: error.message);

      debugPrint('');
      debugPrint('VENDOR CHAT: LOAD MORE API ERROR');
      debugPrint('Error: ${error.message}');
      debugPrint('════════════════════════════════════════════════════');
    } catch (error) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: 'Unable to load more chats.',
      );

      if (kDebugMode) {
        debugPrint('');
        debugPrint('VENDOR CHAT: LOAD MORE ERROR');
        debugPrint('Error: $error');
        debugPrint('════════════════════════════════════════════════════');
      }
    } finally {
      _requestInProgress = false;
    }
  }

  // ============================================================
  // Refresh
  // ============================================================

  Future<void> refreshChats() async {
    if (_requestInProgress) {
      debugPrint(
        'VENDOR CHAT: Refresh ignored - another request is already running.',
      );
      return;
    }

    _requestInProgress = true;

    debugPrint('');
    debugPrint('╔════════════════════════════════════════════════════╗');
    debugPrint('║ VENDOR CHAT: REFRESH STARTED                      ║');
    debugPrint('╚════════════════════════════════════════════════════╝');

    // ==========================================================
    // IMPORTANT FIX
    // ==========================================================
    //
    // isRefreshing = true
    // AND
    // isLoading = true
    //
    // ChatListScreen uses `state.isLoading` to display
    // ChatLoading/Shimmer.
    //
    // Previously only isRefreshing was true, so shimmer
    // condition was not triggered when chats already existed.
    // ==========================================================

    state = state.copyWith(
      isLoading: true,
      isRefreshing: true,
      isLoadingMore: false,
      clearError: true,
    );

    debugPrint('VENDOR CHAT: Loading state = TRUE');
    debugPrint('VENDOR CHAT: Shimmer should now be visible.');

    try {
      final result = await _repository.getChats(page: 1, limit: _defaultLimit);

      final chats = _sortChats(result.chats);

      final pagination = result.pagination;

      final currentPage = pagination?.currentPage ?? 1;

      final totalPages = pagination?.totalPages ?? 1;

      final totalItems = pagination?.totalItems ?? chats.length;

      final limit = pagination?.limit ?? _defaultLimit;

      state = state.copyWith(
        chats: chats,
        filteredChats: _applySearch(chats, state.searchQuery),
        isLoading: false,
        isRefreshing: false,
        isLoadingMore: false,
        currentPage: currentPage,
        totalPages: totalPages,
        totalItems: totalItems,
        limit: limit,
        unreadTotal: result.unreadTotal,
        hasMore: currentPage < totalPages,
        clearError: true,
      );

      debugPrint('');
      debugPrint('╔════════════════════════════════════════════════════╗');
      debugPrint('║ VENDOR CHAT: REFRESH SUCCESS                      ║');
      debugPrint('╚════════════════════════════════════════════════════╝');
      debugPrint('Chats: ${chats.length}');
      debugPrint('Current Page: $currentPage');
      debugPrint('Total Pages: $totalPages');
      debugPrint('Total Items: $totalItems');
      debugPrint('Has More: ${currentPage < totalPages}');
      debugPrint('Unread Total: ${result.unreadTotal}');
      debugPrint('Shimmer: HIDDEN');
    } on ApiException catch (error) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        isLoadingMore: false,
        errorMessage: error.message,
      );

      debugPrint('');
      debugPrint('╔════════════════════════════════════════════════════╗');
      debugPrint('║ VENDOR CHAT: REFRESH API ERROR                    ║');
      debugPrint('╚════════════════════════════════════════════════════╝');
      debugPrint('Error: ${error.message}');
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        isLoadingMore: false,
        errorMessage: 'Unable to refresh chats.',
      );

      if (kDebugMode) {
        debugPrint('');
        debugPrint('╔════════════════════════════════════════════════════╗');
        debugPrint('║ VENDOR CHAT: REFRESH ERROR                        ║');
        debugPrint('╚════════════════════════════════════════════════════╝');
        debugPrint('Error: $error');
      }
    } finally {
      _requestInProgress = false;
    }
  }

  // ============================================================
  // Search
  // ============================================================

  void searchChats(String query) {
    final normalizedQuery = query.trim();

    final filtered = _applySearch(state.chats, normalizedQuery);

    state = state.copyWith(
      searchQuery: normalizedQuery,
      filteredChats: filtered,
    );
  }

  // ============================================================
  // Clear Search
  // ============================================================

  void clearSearch() {
    state = state.copyWith(searchQuery: '', filteredChats: state.chats);
  }

  // ============================================================
  // Search Implementation
  // ============================================================

  List<VendorChatModel> _applySearch(
    List<VendorChatModel> chats,
    String query,
  ) {
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return List<VendorChatModel>.from(chats);
    }

    return chats.where((chat) {
      return chat.searchableText.contains(normalizedQuery);
    }).toList();
  }

  // ============================================================
  // Merge Chats
  // ============================================================

  List<VendorChatModel> _mergeChats(
    List<VendorChatModel> existing,
    List<VendorChatModel> incoming,
  ) {
    final result = <VendorChatModel>[];
    final ids = <int>{};

    // ----------------------------------------------------------
    // Existing Chats
    // ----------------------------------------------------------

    for (final chat in existing) {
      final id = chat.id;

      if (id != null) {
        if (ids.add(id)) {
          result.add(chat);
        }
      } else {
        result.add(chat);
      }
    }

    // ----------------------------------------------------------
    // Incoming Chats
    // ----------------------------------------------------------

    for (final chat in incoming) {
      final id = chat.id;

      if (id != null) {
        if (ids.add(id)) {
          result.add(chat);
        }
      } else {
        result.add(chat);
      }
    }

    return result;
  }

  // ============================================================
  // Sort Latest Chat First
  // ============================================================

  List<VendorChatModel> _sortChats(List<VendorChatModel> chats) {
    final sorted = List<VendorChatModel>.from(chats);

    sorted.sort((a, b) {
      final dateA = _parseDate(a.lastMessageAt);
      final dateB = _parseDate(b.lastMessageAt);

      // --------------------------------------------------------
      // Both dates available
      // --------------------------------------------------------

      if (dateA != null && dateB != null) {
        return dateB.compareTo(dateA);
      }

      // --------------------------------------------------------
      // Date available only in B
      // --------------------------------------------------------

      if (dateA == null && dateB != null) {
        return 1;
      }

      // --------------------------------------------------------
      // Date available only in A
      // --------------------------------------------------------

      if (dateA != null && dateB == null) {
        return -1;
      }

      // --------------------------------------------------------
      // Fallback: Chat ID
      // --------------------------------------------------------

      final idA = a.id ?? 0;
      final idB = b.id ?? 0;

      return idB.compareTo(idA);
    });

    return sorted;
  }

  // ============================================================
  // Parse API Date
  // ============================================================

  DateTime? _parseDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    try {
      return DateTime.parse(value.replaceFirst(' ', 'T'));
    } catch (_) {
      return null;
    }
  }
}
