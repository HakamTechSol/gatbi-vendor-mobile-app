import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Services/api_exception.dart';
import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

import 'Controller/ticket_list_controller.dart';
import 'Models/ticket_list_item_model.dart';
import 'Reuse Widgets/ticket_card.dart';
import 'Reuse Widgets/ticket_empty_state.dart';
import 'Reuse Widgets/ticket_error_state.dart';
import 'Reuse Widgets/ticket_list_header.dart';
import 'Reuse Widgets/ticket_loading.dart';
import 'Reuse Widgets/ticket_search_bar.dart';

class TicketListScreen extends ConsumerStatefulWidget {
  const TicketListScreen({super.key, this.onCreateTicket, this.onTicketTap});

  /// Called when the user taps "Create Ticket".
  final VoidCallback? onCreateTicket;

  /// Called when the user taps a ticket card.
  final ValueChanged<TicketListItemModel>? onTicketTap;

  @override
  ConsumerState<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends ConsumerState<TicketListScreen> {
  // ===========================================================================
  // CONTROLLERS
  // ===========================================================================

  late final TextEditingController _searchController;
  late final ScrollController _scrollController;

  // ===========================================================================
  // STATE
  // ===========================================================================

  String _searchQuery = '';

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasError = false;

  List<TicketListItemModel> _tickets = [];

  int _currentPage = 0;
  int _totalPages = 1;
  int _totalItems = 0;

  // ===========================================================================
  // INIT
  // ===========================================================================

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _scrollController = ScrollController();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _loadInitialTickets();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    super.dispose();
  }

  // ===========================================================================
  // INITIAL LOAD
  // ===========================================================================

  Future<void> _loadInitialTickets() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final controller = ref.read(ticketListControllerProvider);

      await controller.loadTickets(limit: 20);

      if (!mounted) return;

      setState(() {
        _tickets = List<TicketListItemModel>.from(controller.tickets);

        _currentPage = controller.currentPage;
        _totalPages = controller.totalPages;
        _totalItems = controller.totalItems;

        _hasError = false;
      });

