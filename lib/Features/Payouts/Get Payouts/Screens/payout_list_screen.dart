import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../../Payout Request/Controller/payout_request_controller.dart';
import '../../Payout Request/Screens/payout_request_dialog.dart';
import '../Controller/payout_controller.dart';
import '../Models/payout_model.dart';
import '../Models/payout_pagination_model.dart';

import '../Reuse Widgets/payout_card.dart';
import '../Reuse Widgets/payout_empty_state.dart';
import '../Reuse Widgets/payout_error_state.dart';
import '../Reuse Widgets/payout_list_header.dart';
import '../Reuse Widgets/payout_loading.dart';

class PayoutListScreen extends ConsumerStatefulWidget {
  const PayoutListScreen({super.key, this.onBack, required this.onDetail});

  final VoidCallback? onBack;

  /// Detail screen open callback.
  ///
  /// Parent/router should return the Future from context.push()
  /// so this screen can refresh when detail screen is closed.
  final Future<void> Function(PayoutModel payout) onDetail;

  @override
  ConsumerState<PayoutListScreen> createState() => _PayoutListScreenState();
}

class _PayoutListScreenState extends ConsumerState<PayoutListScreen> {
  // ============================================================
  // Controllers
  // ============================================================

  final ScrollController _scrollController = ScrollController();

  // ============================================================
  // Data
  // ============================================================

  final List<PayoutModel> _payouts = [];

  PayoutPaginationModel? _pagination;

  // ============================================================
  // Loading / Error
  // ============================================================

  bool _isLoading = true;
  bool _isRefreshing = false;
  bool _isLoadingMore = false;
  bool _hasError = false;

  String? _errorMessage;

  // ============================================================
  // Filter
  // ============================================================

  String? _selectedStatus;

  static const List<String> _fixedStatuses = [
    'pending',
    'processing',
    'paid',
    'cancelled',
  ];

