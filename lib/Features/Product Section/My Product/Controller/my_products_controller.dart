import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';

import '../Models/main_my_products_model.dart';
import '../Models/my_product_model.dart';

import '../Repo/my_products_repository.dart';

// ============================================================
// Provider
// ============================================================

final myProductsControllerProvider =
    StateNotifierProvider<MyProductsController, MyProductsState>((ref) {
      final dioClient = ref.watch(dioProvider);

      return MyProductsController(repository: MyProductsRepository(dioClient));
    });

// ============================================================
// State
// ============================================================

class MyProductsState {
  const MyProductsState({
    this.products = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.limit = 20,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.errorMessage,
    this.errorCode,
    this.initialized = false,
  });

  // ==========================================================
  // Product Data
  // ==========================================================

  final List<MyProductModel> products;

  // ==========================================================
  // Pagination
  // ==========================================================

  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int limit;

  // ==========================================================
  // Loading
  // ==========================================================

  final bool isLoading;
  final bool isLoadingMore;

  // ==========================================================
  // Pagination Status
  // ==========================================================

  final bool hasMore;

  // ==========================================================
  // Error
  // ==========================================================

  final String? errorMessage;
  final String? errorCode;

  // ==========================================================
  // Initialization
  // ==========================================================

  final bool initialized;

  // ==========================================================
  // Copy With
  // ==========================================================

  MyProductsState copyWith({
    List<MyProductModel>? products,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? limit,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
    String? errorCode,
    bool clearError = false,
    bool? initialized,
  }) {
    return MyProductsState(
      products: products ?? this.products,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      limit: limit ?? this.limit,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
      initialized: initialized ?? this.initialized,
    );
  }
}

// ============================================================
// Controller
// ============================================================

class MyProductsController extends StateNotifier<MyProductsState> {
  MyProductsController({required MyProductsRepository repository})
    : _repository = repository,
      super(const MyProductsState());

  final MyProductsRepository _repository;

  // ==========================================================
  // Constants
  // ==========================================================

  static const int _defaultLimit = 20;
  static const int _minLimit = 1;
  static const int _maxLimit = 100;

  // ==========================================================
  // Get First Page
  // ==========================================================

  Future<void> getProducts({int limit = _defaultLimit}) async {
    // --------------------------------------------------------
    // Prevent duplicate request
    // --------------------------------------------------------

    if (state.isLoading) {
      return;
    }

    final safeLimit = limit.clamp(_minLimit, _maxLimit).toInt();

    // --------------------------------------------------------
    // IMPORTANT:
    //
    // Every first-page request sets isLoading = true.
    //
    // Therefore screen will show MyProductsLoading shimmer
    // every time refresh() / getProducts() is called.
    // --------------------------------------------------------

    state = state.copyWith(
      isLoading: true,
      isLoadingMore: false,
      clearError: true,
      initialized: false,
      limit: safeLimit,
    );

    try {
      final result = await _repository.getMyProducts(page: 1, limit: safeLimit);

      state = _stateFromFirstPage(result: result, fallbackLimit: safeLimit);

      printState();
    } on ApiException catch (error) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        errorMessage: error.message,
        errorCode: error.code,
        initialized: true,
      );