      debugPrint('');
      debugPrint('========== TICKET SCREEN ==========');
      debugPrint('INITIAL LOAD SUCCESS');
      debugPrint('CURRENT PAGE: $_currentPage');
      debugPrint('TOTAL PAGES: $_totalPages');
      debugPrint('TOTAL ITEMS: $_totalItems');
      debugPrint('LOADED TICKETS: ${_tickets.length}');
      debugPrint('HAS MORE: ${controller.hasMore}');
      debugPrint('===================================');
      debugPrint('');
    } on ApiException catch (error) {
      if (!mounted) return;

      setState(() {
        _hasError = true;
        _tickets = [];
      });

      _showErrorMessage(error.message);
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _hasError = true;
        _tickets = [];
      });

      _showErrorMessage('Something went wrong. Please try again.');
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  // ===========================================================================
  // PAGINATION
  // ===========================================================================

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    // Start loading next page before the user reaches
    // the absolute bottom.
    const double loadMoreThreshold = 250;

    if (position.pixels >= position.maxScrollExtent - loadMoreThreshold) {
      _loadNextPage();
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoading || _isLoadingMore) {
      return;
    }

    final controller = ref.read(ticketListControllerProvider);

    if (!controller.hasMore) {
      debugPrint('[TicketListScreen] No more pages available.');
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = controller.currentPage + 1;

      debugPrint('');
      debugPrint('========== LOAD NEXT TICKET PAGE ==========');
      debugPrint('CURRENT PAGE: ${controller.currentPage}');
      debugPrint('REQUESTING PAGE: $nextPage');
      debugPrint('LIMIT: ${controller.limit}');
      debugPrint('============================================');
      debugPrint('');

      await controller.loadNextPage();


      if (!mounted) return;

      setState(() {
        _tickets = List<TicketListItemModel>.from(controller.tickets);

        _currentPage = controller.currentPage;
        _totalPages = controller.totalPages;
        _totalItems = controller.totalItems;
      });

      debugPrint('');
      debugPrint('========== NEXT PAGE LOADED ==========');
      debugPrint('CURRENT PAGE: $_currentPage');
      debugPrint('TOTAL PAGES: $_totalPages');
      debugPrint('TOTAL ITEMS: $_totalItems');
      debugPrint('LOADED TICKETS: ${_tickets.length}');
      debugPrint('HAS MORE: ${controller.hasMore}');
      debugPrint('======================================');
      debugPrint('');
    } on ApiException catch (error) {
      if (!mounted) return;

      _showErrorMessage(error.message);
    } catch (error) {
      if (!mounted) return;

      _showErrorMessage('Unable to load more tickets. Please try again.');
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  // ===========================================================================
  // SEARCH
  // ===========================================================================

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value.trim();
    });
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _searchQuery = '';
    });
  }

  // ===========================================================================
  // FILTERED TICKETS
  // ===========================================================================

  List<TicketListItemModel> get _filteredTickets {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return List<TicketListItemModel>.from(_tickets);
    }

    return _tickets.where((ticket) {
      final ticketNumber = ticket.ticketNumber?.toLowerCase() ?? '';

      final subject = ticket.subject?.toLowerCase() ?? '';

      final category = ticket.category?.toLowerCase() ?? '';

      final priority = ticket.priority?.toLowerCase() ?? '';

      final status = ticket.status?.toLowerCase() ?? '';

      return ticketNumber.contains(query) ||
          subject.contains(query) ||
          category.contains(query) ||
          priority.contains(query) ||
          status.contains(query);
    }).toList();
  }

  // ===========================================================================
  // REFRESH
  // ===========================================================================

  Future<void> _onRefresh() async {
    if (_isLoading) {
      return;
    }

    debugPrint('');
    debugPrint('========== TICKET REFRESH ==========');
    debugPrint('Refreshing ticket list from page 1...');
    debugPrint('====================================');
    debugPrint('');

    try {
      final controller = ref.read(ticketListControllerProvider);

      final result = await controller.refresh(limit: 20);

      if (!mounted) return;

      setState(() {
        _tickets = List<TicketListItemModel>.from(controller.tickets);

        _currentPage = controller.currentPage;
        _totalPages = controller.totalPages;
        _totalItems = controller.totalItems;

        _hasError = false;
      });

      debugPrint('');
      debugPrint('========== TICKET REFRESH RESULT ==========');
      debugPrint('SUCCESS: ${result?.success ?? false}');
      debugPrint('CURRENT PAGE: $_currentPage');
      debugPrint('TOTAL PAGES: $_totalPages');
      debugPrint('TOTAL ITEMS: $_totalItems');
      debugPrint('LOADED TICKETS: ${_tickets.length}');
      debugPrint('HAS MORE: ${controller.hasMore}');
      debugPrint('===========================================');
      debugPrint('');
    } on ApiException catch (error) {
      if (!mounted) return;

      _showErrorMessage(error.message);
    } catch (error) {
      if (!mounted) return;

      _showErrorMessage('Unable to refresh tickets. Please try again.');
    }
  }

  // ===========================================================================
  // RETRY
  // ===========================================================================

  Future<void> _retry() async {
    await _loadInitialTickets();
  }

  // ===========================================================================
  // ERROR MESSAGE
  // ===========================================================================

  void _showErrorMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          onRefresh: _onRefresh,
          child: CustomScrollView(
            controller: _scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // -----------------------------------------------------------------
              // HEADER / SEARCH
              // -----------------------------------------------------------------
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildHeader(),

                    const SizedBox(height: 20),

                    _buildSearch(),

                    const SizedBox(height: 22),

                    _buildSectionHeader(),

                    const SizedBox(height: 12),
                  ]),
                ),
              ),

              // -----------------------------------------------------------------
              // CONTENT
              // -----------------------------------------------------------------
              _buildTicketContent(),

              // -----------------------------------------------------------------
              // PAGINATION LOADER
              // -----------------------------------------------------------------
              if (_isLoadingMore)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  sliver: SliverToBoxAdapter(child: _buildPaginationLoader()),
                ),

              // -----------------------------------------------------------------
              // BOTTOM SPACE
              // -----------------------------------------------------------------
              const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader() {
    return TicketListHeader(onCreateTicket: widget.onCreateTicket);
  }

  // ===========================================================================
  // SEARCH
  // ===========================================================================

  Widget _buildSearch() {
    return TicketSearchBar(
      controller: _searchController,
      onChanged: _onSearchChanged,
      onClear: _clearSearch,
    );
  }

  // ===========================================================================
  // SECTION HEADER
  // ===========================================================================

  Widget _buildSectionHeader() {
    final tickets = _filteredTickets;

    final bool isSearching = _searchQuery.trim().isNotEmpty;

    return Row(
      children: [
        Text(
          'Your Tickets',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(width: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            isSearching ? '${tickets.length}' : '$_totalItems',
            style: AppTextStyles.statusBadge.copyWith(color: AppColors.primary),
          ),
        ),

        const Spacer(),

        if (isSearching)
          GestureDetector(
            onTap: _clearSearch,
            child: Text(
              'Clear search',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }

  // ===========================================================================
  // TICKET CONTENT
  // ===========================================================================

  Widget _buildTicketContent() {
    // -------------------------------------------------------------------------
    // INITIAL LOADING
    // -------------------------------------------------------------------------

    if (_isLoading) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverToBoxAdapter(child: TicketLoading()),
      );
    }

    // -------------------------------------------------------------------------
    // ERROR
    // -------------------------------------------------------------------------

    if (_hasError) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TicketErrorState(onRetry: _retry),
        ),
      );
    }

    final tickets = _filteredTickets;

    // -------------------------------------------------------------------------
    // EMPTY
    // -------------------------------------------------------------------------

    if (tickets.isEmpty) {
      final bool isSearching = _searchQuery.trim().isNotEmpty;

      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TicketEmptyState(
            title: isSearching ? 'No Matching Tickets' : 'No Tickets Yet',
            message: isSearching
                ? 'Try changing your search to find the ticket you are looking for.'
                : 'You haven’t created any support tickets yet. Create a ticket and our support team will help you.',
            buttonText: isSearching ? 'Clear Search' : 'Create Ticket',
            onButtonPressed: isSearching ? _clearSearch : widget.onCreateTicket,
          ),
        ),
      );
    }

    // -------------------------------------------------------------------------
    // TICKET LIST
    // -------------------------------------------------------------------------

    return SliverPadding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      sliver: SliverList.separated(
        itemCount: tickets.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final ticket = tickets[index];

          return TicketCard(
            ticket: ticket,
            onTap: () {
              widget.onTicketTap?.call(ticket);
            },
          );
        },
      ),
    );
  }

  // ===========================================================================
  // PAGINATION LOADER
  // ===========================================================================

  Widget _buildPaginationLoader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      ),
    );
  }
}