  // ============================================================
  // Init
  // ============================================================

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    _loadPayouts();
  }

  // ============================================================
  // Dispose
  // ============================================================

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  // ============================================================
  // Initial / Full Load
  // ============================================================

  Future<void> _loadPayouts({bool showLoader = true}) async {
    if (showLoader && mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _errorMessage = null;
        _payouts.clear();
        _pagination = null;
      });
    }

    try {
      final controller = ref.read(payoutControllerProvider);

      final result = await controller.getPayouts(
        page: 1,
        limit: 100,
        status: _selectedStatus,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _payouts
          ..clear()
          ..addAll(result.payouts);

        _pagination = result.pagination;

        _isLoading = false;
        _isRefreshing = false;
        _isLoadingMore = false;

        _hasError = false;
        _errorMessage = null;
      });
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _isRefreshing = false;
        _isLoadingMore = false;

        _hasError = true;
        _errorMessage = _getApiErrorMessage(error);
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _isRefreshing = false;
        _isLoadingMore = false;

        _hasError = true;
        _errorMessage = 'Unable to load payouts. Please try again.';
      });
    }
  }

  // ============================================================
  // Pull To Refresh
  // ============================================================

  Future<void> _refreshPayouts() async {
    if (_isLoading || _isRefreshing || _isLoadingMore) {
      return;
    }

    if (mounted) {
      setState(() {
        _isRefreshing = true;
        _isLoading = true;
        _hasError = false;
        _errorMessage = null;

        _payouts.clear();
        _pagination = null;
      });
    }

    try {
      final controller = ref.read(payoutControllerProvider);

      final result = await controller.getPayouts(
        page: 1,
        limit: 100,
        status: _selectedStatus,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _payouts
          ..clear()
          ..addAll(result.payouts);

        _pagination = result.pagination;

        _isLoading = false;
        _isRefreshing = false;

        _hasError = false;
        _errorMessage = null;
      });
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _isRefreshing = false;
      });

      _showErrorMessage(_getApiErrorMessage(error));
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _isRefreshing = false;
      });

      _showErrorMessage('Unable to refresh payouts.');
    }
  }

  // ============================================================
  // Refresh After Returning From Detail
  // ============================================================

  Future<void> _refreshAfterDetail() async {
    if (!mounted) {
      return;
    }

    await _loadPayouts(showLoader: true);
  }

  // ============================================================
  // Open Request Payout Dialog
  // ============================================================
  Future<void> _openRequestPayoutDialog() async {
    if (_isLoading || _isRefreshing || _isLoadingMore) {
      return;
    }

    final errorMessage = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PayoutRequestDialog(
          onSubmit:
              ({required String startDate, required String endDate}) async {
                final controller = ref.read(payoutRequestControllerProvider);

                final result = await controller.requestPayout(
                  startDate: startDate,
                  endDate: endDate,
                );

                if (!mounted) {
                  return;
                }

                // ========================================================
                // SUCCESS
                // ========================================================

                if (result.success) {
                  // First close dialog.
                  Navigator.of(dialogContext).pop();

                  // Show shimmer + reload payout list.
                  await _loadPayouts(showLoader: true);

                  if (!mounted) {
                    return;
                  }

                  _showSuccessMessage(
                    result.message?.trim().isNotEmpty == true
                        ? result.message!.trim()
                        : 'Payout request submitted successfully.',
                  );

                  return;
                }

                // ========================================================
                // success:false
                // ========================================================

                final message = result.message?.trim();

                throw ApiException(
                  message: message != null && message.isNotEmpty
                      ? message
                      : 'Unable to submit payout request.',
                  code: 'PAYOUT_REQUEST_FAILED',
                );
              },
        );
      },
    );

    // ==============================================================
    // DIALOG RETURNED WITH ERROR
    // ==============================================================

    if (!mounted) {
      return;
    }

    if (errorMessage != null && errorMessage.trim().isNotEmpty) {
      _showErrorMessage(errorMessage.trim());
    }
  }
  
  // ============================================================
  // Load More
  // ============================================================

  Future<void> _loadMorePayouts() async {
    if (_isLoadingMore ||
        _isLoading ||
        _isRefreshing ||
        _pagination?.hasNextPage != true) {
      return;
    }

    final nextPage = _pagination?.nextPage;

    if (nextPage == null) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final controller = ref.read(payoutControllerProvider);

      final result = await controller.getPayouts(
        page: nextPage,
        limit: 100,
        status: _selectedStatus,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _addUniquePayouts(result.payouts);

        _pagination = result.pagination;

        _isLoadingMore = false;
      });
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingMore = false;
      });

      _showErrorMessage(_getApiErrorMessage(error));
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingMore = false;
      });

      _showErrorMessage('Unable to load more payouts.');
    }
  }

  // ============================================================
  // Unique Payouts
  // ============================================================

  void _addUniquePayouts(List<PayoutModel> newPayouts) {
    for (final payout in newPayouts) {
      final id = payout.id;

      if (id == null) {
        _payouts.add(payout);
        continue;
      }

      final exists = _payouts.any((item) => item.id == id);

      if (!exists) {
        _payouts.add(payout);
      }
    }
  }

  // ============================================================
  // Scroll
  // ============================================================

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 300) {
      _loadMorePayouts();
    }
  }

  // ============================================================
  // Status
  // ============================================================

  Future<void> _changeStatus(String? status) async {
    if (_selectedStatus == status) {
      return;
    }

    setState(() {
      _selectedStatus = status;
    });

    await _loadPayouts();
  }

  // ============================================================
  // Error
  // ============================================================

  String _getApiErrorMessage(ApiException error) {
    final message = error.message.trim();

    if (message.isNotEmpty) {
      return message;
    }

    return 'Unable to load payouts. Please try again.';
  }

  // ============================================================
  // Error SnackBar
  // ============================================================

  void _showErrorMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textOnPrimary,
            ),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ============================================================
  // Success SnackBar
  // ============================================================

  void _showSuccessMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: _buildBody()),
    );
  }

  // ============================================================
  // Body
  // ============================================================

  Widget _buildBody() {
    // ----------------------------------------------------------
    // Initial / Refresh Shimmer
    // ----------------------------------------------------------

    if (_isLoading) {
      return const PayoutLoading(itemCount: 4);
    }

    // ----------------------------------------------------------
    // Error
    // ----------------------------------------------------------

    if (_hasError && _payouts.isEmpty) {
      return PayoutErrorState(
        message: _errorMessage ?? 'Unable to load payouts. Please try again.',
        onRetry: () {
          _loadPayouts();
        },
      );
    }

    // ----------------------------------------------------------
    // Content
    // ----------------------------------------------------------

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      onRefresh: _refreshPayouts,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // ======================================================
          // Header
          // ======================================================
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverToBoxAdapter(
              child: PayoutListHeader(
                onBack: widget.onBack,
                onRequestPayout: _openRequestPayoutDialog,
                showRequestButton:
                    _selectedStatus != null || _payouts.isNotEmpty,
                isRequestEnabled: !_isRefreshing && !_isLoadingMore,
              ),
            ),
          ),

          // ======================================================
          // Payouts
          // ======================================================
          if (_payouts.isNotEmpty) ...[
            // ----------------------------------------------------
            // Filters
            // ----------------------------------------------------
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
              sliver: SliverToBoxAdapter(child: _buildStatusFilters()),
            ),

            // ----------------------------------------------------
            // Cards
            // ----------------------------------------------------
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (index >= _payouts.length) {
                    return const SizedBox.shrink();
                  }

                  final payout = _payouts[index];

                  return PayoutCard(
                    payoutNumber: payout.payoutNumber,
                    amount: payout.amount,
                    currency: payout.currency,
                    currencySymbol: payout.currencySymbol,
                    status: payout.status,
                    paymentMethod: payout.paymentMethod,
                    paymentReference: payout.paymentReference,
                    periodStart: payout.periodStart,
                    periodEnd: payout.periodEnd,
                    notes: payout.notes,
                    processedAt: payout.processedAt,
                    paidAt: payout.paidAt,
                    createdAt: payout.createdAt,
                    onTap: () async {
                      // Wait until detail screen is popped.
                      await widget.onDetail(payout);

                      // Then show shimmer and reload.
                      await _refreshAfterDetail();
                    },
                  );
                }, childCount: _payouts.length),
              ),
            ),

            // ----------------------------------------------------
            // Loading More
            // ----------------------------------------------------
            if (_isLoadingMore)
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverToBoxAdapter(child: _LoadingMoreIndicator()),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 8)),
          ]
          // ======================================================
          // Empty
          // ======================================================
          else ...[
            // ----------------------------------------------------
            // Filters
            // ----------------------------------------------------
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
              sliver: SliverToBoxAdapter(child: _buildStatusFilters()),
            ),

            // ----------------------------------------------------
            // Empty State
            // ----------------------------------------------------
            if (_selectedStatus != null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                  child: _buildStatusEmptyState(),
                ),
              )
            else
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                  child: PayoutEmptyState(
                    onRequestPayout: _openRequestPayoutDialog,
                    isEnabled: !_isRefreshing,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // Status Filters
  // ============================================================

  Widget _buildStatusFilters() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: _fixedStatuses.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _PayoutFilterChip(
              label: 'All',
              selected: _selectedStatus == null,
              onTap: () {
                _changeStatus(null);
              },
            );
          }

          final status = _fixedStatuses[index - 1];

          return _PayoutFilterChip(
            label: _formatStatus(status),
            selected: _selectedStatus == status,
            onTap: () {
              _changeStatus(status);
            },
          );
        },
      ),
    );
  }

  // ============================================================
  // Status Empty State
  // ============================================================

  Widget _buildStatusEmptyState() {
    final status = _selectedStatus;

    final formattedStatus = status == null
        ? 'payouts'
        : _formatStatus(status).toLowerCase();

    final title = status == null
        ? 'No payouts available'
        : 'No ${formattedStatus} payouts';

    final description = status == null
        ? 'There are no payouts available at the moment.'
        : 'There are no $formattedStatus payouts available at the moment.';

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 520),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ----------------------------------------------------
            // Icon
            // ----------------------------------------------------
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_balance_wallet_outlined,
                size: 30,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 18),

            // ----------------------------------------------------
            // Title
            // ----------------------------------------------------
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            // ----------------------------------------------------
            // Description
            // ----------------------------------------------------
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Format Status
  // ============================================================

  String _formatStatus(String status) {
    final value = status.trim();

    if (value.isEmpty) {
      return 'Unknown';
    }

    return value
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map(
          (word) =>
              '${word[0].toUpperCase()}'
              '${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}

// ================================================================
// Payout Filter Chip
// ================================================================

class _PayoutFilterChip extends StatelessWidget {
  const _PayoutFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.captionMedium.copyWith(
              color: selected
                  ? AppColors.textOnPrimary
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// Loading More
// ================================================================

class _LoadingMoreIndicator extends StatelessWidget {
  const _LoadingMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 230),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 9),
            Flexible(
              child: Text(
                'Loading more payouts...',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.captionMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
