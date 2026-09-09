import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Data/dummy_orders.dart';
import '../Models/order_model.dart';
import '../Reuse Widgets/order_card.dart';
import '../Reuse Widgets/orders_empty_state.dart';
import '../Reuse Widgets/orders_header.dart';
import '../Reuse Widgets/orders_loading.dart';
import '../Reuse Widgets/orders_search_bar.dart';
import '../Reuse Widgets/orders_status_tabs.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key, this.onOrderTap});

  /// Later this will navigate to OrderDetailScreen.
  final ValueChanged<OrderModel>? onOrderTap;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final TextEditingController _searchController = TextEditingController();

  OrderStatus? _selectedStatus;

  bool _isLoading = true;
  bool _isRefreshing = false;

  List<OrderModel> _filteredOrders = [];

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_onSearchControllerChanged);

    _loadOrders();
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchControllerChanged)
      ..dispose();

    super.dispose();
  }

  // ============================================================
  // Data
  // ============================================================

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
    });

    // Temporary delay to show the loading UI during testing.
    // This will later be replaced by the repository/API call.
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _applyFilters();
    });
  }

  Future<void> _refreshOrders() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Temporary refresh delay.
    // Later this will call the repository refresh method.
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    setState(() {
      _isRefreshing = false;
      _applyFilters();
    });
  }

  // ============================================================
  // Search
  // ============================================================

  void _onSearchControllerChanged() {
    if (!mounted) return;

    setState(() {
      _applyFilters();
    });
  }

  void _onSearchChanged(String value) {
    _applyFilters();
  }

  void _clearSearch() {
    _searchController.clear();
  }

  // ============================================================
  // Filter
  // ============================================================

  void _onStatusChanged(OrderStatus? status) {
    setState(() {
      _selectedStatus = status;
      _applyFilters();
    });
  }

  void _applyFilters() {
    final query = _searchController.text.trim().toLowerCase();

    var result = List<OrderModel>.from(DummyOrders.orders);

    // Status filter.
    if (_selectedStatus != null) {
      result = result
          .where((order) => order.status == _selectedStatus)
          .toList();
    }

    // Search filter.
    if (query.isNotEmpty) {
      result = result.where((order) {
        final orderNumber = order.orderNumber.toLowerCase();

        final customerName = order.customer.name.toLowerCase();

        final customerEmail = order.customer.email?.toLowerCase() ?? '';

        final customerPhone = order.customer.phone?.toLowerCase() ?? '';

        return orderNumber.contains(query) ||
            customerName.contains(query) ||
            customerEmail.contains(query) ||
            customerPhone.contains(query);
      }).toList();
    }

    _filteredOrders = result;
  }

  void _clearFilters() {
    setState(() {
      _selectedStatus = null;
      _searchController.clear();
      _applyFilters();
    });
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopSection(),

            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrdersHeader(onRefresh: _refreshOrders),

          const SizedBox(height: 18),

          OrdersSearchBar(
            controller: _searchController,
            onChanged: _onSearchChanged,
            onClear: _clearSearch,
          ),

          const SizedBox(height: 14),

          OrdersStatusTabs(
            selectedStatus: _selectedStatus,
            onStatusChanged: _onStatusChanged,
          ),

          const SizedBox(height: 16),

          _buildResultsHeader(),
        ],
      ),
    );
  }

  Widget _buildResultsHeader() {
    final hasFilters =
        _selectedStatus != null || _searchController.text.trim().isNotEmpty;

    return Row(
      children: [
        Text(
          hasFilters
              ? '${_filteredOrders.length} orders found'
              : '${DummyOrders.orders.length} orders',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w600,
          ),
        ),

        const Spacer(),

        if (hasFilters)
          GestureDetector(
            onTap: _clearFilters,
            child: Text(
              'Clear filters',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 4, 16, 24),
        child: OrdersLoading(itemCount: 5),
      );
    }

    if (_filteredOrders.isEmpty) {
      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _refreshOrders,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.45,
              child: OrdersEmptyState(
                onClearFilters: _hasActiveFilters ? _clearFilters : null,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _refreshOrders,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        itemCount: _filteredOrders.length,
        separatorBuilder: (_, __) {
          return const SizedBox(height: 12);
        },
        itemBuilder: (context, index) {
          final order = _filteredOrders[index];

          return OrderCard(
            order: order,
            onTap: () => widget.onOrderTap?.call(order),
          );
        },
      ),
    );
  }

  bool get _hasActiveFilters {
    return _selectedStatus != null || _searchController.text.trim().isNotEmpty;
  }
}
