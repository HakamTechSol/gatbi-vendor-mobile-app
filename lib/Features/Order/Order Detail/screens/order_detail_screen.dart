import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Controller/order_detail_controller.dart';
import '../Models/order_detail_model.dart';
import '../Models/order_payment_proof_model.dart';

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

class OrderDetailScreen extends ConsumerStatefulWidget {
  const OrderDetailScreen({
    super.key,
    required this.orderId,
    this.onBack,
    this.onRefresh,
  });

  final int orderId;

  final VoidCallback? onBack;
  final VoidCallback? onRefresh;

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  VendorOrderDetailModel? _order;
  VendorOrderPaymentProofModel? _paymentProof;

  String _selectedStatus = 'pending';

  late final TextEditingController _trackingController;

  late final TextEditingController _carrierController;

  late final TextEditingController _noteController;

  bool _isLoading = true;
  bool _isRefreshing = false;
  bool _isUpdatingStatus = false;
  bool _isPaymentProcessing = false;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _trackingController = TextEditingController();

    _carrierController = TextEditingController();

    _noteController = TextEditingController();

    _loadOrderDetail();
  }

  @override
  void dispose() {
    _trackingController.dispose();
    _carrierController.dispose();
    _noteController.dispose();

    super.dispose();
  }

  // ============================================================
  // LOAD API
  // ============================================================

  Future<void> _loadOrderDetail({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _isRefreshing = true;
        _errorMessage = null;
      });
    } else {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final controller = ref.read(vendorOrderDetailControllerProvider);

      final result = await controller.getOrderDetail(orderId: widget.orderId);

      if (!mounted) {
        return;
      }

      if (!result.success || result.order == null) {
        setState(() {
          _isLoading = false;
          _isRefreshing = false;
          _errorMessage = 'Unable to load order details.';
        });

        return;
      }

      final order = result.order!;

      setState(() {
        _order = order;
        _paymentProof = result.paymentProof;

        _selectedStatus = _normalizeStatus(order.status);

        _isLoading = false;
        _isRefreshing = false;
        _errorMessage = null;
      });
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _isRefreshing = false;
        _errorMessage = error.message;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _isRefreshing = false;
        _errorMessage = 'Something went wrong. Please try again.';
      });
    }
  }

  // ============================================================
  // STATUS UPDATE
  // ============================================================

  Future<void> _handleStatusUpdate() async {
    FocusScope.of(context).unfocus();

    if (_order == null) {
      return;
    }

    setState(() {
      _isUpdatingStatus = true;
    });

    /*
     * IMPORTANT:
     *
     * Status update API abhi provide nahi hui.
     *
     * Jab API milegi:
     *
     * controller.updateOrderStatus(...)
     *
     * yahan call karenge.
     */

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) {
      return;
    }

    setState(() {
      _isUpdatingStatus = false;
    });

    _showSnackBar('Status update API will be connected here.');
  }

  // ============================================================
  // PAYMENT APPROVE
  // ============================================================

  Future<void> _handleApprovePayment() async {
    final paymentProof = _paymentProof;

    if (paymentProof == null) {
      return;
    }

    setState(() {
      _isPaymentProcessing = true;
    });

    /*
     * IMPORTANT:
     *
     * Payment approve API abhi provide nahi hui.
     *
     * Future mein:
     *
     * controller.approvePayment(...)
     *
     * yahan call hoga.
     */

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) {
      return;
    }

    setState(() {
      _isPaymentProcessing = false;
    });

    _showSnackBar('Payment approve API will be connected here.');
  }

  // ============================================================
  // PAYMENT REJECT
  // ============================================================

  Future<void> _handleRejectPayment() async {
    final paymentProof = _paymentProof;

    if (paymentProof == null) {
      return;
    }

    setState(() {
      _isPaymentProcessing = true;
    });

    /*
     * IMPORTANT:
     *
     * Payment reject API abhi provide nahi hui.
     *
     * Future mein:
     *
     * controller.rejectPayment(...)
     *
     * yahan call hoga.
     */

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) {
      return;
    }

    setState(() {
      _isPaymentProcessing = false;
    });

    _showSnackBar('Payment reject API will be connected here.');
  }

  // ============================================================
  // PAYMENT PROOF VIEW
  // ============================================================

  void _handleViewPaymentProof() {
    final url = _paymentProof?.proofImageUrl;

    if (url == null || url.trim().isEmpty) {
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
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
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),

                Flexible(
                  child: InteractiveViewer(
                    child: Image.network(
                      url,
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
                        if (progress == null) {
                          return child;
                        }

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

  // ============================================================
  // HELPERS
  // ============================================================

  String _normalizeStatus(String? status) {
    final value = status?.trim().toLowerCase() ?? '';

    const available = [
      'pending',
      'processing',
      'shipped',
      'delivered',
      'cancelled',
    ];

    if (available.contains(value)) {
      return value;
    }

    return 'pending';
  }

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

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            if (_order != null) _buildHeader(_order!),

            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(VendorOrderDetailModel order) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: OrderDetailHeader(
        order: order,
        onBack: widget.onBack,
        onRefresh: () {
          _loadOrderDetail(refresh: true);
        },
      ),
    );
  }

  // ============================================================
  // BODY
  // ============================================================

  Widget _buildBody() {
    if (_isLoading && _order == null) {
      return const _DetailLoading();
    }

    if (_errorMessage != null && _order == null) {
      return _DetailError(
        message: _errorMessage!,
        onRetry: () {
          _loadOrderDetail();
        },
      );
    }

    final order = _order;

    if (order == null) {
      return _DetailError(
        message: 'Order details are not available.',
        onRetry: () {
          _loadOrderDetail();
        },
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await _loadOrderDetail(refresh: true);
      },
      child: _buildContent(order),
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _buildContent(VendorOrderDetailModel order) {
    final paymentProof = _paymentProof;

    final hasPaymentProof = paymentProof != null;

    final needsPaymentVerification =
        paymentProof != null &&
        paymentProof.verificationStatus?.trim().toLowerCase() == 'pending';

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------------------------------------------
          // Order Summary
          // ------------------------------------------------------
          OrderSummaryCard(order: order),

          const SizedBox(height: 14),

          // ------------------------------------------------------
          // Customer
          // ------------------------------------------------------
          CustomerInfoCard(order: order),

          const SizedBox(height: 14),

          // ------------------------------------------------------
          // Shipping Address
          // ------------------------------------------------------
          ShippingAddressCard(address: order.shippingAddress),

          const SizedBox(height: 14),

          // ------------------------------------------------------
          // Order Items
          // ------------------------------------------------------
          OrderItemsCard(order: order),

          const SizedBox(height: 14),

          // ------------------------------------------------------
          // Payment Information
          // ------------------------------------------------------
          PaymentInfoCard(
            order: order,
            paymentProof: paymentProof,
            onViewProof: hasPaymentProof ? _handleViewPaymentProof : null,
          ),

          // ------------------------------------------------------
          // Payment Proof
          //
          // IMPORTANT:
          // payment_proof == null
          // => card completely hidden
          // ------------------------------------------------------
          if (hasPaymentProof) ...[
            const SizedBox(height: 14),

            PaymentProofCard(
              paymentProof: paymentProof,
              onView: _handleViewPaymentProof,
            ),
          ],

          // ------------------------------------------------------
          // Payment Verification Actions
          //
          // Only pending verification
          // ------------------------------------------------------
          if (needsPaymentVerification) ...[
            const SizedBox(height: 14),

            _buildPaymentVerificationCard(),
          ],

          const SizedBox(height: 14),

          // ------------------------------------------------------
          // Status Update
          // ------------------------------------------------------
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

          // ------------------------------------------------------
          // Timeline
          // ------------------------------------------------------
          OrderTimelineCard(timeline: order.statusHistory),

          // ------------------------------------------------------
          // Refresh Indicator
          // ------------------------------------------------------
          if (_isRefreshing) ...[
            const SizedBox(height: 16),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // PAYMENT VERIFICATION CARD
  // ============================================================

  Widget _buildPaymentVerificationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.30)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.verified_outlined,
                  size: 19,
                  color: AppColors.warning,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Verification',
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Review the payment proof and choose an action.',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
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
}

// ═════════════════════════════════════════════════════════════════════════════
// LOADING
// ═════════════════════════════════════════════════════════════════════════════

class _DetailLoading extends StatelessWidget {
  const _DetailLoading();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      children: [
        _SkeletonBox(height: 120, radius: 16),
        const SizedBox(height: 14),
        _SkeletonBox(height: 125, radius: 16),
        const SizedBox(height: 14),
        _SkeletonBox(height: 150, radius: 16),
        const SizedBox(height: 14),
        _SkeletonBox(height: 230, radius: 16),
        const SizedBox(height: 14),
        _SkeletonBox(height: 180, radius: 16),
      ],
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({required this.height, required this.radius});

  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// ERROR
// ═════════════════════════════════════════════════════════════════════════════

class _DetailError extends StatelessWidget {
  const _DetailError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 32,
                color: AppColors.error,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              'Unable to load order',
              style: AppTextStyles.titleMedium.copyWith(color: AppColors.navy),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 6),

            Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 18),

            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
