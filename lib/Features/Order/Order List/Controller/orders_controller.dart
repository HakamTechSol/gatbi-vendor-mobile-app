import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/order_model.dart';
import '../Models/orders_pagination_model.dart';
import '../Repo/orders_repo.dart';

final vendorOrdersControllerProvider =
    StateNotifierProvider<VendorOrdersController, VendorOrdersState>((ref) {
      final dioClient = ref.watch(dioProvider);

      return VendorOrdersController(dioClient: dioClient);
    });

// ============================================================
// STATE
// ============================================================

class VendorOrdersState {
  const VendorOrdersState({
    this.orders = const [],
    this.pagination,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.selectedStatus,
    this.searchQuery = '',
  });

  final List<VendorOrderModel> orders;

  final VendorOrdersPaginationModel? pagination;

  final bool isLoading;
  final bool isLoadingMore;
  final bool isRefreshing;

  final String? errorMessage;

  final String? selectedStatus;
  final String searchQuery;

  // ============================================================
  // Getters
  // ============================================================

  bool get hasOrders => orders.isNotEmpty;

  bool get hasError => errorMessage != null && errorMessage!.trim().isNotEmpty;

  bool get isEmpty =>
      !isLoading && !isLoadingMore && orders.isEmpty && !hasError;

  bool get hasActiveFilters =>
      selectedStatus != null || searchQuery.trim().isNotEmpty;

  bool get isAllStatus => selectedStatus == null;

  int get currentPage => pagination?.currentPage ?? 1;

  int get totalPages => pagination?.totalPages ?? 1;

  int get totalItems => pagination?.totalItems ?? 0;

  int get limit => pagination?.limit ?? 20;

  bool get hasMorePages => currentPage < totalPages;

  // ============================================================
  // Copy With
  // ============================================================

  VendorOrdersState copyWith({
    List<VendorOrderModel>? orders,
    VendorOrdersPaginationModel? pagination,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? errorMessage,
    String? selectedStatus,
    String? searchQuery,

    bool clearError = false,
    bool clearStatus = false,
    bool clearPagination = false,
  }) {
    return VendorOrdersState(
      orders: orders ?? this.orders,

      pagination: clearPagination ? null : pagination ?? this.pagination,

      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,

      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,

      selectedStatus: clearStatus
          ? null
          : selectedStatus ?? this.selectedStatus,

      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// ============================================================
// CONTROLLER
// ============================================================

class VendorOrdersController extends StateNotifier<VendorOrdersState> {
  VendorOrdersController({required DioClient dioClient})
    : _repository = VendorOrdersRepository(dioClient),
      super(const VendorOrdersState());

  final VendorOrdersRepository _repository;

  Timer? _searchDebounce;

  // ============================================================
  // INITIAL LOAD
  // ============================================================

  Future<void> loadOrders() async {
    _searchDebounce?.cancel();

    // Fresh entry par purani list clear karo
    state = state.copyWith(
      orders: const [],
      clearError: true,
      clearPagination: true,
    );

    await _fetchOrders(page: 1, replace: true);
  }

  // ============================================================
  // FETCH
  // ============================================================

  Future<void> _fetchOrders({
    required int page,
    required bool replace,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      if (state.isRefreshing) {
        return;
      }

      state = state.copyWith(isRefreshing: true, clearError: true);
    } else if (replace) {
      if (state.isLoading) {
        return;
      }

      state = state.copyWith(isLoading: true, clearError: true);
    } else {
      if (state.isLoadingMore) {
        return;
      }

      state = state.copyWith(isLoadingMore: true, clearError: true);
    }

    try {
      final result = await _repository.getOrders(
        page: page,
        limit: state.limit,
        status: state.selectedStatus,
        search: state.searchQuery,
      );

      final updatedOrders = replace
          ? result.orders
          : [...state.orders, ...result.orders];

      state = state.copyWith(
        orders: updatedOrders,
        pagination: result.pagination,
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        clearError: true,
      );

      if (kDebugMode) {
        debugPrint('');
        debugPrint('════════════════════════════════════════');
        debugPrint('        ORDERS STATE UPDATED');
        debugPrint('════════════════════════════════════════');
        debugPrint('ORDERS       : ${updatedOrders.length}');
        debugPrint('CURRENT PAGE : ${result.pagination?.currentPage ?? 'N/A'}');
        debugPrint('TOTAL PAGES  : ${result.pagination?.totalPages ?? 'N/A'}');
        debugPrint('HAS MORE     : ${state.hasMorePages}');
        debugPrint('════════════════════════════════════════');
        debugPrint('');
      }
    } on ApiException catch (error) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        errorMessage: error.message,
      );

      if (kDebugMode) {
        debugPrint('');
        debugPrint('════════════════════════════════════════');
        debugPrint('        ORDERS API ERROR');
        debugPrint('════════════════════════════════════════');
        debugPrint('MESSAGE : ${error.message}');
        debugPrint('CODE    : ${error.code}');
        debugPrint('════════════════════════════════════════');
        debugPrint('');
      }
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        errorMessage: 'Something went wrong. Please try again.',
      );

      if (kDebugMode) {
        debugPrint('');
        debugPrint('ORDERS UNKNOWN ERROR: $error');
        debugPrint('');
      }
    }
  }

