import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';

import '../Controller/payout_detail_controller.dart';
import '../Models/payout_detail_model.dart';

import '../Reuse Widgets/payout_detail_empty_state.dart';
import '../Reuse Widgets/payout_detail_header.dart';
import '../Reuse Widgets/payout_detail_shimmer_screen.dart';
import '../Reuse Widgets/payout_financial_summary.dart';
import '../Reuse Widgets/payout_information_card.dart';
import '../Reuse Widgets/payout_items_card.dart';
import '../Reuse Widgets/payout_notes_card.dart';
import '../Reuse Widgets/payout_period_card.dart';
import '../Reuse Widgets/payout_summary_card.dart';
import '../Reuse Widgets/payout_timeline_card.dart';

class PayoutDetailScreen extends ConsumerStatefulWidget {
  const PayoutDetailScreen({super.key, required this.payoutId});

  final int payoutId;

  @override
  ConsumerState<PayoutDetailScreen> createState() => _PayoutDetailScreenState();
}

class _PayoutDetailScreenState extends ConsumerState<PayoutDetailScreen> {
  // ============================================================
  // State
  // ============================================================

  PayoutDetailDataModel? _payout;

  bool _isLoading = true;
  String? _errorMessage;

  // ============================================================
  // Lifecycle
  // ============================================================

  @override
  void initState() {
    super.initState();

    _loadPayoutDetail();
  }

  // ============================================================
  // Load Payout Detail
  // ============================================================

  Future<void> _loadPayoutDetail() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _payout = null;
    });

    try {
      final controller = ref.read(payoutDetailControllerProvider);

      final response = await controller.getPayoutDetail(
        payoutId: widget.payoutId,
      );

      if (!mounted) return;

      // ----------------------------------------------------------
      // API Success Check
      // ----------------------------------------------------------

      if (!response.success) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Unable to load payout details. Please try again.';
        });

        return;
      }

      // ----------------------------------------------------------
      // Payout Data Check
      // ----------------------------------------------------------

      final payout = response.payout;

      if (payout == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Payout information is not available.';
        });

        return;
      }

      // ----------------------------------------------------------
      // Success
      // ----------------------------------------------------------

      setState(() {
        _payout = payout;
        _isLoading = false;
        _errorMessage = null;
      });
    } on ApiException catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _payout = null;
        _errorMessage = _getApiErrorMessage(error);
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _payout = null;
        _errorMessage = 'Something went wrong. Please try again.';
      });
    }
  }

  // ============================================================
  // API Error Message
  // ============================================================

  String _getApiErrorMessage(ApiException error) {
    final message = error.message.trim();

    if (message.isNotEmpty) {
      return message;
    }

    return 'Unable to load payout details. Please try again.';
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    // ----------------------------------------------------------
    // Loading
    // ----------------------------------------------------------

    if (_isLoading) {
      return const PayoutDetailShimmerScreen();
    }

    // ----------------------------------------------------------
    // Error / Empty
    // ----------------------------------------------------------

    if (_payout == null) {
      return _buildErrorScreen();
    }

    // ----------------------------------------------------------
    // Success
    // ----------------------------------------------------------

    return _buildPayoutScreen(_payout!);
  }

  // ============================================================
  // Error Screen
  // ============================================================

  Widget _buildErrorScreen() {
    return PayoutDetailEmptyState(
      title: _errorMessage == null
          ? 'Payout Details Unavailable'
          : 'Unable to Load Payout',
      description:
          _errorMessage ??
          'We could not find the payout details. Please try again.',
      icon: Icons.account_balance_wallet_outlined,
      onRetry: _loadPayoutDetail,
      onBack: () => Navigator.of(context).maybePop(),
      retryLabel: 'Try Again',
      backLabel: 'Go Back',
    );
  }

  // ============================================================
  // Payout Screen
  // ============================================================

  Widget _buildPayoutScreen(PayoutDetailDataModel payout) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadPayoutDetail,
          color: AppColors.primary,
          backgroundColor: AppColors.white,
          displacement: 18,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // --------------------------------------------------
              // Step 1 - Header
              // --------------------------------------------------
              SliverToBoxAdapter(
                child: PayoutDetailHeader(
                  payout: payout,
                  onBack: () {
                    Navigator.of(context).maybePop();
                  },
                ),
              ),

              // --------------------------------------------------
              // Step 2 - Summary
              // --------------------------------------------------
              SliverToBoxAdapter(child: PayoutSummaryCard(payout: payout)),

              // --------------------------------------------------
              // Step 3 - Payout Information
              // --------------------------------------------------
              SliverToBoxAdapter(child: PayoutInformationCard(payout: payout)),

              // --------------------------------------------------
              // Step 4 - Payout Period
              // --------------------------------------------------
              SliverToBoxAdapter(child: PayoutPeriodCard(payout: payout)),

              // --------------------------------------------------
              // Step 5 - Financial Summary
              // --------------------------------------------------
              SliverToBoxAdapter(child: PayoutFinancialSummary(payout: payout)),

              // --------------------------------------------------
              // Step 6 - Included Orders
              // --------------------------------------------------
              SliverToBoxAdapter(child: PayoutItemsCard(payout: payout)),

              // --------------------------------------------------
              // Step 7 - Timeline
              // --------------------------------------------------
              SliverToBoxAdapter(child: PayoutTimelineCard(payout: payout)),

              // --------------------------------------------------
              // Step 8 - Notes
              // --------------------------------------------------
              SliverToBoxAdapter(child: PayoutNotesCard(payout: payout)),

              // --------------------------------------------------
              // Bottom Spacing
              // --------------------------------------------------
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
