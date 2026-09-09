import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../../Order List/Models/order_model.dart';
import '../Models/order_detail_model.dart';

import '../Reuse Widgets/customer_info_card.dart';
import '../Reuse Widgets/order_detail_header.dart';
import '../Reuse Widgets/order_items_card.dart';
import '../Reuse Widgets/order_status_update_card.dart';
import '../Reuse Widgets/order_summary_card.dart';
import '../Reuse Widgets/order_timeline_card.dart';
import '../Reuse Widgets/payment_action_buttons.dart';
import '../Reuse Widgets/payment_info_card.dart';
import '../Reuse Widgets/payment_proof_card.dart';
import '../Reuse Widgets/shipping_address_card.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({
    super.key,
    required this.order,
    this.onBack,
    this.onRefresh,
  });

  final OrderDetailModel order;

  final VoidCallback? onBack;
  final VoidCallback? onRefresh;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late OrderStatus _selectedStatus;

  late final TextEditingController _trackingController;
  late final TextEditingController _carrierController;
  late final TextEditingController _noteController;

  bool _isUpdatingStatus = false;
  bool _isPaymentProcessing = false;

  @override
  void initState() {
    super.initState();

    _selectedStatus = widget.order.status;

    _trackingController = TextEditingController();
    _carrierController = TextEditingController();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _trackingController.dispose();
    _carrierController.dispose();
    _noteController.dispose();

    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS UPDATE
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _handleStatusUpdate() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isUpdatingStatus = true;
    });

    // UI-only simulation.
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    setState(() {
      _isUpdatingStatus = false;
    });

    _showSnackBar('Order status updated to ${_selectedStatus.label}');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PAYMENT ACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _handleApprovePayment() async {
    setState(() {
      _isPaymentProcessing = true;
    });

    // UI-only simulation.
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    setState(() {
      _isPaymentProcessing = false;
    });

    _showSnackBar('Payment approved successfully');
  }

  Future<void> _handleRejectPayment() async {
    setState(() {
      _isPaymentProcessing = true;
    });

    // UI-only simulation.
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    setState(() {
      _isPaymentProcessing = false;
    });

    _showSnackBar('Payment rejected');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PAYMENT PROOF
  // ═══════════════════════════════════════════════════════════════════════════

  void _handleViewPaymentProof() {
    if (widget.order.paymentProofUrl == null ||
        widget.order.paymentProofUrl!.isEmpty) {
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.white,
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 10, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Payment Proof',
                          style: AppTextStyles.titleMedium,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: InteractiveViewer(
                    child: Image.network(
                      widget.order.paymentProofUrl!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) {
                        return const SizedBox(
                          height: 300,
                          child: Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              size: 48,
                              color: AppColors.textMuted,
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;

                        return const SizedBox(
                          height: 300,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SNACKBAR
  // ═══════════════════════════════════════════════════════════════════════════

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(order),

            Expanded(child: _buildContent(order)),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildHeader(OrderDetailModel order) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: OrderDetailHeader(
        order: order,
        onBack: widget.onBack,
        onRefresh: widget.onRefresh,
        status: order.status,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CONTENT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildContent(OrderDetailModel order) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order summary
          OrderSummaryCard(order: order),

          const SizedBox(height: 14),

          // Customer information
          CustomerInfoCard(order: order),

          const SizedBox(height: 14),

          // Shipping address
          ShippingAddressCard(address: order.shippingAddress),

          const SizedBox(height: 14),

          // Order items
          OrderItemsCard(order: order),

          const SizedBox(height: 14),

          // Payment information
          PaymentInfoCard(
            payment: order.payment,
            onViewProof: _handleViewPaymentProof,
          ),

          if (order.paymentProofUrl != null &&
              order.paymentProofUrl!.isNotEmpty) ...[
            const SizedBox(height: 14),

            PaymentProofCard(
              paymentProofUrl: order.paymentProofUrl,
              onView: _handleViewPaymentProof,
            ),
          ],

          if (order.payment != null) ...[
            const SizedBox(height: 14),

            _buildPaymentActions(),
          ],

          const SizedBox(height: 14),

          // Status update
          OrderStatusUpdateCard(
            status: _selectedStatus,
            onStatusChanged: (status) {
              setState(() {
                _selectedStatus = status;
              });
            },
            onUpdate: _handleStatusUpdate,
            trackingController: _trackingController,
            carrierController: _carrierController,
            noteController: _noteController,
            isLoading: _isUpdatingStatus,
          ),

          const SizedBox(height: 14),

          // Timeline
          OrderTimelineCard(timeline: order.timeline),

          if (order.notes != null && order.notes!.trim().isNotEmpty) ...[
            const SizedBox(height: 14),

            _buildOrderNotes(order.notes!),
          ],
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PAYMENT ACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPaymentActions() {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment Actions', style: AppTextStyles.titleMedium),

          const SizedBox(height: 5),

          Text(
            'Review and confirm the customer payment.',
            style: AppTextStyles.bodySmall,
          ),

          const SizedBox(height: 16),

          PaymentActionButtons(
            onApprove: _handleApprovePayment,
            onReject: _handleRejectPayment,
            isLoading: _isPaymentProcessing,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ORDER NOTES
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildOrderNotes(String notes) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.notes_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 10),

              Text('Order Notes', style: AppTextStyles.titleMedium),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            notes,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// SECTION CARD
// ═════════════════════════════════════════════════════════════════════════════

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