  // ============================================================
  // STATUS FILTER
  // ============================================================

  Future<void> filterByStatus(String? status) async {
    final normalizedStatus = _normalizeStatus(status);

    if (state.selectedStatus == normalizedStatus) {
      return;
    }

    _searchDebounce?.cancel();

    state = state.copyWith(
      selectedStatus: normalizedStatus,
      orders: const [],
      clearError: true,
      clearPagination: true,
      clearStatus: normalizedStatus == null,
    );

    await _fetchOrders(page: 1, replace: true);
  }

  // ============================================================
  // SEARCH - DEBOUNCED
  // ============================================================

  void searchOrders(
    String query, {
    Duration delay = const Duration(milliseconds: 500),
  }) {
    final value = query.trim();

    _searchDebounce?.cancel();

    state = state.copyWith(searchQuery: value);

    _searchDebounce = Timer(delay, () async {
      state = state.copyWith(
        orders: const [],
        clearError: true,
        clearPagination: true,
      );

      await _fetchOrders(page: 1, replace: true);
    });
  }

  // ============================================================
  // SEARCH IMMEDIATE
  // ============================================================

  Future<void> searchOrdersNow(String query) async {
    _searchDebounce?.cancel();

    final value = query.trim();

    state = state.copyWith(
      searchQuery: value,
      orders: const [],
      clearError: true,
      clearPagination: true,
    );

    await _fetchOrders(page: 1, replace: true);
  }

  // ============================================================
  // CLEAR SEARCH
  // ============================================================

  Future<void> clearSearch() async {
    _searchDebounce?.cancel();

    if (state.searchQuery.isEmpty) {
      return;
    }

    state = state.copyWith(
      searchQuery: '',
      orders: const [],
      clearError: true,
      clearPagination: true,
    );

    await _fetchOrders(page: 1, replace: true);
  }

  // ============================================================
  // CLEAR FILTER
  // ============================================================

  Future<void> clearFilter() async {
    await filterByStatus(null);
  }

  // ============================================================
  // LOAD MORE
  // ============================================================

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || state.isRefreshing) {
      return;
    }

    if (!state.hasMorePages) {
      if (kDebugMode) {
        debugPrint('VENDOR ORDERS: No more pages available.');
      }

      return;
    }

    final nextPage = state.currentPage + 1;

    await _fetchOrders(page: nextPage, replace: false);
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refreshOrders() async {
    _searchDebounce?.cancel();

    // Existing orders remove karo taake full shimmer show ho
    state = state.copyWith(
      orders: const [],
      clearError: true,
      clearPagination: true,
    );

    await _fetchOrders(page: 1, replace: true);
  }
  // ============================================================
  // RETRY
  // ============================================================

  Future<void> retry() async {
    await _fetchOrders(page: 1, replace: true);
  }

  // ============================================================
  // CLEAR ERROR
  // ============================================================

  void clearError() {
    if (state.errorMessage == null) {
      return;
    }

    state = state.copyWith(clearError: true);
  }

  // ============================================================
  // STATUS NORMALIZER
  // ============================================================

  String? _normalizeStatus(String? status) {
    if (status == null) {
      return null;
    }

    final value = status.trim().toLowerCase();

    if (value.isEmpty || value == 'all') {
      return null;
    }

    return value;
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}
