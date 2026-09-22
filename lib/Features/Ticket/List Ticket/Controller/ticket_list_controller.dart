import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/ticket_list_item_model.dart';
import '../Models/ticket_list_model.dart';
import '../Repo/ticket_list_repository.dart';

// ============================================================
// Ticket List Provider
// ============================================================

final ticketListControllerProvider = Provider<TicketListController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return TicketListController(dioClient: dioClient);
});

// ============================================================
// Ticket List Controller
// ============================================================

class TicketListController {
  TicketListController({required DioClient dioClient})
    : _repository = TicketListRepository(dioClient);

  final TicketListRepository _repository;

  // ==========================================================
  // Pagination State
  // ==========================================================

  final List<TicketListItemModel> _tickets = [];

  int _currentPage = 0;
  int _totalPages = 1;
  int _totalItems = 0;
  int _limit = 20;

  bool _isLoading = false;
  bool _isLoadingMore = false;

  Object? _error;

  // ==========================================================
  // Getters
  // ==========================================================

  List<TicketListItemModel> get tickets => List.unmodifiable(_tickets);

  int get currentPage => _currentPage;

  int get totalPages => _totalPages;

  int get totalItems => _totalItems;

  int get limit => _limit;

  bool get isLoading => _isLoading;

  bool get isLoadingMore => _isLoadingMore;

  Object? get error => _error;

  bool get hasError => _error != null;

  bool get hasMore {
    return _currentPage < _totalPages;
  }

  bool get isEmpty {
    return !_isLoading && _tickets.isEmpty;
  }

  // ==========================================================
  // Load First Page
  // ==========================================================

  Future<TicketListModel?> loadTickets({int limit = 20}) async {
    if (_isLoading) {
      return null;
    }

    _isLoading = true;
    _error = null;
    _limit = limit;

    try {
      final result = await _repository.getTickets(page: 1, limit: limit);

      _tickets.clear();
      _addUniqueTickets(result.tickets);

      _updatePagination(result);

      return result;
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    } finally {
      _isLoading = false;
    }
  }

  // ==========================================================
  // Load Next Page
  // ==========================================================

  Future<TicketListModel?> loadNextPage() async {
    // ----------------------------------------------------------
    // Prevent Duplicate Request
    // ----------------------------------------------------------

    if (_isLoading || _isLoadingMore) {
      return null;
    }

    // ----------------------------------------------------------
    // No More Pages
    // ----------------------------------------------------------

    if (!hasMore) {
      return null;
    }

    final nextPage = _currentPage + 1;

    _isLoadingMore = true;
    _error = null;

    try {
      final result = await _repository.getTickets(
        page: nextPage,
        limit: _limit,
      );

      _addUniqueTickets(result.tickets);

      _updatePagination(result);

      return result;
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  // ==========================================================
  // Refresh
  // ==========================================================

  Future<TicketListModel?> refresh({int limit = 20}) async {
    return loadTickets(limit: limit);
  }

  // ==========================================================
  // Reset
  // ==========================================================

  void reset() {
    _tickets.clear();

    _currentPage = 0;
    _totalPages = 1;
    _totalItems = 0;
    _limit = 20;

    _isLoading = false;
    _isLoadingMore = false;

    _error = null;
  }

  // ==========================================================
  // Update Pagination
  // ==========================================================

  void _updatePagination(TicketListModel result) {
    final pagination = result.pagination;

    if (pagination == null) {
      // --------------------------------------------------------
      // Safe fallback if API doesn't return pagination
      // --------------------------------------------------------

      _currentPage = _currentPage == 0 ? 1 : _currentPage;

      _totalPages = _currentPage;
      _totalItems = _tickets.length;

      return;
    }

    _currentPage = pagination.currentPage;
    _totalPages = pagination.totalPages;
    _totalItems = pagination.totalItems;
    _limit = pagination.limit;
  }

  // ==========================================================
  // Add Unique Tickets
  // ==========================================================

  void _addUniqueTickets(List<TicketListItemModel> newTickets) {
    for (final ticket in newTickets) {
      final ticketId = ticket.id;

      // --------------------------------------------------------
      // If ID is available, prevent duplicate tickets
      // --------------------------------------------------------

      if (ticketId != null) {
        final alreadyExists = _tickets.any(
          (existing) => existing.id == ticketId,
        );

        if (alreadyExists) {
          continue;
        }
      }

      _tickets.add(ticket);
    }
  }
}