      rethrow;
    } catch (error) {
      final exception = ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );

      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        errorMessage: exception.message,
        errorCode: exception.code,
        initialized: true,
      );

      rethrow;
    }
  }

  // ==========================================================
  // Load Next Page
  // ==========================================================

  Future<void> loadNextPage() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }

    final nextPage = state.currentPage + 1;

    state = state.copyWith(isLoadingMore: true, clearError: true);

    try {
      final result = await _repository.getMyProducts(
        page: nextPage,
        limit: state.limit,
      );

      final mergedProducts = _mergeProducts(state.products, result.products);

      state = state.copyWith(
        products: mergedProducts,
        currentPage: result.pagination.currentPage,
        totalPages: result.pagination.totalPages,
        totalItems: result.pagination.totalItems,
        limit: result.pagination.limit > 0
            ? result.pagination.limit
            : state.limit,
        isLoadingMore: false,
        hasMore: result.pagination.hasNextPage,
        clearError: true,
        initialized: true,
      );

      printState();
    } on ApiException catch (error) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: error.message,
        errorCode: error.code,
      );

      rethrow;
    } catch (error) {
      final exception = ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );

      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: exception.message,
        errorCode: exception.code,
      );

      rethrow;
    }
  }

  // ==========================================================
  // Refresh
  // ==========================================================
  //
  // IMPORTANT:
  // refresh() intentionally calls getProducts().
  //
  // getProducts() sets:
  //   isLoading = true
  //   initialized = false
  //
  // So the screen displays the FULL shimmer while refreshing.
  // ==========================================================

  Future<void> refresh() async {
    if (state.isLoading) {
      return;
    }

    debugPrint('');
    debugPrint('============================================================');
    debugPrint('[MyProductsController] REFRESH PRODUCTS');
    debugPrint('[MyProductsController] Limit: ${state.limit}');
    debugPrint('============================================================');

    await getProducts(limit: state.limit);
  }

  // ==========================================================
  // Get Specific Page
  // ==========================================================

  Future<void> getPage(int page) async {
    if (state.isLoading || state.isLoadingMore) {
      return;
    }

    if (page < 1 || page > state.totalPages) {
      return;
    }

    state = state.copyWith(
      isLoading: true,
      isLoadingMore: false,
      clearError: true,
      initialized: false,
    );

    try {
      final result = await _repository.getMyProducts(
        page: page,
        limit: state.limit,
      );

      state = _stateFromFirstPage(result: result, fallbackLimit: state.limit);

      printState();
    } on ApiException catch (error) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        errorMessage: error.message,
        errorCode: error.code,
        initialized: true,
      );

      rethrow;
    } catch (error) {
      final exception = ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );

      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        errorMessage: exception.message,
        errorCode: exception.code,
        initialized: true,
      );

      rethrow;
    }
  }

  // ==========================================================
  // Clear Error
  // ==========================================================

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  // ==========================================================
  // Build First Page State
  // ==========================================================

  MyProductsState _stateFromFirstPage({
    required MainMyProductModel result,
    required int fallbackLimit,
  }) {
    final apiLimit = result.pagination.limit;

    final effectiveLimit = apiLimit > 0 ? apiLimit : fallbackLimit;

    return MyProductsState(
      products: result.products,
      currentPage: result.pagination.currentPage,
      totalPages: result.pagination.totalPages,
      totalItems: result.pagination.totalItems,
      limit: effectiveLimit,
      isLoading: false,
      isLoadingMore: false,
      hasMore: result.pagination.hasNextPage,
      initialized: true,
    );
  }

  // ==========================================================
  // Merge Products
  // ==========================================================

  List<MyProductModel> _mergeProducts(
    List<MyProductModel> oldProducts,
    List<MyProductModel> newProducts,
  ) {
    final result = <MyProductModel>[...oldProducts];

    final existingIds = oldProducts
        .where((product) => product.id != null)
        .map((product) => product.id!)
        .toSet();

    for (final product in newProducts) {
      if (product.id == null) {
        result.add(product);
        continue;
      }

      if (!existingIds.contains(product.id)) {
        result.add(product);
        existingIds.add(product.id!);
      }
    }

    return result;
  }

  // ==========================================================
  // Getters
  // ==========================================================

  bool get hasMorePages => state.hasMore;

  bool get isEmpty => state.products.isEmpty;

  int get productCount => state.products.length;

  // ==========================================================
  // Debug
  // ==========================================================

  void printState() {
    if (!kDebugMode) {
      return;
    }

    debugPrint('');
    debugPrint('========== MY PRODUCTS STATE ==========');
    debugPrint('PRODUCTS: ${state.products.length}');
    debugPrint('CURRENT PAGE: ${state.currentPage}');
    debugPrint('TOTAL PAGES: ${state.totalPages}');
    debugPrint('TOTAL ITEMS: ${state.totalItems}');
    debugPrint('LIMIT: ${state.limit}');
    debugPrint('IS LOADING: ${state.isLoading}');
    debugPrint('IS LOADING MORE: ${state.isLoadingMore}');
    debugPrint('HAS MORE: ${state.hasMore}');
    debugPrint('INITIALIZED: ${state.initialized}');
    debugPrint('ERROR: ${state.errorMessage ?? 'N/A'}');
    debugPrint('ERROR CODE: ${state.errorCode ?? 'N/A'}');
    debugPrint('=======================================');
    debugPrint('');
  }
}
