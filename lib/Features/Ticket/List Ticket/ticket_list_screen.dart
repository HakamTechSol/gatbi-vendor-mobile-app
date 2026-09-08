import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

import '../Data/dummy_ticket_data.dart';
import '../Models/ticket_model.dart';

import 'Reuse Widgets/ticket_card.dart';
import 'Reuse Widgets/ticket_empty_state.dart';
import 'Reuse Widgets/ticket_error_state.dart';
import 'Reuse Widgets/ticket_filter.dart';
import 'Reuse Widgets/ticket_list_header.dart';
import 'Reuse Widgets/ticket_loading.dart';
import 'Reuse Widgets/ticket_search_bar.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key, this.onCreateTicket, this.onTicketTap});

  /// Called when the user taps "Create Ticket".
  final VoidCallback? onCreateTicket;

  /// Called when the user taps a ticket card.
  final ValueChanged<TicketModel>? onTicketTap;

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  late final TextEditingController _searchController;

  String _selectedStatus = 'All';
  String _searchQuery = '';

  bool _isLoading = false;
  bool _hasError = false;

  List<TicketModel> _tickets = [];

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();

    _loadTickets();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // DATA
  // ---------------------------------------------------------------------------

  void _loadTickets() {
    setState(() {
      _tickets = DummyTicketData.all;
    });
  }

  List<TicketModel> get _filteredTickets {
    Iterable<TicketModel> result = _tickets;

    // Status filter
    if (_selectedStatus.toLowerCase() != 'all') {
      result = result.where(
        (ticket) =>
            ticket.status.toLowerCase() == _selectedStatus.toLowerCase(),
      );
    }

    // Search filter
    final query = _searchQuery.trim().toLowerCase();

    if (query.isNotEmpty) {
      result = result.where((ticket) {
        return ticket.ticketNumber.toLowerCase().contains(query) ||
            ticket.subject.toLowerCase().contains(query) ||
            ticket.category.toLowerCase().contains(query) ||
            ticket.priority.toLowerCase().contains(query) ||
            ticket.status.toLowerCase().contains(query);
      });
    }

    return result.toList();
  }

  // ---------------------------------------------------------------------------
  // SEARCH
  // ---------------------------------------------------------------------------

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _searchQuery = '';
    });
  }

  // ---------------------------------------------------------------------------
  // FILTER
  // ---------------------------------------------------------------------------

  void _onStatusChanged(String status) {
    setState(() {
      _selectedStatus = status;
    });
  }

  // ---------------------------------------------------------------------------
  // REFRESH
  // ---------------------------------------------------------------------------

  Future<void> _onRefresh() async {
    // This is intentionally local for now.
    //
    // Later:
    // Repository -> Controller/Riverpod -> API
    //
    // The UI structure will not need to change.

    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      _tickets = DummyTicketData.all;
      _hasError = false;
    });
  }

  // ---------------------------------------------------------------------------
  // ERROR
  // ---------------------------------------------------------------------------

  void _retry() {
    setState(() {
      _hasError = false;
      _isLoading = true;
    });

    Future<void>.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _tickets = DummyTicketData.all;
      });
    });
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

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
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildSearch(),
                    const SizedBox(height: 14),
                    _buildFilters(),
                    const SizedBox(height: 22),
                    _buildSectionHeader(),
                    const SizedBox(height: 12),
                  ]),
                ),
              ),

              _buildTicketContent(),

              const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return TicketListHeader(onCreateTicket: widget.onCreateTicket);
  }

  // ---------------------------------------------------------------------------
  // SEARCH
  // ---------------------------------------------------------------------------

  Widget _buildSearch() {
    return TicketSearchBar(
      controller: _searchController,
      onChanged: _onSearchChanged,
      onClear: _clearSearch,
    );
  }

  // ---------------------------------------------------------------------------
  // FILTER
  // ---------------------------------------------------------------------------

  Widget _buildFilters() {
    return TicketFilter(
      selectedStatus: _selectedStatus,
      onStatusChanged: _onStatusChanged,
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION HEADER
  // ---------------------------------------------------------------------------

  Widget _buildSectionHeader() {
    final count = _filteredTickets.length;

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
            '$count',
            style: AppTextStyles.statusBadge.copyWith(color: AppColors.primary),
          ),
        ),
        const Spacer(),
        if (_selectedStatus != 'All' || _searchQuery.isNotEmpty)
          GestureDetector(
            onTap: _resetFilters,
            child: Text(
              'Clear filters',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TICKET CONTENT
  // ---------------------------------------------------------------------------

  Widget _buildTicketContent() {
    if (_isLoading) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverToBoxAdapter(child: TicketLoading()),
      );
    }

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

    if (tickets.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TicketEmptyState(
            title: _searchQuery.isNotEmpty || _selectedStatus != 'All'
                ? 'No Matching Tickets'
                : 'No Tickets Yet',
            message: _searchQuery.isNotEmpty || _selectedStatus != 'All'
                ? 'Try changing your search or filter to find the ticket you are looking for.'
                : 'You haven’t created any support tickets yet. Create a ticket and our support team will help you.',
            buttonText: 'Create Ticket',
            onButtonPressed: widget.onCreateTicket,
          ),
        ),
      );
    }

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
  // ---------------------------------------------------------------------------
  // FILTER RESET
  // ---------------------------------------------------------------------------

  void _resetFilters() {
    _searchController.clear();

    setState(() {
      _searchQuery = '';
      _selectedStatus = 'All';
    });
  }
}
