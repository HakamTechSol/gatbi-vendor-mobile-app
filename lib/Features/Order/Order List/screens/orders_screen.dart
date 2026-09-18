import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Routes/route_observer.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Controller/orders_controller.dart';
import '../Models/order_model.dart';
import '../Reuse Widgets/order_card.dart';
import '../Reuse Widgets/orders_empty_state.dart';
import '../Reuse Widgets/orders_error_state.dart';
import '../Reuse Widgets/orders_header.dart';
import '../Reuse Widgets/orders_loading.dart';
import '../Reuse Widgets/orders_search_bar.dart';
import '../Reuse Widgets/orders_status_tabs.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key, this.onOrderTap});

  /// Later this will navigate to OrderDetailScreen.
  final ValueChanged<VendorOrderModel>? onOrderTap;

  @override
  OrdersScreenState createState() => OrdersScreenState();
}

class OrdersScreenState extends ConsumerState<OrdersScreen> with RouteAware {
  final TextEditingController _searchController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  bool _routeSubscribed = false;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_onSearchControllerChanged);

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      ref.read(vendorOrdersControllerProvider.notifier).loadOrders();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_routeSubscribed) {
      return;
    }

    final route = ModalRoute.of(context);

    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
      _routeSubscribed = true;
    }
  }

  @override
  void dispose() {
    if (_routeSubscribed) {
      routeObserver.unsubscribe(this);
    }

    _searchController
      ..removeListener(_onSearchControllerChanged)
      ..dispose();

    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();

    if (!mounted) {
      return;
    }

    debugPrint('════════════════════════════════════════════════════════════');
    debugPrint('RETURNED TO ORDERS SCREEN');
    debugPrint('REFRESHING ORDERS API...');
    debugPrint('════════════════════════════════════════════════════════════');

    ref.read(vendorOrdersControllerProvider.notifier).refreshOrders();
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void _onSearchControllerChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  void _onSearchChanged(String value) {
    ref.read(vendorOrdersControllerProvider.notifier).searchOrders(value);
  }

  Future<void> _clearSearch() async {
    _searchController.clear();

    await ref.read(vendorOrdersControllerProvider.notifier).clearSearch();
  }

  // ============================================================
  // STATUS
  // ============================================================

  Future<void> _onStatusChanged(String? status) async {
    await ref
        .read(vendorOrdersControllerProvider.notifier)
        .filterByStatus(status);
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _refreshOrders() async {
    await ref.read(vendorOrdersControllerProvider.notifier).refreshOrders();
  }

  // ============================================================
  // RETRY
  // ============================================================

  Future<void> _retry() async {
    await ref.read(vendorOrdersControllerProvider.notifier).retry();
  }

  // ============================================================
  // CLEAR FILTERS
  // ============================================================

  Future<void> _clearFilters() async {
    _searchController.clear();

    await ref.read(vendorOrdersControllerProvider.notifier).searchOrdersNow('');
  }

  // ============================================================
  // PAGINATION
  // ============================================================

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    // Start loading next page before reaching the
    // absolute bottom.
    if (position.pixels >= position.maxScrollExtent - 300) {
      ref.read(vendorOrdersControllerProvider.notifier).loadMore();
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vendorOrdersControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopSection(state),

            Expanded(child: _buildContent(state)),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TOP SECTION
  // ============================================================

  Widget _buildTopSection(VendorOrdersState state) {
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
            selectedStatus: state.selectedStatus,
            onStatusChanged: _onStatusChanged,
          ),

          const SizedBox(height: 16),

          _buildResultsHeader(state),
        ],
      ),
    );
  }

  // ============================================================
  // RESULTS HEADER
  // ============================================================

  Widget _buildResultsHeader(VendorOrdersState state) {
    final hasFilters = state.hasActiveFilters;

    final count = state.totalItems > 0 ? state.totalItems : state.orders.length;

    return Row(
      children: [
        Text(
          hasFilters ? '$count orders found' : '$count orders',
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

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _buildContent(VendorOrdersState state) {
    // ----------------------------------------------------------
    // INITIAL LOADING
    // ----------------------------------------------------------

    if (state.isLoading && state.orders.isEmpty) {
      return const SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(6, 4, 6, 24),
        child: OrdersLoading(itemCount: 5),
      );
    }

    // ----------------------------------------------------------
    // ERROR
    // ----------------------------------------------------------

    if (state.hasError && state.orders.isEmpty) {
      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _refreshOrders,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.45,
              child: OrdersErrorState(
                message:
                    state.errorMessage ??
                    'Something went wrong. Please try again.',
                onRetry: _retry,
              ),
            ),
          ],
        ),
      );
    }

    // ----------------------------------------------------------
    // EMPTY
    // ----------------------------------------------------------

    if (state.orders.isEmpty) {
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
                onClearFilters: state.hasActiveFilters ? _clearFilters : null,
              ),
            ),
          ],
        ),
      );
    }

    // ----------------------------------------------------------
    // ORDERS LIST
    // ----------------------------------------------------------

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _refreshOrders,
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        itemCount: state.orders.length + (state.isLoadingMore ? 1 : 0),
        separatorBuilder: (_, __) {
          return const SizedBox(height: 12);
        },
        itemBuilder: (context, index) {
          // ----------------------------------------------------
          // LOAD MORE
          // ----------------------------------------------------

          if (index >= state.orders.length) {
            return const _LoadMoreIndicator();
          }

          final order = state.orders[index];

          return OrderCard(
            order: order,
            onTap: () {
              widget.onOrderTap?.call(order);
            },
          );
        },
      ),
    );
  }
}

// ============================================================
// LOAD MORE INDICATOR
// ============================================================

class _LoadMoreIndicator extends StatelessWidget {
  const _LoadMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
